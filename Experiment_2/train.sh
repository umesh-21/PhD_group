
MASS=$PWD/MASS/MASS-unsupNMT

python $MASS/train.py                                      \
--exp_name unsup_text_to_gloss_without_tokenizer                            \
--data_path $PWD/data/processed/de-dg/                  \
--lgs 'de-dg'                                        \
--mass_steps 'de,dg'                                 \
--encoder_only false                                 \
--emb_dim 1024                                       \
--n_layers 6                                         \
--n_heads 8                                          \
--dropout 0.1                                        \
--attention_dropout 0.1                              \
--gelu_activation true                               \
--tokens_per_batch 3000                              \
--optimizer adam_inverse_sqrt,beta1=0.9,beta2=0.98,lr=0.0001 \
--epoch_size 20000                                  \
--max_epoch 100                                      \
--eval_bleu true                                     \
--word_mass 0.5                                      \
--min_len 5                                          \
