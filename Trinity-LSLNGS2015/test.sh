../STAR/bin/Linux_x86_64_static/STAR --genomeDir GENOME_data/star --sjdbGTFfile GENOME_data/Homo_sapiens.GRCh38.82.gtf --readFilesIn RNASEQ_data/GM12878.rep1.R1.fastq.gz RNASEQ_data/GM12878.rep1.R2.fastq.gz --readFilesCommand zcat --outSAMtype BAM Unsorted SortedByCoordinate --outFilterMultimapNmax 1 --outSAMunmapped Within --quantMode TranscriptomeSAM --twopassMode Basic --runThreadN 20 --outFileNamePrefix "RNASEQ_data/star_GM12878_rep1/"

../STAR/bin/Linux_x86_64_static/STAR --genomeDir GENOME_data/star --sjdbGTFfile GENOME_data/Homo_sapiens.GRCh38.82.gtf --readFilesIn RNASEQ_data/GM12878.rep2.R1.fastq.gz RNASEQ_data/GM12878.rep2.R2.fastq.gz --readFilesCommand zcat --outSAMtype BAM Unsorted SortedByCoordinate --outFilterMultimapNmax 1 --outSAMunmapped Within --quantMode TranscriptomeSAM --twopassMode Basic --runThreadN 20 --outFileNamePrefix "RNASEQ_data/star_GM12878_rep2/"

mkdir RNASEQ_data/star_K562_rep1 RNASEQ_data/star_K562_rep2

../STAR/bin/Linux_x86_64_static/STAR --genomeDir GENOME_data/star --sjdbGTFfile GENOME_data/Homo_sapiens.GRCh38.82.gtf --readFilesIn RNASEQ_data/K562.rep1.R1.fastq.gz RNASEQ_data/K562.rep1.R2.fastq.gz --readFilesCommand zcat --outSAMtype BAM Unsorted SortedByCoordinate --outFilterMultimapNmax 1 --outSAMunmapped Within --quantMode TranscriptomeSAM --twopassMode Basic --runThreadN 20 --outFileNamePrefix "RNASEQ_data/star_K562_rep1/" &

../STAR/bin/Linux_x86_64_static/STAR --genomeDir GENOME_data/star --sjdbGTFfile GENOME_data/Homo_sapiens.GRCh38.82.gtf --readFilesIn RNASEQ_data/K562.rep2.R1.fastq.gz RNASEQ_data/K562.rep2.R2.fastq.gz --readFilesCommand zcat --outSAMtype BAM Unsorted SortedByCoordinate --outFilterMultimapNmax 1 --outSAMunmapped Within --quantMode TranscriptomeSAM --twopassMode Basic --runThreadN 20 --outFileNamePrefix "RNASEQ_data/star_K562_rep2/" &

mkdir RNASEQ_data/rsem_GM12878_rep1 RNASEQ_data/rsem_GM12878_rep2

../RSEM/rsem-calculate-expression --bam --no-bam-output -p 20 --paired-end --forward-prob 0 RNASEQ_data/star_GM12878_rep1/Aligned.toTranscriptome.out.bam GENOME_data/rsem/rsem RNASEQ_data/rsem_GM12878_rep1/rsem > RNASEQ_data/rsem_GM12878_rep1/rsem.log &

../RSEM/rsem-calculate-expression --bam --no-bam-output -p 20 --paired-end --forward-prob 0 RNASEQ_data/star_GM12878_rep2/Aligned.toTranscriptome.out.bam GENOME_data/rsem/rsem RNASEQ_data/rsem_GM12878_rep2/rsem > RNASEQ_data/rsem_GM12878_rep2/rsem.log &

mkdir RNASEQ_data/rsem_K562_rep1 RNASEQ_data/rsem_K562_rep2

../RSEM/rsem-calculate-expression --bam --no-bam-output -p 20 --paired-end --forward-prob 0 RNASEQ_data/star_K562_rep1/Aligned.toTranscriptome.out.bam GENOME_data/rsem/rsem RNASEQ_data/rsem_K562_rep1/rsem > RNASEQ_data/rsem_K562_rep1/rsem.log &

rsem-calculate-expression --bam --no-bam-output -p 20 --paired-end --forward-prob 0 RNASEQ_data/star_K562_rep2/Aligned.toTranscriptome.out.bam GENOME_data/rsem/rsem RNASEQ_data/rsem_K562_rep2/rsem > RNASEQ_data/rsem_K562_rep2/rsem.log &

Trinity --seqType fq --SS_lib_type RF --left sp.left.fq.gz --right sp.right.fq.gz --CPU 6 --max_memory 64G --output trinity_reference > trinity_reference.log

STAR --runThreadN 6 --runMode genomeGenerate --genomeDir star_spo --genomeFastaFiles Schizosaccharomyces_pombe.ASM294v2.29.dna.genome.fa

STAR --genomeDir star_spo --readFilesIn sp.left.fq.gz sp.right.fq.gz --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate  --outFilterMultimapNmax 10 --outSAMunmapped None --twopassMode Basic --runThreadN 6 --outFileNamePrefix \"star_alignment/\"

../trinityrnaseq/util/align_and_estimate_abundance.pl --seqType fq --left RNASEQ_data/Sp_ds.left.fq.gz --right RNASEQ_data/Sp_ds.right.fq.gz --transcripts trinity_reference/Trinity.fasta --output_prefix Sp_ds --est_method RSEM --aln_method bowtie --trinity_mode --prep_reference --output_dir RSEM_Sp_ds

../trinityrnaseq/util/align_and_estimate_abundance.pl --seqType fq --left RNASEQ_data/Sp_hs.left.fq.gz --right RNASEQ_data/Sp_hs.right.fq.gz --transcripts trinity_reference/Trinity.fasta --output_prefix Sp_hs --est_method RSEM --aln_method bowtie --trinity_mode --prep_reference --output_dir RSEM_Sp_hs

../trinityrnaseq/util/align_and_estimate_abundance.pl --seqType fq --left RNASEQ_data/Sp_log.left.fq.gz --right RNASEQ_data/Sp_log.right.fq.gz --transcripts trinity_reference/Trinity.fasta --output_prefix Sp_log --est_method RSEM --aln_method bowtie --trinity_mode --prep_reference --output_dir RSEM_Sp_log

../trinityrnaseq/util/align_and_estimate_abundance.pl --seqType fq  --left RNASEQ_data/Sp_plat.left.fq.gz --right RNASEQ_data/Sp_plat.right.fq.gz --transcripts trinity_reference/Trinity.fasta --output_prefix Sp_plat --est_method RSEM --aln_method bowtie --trinity_mode --prep_reference --output_dir RSEM_Sp_plat

../trinityrnaseq/util/abundance_estimates_to_matrix.pl --est_method RSEM --out_prefix Trinity_trans RSEM_Sp_ds/Sp_ds.isoforms.results RSEM_Sp_hs/Sp_hs.isoforms.results RSEM_Sp_log/Sp_log.isoforms.results RSEM_Sp_plat/Sp_plat.isoforms.results

../trinityrnaseq/Analysis/DifferentialExpression/run_DE_analysis.pl --matrix Trinity_trans.counts.matrix --method edgeR --dispersion 0.1 --output edgeR_output

../trinityrnaseq/Analysis/DifferentialExpression/analyze_diff_expr.pl --matrix ../Trinity_trans.TMM.fpkm.matrix -P 1e-3 -C 2
