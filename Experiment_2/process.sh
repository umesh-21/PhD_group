N_MONO=50000  # number of monolingual sentences for each language
CODES=10000     # number of BPE codes
N_THREADS=16


SRC='de' # de for german (text)
TGT='dg' # dg for german gloss


MAIN_PATH=$PWD
TOOLS_PATH=$PWD/tools
DATA_PATH=$PWD/data
MONO_PATH=$DATA_PATH/mono
PARA_PATH=$DATA_PATH/para
PROC_PATH=$DATA_PATH/processed/$SRC-$TGT



# moses
MOSES=$TOOLS_PATH/mosesdecoder
REPLACE_UNICODE_PUNCT=$MOSES/scripts/tokenizer/replace-unicode-punctuation.perl
NORM_PUNC=$MOSES/scripts/tokenizer/normalize-punctuation.perl
REM_NON_PRINT_CHAR=$MOSES/scripts/tokenizer/remove-non-printing-char.perl
TOKENIZER=$MOSES/scripts/tokenizer/tokenizer.perl
INPUT_FROM_SGM=$MOSES/scripts/ems/support/input-from-sgm.perl

# fastBPE
FASTBPE_DIR=$TOOLS_PATH/fastBPE
FASTBPE=$TOOLS_PATH/fastBPE/fast


# raw and tokenized files
SRC_RAW=$MONO_PATH/$SRC/all.$SRC
TGT_RAW=$MONO_PATH/$TGT/all.$TGT
# SRC_TOK=$SRC_RAW.tok
# TGT_TOK=$TGT_RAW.tok

# BPE / vocab files
BPE_CODES=$PROC_PATH/codes
SRC_VOCAB=$PROC_PATH/vocab.$SRC
TGT_VOCAB=$PROC_PATH/vocab.$TGT
FULL_VOCAB=$PROC_PATH/vocab.$SRC-$TGT

# train / valid / test monolingual BPE data
SRC_TRAIN_BPE=$PROC_PATH/train.$SRC
TGT_TRAIN_BPE=$PROC_PATH/train.$TGT
SRC_VALID_BPE=$PROC_PATH/valid.$SRC
TGT_VALID_BPE=$PROC_PATH/valid.$TGT
SRC_TEST_BPE=$PROC_PATH/test.$SRC
TGT_TEST_BPE=$PROC_PATH/test.$TGT

# valid / test parallel BPE data
PARA_SRC_VALID_BPE=$PROC_PATH/valid.$SRC-$TGT.$SRC
PARA_TGT_VALID_BPE=$PROC_PATH/valid.$SRC-$TGT.$TGT
PARA_SRC_TEST_BPE=$PROC_PATH/test.$SRC-$TGT.$SRC
PARA_TGT_TEST_BPE=$PROC_PATH/test.$SRC-$TGT.$TGT

PARA_SRC_VALID=$PARA_PATH/dev/valid.de
PARA_TGT_VALID=$PARA_PATH/dev/valid.dg
PARA_SRC_TEST=$PARA_PATH/dev/test.de
PARA_TGT_TEST=$PARA_PATH/dev/test.dg


# PARA_SRC_VALID_TOK=$PARA_SRC_VALID.tok
# PARA_TGT_VALID_TOK=$PARA_TGT_VALID.tok
# PARA_SRC_TEST_TOK=$PARA_SRC_TEST.tok
# PARA_TGT_TEST_TOK=$PARA_TGT_TEST.tok


# SRC_PREPROCESSING="$REPLACE_UNICODE_PUNCT | $NORM_PUNC -l $SRC | $REM_NON_PRINT_CHAR |                                            $TOKENIZER -l $SRC -no-escape -threads $N_THREADS"

# TGT_PREPROCESSING="$REPLACE_UNICODE_PUNCT | $NORM_PUNC -l $SRC | $REM_NON_PRINT_CHAR |                                            $TOKENIZER -l $SRC -no-escape -threads $N_THREADS"

# # tokenize data

# echo "Tokenize $SRC monolingual data..."
# eval "cat $SRC_RAW | $SRC_PREPROCESSING > $SRC_TOK"



# echo "Tokenize $TGT monolingual data..."
# eval "cat $TGT_RAW | $TGT_PREPROCESSING > $TGT_TOK"

# echo "$SRC monolingual data tokenized in: $SRC_TOK"
# echo "$TGT monolingual data tokenized in: $TGT_TOK"

# learn BPE codes

echo "Learning BPE codes..."
$FASTBPE learnbpe $CODES $SRC_RAW $TGT_RAW > $BPE_CODES

echo "BPE learned in $BPE_CODES"

# apply BPE codes

echo "Applying $SRC BPE codes..."
$FASTBPE applybpe $SRC_TRAIN_BPE $SRC_RAW $BPE_CODES


