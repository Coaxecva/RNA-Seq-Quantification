library(polyester)
library(Biostrings)

range = 15
fold_changes = matrix(c(rep(1,length(fasta)),sample.int(range, length(fasta), TRUE)), nrow=length(fasta))
head(fold_changes)

# FASTA annotation
fasta_file = system.file('extdata', 'chr22.fa', package='polyester')
fasta = readDNAStringSet(fasta_file)


# ~20x coverage ----> reads per transcript = transcriptlength/readlength * 20
# here all transcripts will have ~equal FPKM
readspertx = round(20 * width(fasta) / 100)

# simulation call:
simulate_experiment('chr22.fa', reads_per_transcript=readspertx, 
    num_reps=c(1,1), fold_changes=fold_changes, outdir='simulated_reads') 
