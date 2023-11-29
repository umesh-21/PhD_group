MODEL=$PWD/dumped/fine_tuned_without_tok/ddw2yj7six/checkpoint.pth
MASS=$PWD/MASS/MASS-unsupNMT


cat $PWD/data/processed/de-dg/test.de-dg.de | \
python $MASS/translate.py \
--exp_name test \
--model_path $MODEL \
--output_path $PWD/dumped/test_de-dg  \
--src_lang 'de' \
--tgt_lang 'dg' \


