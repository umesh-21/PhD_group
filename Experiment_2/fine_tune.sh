
MODEL=$PWD/dumped/unsup_text_to_gloss_without_tokenizer/651xe7kkds/checkpoint.pth

MASS=$PWD/MASS/MASS-unsupNMT

python $MASS/train.py                                      \
--exp_name fine_tuned_without_tok                              \
--data_path $PWD/data/processed/de-dg/                  \
--lgs 'de-dg'                                        \
--bt_steps 'de-dg-de,dg-de-dg' \
--encoder_only false                                 \
--emb_dim 1024                                       \
--n_layers 6                                         \
--n_heads 8                                          \
--dropout 0.1                                        \
--attention_dropout 0.1                              \
--gelu_activation true                               \
--tokens_per_batch 2000                              \
--batch_size 32 \
--bptt 256 \
--optimizer adam_inverse_sqrt,beta1=0.9,beta2=0.98,lr=0.0001 \
--epoch_size 20000                                  \
--max_epoch 30                                      \
--reload_model "$MODEL,$MODEL"
