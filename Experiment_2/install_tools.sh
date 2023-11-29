MAIN_PATH=$PWD
TOOLS_PATH=$PWD/tools
DATA_PATH=$PWD/data
MONO_PATH=$DATA_PATH/mono
PARA_PATH=$DATA_PATH/para
PROC_PATH=$DATA_PATH/processed/$SRC-$TGT

# Clone the MASS repo
echo "Cloning MASS from GitHub repository..."
git clone https://github.com/microsoft/MASS.git


cd $TOOLS_PATH

# Download Moses

echo "Cloning Moses from GitHub repository..."
git clone https://github.com/moses-smt/mosesdecoder.git


# Download fastBPE

echo "Cloning fastBPE from GitHub repository..."
git clone https://github.com/glample/fastBPE


# Compile fastBPE

echo "Compiling fastBPE..."
cd fastBPE
g++ -std=c++11 -pthread -O3 fastBPE/main.cc -IfastBPE -o fast
cd ..


# Download Sennrich's tools

echo "Cloning WMT16 preprocessing scripts..."
git clone https://github.com/rsennrich/wmt16-scripts.git


# Download WikiExtractor

echo "Cloning WikiExtractor from GitHub repository..."
git clone https://github.com/attardi/wikiextractor.git
