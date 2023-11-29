# We followed the following steps (in ascending order) to train our models: -



1) First run create_dirs.sh

2) Then run install_tools.sh

3) Run process.sh 

4) Run train.sh to start the training

5) Once trained fine-tune the model by running fine_tune.sh

6) To generate translations using the fine-tuned mdoel, run translate.sh


# Data Processing

* We used Moses tokenizer to tokenize and BPE as encoding for both the source and target sentences.


# Results

* All our training logs and results are inside `dumped` folder.





# Effect of Moses Tokenizer

* Initially we used Moses tokenizer to tokenize our text and gloss data, however, we found that the Moses tokenizer split some of the words like '$gest' to $ and 'gest', because of which the original context or meaning was lost.

* To rectify this we trained our model without using Moses tokenizer and direclty applying BPE to source and targer sentences.






**For more information regarding MASS pretraining for Unsupervised NMT refer to** `https://github.com/microsoft/MASS.git`