echo "Applying $TGT BPE codes..."
$FASTBPE applybpe $TGT_TRAIN_BPE $TGT_RAW $BPE_CODES

echo "BPE codes applied to $SRC in: $SRC_TRAIN_BPE"
echo "BPE codes applied to $TGT in: $TGT_TRAIN_BPE"

# extract source and target vocabulary

echo "Extracting vocabulary..."
$FASTBPE getvocab $SRC_TRAIN_BPE > $SRC_VOCAB
$FASTBPE getvocab $TGT_TRAIN_BPE > $TGT_VOCAB

echo "$SRC vocab in: $SRC_VOCAB"
echo "$TGT vocab in: $TGT_VOCAB"

# extract full vocabulary

echo "Extracting vocabulary..."
$FASTBPE getvocab $SRC_TRAIN_BPE $TGT_TRAIN_BPE > $FULL_VOCAB
echo "Full vocab in: $FULL_VOCAB"

# binarize data

echo "Binarizing $SRC data..."
$MAIN_PATH/MASS/MASS-unsupNMT/preprocess.py $FULL_VOCAB $SRC_TRAIN_BPE

echo "Binarizing $TGT data..."
$MAIN_PATH/MASS/MASS-unsupNMT/preprocess.py $FULL_VOCAB $TGT_TRAIN_BPE

echo "$SRC binarized data in: $SRC_TRAIN_BPE.pth"
echo "$TGT binarized data in: $TGT_TRAIN_BPE.pth"

cd $PARA_PATH

# echo "Tokenizing valid and test data..."

# eval "cat $PARA_SRC_VALID | $SRC_PREPROCESSING > $PARA_SRC_VALID_TOK"
# eval "cat $PARA_TGT_VALID | $TGT_PREPROCESSING > $PARA_TGT_VALID_TOK"
# eval "cat $PARA_SRC_TEST | $SRC_PREPROCESSING > $PARA_SRC_TEST_TOK"
# eval "cat $PARA_TGT_TEST | $TGT_PREPROCESSING > $PARA_TGT_TEST_TOK"


echo "Applying BPE to valid and test files..."
$FASTBPE applybpe $PARA_SRC_VALID_BPE $PARA_SRC_VALID $BPE_CODES $SRC_VOCAB
$FASTBPE applybpe $PARA_TGT_VALID_BPE $PARA_TGT_VALID $BPE_CODES $TGT_VOCAB
$FASTBPE applybpe $PARA_SRC_TEST_BPE  $PARA_SRC_TEST  $BPE_CODES $SRC_VOCAB
$FASTBPE applybpe $PARA_TGT_TEST_BPE  $PARA_TGT_TEST  $BPE_CODES $TGT_VOCAB

echo "Binarizing data..."
rm -f $PARA_SRC_VALID_BPE.pth $PARA_TGT_VALID_BPE.pth $PARA_SRC_TEST_BPE.pth $PARA_TGT_TEST_BPE.pth
$MAIN_PATH/MASS/MASS-unsupNMT/preprocess.py $FULL_VOCAB $PARA_SRC_VALID_BPE
$MAIN_PATH/MASS/MASS-unsupNMT/preprocess.py $FULL_VOCAB $PARA_TGT_VALID_BPE
$MAIN_PATH/MASS/MASS-unsupNMT/preprocess.py $FULL_VOCAB $PARA_SRC_TEST_BPE
$MAIN_PATH/MASS/MASS-unsupNMT/preprocess.py $FULL_VOCAB $PARA_TGT_TEST_BPE

# Link monolingual validation and test data to parallel data
#
ln -sf $PARA_SRC_VALID_BPE.pth $SRC_VALID_BPE.pth
ln -sf $PARA_TGT_VALID_BPE.pth $TGT_VALID_BPE.pth
ln -sf $PARA_SRC_TEST_BPE.pth  $SRC_TEST_BPE.pth
ln -sf $PARA_TGT_TEST_BPE.pth  $TGT_TEST_BPE.pth


#
# Summary
#
echo ""
echo "===== Data summary"
echo "Monolingual training data:"
echo "    $SRC: $SRC_TRAIN_BPE.pth"
echo "    $TGT: $TGT_TRAIN_BPE.pth"
echo "Monolingual validation data:"
echo "    $SRC: $SRC_VALID_BPE.pth"
echo "    $TGT: $TGT_VALID_BPE.pth"
echo "Monolingual test data:"
echo "    $SRC: $SRC_TEST_BPE.pth"
echo "    $TGT: $TGT_TEST_BPE.pth"
echo "Parallel validation data:"
echo "    $SRC: $PARA_SRC_VALID_BPE.pth"
echo "    $TGT: $PARA_TGT_VALID_BPE.pth"
echo "Parallel test data:"
echo "    $SRC: $PARA_SRC_TEST_BPE.pth"
echo "    $TGT: $PARA_TGT_TEST_BPE.pth"
echo ""




