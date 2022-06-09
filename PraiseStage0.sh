#!/usr/bin/bash
firstname="Praise"
Lastname="Fawehinmi"

#Print variables in the same line
echo $firstname $Lastname

#Print variables on different lines
echo $firstname
echo $Lastname


#BASH STORY ONE
mkdir Praise

#Create a folder named biocomputing
mkdir biocomputing && cd $_

#download the file
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.fna
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk

#move the .fna into Praise
mv wildtype.fna ../Praise

#delete duplicate
rm wildtype.gbk.1

#confirm mutant or wildtype
grep "tatatata" ../Praise/wildtype.fna

#print all lines to prove
grep "tatatata" ../Praise/wildtype.fna > mutant.txt

#clear terminal and print all commands
clear && history

#print the files in the two folders
ls ../Praise ../biocomputing

#BASH STORY TWO

#draw a graphical representation of my name
cd ∼
sudo apt-get install figlet

figlet Praise

#create compare
mkdir compare

#download the file
cd compare
wget https://www.bioinformatics.babraham.ac.uk/training/Introduction%20to%20Unix/unix_intro_data.tar.gz

#unzip the file
gunzip unix_intro_data.tar.gz

#untar the file
#get into seqmonk_genomes/Saccharomyces cerevisiae/EF4 
cd "seqmonk_genomes/Saccharomyces cerevisiae/EF4" 

# identify RNAs present in Mito.dat
grep "rRNA" Mito.dat

#copy Mito.dat into compare
cp Mito.dat ∼/unixTutorial/compare

#use the following edits to edit the file
nano Mito.dat

#save the file: Ctrl + S

#Exit: Ctrl + x

#rename the file
cp Mito.dat Mitochondrion.dat
#rename Mito.dat to Mitichondrion
# step4 move to compare and cd to FastQ_Data directory
cd ∼/unixTutorial/compare

cd FastQ_Data

#calculate number of lines in lane8_DD_P4_TTAGGC_L008_R1.fastq.gz
cat lane8_DD_P4_TTAGGC_L008_R1.fastq.gz | wc -l

#print all total number of lines in all the fastq.gz and save as new
cat *.fastq.gz | wc -l