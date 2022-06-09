#!/usr/bin/bash

#download the DNA.fa
wget https://raw.githubusercontent.com/Hackbio-Internship/wale-home-tasks/main/DNA.fa

#Count the number of sequences in DNA.fa
grep -c "^>" DNA.fa

#Write a one-line command in Bash to get the total A, T, G & C counts for all the sequences in the file above
$echo -e "seq_id\tA\tT\tG\tC"; while read line; do echo $line | grep ">" | sed 's/>//g'; for i in A T G C;do echo $line | grep -v ">" | grep -o $i | wc -l | grep -v "^0"; done; done < DNA.fa | paste - - - - -

#Set up a conda (anaconda, miniconda or mini forge) environment on your terminal.
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
rm Miniconda3-latest-Linux-x86_64.sh

#Write a script that does the following in the specified order
nano ngsdata.sh

#install the software
conda install -y -c bioconda ⧵
fastp ⧵
fastqc ⧵
bwa

#Download datasets from https://github.com/josoga2/yt-dataset/tree/main/dataset
mkdir workdir && cd $_
mkdir dataset
cd dataset

wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/ACBarrie_R1.fastq.gz?raw=true - O ACBarrie_R1.fastq.
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/ACBarrie_R2.fastq.gz?raw=true - O ACBarrie_R2.fastq.
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Alsen_R2.fastq.gz?raw=true - O Alsen_R2.fastq.
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Baxter_R1.fastq.gz?raw=true  - O Baxter_R1.fastq.
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Baxter_R2.fastq.gz?raw=true - O Baxter_R2.fastq.
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Chara_R1.fastq.gz?raw=true - O Chara_R1.fastq.
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Chara_R2.fastq.gz?raw=true - O Chara_R2.fastq.
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Drysdale_R1.fastq.gz?raw=true - O Drysdale_R1.fastq.
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Drysdale_R2.fastq.gz?raw=true - O Drysdale_R2.fastq.

#create a folder called output
cd ∼/workdir
mkdir output

#Implement

#fastqc: quality control
mkdir QC-Report
my QC-Report output
fastqc ∼/workdir/dataset/*.fastq.gz

#fastp: trimming low quality reads
TRIMMED_DIR=∼/workdir/output/trimmed_data
DATA_DIR=∼/workdir/dataset/

mkdir -p $TRIMMED_DIR

SAMPLES= "ACBarrie Alsen Baxter Chara Drysdale"

for sample in $SAMPLES:
do


fastp ＼
-i "$DATA_DIR/${SAMPLE}_R1.fastq.gz" ＼
-i "$DATA_DIR/${SAMPLE}_R2.fastq.gz" ＼
-O "$DATA_DIR/${SAMPLE}_R1.fastq.gz" ＼
-O "$DATA_DIR/${SAMPLE}_R2.fastq.gz" ＼
--html "$TRIMMED_DIR/${SAMPLE}_R1.fastp.html"

done

#bwa: map the genome

# download reference genome first
wget http://github.com/josoga2/yt-dataset/raw/main/dataset/references/reference.fasta

#index reference genome
bwa index references/reference.fasta

#perform alignment
mkdir aligned_map
SAMPLES= "ACBarrie Alsen Baxter Chara Drysdale"
for SAMPLE in $SAMPLES

 do
    repair.sh in1="output/${SAMPLE}_R1.fastq.gz" in2="output/${SAMPLE}_R2.fastq.gz" out1="repaired/${SAMPLE}_R1_rep.fastq.gz" out2="repaired/${SAMPLE}_R2_rep.fastq.gz" outsingle="repaired/${SAMPLE}_single.fq"
    echo $PWD
    bwa mem -t 1 \
    references/reference.fasta \
    "repaired/${SAMPLE}_R1_rep.fastq.gz" "repaired/${SAMPLE}_R2_rep.fastq.gz" \
  | samtools view -b \
  > "aligned_map/${SAMPLE}.bam" 
done
