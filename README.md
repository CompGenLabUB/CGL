# CGL

Modules and scripts of general use for the [Computational Genomics Lab](https://compgen.bio.ub.edu/)


## Installation

To install this module, run the following commands:

```
	perl Makefile.pl
	make
	make test
	make install
```

## Requirements

This package depends on the following `Perl` modules, make sure they are installed on your system:

```
perl -MCPAN -e'install Term::ANSIColor Inline Inline::C Inline::Files Inline::Filters'
```

## Modules

* Global.pm

* Largeseqs.pm

* Unalias.pm


## Scripts

### grepID


> Using a gene list to filter records from another file in FASTA or tabular format.

<details>
<summary>Usage</summary>

```
                                                                          
 PROGRAM:   grepID - version 1.0                                       
                                                                          
 USAGE:                                                                   
                                                                          
    grepID [options] ids.file genes.file > filtered_genes.file         
                                                                          
                                                                          
 DESCRIPTION:                                                             
                                                                          
    Using a gene list to filter records from another files, including     
    files in fasta format or tabular (via CGL::Largeseqs.pm).  Now also   
    featuring record extraction from quality files in fasta format.       
                                                                          
                                                                          
 COMMAND-LINE OPTIONS:                                                    
                                                                          
   -c, --column <col_num[, ..., [colnum]]>                                
   -I, --column-FILTER <col_num[, ..., [colnum]]>                         
   -D, --column-DATA <col_num[, ..., [colnum]]>                           
     First <col_num> it is assumed to be a sequence ID.                   
                                                                          
   -S, --slurp-mode                                                       
     Read all fields from each ids.file lines and set                     
     as gene IDs.                                                         
                                                                          
   -X, --expand-filenames                                                 
     Take a pattern such as "file[N].ext:range" and                       
     produce a set of files in which "[N]" has been replaced              
     by all the elements of the range.                                    
                                                                          
   -N, --negate-filter                                                    
     Select those sequences/records that are not in the                   
     ids.file (so that, the program returns the complement matches).      
                                                                          
   -j, --join                                                             
   -J, --full-join                                                        
                                                                          
   -p, --add-prefix                                                       
   -s, --add-suffix                                                       
                                                                          
   -a, --forcebase                                                        
   -f, --forcebase-FILTER                                                 
   -d, --forcebase-DATA                                                   
       "forcebase" defines unique IDs, input IDs in the form              
       "ID_00000.00.xxx" are converted to "ID_00000".                     
       By default, trimming on the last suffix after a dot,               
       so a generic ID is produced, from "ID_00000.00.xxx"                
       we got "ID_00000.00".                                              
   -A, --as-is-ids                                                        
       Leave IDs "as is", do not change the IDs,                          
       "ID_00000.00.xxx" is kept as "ID_00000.00.xxx".                    
                                                                          
   -F, --fasta-file                                                       
   -T, --tabular-file                                                     
   -Q, --quality-file                                                     
                                                                          
   The following command-line options are set by default                  
   when using "CGL::Global.pm":                                           
                                                                          
            -h, --help  Shows this help.                                  
             --version  Shows version for current script.                 
         -v, --verbose  Execution messages are sent to STDERR.            
   -V, --color-verbose  Messages are text-coloured to highlight           
                        different kinds of messages.                      
               --debug  All execution messages are sent to STDERR,        
                        including dumps of the internal data structures.  
                                                                          
```
</details>

### fa2tbl


> Converting a sequence input stream in FASTA format to tabular.


<details>
<summary>Usage</summary>

```
                                                                          
 PROGRAM:   fa2tbl - version 1.0                                       
                                                                          
 USAGE:                                                                   
                                                                          
   fa2tbl [ options ] < prot_seq.fasta > prot_seq.tbl                  
                                                                          
                                                                          
 DESCRIPTION:                                                             
                                                                          
   Converting a sequence input stream in fasta format to tabular.         
   It is quite fast as it uses C functions from CGL::Largeseqs.pm (via    
   Inline perl module).                                                   
                                                                          
                                                                          
 COMMAND-LINE OPTIONS:                                                    
                                                                          
   -Z, --gzip-output                                                      
     Compress output on the fly and send to stdout.                       
                                                                          
   -T, --use-tabs                                                         
     Using tab char instead of whitespace to separate output fields.      
                                                                          
   The following command-line options are set by default                  
   when using "CGL::Global.pm":                                           
                                                                          
            -h, --help  Shows this help.                                  
             --version  Shows version for current script.                 
         -v, --verbose  Execution messages are sent to STDERR.            
   -V, --color-verbose  Messages are text-coloured to highlight           
                        different kinds of messages.                      
               --debug  All execution messages are sent to STDERR,        
                        including dumps of the internal data structures.  
                                                                          
```

</details>


### tbl2fa


> Converting a sequence input stream in tabular format to FASTA.


<details>
<summary>Usage</summary>

```
                                                                          
 PROGRAM:   tbl2fa - version 1.0                                       
                                                                          
 USAGE:                                                                   
                                                                          
   tbl2fa [ options ] < prot_seq.tbl > prot_seq.fasta                  
                                                                          
                                                                          
 DESCRIPTION:                                                             
                                                                          
   Converting a sequence input stream in tabular format to fasta.         
   It is quite fast as it uses C functions from CGL::Largeseqs.pm (via    
   Inline perl module).                                                   
                                                                          
                                                                          
 COMMAND-LINE OPTIONS:                                                    
                                                                          
   -Z, --gzip-output                                                      
     Compress output on the fly and send to stdout.                       
                                                                          
   The following command-line options are set by default                  
   when using "CGL::Global.pm":                                           
                                                                          
            -h, --help  Shows this help.                                  
             --version  Shows version for current script.                 
         -v, --verbose  Execution messages are sent to STDERR.            
   -V, --color-verbose  Messages are text-coloured to highlight           
                        different kinds of messages.                      
               --debug  All execution messages are sent to STDERR,        
                        including dumps of the internal data structures.  
                                                                          
```

</details>


### coverage_blastshorttbl

> Calculates the overall coverage for all queries and targets from BLAST output, 
accounting for overlaps among HSPs within each single query and target sequence.

<details>
<summary>Usage</summary>

```
 PROGRAM: coverage_blastshorttbl

 DESCRIPTION
    Computes different coverage statistics for each Query and each Target of a
    BLAST run.

 USAGE
    coverageblasttbl [options] blast.output6.tbl > coverage.tbl

 OPTIONS
    -prog [ BLASTN | BLASTP | BLASTX | TBLASTX | TBLASTN ]
    -Qaa
    -Taa
    -debug



  Input requirements
    Run BLAST with the following option:

    -outfmt '6 qseqid qlen sseqid slen qstart qend sstart send length score
    evalue bitscore pident nident mismatch positive gapopen gaps ppos qframe
    sframe qseq sseq'

  Output table
    1. Query(Q)/Target(T)
    2. Query/Target Id
    3. Query/Target length
    4. Total Forward(+) alignment length
    5. Total Forward(+) alignment coverage
    6. Total Reverse(-) alignment length
    7. Total Reverse(-) alignment coverage
    8. Total NoStrand(.) alignment length
    9. Total NoStrand(.) alignment coverage
    10. Total All(+,-,.) alignment length
    11. Total All(+,-,.) alignment coverage
    12. BestHit alignment length
    13. BestHit alignment coverage
    14. BestHit information (id, length, score, e-value)
```

</details>



### cdna2orfs


> Translating cDNA sequences into open reading frames

<details>
<summary>Usage</summary>

```
                                                                          
 PROGRAM:   cdna2orfs - version 1.0                                    
                                                                          
 USAGE:                                                                   
                                                                          
   cdna2orfs [ options ] < prot_seq.tbl > prot_seq.fasta               
                                                                          
                                                                          
 DESCRIPTION:                                                             
                                                                          
   Translating an input stream of cDNA sequences in fasta format to       
   all the possible open reading frames, output is also in fasta format.  
   The program assumes the sequence to be in forward strand.              
   It is quite fast as it uses C functions from largeseqs.pm (via         
   Inline perl module).                                                   
                                                                          
                                                                          
 COMMAND-LINE OPTIONS:                                                    
                                                                          
   -N, --do-not-translate                                                 
     Return de ORF sequences at nucleotide level instead of the           
     translated ORFs, which is the default option.                        
                                                                          
   -B, --both-strands                                                     
     Check forward and reverse, by default only looking at forward.       
     Useful when not sure if proper orientation was given for             
     the RNA/cDNA sequence.                                               
                                                                          
   -l, --largest-only                                                     
   -m, --min-length <integer>                                             
     By default all the possible open reading frames are calculated.      
     When 'l' switch is provided, then returns only the largest of all    
     the ORFs obtained when the input sequence is translated              
     in all three phases from the initial nucleotide.                     
     The 'm' switch allows to define a length cut-off, where <integer>    
     refers to the minimum amino acid length that an ORF should have to   
     be outputed.                                                         
     If both options are provided, 'l' and 'm', for each cDNA sequence,   
     the largest ORF is printed out only when it is larger than           
     the length cutoff.                                                   
                                                                          
   -u, --unique-orf                                                       
     If more than one ORF has the same length, the one with the           
     smaller phase is printed when filtering by length.                   
                                                                          
   -d, --full-orf-desc                                                    
     Append the location, strand and phase information to the             
     sequence description.                                                
                                                                          
   -Z, --gzip-output                                                      
     Compress output on the fly and send to stdout.                       
                                                                          
   The following command-line options are set by default                  
   when using "CGL::Global.pm":                                           
                                                                          
            -h, --help  Shows this help.                                  
             --version  Shows version for current script.                 
         -v, --verbose  Execution messages are sent to STDERR.            
   -V, --color-verbose  Messages are text-coloured to highlight           
                        different kinds of messages.                      
               --debug  All execution messages are sent to STDERR,        
                        including dumps of the internal data structures.  
                                                                          
```

</details>

### tblshuffle


> Converting a sequence input stream in tabular format to shuffled tabular.


<details>
<summary>Usage</summary>

```
                                                                          
 PROGRAM:   tblshuffle - version 1.0                                      
                                                                          
 USAGE:                                                                   
                                                                          
   tblshuffle [ options ] < prot_seq.tbl > prot_seq_shuffled.tbl          
                                                                          
                                                                          
 DESCRIPTION:                                                             
                                                                          
   Converting a sequence input stream in tabular format to another        
   tabular file with all sequences shuffled.                              
   It is quite fast as it uses C functions from largeseqs.pm (via         
   Inline perl module).                                                   
                                                                          
                                                                          
 COMMAND-LINE OPTIONS:                                                    
                                                                          
   -Z, --gzip-output                                                      
     Compress output on the fly and send to stdout.                       
                                                                          
   The following command-line options are set by default                  
   when using "CGL::Global.pm":                                           
                                                                          
            -h, --help  Shows this help.                                  
             --version  Shows version for current script.                 
         -v, --verbose  Execution messages are sent to STDERR.            
   -V, --color-verbose  Messages are text-coloured to highlight           
                        different kinds of messages.                      
               --debug  All execution messages are sent to STDERR,        
                        including dumps of the internal data structures.  
                                                                          
```
</details>

### fa2fa


> Cleaning fasta sequences from non-standard symbols (like '*'), 
also providing reverse, complement, and reverse-complement options.


<details>
<summary>Usage</summary>

```
                                                                          
 PROGRAM:   fa2fa - version 1.0                                        
                                                                          
 USAGE:                                                                   
                                                                          
   fa2fa [ options ] < prot_seq.tbl > prot_seq.fasta                   
                                                                          
                                                                          
 DESCRIPTION:                                                             
                                                                          
   Fixing fasta files: standard sequence IDs, removing weird chars,       
   and so on.                                                             
   It is quite fast as it uses C functions from largeseqs.pm (via         
   Inline perl module).                                                   
                                                                          
                                                                          
 COMMAND-LINE OPTIONS:                                                    
                                                                          
   -R, --reverse-seq                                                      
     Returns the reverse sequence of each input sequence.                 
                                                                          
   -C, --complement-seq                                                   
     Returns the complement sequence for each input sequence.             
                                                                          
   -RC, --reverse-complement                                              
     Returning the reverse-complement for all the input seqs.             
                                                                          
   -Z, --gzip-output                                                      
     Compress output on the fly and send to stdout.                       
                                                                          
   -p, --fix-id-prefix <regexp>                                           
   -s, --fix-id-suffix <regexp>                                           
      Fixing IDs by removing a prefix or a suffix from the ID string.     
      <regexp> sets a regular expression which defines what has to be     
      removed from input sequence IDs.                                    
                                                                          
   The following command-line options are set by default                  
   when using "CGL::Global.pm":                                           
                                                                          
            -h, --help  Shows this help.                                  
             --version  Shows version for current script.                 
         -v, --verbose  Execution messages are sent to STDERR.            
   -V, --color-verbose  Messages are text-coloured to highlight           
                        different kinds of messages.                      
               --debug  All execution messages are sent to STDERR,        
                        including dumps of the internal data structures.  
                                                                          
```

</details>


### N50stats


> From a sequence file in fasta format, compute N50 assembly statistics
for different sequence length ranges.

<details>
<summary>Usage</summary>

```
 PROGRAM:   N50stats - version 1.0                                     
                                                                          
 USAGE:                                                                   
                                                                          
   N50stats [options] seqsfile.fasta                                   
                                                                          
                                                                          
 DESCRIPTION:                                                             
                                                                          
   From a sequence file in fasta format, compute N50 assembly statistics  
   for different sequence length ranges. This script extends previous     
   count_fasta program developed by Joseph Fass at the Bioinformatics  
   Core at UC Davis Genome Center, modified from a script by Brad Sickler.
   The point is to get further info from sequences length distribution,   
   as well as segmenting the N50 calculation by fixed length ranges,      
   ressembling the output produced by SOAPdenovo on the ScaffStats file.  
                                                                          
   When several fasta files are provided this program will calculate      
   all the assembly statistics as if they were coming from a single file. 
   This can be useful when the assembler produces separate files          
   for scaffolds, contigs, singletons and/or other, and we do not want    
   to keep another copy of the sequences in a merged file.                
                                                                          
                                                                          
 COMMAND-LINE OPTIONS:                                                    
                                                                          
   -G, --genome-length <int>                                              
     Estimated genome size, which is used to calculate NG50. It is        
     similar to N50 but corrected by expected genome size. It accepts     
     SI units: 'k' for kilo bases, 'M' for mega bases, and 'G' for        
     giga bases; for instance "10k" instead of "10000". Just notice       
     there is no space allowed between the number and the unit symbol.    
                                                                          
   -B, --bin-size <int>                                                   
     Bin size for the lengths histogram printed to STDERR when            
     computing the N50 stats. By default it uses 1000bp, but any          
     positive integer value can be provided. If bin size is set           
     to zero, the histogram is not calculated then. It also accepts       
     SI units as the previous seitch.                                     
                                                                          
   -S, --scaffold-label                                                   
   -C, --contig-label                                                     
     First one sets the labels of the different output items to include   
     "Scaffold", while the second sets it to "Contig". By default, the    
     label is simply set to "Sequence". In case both are simultaneously   
     provided, none of those command-line switches will be considered     
     by the program (setting it back to "Sequence").                      
                                                                          
   -T, --title <string>                                                   
     If defined, write a header showing this title.                       
                                                                          
   -M, --save-histogram <output_file>                                     
     Filename where to save the histogram, otherwise by default           
     it will be sent to the STDERR channel. If bin size is set            
     to zero, see corresponding switch info, this file will not           
     be created either.                                                   
                                                                          
   -L, --save-length-vectors <vectors_file>                               
     Provide a filename where length vectors will be stored for later     
     analyses and visualization (using R for instance). Output file       
     has two columns, one with the factor, the second with a length,      
     repeated as many times as lengths were defined for the factor.       
     The program will generate a file having as many rows as two times    
     the number of input sequences.                                       
                                                                          
                                                                          
```

</details>


### gunalias


> Normalize gene/protein names according to the HGNC dictionary, or to any specified symbol dictionary.
> Can also be used for any other symbol mappings by using option `-d`.
> see `man gunalias` or `man CGL::Unalias`.

<details>
<summary>Usage</summary>

```
Usage:
        gunalias [-h] [-i INPUT] [-o OUTPUT] [-c COLUMN [-c COLUMN] ...] [-s SEPARATOR] [-d DICTIONARY]

Options:
    -h, -help
            Shows this help.

    -v, -verbose
            Change verbosity.

    -i, -input FILE
            Input file to normalize gene names from. If not specified, will
            use STDIN.

    -o, -output FILE
            Output file to write normalized table. If not specified, will
            write to STDOUT.

    -c, -columns INTEGER
            Columns in input or STDIN where the gene names are so that
            gunalias can normalize them. Should be bigger than 1. Default is
            1. Normalize multiple columns by specifying the option multiple
            times, e.g.: `gunalias -c 1 -c 2`

    -s, -separator STRING
            Separator character (or Perl-compatible regular expression) that
            defines columns in input or STDIN. By default "\t".

    -d, -dictionary FILE
            Dictionary file for CGL::Unalias to use. If not specified,
            gunalias will use the default HGNC dictionary of the
            CGL::Unalias module.

```

</details>


## Tricks

<details>
<summary>Changing name of sequence identifiers in fasta file</summary>
	
```
	fa2tbl fasta.fa | gunalias -c 1 -d ids.txt | tbl2fa > fasta.newids.fa 
```

</details>


## License and copyright

Copyright (C) 2018 Computational Genomics Lab @ UB 
with contributions from J.F. Abril, S. Castillo-Lara, R. Arenas-Galnares

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
