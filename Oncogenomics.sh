                                                                           stage02_task.sh                                                                                      
#!usr/bin/bash

# create a working directory(stage02 for me).
mkdir stage02 && cd $_

# sample dataset
mkdir raw_data
wget -P raw_data/ https://zenodo.org/record/2582555/files/SLGFSK-N_2313>
wget -P raw_data/ https://zenodo.org/record/2582555/files/SLGFSK-N_2313>
wget -P raw_data/ https://zenodo.org/record/2582555/files/SLGFSK-T_2313>
wget -P raw_data/ https://zenodo.org/record/2582555/files/SLGFSK-T_2313>

# download reference sequence and unzip it. 
mkdir reference
wget -P reference/ https://zenodo.org/record/2582555/files/hg19.chr5_12>

gunzip reference/hg19.chr5_12_17.fa.gz

# quality check
mkdir Fastqc_Reports

samples=(
    "SLGFSK-N_231335_r1_chr5_12_17"
    "SLGFSK-N_231335_r2_chr5_12_17"
    "SLGFSK-T_231336_r1_chr5_12_17"
    "SLGFSK-T_231336_r2_chr5_12_17"
)


for sample in ${samples[@]}
do
    fastqc raw_data/${sample}*.fastq.gz -o Fastqc_Reports
done

# create a multiqc report
multiqc Fastqc_Reports -o Fastqc_Reports

 
# remove low quality sequences with trimmomatic

for sample in ${samples[@]}
do
    trimmomatic PE -threads 8 raw_data/${sample}_r1_chr5_12_17.fastq.gz
             trimmed_reads/${sample}_r1_paired.fq.gz trimmed_reads/${sa
             trimmed_reads/${sample}_r2_paired.fq.gz trimmed_reads/${sa
               ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:8:keepBothReads \
               LEADING:3 TRAILING:10 MINLEN:25

  fastqc  trimmed_reads/${sample}_r1_paired.fq.gz  trimmed_reads/${sa
                 -o trimmed_reads/Fastqc_results
done



multiqc trimmed_reads/Fastqc_results -o trimmed_reads/Fastqc_results


#READS MAPPING
mkdir Mapping

# index reference 
bwa index reference/hg19.chr5_12_17.fa

# perform alignment with bwa mem
bwa mem -R '@RG\tID:231335\tSM:Normal' reference/hg19.chr5_12_17.fa
        trimmed_reads/SLGFSK-N_231335_r1_paired.fq.gz \ trimmed_reads/SLGFSK-N_231335_r2_paired.fq.gz > Mapping/SLGFSK-N_231335.sam

bwa mem -R '@RG\tID:231336\tSM:Tumor' reference/hg19.chr5_12_17.fa
        trimmed_reads/SLGFSK-T_231336_r1_paired.fq.gz \ trimmed_reads/SLGFSK-T_231336_r2_paired.fq.gz > Mapping/SLGFSK-T_231336.sam


# converting sam to bam, soting and indexing
for sample in ${samples[@]}
do
    #convert sam to bam and sort it
    samtools view -@ 20 -S -b Mapping/${sample}.sam | samtools sort -@ 32 > Mapping/${sample}.sorted.bam
    # index bam files
    samtools index Mapping/${sample}.sorted.bam

done

# filter the mapped reads
for sample in ${samples[@]}
do
	#Filter BAM files
        samtools view -q 1 -f 0x2 -F 0x8 -b Mapping/${sample}.sorted.bam > Mapping/${sample}.filtered1.bam
done

# Check alignments statistics with samtools 
flagstat <bam file> -O

# remove duplicates
samples=(
    "SLGFSK-N_231335"
    "SLGFSK-T_231336"
)

for sample in ${samples[@]}
do
    samtools collate Mapping/${sample}.filtered1.bam Mapping/${sample}.
    samtools fixmate -m Mapping/${sample}.namecollate.bam Mapping/${sam
    samtools sort -@ 32 -o Mapping/${sample}.positionsort.bam Mapping/$
    samtools markdup -@ 32 -r Mapping/${sample}.positionsort.bam Mappin
done

#or 
samtools rmdup -S - SLGFSK-N_231335.sorted.bam  SLGFSK-N_231335.rdup and samtools rmdup SLGFSK-T_231336.sorted.bam  SLGFSK-T_231336.rdup

#left align bam files
for sample in ${samples[@]}
> do
>         cat Mapping/${sample}*.bam  | bamleftalign -f reference/hg19.chr5_12_17.fa -m 5 -c > Mapping/${sample}.leftAlign.bam

# recalibrate the read mapping qualities
samples=(
    "SLGFSK-N_231335"
    "SLGFSK-T_231336"
)

for sample in ${samples[@]}
do
    samtools calmd -@ 32 -b Mapping/${sample}.leftAlign.bam hg19.chr5_1>
done

# refilter the read mapping qualities
samples=(
    "SLGFSK-N_231335"
    "SLGFSK-T_231336"
)

for sample in ${samples[@]}
do
    bamtools filter -in Mapping/${sample}.recalibrate.bam -mapQuality "<=254" > Mapping/${sample}.refilter.bam;
done



# VARIANT CALLING AND CLASSIFICATION

# installation
#wget https://sourceforge.net/projects/varscan/files/VarScan.v2.3.9.jar

# convert data to pileup
mkdir Variants

samples=(
    "SLGFSK-N_231335"
    "SLGFSK-T_231336"
)

for sample in ${samples[@]}
do
        samtools mpileup -f hg19.chr5_12_17.fa Mapping/${sample}.refilter.bam --min-MQ 1 --min-BQ 28 \
                > Variants/${sample}.pileup

#Call variants
java -jar VarScan.v2.3.9.jar somatic Variants/SLGFSK-N_231335.pileup \
        Variants/SLGFSK-T_231336.pileup Variants/SLGFSK \
        --normal-purity 1  --tumor-purity 0.5 --output-vcf 1 

#merge vcf
bgzip Variants/SLGFSK.snp.vcf > Variants/SLGFSK.snp.vcf.gz
bgzip Variants/SLGFSK.indel.vcf > Variants/SLGFSK.indel.vcf.gz
tabix Variants/SLGFSK.snp.vcf.gz
tabix Variants/SLGFSK.indel.vcf.gz
bcftools merge SLGFSK.snp.vcf.gz SLGFSK.indel.vcf.gz > SLGFSK.vcf


# Variant annotation 

## download jar file
wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip
## unzip the file 
unzip snpEff_latest_core.zip

#download snpEff database
java -jar snpEff.jar download hg19

# functionnal annotation with snpeff
snpEff hg19 Variants/SLGFSK.vcf > Variants/SLGFSK.ann.vcf

#annotate variants
java -Xmx8g -jar snpEff/snpEff.jar hg19 Variants/SLGFSK.vcf > Variants/SLGFSK.ann.vcf

#Clinical Annotation using gemini continued on galaxy












