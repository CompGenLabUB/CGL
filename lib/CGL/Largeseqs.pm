#
# CGL::Largeseqs.pm
#
#   embedded C functions for large sequences processing.
#
# ####################################################################
#
#            Copyright (C) 2003 - Josep F ABRIL
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# ####################################################################
#
# $Id$
#
package CGL::Largeseqs;
use strict;
use warnings;
use vars qw( @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $VERSION 
	     $scoP $scoN $opnG $extG $TS
	     $fasta_LW $qual_LW
	     $MYHOST $MYPATH
	     );

use Exporter;
$VERSION = substr('$Id$', 5, -2); # $VERSION = '1.00';
@ISA = qw(Exporter);
@EXPORT = qw(
           set_verbose LS_v LS_LNC LS_lnm LS_LNM
           get_large_fasta_seqs get_large_tbl_seqs
           get_large_qual_sets get_large_fasta_from_file
           reversecompl complement_dnaseq reverse_seq
           substr_largeseq dna_sequence_composition
           translate stopcodons_in_protseq CODON_TABLE
           save_fasta $fasta_LW save_qual $qual_LW save_tbl $TS
           pairwise_seq_comp pairwise_seq_comp_maxlocal $scoP $scoN $opnG $extG
           open_input_file open_output_file close_file
           set_perlfh
           );
@EXPORT_OK = qw( );
%EXPORT_TAGS = (
           MULTIfasta => [ qw( set_verbose get_large_fasta_seqs
                               open_input_file close_file            ) ],
           MULTItbl   => [ qw( set_verbose get_large_tbl_seqs
                               open_input_file close_file            ) ],
           MULTIqual  => [ qw( set_verbose get_large_qual_sets
                               open_input_file close_file            ) ],
           READfasta  => [ qw( set_verbose get_large_fasta_from_file
                               open_input_file close_file            ) ],
           SBSTRseqs  => [ qw( set_verbose substr_largeseq           ) ],
           DNAsqcomp  => [ qw( set_verbose dna_sequence_composition  ) ],
           TRANSLATE  => [ qw( set_verbose
                               translate stopcodons_in_protseq       ) ],
           REVCOMPseq => [ qw( set_verbose reversecompl
                               complement_dnaseq reverse_seq         ) ],
           SAVEfasta  => [ qw( set_verbose save_fasta $fasta_LW
                               open_output_file close_file           ) ],
           SAVEtbl    => [ qw( set_verbose save_tbl $TS
                               open_output_file close_file           ) ],
           SAVEqual   => [ qw( set_verbose save_qual $qual_LW
                               open_output_file close_file           ) ],
           FILEfasta  => [ qw( set_verbose
                               open_input_file open_output_file
                               close_file                            ) ],
           SEQSfasta  => [ qw( set_verbose
                               get_large_fasta_from_file
                               substr_largeseq reversecompl
                               dna_sequence_composition
                               translate stopcodons_in_protseq CODON_TABLE
                               save_fasta $fasta_LW
                               open_input_file open_output_file
                               close_file                            ) ],
           PWSEQcomp  => [ qw( pairwise_seq_comp
                               $scoP $scoN $opnG $extG ) ],
           PWSEQcompML => [ qw( pairwise_seq_comp_maxlocal
                                $scoP $scoN $opnG $extG ) ],
           PERLiofh   => [ qw( set_perlfh ) ],
           );
#
# $MYHOST = defined($ENV{HOST}) ? $ENV{HOST} : "generic";
# $MYPATH = (defined($ENV{BIN}) ? $ENV{BIN} : ".").'/.inline';
# ( -e $MYPATH && -d _ ) || mkdir($MYPATH);
# $MYPATH .= '/'.$MYHOST;
# ( -e $MYPATH && -d _ ) || mkdir($MYPATH);
# $MYPATH .= '/.inline';
# ( -e $MYPATH && -d _ ) || mkdir($MYPATH);
# print STDERR "### COMPILING INLINE INTO $MYPATH\n";
#
my $ILD = defined($ENV{HOME})
         ? $ENV{HOME}.'/.inline'
         : (defined($ENV{BIN}) ? $ENV{BIN}.'/.inline'
                               : '/usr/lib/perl5/molbio/.inline');
# my $ILD = defined($ENV{BIN}) ? $ENV{BIN}.'/.inline'
#                              : '/usr/lib/perl5/molbio';
(-e $ILD && -d _) || system('mkdir', $ILD);
$ENV{'PERL_INLINE_DIRECTORY'} = $ILD;
use Inline ( C         => 'DATA',
             FILTERS   => 'Strip_POD',
             DIRECTORY => $ILD,
             NAME      => 'CGL::Largeseqs',
            );
           # DIRECTORY => $MYPATH,
           # VERSION   => '1.00', # required if must build a CPAN like module
use Inline Config    => (
               'FORCE_BUILD'       => 0,
               'CLEAN_AFTER_BUILD' => 0
             );
#
###
### Setting Default Variables
###


#
# Exiting from "CGL::Largeseqs" package
1;

__DATA__

=pod


=head1 B<NAME>

largeseqs - embeeded C functions for large sequences processing

=head1 B<SYNOPSIS>

use largeseqs qw( :Exported_TAGs );

=head1 B<DESCRIPTION>

The largeseqs module implements perl functions that interface
with C procedures for handling large sequences faster.

=head2 Available Tags from this module (C<:Exported_TAGs>):

The following TAGs list shows each available tag followed by the
variables and functions that makes available to those scripts using
the C<qw> form for B<largeseqs.pm>. If C<:DEFAULT> tag is provided, 
all the exported variables and functions will be available on the script
using B<largeseqs.pm> (also when no tags at all were given).

=over 4

=item B<:READfasta>
C< get_large_fasta_from_file()  open_input_file()  close_file()  set_verbose() >

=item B<:MULTIfasta>
C< set_verbose()  get_large_fasta_seqs()  open_input_file()  close_file() >

=item B<:MULTItbl>
C< set_verbose()  get_large_tbl_seqs()  open_input_file()  close_file() >

=item B<:MULTIqual>
C< set_verbose()  get_large_qual_sets()  open_input_file()  close_file() >

=item B<:SBSTRseqs>
C< substr_largeseq()  set_verbose() >

=item B<:DNAsqcomp>
C< dna_sequence_composition()  set_verbose() >

=item B<:TRANSLATE>
C< translate() stopcodons_in_protseq() set_verbose() >

=item B<:SAVEfasta>
C< save_fasta()  $fasta_LW  open_output_file()  close_file()  set_verbose() >

=item B<:SAVEtbl>
C< save_tbl()  open_output_file()  close_file()  set_verbose() >

=item B<:SAVEqual>
C< save_qual()   $qual_LW   open_output_file()  close_file()  set_verbose() >

=item B<:FILEfasta>
C< open_input_file()  open_output_file()  close_file()  set_verbose() >

=item B<:SEQSfasta>
C< :READfasta  :SBSTRseqs  :DNAsqcomp  :TRANSLATE  :SAVEfasta  :FILEfasta >

=item B<:PWSEQcomp>
C< pairwise_seq_comp() $scoP $scoN $opnG $extG >

=item B<:PERLiofh>
C< set_perlfh() >

=back

=head1 B<AUTHOR>

       Josep F Abril <jabril@imim.es>


=head1 B<COPYRIGHT AND DISCLAIMER>

This program is Copyright 2003 by Josep F Abril.  This program is
free software; you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

If you do not have a copy of the GNU General Public License write to
the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139,
USA.


=head1 B<APPENDIX>

The rest of the documentation details each of the functions implemented 
for the current perl module. Exported functions and variables are described
first and are available from perl caller, internal functions or variables 
may be described after those but can only be accessed within this module.

=begin comment

Internal functions are usually preceded with a "_".

=end comment

    
    
=head1 B<APPENDIX : Exported Features>
    
    
=head2 GLOBAL VARS (exportable)

=over 4

=item B<C<int LS_v>>

B<LS_v> switches ON/OFF execution process report to stderr, 0 disables
and any other numeric value enables messages (use of 1 is preferable).
Default is set to 0 (not to report function execution).

=item B<C<int LS_V>>

B<LS_V> switches ON/OFF debugging extended execution report to stderr,
0 disables and any other numeric value enables extended messages 
(use of 1 is preferable). Default is set to 0 (not to extend reports).

=item B<C<long LS_lnm>>

B<LS_lnm> (LargeSeqs LineNumberMod) defines the number of lines parsed 
before printing a dot ('.') counter when generating process report 
to stderr ('... [xxx bp]'). Default value is 1.

=item B<C<long LS_LNC>>

B<LS_LNC> (LargeSeqs LineNumberCounter) defines the number of B<LS_lnm> 
lines parsed before printing a subtotal counter ('[xxx]') (which is
decided from B<LS_LNM>) when generating progress report to stderr 
('... [xxx bp]'). B<LS_LNM> is the the product of B<LS_lnm> by B<LS_LNC>.
B<LS_LNC> is set to 50 by default.

=item B<C<long LS_LNM>>

B<LS_LNM> (LargeSeqs LineNumberMod) defines the number lines parsed 
before printing a subtotal counter ('[xxx]') when generating progress 
report to stderr ('... [xxx]'). It is computed as the product of
B<LS_lnm> by B<LS_LNC>.

=item B<C<$fasta_LW>>

B<$fasta_LW> sets line width for the output fasta formated sequences.
Default is set to 50 (useful to calculate sequence length from file)
and accepted values ranging from 10 to 250.

=item B<C<$qual_LW>>

B<$qual_LW> sets number of quality scores for the output fasta
formated quality files.  Default is set arbitrarily to 25 (which takes
about 75 chars per line if we assume two digit integer scores and a
blank space between each score pair) and accepted values ranging from
10 to 250.

=item B<C<int LS_stdin>>

=item B<C<int LS_stdout>>

=item B<C<FILE* ifh>>

=item B<C<FILE* ofh>>


=item B<C<HV* CODON_TABLE>>

B<CODON_TABLE> will contain the dictionary of DNA codons with their
corresponding amino acid symbols. The three stop codons were coded 
using three different symbols and an extra key 'STP'is set to code 
any stop codon (if do not want to distinguish among them).


=back
    
=head2 SUB B<C< void set_verbose(int [, long [, long [, int ] ] ]) >>

=over 4

=item Usage   :

    set_verbose($verbose,$lnm,$lnc,$debug);

=item Function:

Setting verbose mode C variables from current perl script caller.

=item Returns :

(void)

=item Args    :

B<$verbose> switches ON/OFF execution process report to stderr, 0 disables
and any other numeric value enables messages (use of 1 is preferable).
Default is set to 0 (not to report function execution).
B<$lnm> (line number modulus) is optional and defines the number lines
parsed before printing a dot ('.') counter when generating process report 
to stderr ('... [xxx bp]'). Default is set to 1, which is also the lowest 
value that this variable can hold. Set it to 0 to leave unchanged when
the next variables have to be modified.
B<$lnc> (line number counter) is optional too and sets the number of dots
reported before printing nucleotide counter when generating process report 
to stderr ('... [xxx bp]'). Default is set to 50, minimum allowed value is
10. Set it to 0 to leave unchanged when the next variable has to be modified.
B<$debug> switches ON/OFF debugging extended execution report to stderr,
0 disables and any other numeric value enables extended messages 
(use of 1 is preferable). Default is set to 0 (not to extend reports).

Warnings and fatal errors are always reported (via croak->die).

=back
    
=head2 SUB B<C< int get_large_fasta_seqs(SV*,SV*,SV*,long) >>

=over 4

=item Usage   :

        while ( get_large_fasta_seqs($seq_id, $seq_desc,
                                 $sequence, $seq_len) )
        { ... };

=item Function:

Reads single fasta sequence records from an opened input filehandle.
User must call this function from a while loop to read all 
the fasta records from the input stream.

=item Returns :

If function could read a fasta sequence, sets arguments to corresponding
values of sequence id, description, sequence itself and sequence length.
Returns 1 or 0, if it was able to load a fasta sequence or not. 

=item Args    :

B<$seq_id>
B<$seq_desc>
B<$sequence>
B<$seq_len>

=back
    
=head2 SUB B<C< int get_large_tbl_seqs(SV*,SV*,SV*,long) >>

=over 4

=item Usage   :

        while ( get_large_tbl_seqs($seq_id, $seq_desc,
                               $sequence, $seq_len) )
        { ... };

=item Function:

Reads single tbl sequence records from an opened input filehandle.
User must call this function from a while loop to read all 
the sequence records from the input stream.

=item Returns :

If function could read a sequence record, sets arguments to corresponding
values of sequence id, description, sequence itself and sequence length.
Returns 1 or 0, if it was able to load a sequence record in tabular format
or not. 

=item Args    :

B<$seq_id>
B<$seq_desc>
B<$sequence>
B<$seq_len>

=back
    
=head2 SUB B<C< long get_large_fasta_from_file(SV*) >>

=over 4

=item Usage   :

=over 4

=item From perl caller:
    
        $seqnum = get_large_fasta_from_file($seq_hash);
    
=item From C caller:
    
        seqnum = (long) get_large_fasta_from_file(SV* seq_hash);
    
=back

=item Function:

Loading large files having one or more sequences in fasta format.

=item Returns :

Number of elements loaded into B<%{$seq_hash}>,
0 on failure (empty file/hash).

=item Args    :

Function reads input from an opened input filehandle (see 
B<open_input_file()>), which provides a fasta file containing the 
sequences to be read.
B<$seq_hash> is a reference to a hash, it will contain a list of sequence
identifiers from input stream, used as keys to index an anonymous hash
having the following sub-keys: DSC (sequence description from fasta header),
SEQ (the sequence itself) and LEN (the sequence string length). The final
ouput hash will look like:
    
    %seq_hash = (
        'SEQ1' => {
            'SEQ' => 'GAATTCTCGAGT...CAATAAATCTCA',
            'LEN' => 4500,
            'DSC' => 'An example of sequence description'
            },
        [ ... more sequences (anonymous hashes for each one) ... ]
        );

=back

    
=head2 SUB B<C< long substr_largeseq(SV*, long, SV*, SV*, char) >>

=over 4

=item Usage   :

=over 4

=item From perl caller:
    
        $seqnum = substr_largeseq(
                  $bigseq, $bigseqlen, $reftocoords, $reftoseqary, $strand);
    
=item From C caller:
    
        seqnum = (long) substr_largeseq(SV* bigseq, long bigseqlen,
                        SV* reftocoords, SV* reftoseqary, char strand);
    
=back

=item Function:

Retrieving sequence substrings from large sequences.

=item Returns :

Number of substrings retrieved from B<bigseq>,
0 on failure (unable to get substrings). It loads
the B<reftoseqary> array with the set of extracted
subsequences.

=item Args    :

    ...

=back

    
=head2 SUB B<C< void dna_sequence_composition(SV*, long) >>

=over 4

=item Usage   :

        @composition = dna_sequence_composition($dna_seq, $seq_len);

=item Function:

Computing the amount of each nucleotide in a given DNA sequence.

=item Returns :

A list of numbers, acounting for #A, #T, #G, #C, #N, #? and #lc.
#N also includes any 'X' found in the sequence string.
#lc summarizes the ammount of lower-case chars in the sequence.

=item Args    :

...

=back

    
=head2 SUB B<C< long translate(SV*, SV*, int, [ int ]) >>

=over 4

=item Usage   :

        $protlength = translate(SV* dna_seq, SV* prot_seq,
                            int frame, [ int stopcodon ])

=item Function:

...

=item Returns :

...
This function allows the translation of stop codons using two different
char sets. The standard translation assumes that all stop codons map to 
same symbol, e.g. '*'. The extended translation, set by default, allows
the user to distingish among the three different stop codons, by using 
other chars in the translation (see Args section).

=item Args    :

B<stopcodon> is an optional boolean argument. If the B<stopcodon> flag
is passed to the function, then switches the standard stop-codon 
translation ON/OFF (depending on its value, set as 1/0 respectively). 
By default, it is set to 0 (OFF), so the stop codons are translated 
in the extended format ('@' -> 'TGA', '#' -> 'TAG', '!' -> 'TAA').

=back
    
=head2 SUB B<C< void stopcodons_in_protseq(SV*) >>

=over 4

=item Usage   :

        void stopcodons_in_protseq(SV* prot_seq)

=item Function:

...

=item Returns :

A list containing the number of stop codons found in a protein sequence.
Counters for codons are also taking into account codes for extended format 
('@' -> 'TGA', '#' -> 'TAG', '!' -> 'TAA', '*' -> any stop codon / total).

=item Args    :

...

=back

    
=head2 SUB B<C< void save_fasta(SV*, SV*) >>

=over 4

=item Usage   :

        ...

=item Function:

...

=item Returns :

...

=item Args    :

...

=back
    
=head2 SUB B<C< void save_tbl(SV*, SV*, SV*) >>

=over 4

=item Usage   :

        ...

=item Function:

...

=item Returns :

...

=item Args    :

...

=back

    
=head2 SUB B<C< void pairwise_seq_comp(SV*, SV*) >>

=over 4

=item Usage   :

        ...

=item Function:

...

=item Returns :

...

=item Args    :

...

=back

    
=head2 SUB B<C< FILE* open_input_file(char*) >>

=over 4

=item Usage   :
    
        FILE* fh = open_input_file(char* file_name);
    
=item Function:

Opens a file pointer for a given file name to read.

=item Returns :

A file pointer, forces program exit if cannot open the file.

=item Args    :

B<file_name> must have read permissions. If set to '-', then function 
returns a file pointer to standard input (STDIN).  

=back
    
=head2 SUB B<C< FILE* open_output_file(char*, [ char ]) >>

=over 4

=item Usage   :
    
        FILE* fh = open_output_file(char* file_name, [ char open_mode ]);
    
=item Function:

Opens a file pointer for a given file name to write/append.

=item Returns :

A file pointer, forces program exit if cannot open the file.

=item Args    :

B<file_name> must have write permissions. If set to '-', then function 
returns a file pointer to standard output (STDOUT).
If defined, B<open_mode> sets whether file can be open to overwrite ("w") 
or to append ("a"), by default function opens files in overwrite mode.

=back
    
=head2 SUB B<C< void close_file(FILE*, int) >>

=over 4

=item Usage   :
    
        close_file(FILE* file_handle, int IO_flag);
    
=item Function:

Flushes contents of current opened buffers and closes 
the B<file_handle> if it is neither B<stdin> nor B<stdout>
(depending on B<IO_flag> value if it is set to 0 or 1,
respectively).

=item Returns :

(void)

=item Args    :

B<file_handle> must be set to an opened file pointer
(see further details on functions B<open_input_file>
and B<open_output_file> descriptions).
B<IO_flag> determines if the B<file_handle> was opened
for an input or an output stream (0 and 1 respectively).

=back
    
=head2 SUB B<C< void set_perlfh(SV*, int) >>

=over 4

=item Usage   :
    
        set_perlfh(SV* file_handle, int IO_flag, int);
    
=item Function:

This function is an attempt to pass an already opened
perl perlfh to the C functions from this module.

=item Returns :

(void)

=item Args    :

B<file_handle> must be set to an opened file pointer
(see further details on functions B<open_input_file>
and B<open_output_file> descriptions).
B<IO_flag> determines if the B<file_handle> was opened
for an input or an output stream (0 and 1 respectively).

=back
    
=head1 B<APPENDIX : Internal Features>
    

=item B<C<static long FASTAseqcnt>>

A global variable that counts the number of sequences loaded by 
B<get_large_fasta_seqs>, if it is called several times...

    
=head2 SUB B<C< static void my_chomp(char*) >>

=over 4

=item Usage   :

        my_chomp(char* current_string)

=item Function:

Removes all trailing whitespaces, tabs or newline chars.

=item Returns :

(void) and modifies B<current_string>.

=item Args    :

B<current_string>.

=back
    
=head2 SUB B<C< static void parse_sequence_fasta_header(char*, char*, char*) >>

=over 4

=item Usage   :

        parse_sequence_fasta_header(char* current_string,
                                char* sequence_id, char* description)

=item Function:

From a fasta header formated line, retrieves the sequence identifier
and loads the remaining characters as that sequence description.

=item Returns :

(void) and modifies B<sequence_id> and B<description>.

=item Args    :

B<current_string>, B<sequence_id> and B<description>.

=back
    
=head2 SUB B<C< static void add_seqhash_value(SV*, SV*, SV*, SV*, long) >>

=over 4

=item Usage   :

        add_seqhash_value(SV* hash_ref, SV* seq_id, 
                      SV* seq_desc, SV* sequence,
                      long seq_length)

=item Function:

...

=item Returns :

(void) and loads a new B<key => value> pair on the hash referred by 
B<hash_ref>, as shown in the following data structure example:
    
    B<seq_id> => {
            'SEQ' => B<sequence>,
            'LEN' => B<seq_length>,
            'DSC' => B<seq_desc>
            }
    
=item Args    :

B<hash_ref>, B<seq_id>, B<seq_desc>, B<sequence> and B<seq_length>.

=back
    
=head2 SUB B<C< static void check_subsequence_coords(long*, long*, long) >>

=over 4

=item Usage   :

        ...

=item Function:

...

=item Returns :

...

=item Args    :

...

=back
    
=head2 SUB B<C< static void get_subsequence(long, long, char, char*, char*) >>

=over 4

=item Usage   :

        ...

=item Function:

...

=item Returns :

...

=item Args    :

...

=back
    
=head2 SUB B<C< static void direct_sequence(long, long, char*, char*) >>

=over 4

=item Usage   :

        ...

=item Function:

...

=item Returns :

...

=item Args    :

...

=back
    
=head2 SUB B<C< static void subseq_revcomp(long, long, char*, char*) >>

=over 4

=item Usage   :

        ...

=item Function:

...

=item Returns :

...

=item Args    :

...

=back
    
=head2 SUB B<C< static void reversecompl(SV*, long) >>

=over 4

=item Usage   :

        ...

=item Function:

...

=item Returns :

...

=item Args    :

...

=back
    
=head2 SUB B<C< static int dna_complement(int c) >>

=over 4

=item Usage   :

        ...

=item Function:

...

=item Returns :

...

=item Args    :

...

=back
    
=head2 SUB B<C< static void load_codon_hash(SV*) >>

=over 4

=item Usage   :

        ...

=item Function:

...

=item Returns :

...

=item Args    :

...

=back
    
=head2 SUB B<C< static long translate_seq(char*, char*, int, int) >>

=over 4

=item Usage   :

        ...

=item Function:

...

=item Returns :

...

=item Args    :

...

=back
    
=cut

__C__
/* */
/* #include <stdio.h>    *** loaded by default via perl.h */
/* #include <string.h>   *** loaded by default via perl.h */
/* #include <stdlib.h> */
/* */
int LS_v = 0;
int LS_V = 0;
long LS_lnm = 1;
long LS_LNC = 50;
long LS_LNM = 50;
     /* (long) (((long) LS_lnm) * ((long) LS_LNC)) */
     /* LS_LNM is re-calculated by set_verbose()   */
static long FASTAseqcnt = 0;
HV* CODON_TABLE;
int LENGTHCODON = 3;
long seqfa_lw = 50;  /* output fasta sequence line width */
static char go_left = 'L', go_up = 'U', go_diag = 'D', go_stop = '*';
int LS_stdin = 0;
int LS_stdout = 0;
FILE* ifh;
FILE* ofh;
/* */
void set_verbose(int, ...);
long get_large_fasta_from_file(SV*);
int get_large_fasta_seqs(SV*,SV*,SV*,SV*);
static void pushback(FILE*, char*);
static void my_chomp(char*);
static void parse_sequence_fasta_header(char*, char*, char*);
static void add_seqhash_value(SV*, SV*, SV*, SV*, long);
int get_large_tbl_seqs(SV*,SV*,SV*,SV*);
int get_large_qual_sets(SV*,SV*,SV*,SV*);
long substr_largeseq(SV*, long, SV*, SV*, char);
static void check_subsequence_coords(long*, long*, long);
static void get_subsequence(long, long, char, char*, char*);
static void direct_sequence(long, long, char*, char*);
static void subseq_revcomp(long, long, char*, char*);
void reversecompl(SV*, long);
void complement_dnaseq(SV*, long);
void reverse_seq(SV*, long);
static int dna_complement(int c);
void dna_sequence_composition(SV*, long);
long translate(SV*, SV*, int, ...);
static void load_codon_hash(SV*);
static long translate_seq(char*, char*, int, int);
void stopcodons_in_protseq(SV*);
void save_fasta(SV*, SV*);
void save_tbl(SV*, SV*, SV*);
void save_qual(SV*, SV*, SV*);
void pairwise_seq_comp(SV*,SV*);
void pairwise_seq_comp_maxlocal(SV*,SV*);
static void init_long_matrix(long***, long, long);
static void init_char_matrix(char***, long, long);
static long max(long, long);
static void free_matrix(void***, long);
static void prt_seq(long, char*);
FILE* open_input_file(char*);
FILE* open_output_file(char*, ...);
void close_file(FILE*, int);
void set_perlfh(SV*, int, ...);
/* */
/*<largeseqs.pm: setting SV global vars>*/
/* */
/* */
void set_verbose(int v, ...)
{

    Inline_Stack_Vars;
    long hlcnt, cnt;
    int d = 0;
    int c = 0;

    if (v != 0) /* SWITCHING ON VERBOSE */
        LS_v = 1;

    if (Inline_Stack_Items > 3)
    {
        if (SvIOK(Inline_Stack_Item(3)))
        {
            d = (int) SvIV(Inline_Stack_Item(3));
        }
        if (d != 0) /* SWITCHING ON DEBUG */
            LS_V = 1;
    }

    if (Inline_Stack_Items > 1)
    {
        hlcnt = LS_lnm;
        if (SvIOK(Inline_Stack_Item(1)))
        {
            hlcnt = (long) SvIV(Inline_Stack_Item(1));
            c++;
        }
        else
        {
            croak("#############\n### ERROR ### %s\n############# %s\n",
                  "USAGE: void set_verbose(int, >>long<<, long)",
                  "       2nd argument must be an integer...");
            /* exit(1); */
        }
        if (hlcnt != 0) { /* 0 as a null value to avoid var modification */
            if (hlcnt < 1)
                hlcnt = 1;
            LS_lnm = hlcnt;
        }
    }

    if (Inline_Stack_Items > 2)
    {
        cnt = LS_LNC;
        if (SvIOK(Inline_Stack_Item(2)))
        {
            cnt = (long) SvIV(Inline_Stack_Item(2));           
            c++;
        }
        else
        {
            croak("#############\n### ERROR ### %s\n############# %s\n",
                  "USAGE: void set_verbose(int, long, >>long<<)",
                  "       3rd argument must be an integer...");
            /* exit(1); */
        }
        if (cnt != 0) { /* 0 as a null value to avoid var modification */
            if (cnt < 10)
                cnt = 10;
            LS_LNC = cnt;
        }
    }

    if (c > 0)
       LS_LNM = (long) (((long) LS_lnm) * ((long) LS_LNC));

 /* fprintf(stderr,                                                             */
 /*   "## SET_VERBOSE: v %ld / V %ld / LS_lnm %ld / LS_LNC %ld / LS_LNM %ld\n", */
 /*   v,i,LS_lnm,LS_LNC,LS_LNM);                                                */

    Inline_Stack_Void;

} /* set_verbose */
/**/
/* load sequences in fasta format from input */
int get_large_fasta_seqs(SV* seq_id, SV* seq_desc, SV* sequence, SV* seq_len)
{
  
  /* current line buffer */
  int lmx = 32000; /* there are very long headers */
  int max =  1024;
  char line[lmx], mids[max], mdsc[lmx];
  
  /* single fasta elements */
  long llen;
  long pos = 0;
  
  /* line counter */
  long lc = 0;
  
  /* if found then save hash values (and reset to 0) */
  int found = 0;
  
  sv_setpv(seq_id  ,"");
  sv_setpv(seq_desc,"");
  sv_setpv(sequence,"");
  
  /* looping through the fasta file getting lines */
  while (fgets(line, lmx, ifh) != NULL)
    {
      llen = strlen(line);
      my_chomp(line);
      
      if (line[0] == '\0' || line[0] == '#') /* skipping empty lines */
	continue;
      
      if (line[0] == '>') /* fasta format sequence header */
        {
	  if (found)
            {
	      if (LS_v && (lc % LS_LNM))
		fprintf(stderr," [%10ld bp]\n",pos);
	      
	      /* seq_len = pos; */
	      sv_setiv(seq_len,pos);
	      
	      if (LS_stdin)
		pushback(ifh,line);
	      else
		fseek(ifh, 0 - llen, SEEK_CUR);
	      
	      return 1;
            }
	  
	  /* reset position on the current sequence string */
	  pos = 0;
	  lc = 0;
	  found = 1;
	  
	  /* line has the locus of the current sequence */
	  parse_sequence_fasta_header(line,mids,mdsc);
	  
	  if (mids[0] == '\0')
	    sprintf(mids,"seq_%ld",++FASTAseqcnt);
	  
	  if (mdsc[0] == '\0')
	    strcpy(mdsc,"undef");
	  
	  sv_setpvn(seq_id,  mids,strlen(mids));
	  sv_setpvn(seq_desc,mdsc,strlen(mdsc));
	  /* sv_setpv(sequence,""); */
	  
	  if (LS_v)
	    fprintf(stderr,"### %s\n", SvPV_nolen(seq_id));
	  continue;
        }
      else /* fasta format sequence line = "atcgata...atta\n" */
        {
	  sv_catpv(sequence,line);
	  pos = pos + strlen(line);
        }
      
      if (LS_v && found)
        {
	  ++lc;
	  if ( !(lc % LS_lnm) )
	    fprintf(stderr,"r");
	  
	  if ( !(lc % LS_LNM) )
	    fprintf(stderr," [%10ld bp]\n",pos);
        }
    } /* while fgets */
  
  if (found)
    {
      if (LS_v && (lc % LS_LNM))
	fprintf(stderr," [%10ld bp]\n",pos);
      
      /* seq_len = pos; */
      if (SvLEN(seq_desc) == 0)
	sv_setpv(seq_desc,"undef");
      sv_setiv(seq_len,pos);
      
      if (LS_stdin)
	pushback(ifh,line);
      else
	fseek(ifh, 0 - llen, SEEK_CUR);
      
      return 1;
    }
  
  /* Safefree(line); */
  /* Safefree(mids); */
  /* Safefree(mdsc); */
  
  return 0; /* NO FASTA SEQUENCE FOUND */
  
} /* get_large_fasta_seqs */
/* */
void pushback(FILE* ifh, char* line)
{
  long lns;
  
  lns = (long) strlen(line);
  
  ungetc('\n', ifh);
  
  while (line[lns] == '\0')
    {
      lns--;
    }
  
  while (lns >= 0)
    {
      ungetc(line[lns], ifh);
      lns--;
    }
  
} /* pushback */
/* */
/* load trace sequence quality records in fasta format from input */
int get_large_qual_sets(SV* seq_id, SV* seq_desc, SV* aryref, SV* seq_len)
{
  
  /* current line buffer */
  int lmx = 32000; /* there are very long headers */
  int max =  1024;
  char line[lmx], mids[max], mdsc[lmx];

  /* single fasta elements */
  long llen;
  long pos = 0;
  
  /* line counter */
  long lc = 0;
  
  /* if found then save hash values (and reset to 0) */
  int found = 0;
  
  sv_setpv(seq_id  ,"");
  sv_setpv(seq_desc,"");
  AV* sco_ary; /* = newAV(); */
  
  /* array references were expected */
  if ((! SvROK(aryref)) || (! SvTYPE(SvRV(aryref)) == SVt_PVAV))
    {
      croak("#############\n### ERROR ### %s\n############# %s\n",
	    "USAGE: int get_large_qual_sets(SV*, SV*, >>SV*<<, SV*)",
	    "       3rd argument must be a scores array ref...");
      /* exit(1); */
    };
  
  /* dereferencing */
  sco_ary = (AV*) SvRV(aryref);
  av_clear(sco_ary);

  /* looping through the fasta file getting lines */
  while (fgets(line, lmx, ifh) != NULL)
    {
      llen = strlen(line);
      my_chomp(line);
      
      if (line[0] == '\0' || line[0] == '#') /* skipping empty lines */
	continue;
      
      if (line[0] == '>') /* fasta format quality record header */
        {

	  if (found)
            {
	      if (LS_v && (lc % LS_LNM))
		fprintf(stderr," [%10ld sco]\n",pos);
	      
	      /* seq_len = pos; */
	      sv_setiv(seq_len,pos);
	      
	      if (LS_stdin)
		pushback(ifh,line);
	      else
		fseek(ifh, 0 - llen, SEEK_CUR);
	      
	      return 1;
            }
	  
	  /* reset position on the current record string */
	  pos = 0;
	  lc = 0;
	  found = 1;
	  
	  /* line has the locus of the current sequence */
	  parse_sequence_fasta_header(line,mids,mdsc);
	  
	  if (mids[0] == '\0')
	    sprintf(mids,"seq_%ld",++FASTAseqcnt);
	  
	  if (mdsc[0] == '\0')
	    strcpy(mdsc,"undef");
	  
	  sv_setpvn(seq_id,  mids,strlen(mids));
	  sv_setpvn(seq_desc,mdsc,strlen(mdsc));
	  /* sv_setpv(sequence,""); */
	  
	  if (LS_v)
	    fprintf(stderr,"### %s\n", SvPV_nolen(seq_id));
	  continue;

        }
      else /* fasta format scores line = " 10 12 ... 30( )*\n" */
        {
	  
	  /* loop through scores (words separated by blank spaces) */
	  long i, o, e;
	  
	  o = 0;
	  e = strlen(line);
	  
	  for (i = 0; i <= e; i++)
	    {
	      
	      /* scores separated by blank spaces */
	      if (line[i] == ' ' || line[i] == '\t' || line[i] == '\0')
		{
		  /* saving score into scores array */
		  if (o < i)
		    {

		      long j, k;
		      char sco[10];

		      for (j = o, k = 0; j < i; j++, k++)
			{
			  sco[k] = line[j];
			}
		      sco[k] = '\0';

		      av_push(sco_ary, newSViv(strtol(sco, NULL, 10)));
                                       /* quality scores are integers */
		      pos++;

		    }

		  o = i + 1;

		}

	      if (line[i] == '\0')
		break;
	      	      
	    } /* for i */
	  
	} /* else fasta format scores line */
      
      if (LS_v && found)
        {
	  ++lc;
	  if ( !(lc % LS_lnm) )
	    fprintf(stderr,"r");
	  
	  if ( !(lc % LS_LNM) )
	    fprintf(stderr," [%10ld sco]\n",pos);
        }
    } /* while fgets */
  
  if (found)
    {
      if (LS_v && (lc % LS_LNM))
	fprintf(stderr," [%10ld sco]\n",pos);
      
      /* seq_len = pos; */
      if (SvLEN(seq_desc) == 0)
	sv_setpv(seq_desc,"undef");
      sv_setiv(seq_len,pos);
      
      if (LS_stdin)
	pushback(ifh,line);
      else
	fseek(ifh, 0 - llen, SEEK_CUR);
      
      return 1;
    }
  
  /* Safefree(line); */
  /* Safefree(mids); */
  /* Safefree(mdsc); */
  
  return 0; /* NO FASTA QUALITY RECORDS FOUND */
  
} /* get_large_qual_sets */
/* */
int get_large_tbl_seqs(SV* seq_id, SV* seq_desc, SV* sequence, SV* seq_len)
{

    int c, k, v, e;
    long n;
    char l;

    sv_setpv(seq_id  ,"");
    sv_setpv(seq_desc,"");
    sv_setpv(sequence,"");

    c = 0; /* initializing char counter for current line */
    k = 0; /* empty lines check counter */
    v = 0; /* variable chooser */
    e = 1; /* l ne NULL */
    n = 0; /* initializing sequence length */

    while (1)
    {

        if ((l = fgetc(ifh)) != NULL && l != EOF)
        {
            if (c == 0)
            {
                if (l == '\n')
                {   /* skipping  empty  lines */
                    k = 0;
                    continue; 
                }
                if (l == ' ' || l == '\t')
                {   /* skipping "empty" lines (white spaces only) */
                    k++;
                    continue; 
                }
                if (l == '#')
                {   /* skipping comment lines */
                    while ((l = fgetc(ifh)) != NULL && l != '\n')
                        ;
                    if (l == NULL)
                    {
                        e = 0;
                        break;
                    }
                    continue; 
                }
            }
            if (k == 0)
            {
                c++;

                if (l == '\n')
                {
                    break;
                }

                if (v < 2 && (l == ' ' || l == '\t'))
                {
                    v++;
                    if (LS_v && v == 1)
                        fprintf(stderr,"### %s\n", SvPV_nolen(seq_id));
                    while ((l = fgetc(ifh)) != NULL && (l == ' ' || l == '\t'))
                        ;
                    if (l == '\n')
                    {
                        break;
                    }
                    if (l == NULL)
                    {
                        e = 0;
                        break;
                    }
                }

                switch (v) {
                    case 0:
                        sv_catpvf(seq_id,"%c",l);
                        break;
                    case 1:
                        sv_catpvf(sequence,"%c",l);
                        n++;
                        if (LS_v)
                        {
                                if ( !(n % LS_lnm) )
                                    fprintf(stderr,"r");
                            if ( !(n % LS_LNM) )
                                fprintf(stderr," [%10ld bp]\n",n);
                        }
                        break;
                    default:
                        sv_catpvf(seq_desc,"%c",l);
                        break;
                } /* switch */
                
            } 
        }
        else
        {
            e = 0;
            break;
        }

    } /* while 1 */

    if (LS_v && (n % LS_LNM))
        fprintf(stderr," [%10ld bp]\n",n);

    if (SvLEN(seq_desc) == 0)
        sv_setpv(seq_desc,"undef");
    sv_setiv(seq_len,n);

    return e;

} /* get_large_tbl_seqs */
/* */
/* long get_large_fasta_from_file(char* file_name, SV* hash_ref) */
long get_large_fasta_from_file(SV* hash_ref)
{
    /* current line buffer */
    int lmx = 32000; /* there are very long headers */
    int max =  1024;
    char line[lmx], mids[max], mdsc[lmx];

    /* single fasta elements */
    SV* id;
    SV* desc;
    SV* sequence;
    long pos = 0;
    long sqcnt = 0;

    /* defining variables to work with a hash */
    HV* hash = newHV();

    /* line counter */
    long lc = 0;

    /* if found then save hash values (and reset to 0) */
    int found = 0;

    /* hash references were expected */
    if ((! SvROK(hash_ref)) || (! SvTYPE(SvRV(hash_ref)) == SVt_PVHV))
    {
        croak("#############\n### ERROR ### %s\n############# %s\n",
              "USAGE: long get_large_fasta_from_file(char*, >>SV*<<)",
              "       2nd argument must be a hash reference...");
        /* exit(1); */
    };

    /* linking the hash from perl to C structure */
    hash = (HV*) SvRV(hash_ref);

    /* looping through the fasta file getting lines */
    while (fgets(line, lmx, ifh) != NULL)
    {
        my_chomp(line);

        if (line[0] == '\0' || line[0] == '#') /* skipping empty lines */
            continue;

        if (line[0] == '>') /* fasta format sequence header */
        {
            if (found)
            {
                if (LS_v && (lc % LS_LNM))
                    fprintf(stderr," [%10ld bp]\n",pos);

                add_seqhash_value(newRV_noinc((SV*) hash),
                                  id, desc, sequence, pos);
            }
            /* reset position on the current sequence string */
            sqcnt++;
            pos = 0;
            lc = 0;
            found = 1;
            /* line has the locus of the current sequence */
            parse_sequence_fasta_header(line,mids,mdsc);

            if (mids[0] == '\0')
                sprintf(mids,"seq_%ld",sqcnt);

            if (mdsc[0] == '\0')
                strcpy(mdsc,"undef");

            id       = newSVpv(mids,0);
            desc     = newSVpv(mdsc,0);
            sequence = newSVpv("",0);
            /* sv_setpvn(id,  mids,strlen(mids)); */
            /* sv_setpvn(desc,mdsc,strlen(mdsc)); */
            /* sv_setpv(sequence,"");             */

            if (LS_v)
                fprintf(stderr,"###\n### LOADING SEQUENCE:\t%s [%ld]\n###\n",
                               SvPV_nolen(id),sqcnt);
            continue;
        }
        else /* fasta format sequence line = "atcgata...atta\n" */
        {
            sv_catpv(sequence,line);
                pos = pos + strlen(line);
        }

        if (LS_v && found)
        {
            ++lc;
                if ( !(lc % LS_lnm) )
                    fprintf(stderr,".");

            if ( !(lc % LS_LNM) )
                fprintf(stderr," [%10ld bp]\n",pos);
        }
    } /* while fgets */
    
    if (found)
    {
            if (LS_v && (lc % LS_LNM))
            fprintf(stderr," [%10ld bp]\n",pos);

        add_seqhash_value(newRV_noinc((SV*) hash),
                          id, desc, sequence, pos);
    }

    return sqcnt;
} /* get_large_fasta_from_file */
/* */
static void my_chomp(char* s)
{
    int n;

    for (n = strlen(s) - 1; n >= 0; n--)
    {
        if (s[n] != ' ' && s[n] != '\t' && s[n] != '\n')
            break;
    }

    s[n+1] = '\0';

} /* my_chomp */
/* */
static void parse_sequence_fasta_header(char* l, char* i, char* d)
{
    int n, c, k;

    k = strlen(l);
    n = 1; /* skipping first char == '>' */ 
    c = 0;
    while (n < k)
    {
        if (l[n] == ' ' || l[n] == '\t')
            break; /* NOT needed:  l[n] != '\n' && l[n] != '\0'               */
                   /* because they were already removed:                      */
                   /* + my_chomp(line) removes trailing spaces, tabs and '\n' */
                   /* + '\0' is found at l[strlen(l)] which is never checked  */
        i[c++] = l[n++];
    }
    i[c] = '\0';

    while ((l[n] == ' ' || l[n] == '\t') && n < k)
        n++;

    c = 0;
    while (n < k)
        d[c++] = l[n++]; /* load all till the end of line */

    d[c] = '\0';

} /* parse_sequence_fasta_header */
/* */
static void add_seqhash_value(SV* hash_ref, SV* sq_id,
                              SV* sq_desc, SV* sequence, long sq_len)
{
     HV* ori_hash = newHV();
     HV* an_hash = newHV();
     /* SV** valref; */
     /* HE* hshref; */
     int kl = 3;
     /* char k[kl]; */

     ori_hash = (HV*) SvRV(hash_ref);

     /* loading key-value pairs for the annonymous child hash */
     /* valref = */
     hv_store(an_hash, "DSC", kl, sq_desc, 0);
     /* valref = */
     hv_store(an_hash, "LEN", kl, newSVpvf("%ld", sq_len), 0);
     /* valref = */
     hv_store(an_hash, "SEQ", kl, sequence, 0);

     /* loading anonymous child-hash into parent hash */
     /* hshref = */
     hv_store_ent(ori_hash, sq_id, newRV_noinc((SV*) an_hash), 0);
            /* last param == 0 -> let perl to generate key indices auto */

     if (LS_v)
         fprintf(stderr,"###\n### SEQUENCE LOADED:\t%s %ldbp\n###\n",
                        SvPV_nolen(sq_id), sq_len);

} /* add_seqhash_value */
/* */
/* retrieving sequence substrings */
long substr_largeseq(SV* bigseq, long bigseqlen,
                     SV* reftocoords, SV* reftoseqary, char strand)
{
    long max_carylen, j;
    AV* coords_ary = newAV();
    AV* subsqs_ary = newAV();
    char* bseq;

    bseq = SvPVX(bigseq);

    /* array references were expected */
    if ((! SvROK(reftocoords)) || (! SvTYPE(SvRV(reftocoords)) == SVt_PVAV))
    {
        croak("#############\n### ERROR ### %s\n############# %s\n",
              "USAGE: long substr_largeseq(SV*, >>SV*<<, SV*)",
              "       2nd argument must be a gene coords array reference...");
        /* exit(1); */
    };
    if ((! SvROK(reftoseqary)) || (! SvTYPE(SvRV(reftoseqary)) == SVt_PVAV))
    {
        croak("#############\n### ERROR ### %s\n############# %s\n",
              "USAGE: long get_largeseq_substrings(SV*, SV*, >>SV*<<)",
              "       3rd argument must be a sequence substrings array ref...");
        /* exit(1); */
    };

    /* dereferencing */
    coords_ary = (AV*) SvRV(reftocoords);
    max_carylen = av_len(coords_ary) + 1;
    subsqs_ary = (AV*) SvRV(reftoseqary);

    /* fprintf(stderr, " (bigseq is %ldbp long)", bigseqlen); */
    if (LS_v)
        fprintf(stderr, " CPA(%ld) BSL(%ldbp)\n", (max_carylen / 2), bigseqlen);
    if (max_carylen % 2 != 0)
    {
        croak("#############\n### ERROR ### %s\n############# %s\n",
              "USAGE: long substr_largeseq(SV*, >>SV*<<, SV*)",
              "       gene coords array must contain even number of elements...");
        /* exit(1); */
    };
        
    /* looping through coord pairs */
    j = 0;
    while ((j + 1) < max_carylen) /* loop for coord pairs in 'CPA' */
    {
        /* local variables definition */
        SV** valref;
        SV* subseq;
        char* tmpseq;
        long ori, end, oed;
        /* STRLEN subseqlen; */

        valref = av_fetch(coords_ary, j, 0);
        if (valref == NULL)
        {
            fprintf(stderr, "...ORI COORD NOT DEF...");
            break;
        }
/*
        if (!SvIOK((SV*) *valref))
        {
            fprintf(stderr, "...ORI COORD NOT NUM...");
            break;
        }
*/
        ori = (long) SvIV((SV*) *valref); j++;

        valref = av_fetch(coords_ary, j, 0);
        if (valref == NULL)
        {
            fprintf(stderr, "...END COORD NOT DEF...");
            break;
        }
/*
        if (!SvIOK((SV*) *valref))
        {
            fprintf(stderr, "...END COORD NOT NUM...");
            break;
        }
*/
        end = (long) SvIV((SV*) *valref); j++;

        /* if (LS_v)                                       */
        /*     fprintf(stderr, "...C(%ld-%ld)", ori, end); */

        check_subsequence_coords(&ori, &end, bigseqlen);

        if (LS_v)
            fprintf(stderr, "...C(%ld-%ld)", ori, end);

        oed = end - ori + 1;
        subseq = newSV(oed);
        tmpseq = SvPVX(subseq);
        get_subsequence(ori, end, strand, bseq, tmpseq);

        /* saving subsequence into gene hash SQS */
        av_push(subsqs_ary, newSVpvf("%s", tmpseq));

        Safefree(tmpseq);

        if (LS_v)
            fprintf(stderr, "...SQSok(%ldbp)\n", oed); /* , subseq); */

    } /* finishing while loop for coord pairs in 'CPA' */ 

    return (long) (j / 2);

} /* substr_largeseq */
/* */
static void check_subsequence_coords(long* o, long* e, long l)
{
    long t;
    /* fprintf(stderr, "...CHECKING COORDS..."); */

    if (*o < 1)
    {
        fprintf(stderr,
           "\n### WARNING!!! start-coord is out of the range: %ld < 1\n",*o);
        *o = 1;
    }

    if (*e > l)
    {
        fprintf(stderr,
           "\n### WARNING!!! end-coord is out of the range: %ld > %ld\n",*e,l);
        *e = l;
    } 

    if (*o > *e)
    {
        warn("###############\n### WARNING ### %s\n############### %s %ld !< %ld\n",
             "substr_largeseq() : coords must always be provided as",
             "       forward coords...", *o, *e);
        t = *o;
        *o = *e;
        *e = t;
    }

} /* check_subsequence_coords */
/**/
static void get_subsequence(long o, long e, char str, char* s, char* t)
{

    if (str == '-')     /* reverse:'-' strand */
    {
        if (LS_v)
            fprintf(stderr, "...REV");
        subseq_revcomp(o, e, s, t);
    }
    else /* forward:'+' or unknown:'.' strand */
    {
        if (LS_v)
            fprintf(stderr, "...FWD");
        direct_sequence(o, e, s, t);
    }

} /* get_subsequence */
/**/
static void direct_sequence(long o, long e, char* s, char* t)
{
    long i;

    /* fixing coords for string indices and          */
    /* getting substring width (reusing 'e' varname) */
    o--;
    e = e - o;

    /* we assume that numbers for width are smaller     */ 
    /* than for origin, also that e is the total witdh  */
    /* so that we have to substract 1 from it (i < e-1) */
    /* or make counter never reach it (i < e)           */
    for (i = 0; i < e; i++)
        t[i] = s[i+o];

    t[e] = '\0';
    /* char number e from string is out of the string */
    /* as its counter starts at 0 not at 1... ;^D     */

} /* direct_sequence */
/**/
static void subseq_revcomp(long o, long e, char* s, char* t)
{
    long i, j;

    /* fixing coords for string indices and          */
    /* getting substring width (reusing 'e' varname) */
    o--;
    e = e - o;

    for (i = 0, j = (e - 1); i <= j; i++, j--)
    {
        t[i] = dna_complement(s[j+o]);
        t[j] = dna_complement(s[i+o]);
    }

    t[e] = '\0';
    /* char number e from string is out of the string */
    /* as its counter starts at 0 not at 1... ;^D     */

} /* subseq_revcomp */
/**/
void reversecompl(SV* dna_seq, long seq_len)
{
    long i, j, l;
    char* s;
    char t;

    if (SvROK(dna_seq) && SvTYPE(SvRV(dna_seq)) == SVt_PV)
    {
	s = SvPVX((SV*) SvRV(dna_seq));
    }
    else
    {
	s = SvPVX(dna_seq);
    };
    l = seq_len - 1;

    for (i = 0, j = l; i <= j; i++, j--)
    {
        t = dna_complement(s[i]);
        s[i] = dna_complement(s[j]);
        s[j] = t;
    }

    s[seq_len] = '\0';
    /* char number e from string is out of the string */
    /* as its counter starts at 0 not at 1... ;^D     */

} /* reversecompl */
/**/
void complement_dnaseq(SV* dna_seq, long seq_len)
{
    long i;
    char* s;
    char t;

    if (SvROK(dna_seq) && SvTYPE(SvRV(dna_seq)) == SVt_PV)
    {
	s = SvPVX((SV*) SvRV(dna_seq));
    }
    else
    {
	s = SvPVX(dna_seq);
    };

    for (i = 0; i < seq_len; i++)
    {
        t = dna_complement(s[i]);
        s[i] = t;
    }

    s[seq_len] = '\0';
    /* char number e from string is out of the string */
    /* as its counter starts at 0 not at 1... ;^D     */

} /* complement_dnaseq */
/**/
void reverse_seq(SV* dna_seq, long seq_len)
{
    long i, j, l;
    char* s;
    char t;

    if (SvROK(dna_seq) && SvTYPE(SvRV(dna_seq)) == SVt_PV)
    {
	s = SvPVX((SV*) SvRV(dna_seq));
    }
    else
    {
	s = SvPVX(dna_seq);
    };
    l = seq_len - 1;

    for (i = 0, j = l; i <= j; i++, j--)
    {
        t = s[i];
        s[i] = s[j];
        s[j] = t;
    }

    s[seq_len] = '\0';
    /* char number e from string is out of the string */
    /* as its counter starts at 0 not at 1... ;^D     */

} /* reverse_seq */
/**/
static int dna_complement(int c)
{

    /* setting values for all nucleotide codes, NC-IUB(1984) */ 

    switch (c) {
        /* single values */
        case 'A':
            return('T');
        case 'C':
            return('G');
        case 'G':
            return('C');
        case 'T':
            return('A');
        case 'a':
            return('t');
        case 'c':
            return('g');
        case 'g':
            return('c');
        case 't':
            return('a');
        /* willcard values */
        case 'N':
            return('N');
        case 'n':
            return('n');
        case 'X':
            return('X');
        case 'x':
            return('x');
        /* two values */
        case 'W':
            return('W');
        case 'S':
            return('S');
        case 'M':
            return('K');
        case 'K':
            return('M');
        case 'R':
            return('Y');
        case 'Y':
            return('R');
        case 'w':
            return('w');
        case 's':
            return('s');
        case 'm':
            return('k');
        case 'k':
            return('m');
        case 'r':
            return('y');
        case 'y':
            return('r');
        /* three values */
        case 'V':
            return('B');
        case 'B':
            return('V');
        case 'H':
            return('D');
        case 'D':
            return('H');
        case 'v':
            return('b');
        case 'b':
            return('v');
        case 'h':
            return('d');
        case 'd':
            return('h');
        /* unknown values */
        case '-':
            return('-');
        default:
            return('N');
     } /* switch */

} /* dna_complement */
/**/
void dna_sequence_composition(SV* dna_seq, long seq_len)
{
    Inline_Stack_Vars;

    char U, u; 
    char* nucseq;
    long j;
    long A, T, G, C, N, O, L;
    
    nucseq = SvPVX(dna_seq);

    A = T = G = C = N = O = L = 0;

    for (j = 0; j < seq_len; j++) {
        U = nucseq[j];
        u = tolower(U);
        if (U == u) L++;
        switch (u) {
            case 'a':
                A++;
                break;
            case 't':
                T++;
                break;
            case 'g':
                G++;
                break;
            case 'c':
                C++;
                break;
            case 'n':
                N++;
                break;
            case 'x':
                N++;
                break;
            default:
                O++;
                break;
        } /* switch */
    } /* for j */

    Inline_Stack_Reset;
    Inline_Stack_Push(sv_2mortal(newSViv(A)));
    Inline_Stack_Push(sv_2mortal(newSViv(T)));
    Inline_Stack_Push(sv_2mortal(newSViv(G)));
    Inline_Stack_Push(sv_2mortal(newSViv(C)));
    Inline_Stack_Push(sv_2mortal(newSViv(N)));
    Inline_Stack_Push(sv_2mortal(newSViv(O)));
    Inline_Stack_Push(sv_2mortal(newSViv(L)));
    Inline_Stack_Done;
    /* Inline_Stack_Void; */
} /* dna_sequence_composition */
/* */
/* DNA -> protein translation */
long translate(SV* dna_seq, SV* prot_seq, int frame, ...)
{
    Inline_Stack_Vars;
    SV* p_seq;
    char* dnaseq;
    char* aa_seq;
    long len;
    int stopcodon = 0;

    if (Inline_Stack_Items > 3)
    {
       if ((int) SvIV(Inline_Stack_Item(3)) != 0)
       {
           stopcodon = 1;
       }
    }

    if (!hv_exists(CODON_TABLE, "STP", 3))
    {
        CODON_TABLE = newHV();
        load_codon_hash(newRV_noinc((SV*) CODON_TABLE));
    }

    /* len = (long) (((long) SvLEN(dna_seq) / 3) + 1); */
    dnaseq = SvPVX(dna_seq);
    len = (long) (((long) strlen(dnaseq) / 3) + 1);
    p_seq = newSV(len);
    aa_seq = SvPVX(p_seq);

    len = translate_seq(dnaseq, aa_seq, frame, stopcodon);

    sv_setpvn(prot_seq, aa_seq, len);

        Safefree(aa_seq); /* do not free dnaseq as points to dna_seq string */

    return len; /* returns amino acids sequence length */
    /* Inline_Stack_Void; */

} /* translate */
/* */
static void load_codon_hash(SV* codon_hash)
{
     HV* hash = newHV();
     int kl = 3;
     int al = 1;

     hash = (HV*) SvRV(codon_hash);

     /* loading key-value pairs for DNA->AA codon translation */
     hv_store(hash, "GCA", kl, newSVpvn("A",al), 0);
     hv_store(hash, "GCC", kl, newSVpvn("A",al), 0);
     hv_store(hash, "GCG", kl, newSVpvn("A",al), 0);
     hv_store(hash, "GCT", kl, newSVpvn("A",al), 0);
     hv_store(hash, "TGC", kl, newSVpvn("C",al), 0);
     hv_store(hash, "TGT", kl, newSVpvn("C",al), 0);
     hv_store(hash, "GAC", kl, newSVpvn("D",al), 0);
     hv_store(hash, "GAT", kl, newSVpvn("D",al), 0);
     hv_store(hash, "GAA", kl, newSVpvn("E",al), 0);
     hv_store(hash, "GAG", kl, newSVpvn("E",al), 0);
     hv_store(hash, "TTC", kl, newSVpvn("F",al), 0);
     hv_store(hash, "TTT", kl, newSVpvn("F",al), 0);
     hv_store(hash, "GGA", kl, newSVpvn("G",al), 0);
     hv_store(hash, "GGC", kl, newSVpvn("G",al), 0);
     hv_store(hash, "GGG", kl, newSVpvn("G",al), 0);
     hv_store(hash, "GGT", kl, newSVpvn("G",al), 0);
     hv_store(hash, "CAC", kl, newSVpvn("H",al), 0);
     hv_store(hash, "CAT", kl, newSVpvn("H",al), 0);
     hv_store(hash, "ATA", kl, newSVpvn("I",al), 0);
     hv_store(hash, "ATC", kl, newSVpvn("I",al), 0);
     hv_store(hash, "ATT", kl, newSVpvn("I",al), 0);
     hv_store(hash, "AAA", kl, newSVpvn("K",al), 0);
     hv_store(hash, "AAG", kl, newSVpvn("K",al), 0);
     hv_store(hash, "TTA", kl, newSVpvn("L",al), 0);
     hv_store(hash, "TTG", kl, newSVpvn("L",al), 0);
     hv_store(hash, "CTA", kl, newSVpvn("L",al), 0);
     hv_store(hash, "CTC", kl, newSVpvn("L",al), 0);
     hv_store(hash, "CTG", kl, newSVpvn("L",al), 0);
     hv_store(hash, "CTT", kl, newSVpvn("L",al), 0);
     hv_store(hash, "ATG", kl, newSVpvn("M",al), 0);
     hv_store(hash, "AAC", kl, newSVpvn("N",al), 0);
     hv_store(hash, "AAT", kl, newSVpvn("N",al), 0);
     hv_store(hash, "CCA", kl, newSVpvn("P",al), 0);
     hv_store(hash, "CCC", kl, newSVpvn("P",al), 0);
     hv_store(hash, "CCG", kl, newSVpvn("P",al), 0);
     hv_store(hash, "CCT", kl, newSVpvn("P",al), 0);
     hv_store(hash, "CAA", kl, newSVpvn("Q",al), 0);
     hv_store(hash, "CAG", kl, newSVpvn("Q",al), 0);
     hv_store(hash, "AGA", kl, newSVpvn("R",al), 0);
     hv_store(hash, "AGG", kl, newSVpvn("R",al), 0);
     hv_store(hash, "CGA", kl, newSVpvn("R",al), 0);
     hv_store(hash, "CGC", kl, newSVpvn("R",al), 0);
     hv_store(hash, "CGG", kl, newSVpvn("R",al), 0);
     hv_store(hash, "CGT", kl, newSVpvn("R",al), 0);
     hv_store(hash, "AGC", kl, newSVpvn("S",al), 0);
     hv_store(hash, "AGT", kl, newSVpvn("S",al), 0);
     hv_store(hash, "TCA", kl, newSVpvn("S",al), 0);
     hv_store(hash, "TCC", kl, newSVpvn("S",al), 0);
     hv_store(hash, "TCG", kl, newSVpvn("S",al), 0);
     hv_store(hash, "TCT", kl, newSVpvn("S",al), 0);
     hv_store(hash, "ACA", kl, newSVpvn("T",al), 0);
     hv_store(hash, "ACC", kl, newSVpvn("T",al), 0);
     hv_store(hash, "ACG", kl, newSVpvn("T",al), 0);
     hv_store(hash, "ACT", kl, newSVpvn("T",al), 0);
     hv_store(hash, "GTA", kl, newSVpvn("V",al), 0);
     hv_store(hash, "GTC", kl, newSVpvn("V",al), 0);
     hv_store(hash, "GTG", kl, newSVpvn("V",al), 0);
     hv_store(hash, "GTT", kl, newSVpvn("V",al), 0);
     hv_store(hash, "TGG", kl, newSVpvn("W",al), 0);
     hv_store(hash, "TAC", kl, newSVpvn("Y",al), 0);
     hv_store(hash, "TAT", kl, newSVpvn("Y",al), 0);
     hv_store(hash, "TAA", kl, newSVpvn("!",al), 0);
     hv_store(hash, "TAG", kl, newSVpvn("#",al), 0);
     hv_store(hash, "TGA", kl, newSVpvn("@",al), 0); /* selenoproteins!!! */
     hv_store(hash, "STP", kl, newSVpvn("*",al), 0);

     if (LS_v)
         fprintf(stderr,"###\n### CODON TABLE HASH LOADED...\n###\n");

} /* load_codon_hash */
/* */
static long translate_seq(char* dna, char* prot, int frame, int stopflg)
{
    char c;
    /* char codon[LENGTHCODON + 1]; */
    char codon[4];
    long d, p, l;
    int kl = 3; /* LENGTHCODON; */
    
    l = strlen(dna) + 1; /* length must be fixed to obtain the final aa seq */

    d = (long) frame; /* frame must be 0 1 2 */
    p = 0;
    while ((d + 3) < l) {

        codon[0] = toupper(dna[d]);
        codon[1] = toupper(dna[d+1]);
        codon[2] = toupper(dna[d+2]);
        codon[3] = '\0';

        if (hv_exists(CODON_TABLE, codon, kl))
        {
            c = (char) (SvPVX(*(hv_fetch((HV*) CODON_TABLE, codon, kl, 0))))[0];
            if (stopflg && (c == '@' || c == '#' || c == '!'))
            {
                c = '*';
            /* c = (char) (*(hv_fetch((HV*) CODON_TABLE, "STP", kl, 0)))[0]; */
            }
        }
        else
            c = 'X'; /* char '?' gives errors with blast */

        /* fprintf(stderr, "### TR %ld (%ld) : %s %c\n", d, p, codon, c); */

        prot[p] = c;

        d += 3;
        p++;
    } /* while (d + 3) < l */

    prot[p] = '\0';

    /* fprintf(stderr, "### TR %s\n", prot); */
    return p; /* p starts at 0 */

} /* translate_seq */
/* */
void stopcodons_in_protseq(SV* prot_seq)
{
    Inline_Stack_Vars;
      /* required to make the function able to */
      /*    return a perl-like array of values */

    char* aa_seq;
    long j;
    long len;
    long stopTGA = 0; /* '@' */
    long stopTAG = 0; /* '#' */
    long stopTAA = 0; /* '!' */
    long stopALL = 0; /* '*' */

    /* len = (long) SvLEN(prot_seq); */
              /* SvLEN Returns the size of the string buffer in the SV */
    /* len = (long) SvCUR(prot_seq); */
              /* SvCUR Returns the length of the string which is in the SV */
    aa_seq = SvPVX(prot_seq); /* do not free aa_seq, points to prot_seq string */
    len = (long) strlen(aa_seq);

    for (j = 0; j < len; j++) {
        switch (toupper(aa_seq[j])) {
            case '@':
                stopTGA++;
                break;
            case '#':
                stopTAG++;
                break;
            case '!':
                stopTAA++;
                break;
            case '*':
                stopALL++;
                break;
        } /* switch */
    } /* for j */

    stopALL = stopALL + stopTGA + stopTAG + stopTAA;

    /* return sv_2mortal(newSVpvf("%ld\@%ld\#%ld\!%ld\*",            */
    /*                            stopTGA,stopTAG,stopTAA,stopALL)); */
    Inline_Stack_Reset;
    Inline_Stack_Push(sv_2mortal(newSViv(stopTGA)));
    Inline_Stack_Push(sv_2mortal(newSViv(stopTAG)));
    Inline_Stack_Push(sv_2mortal(newSViv(stopTAA)));
    Inline_Stack_Push(sv_2mortal(newSViv(stopALL)));
    Inline_Stack_Done;
    /* Inline_Stack_Void; */
} /* stopcodons_in_protseq */
/* */
/* output sequence in fasta format */
void save_fasta(SV* seq_desc, SV* bigseq)
{

    long j, l, J, dsc_len, seq_len, fasta_lw;
    char* seq_dsc;
    char* seq_out;
    SV   *fasta_LW;

    /* retrieving the corresponding perl scalar */
    fasta_LW = get_sv("fasta_LW", TRUE);

    /* looking if it is defined from perl side, */
    /*    otherwise set default values          */
    if (! SvIOK(fasta_LW) || fasta_LW == NULL) { sv_setiv(fasta_LW, 50); }

    fasta_lw = (long) sv_2iv(fasta_LW);

    /* check fasta_lw */
    if (fasta_lw < 10)
        fasta_lw = 10;
    else
        if (fasta_lw > 250)
            fasta_lw = 250;
    J = (long) (fasta_lw * 50);

    /* retieving desc and sequence arguments */
    seq_dsc = SvPVX(seq_desc);
    dsc_len = (long) strlen(seq_dsc); /* SvLEN(seq_desc); */
    seq_out = SvPVX(bigseq);
    seq_len = (long) strlen(seq_out); /* SvLEN(bigseq); */

    /* printing fasta sequence header */
    fprintf(ofh,">");
    for (j = 0; j < dsc_len; j++)
    {
        fprintf(ofh,"%c",seq_dsc[j]);
    }
    fprintf(ofh,"\n");

    /* print sequence char by char */
    for (j = 0; j < seq_len; j++)
    {
        fprintf(ofh,"%c",seq_out[j]);
        l = j + 1;
        if (!(l % fasta_lw))
        {
            fprintf(ofh,"\n");
            if (LS_v)
            {
                fprintf(stderr,"w");
                if (!(l % J))
                {
                    fprintf(stderr," [%10ld bp]\n", l);
                }
            }
        }
    }
    if (l % fasta_lw)
    {
        fprintf(ofh,"\n");
        if (LS_v)
            fprintf(stderr," [%10ld bp]\n", l);
    }

} /* save_fasta */
/* */
void save_qual(SV* seq_id, SV* aryref, SV* seq_desc)
{

    long j, l, J, seq_len, qual_lw;
    SV*   qual_LW;
    AV*   sco_ary; /* = newAV(); */

    /* retrieving the corresponding perl scalar */
    qual_LW = get_sv("qual_LW", TRUE);

    /* looking if it is defined from perl side, */
    /*    otherwise set default values          */
    if (! SvIOK(qual_LW) || qual_LW == NULL) { sv_setiv(qual_LW, 25); }

    qual_lw = (long) sv_2iv(qual_LW);

    /* check qual_lw */
    if (qual_lw < 10)
        qual_lw = 10;
    else
        if (qual_lw > 250)
            qual_lw = 250;
    J = (long) (qual_lw * 50);
  
    /* array references were expected */
    if ((! SvROK(aryref)) || (! SvTYPE(SvRV(aryref)) == SVt_PVAV))
    {
      croak("#############\n### ERROR ### %s\n############# %s\n",
	    "USAGE: void save_qual(SV*, >>SV*<<, SV*)",
	    "       2nd argument must be a scores array ref...");
      /* exit(1); */
    };
  
    /* dereferencing */
    sco_ary = (AV*) SvRV(aryref);
    seq_len = av_len(sco_ary) + 1;

    /* printing fasta sequence header */
    fprintf(ofh, ">%s %s\n", SvPV_nolen(seq_id), SvPV_nolen(seq_desc));

    /* print quality scores, score by score */
    for (j = 0; j < seq_len; j++)
    {
        SV** valref;
        int sco;

	l = j + 1;

	valref = av_fetch(sco_ary, j, 0);
        if (valref == NULL)
        {
            fprintf(stderr, "...ORI COORD NOT DEF...");
            break;
        };

/*
        if (!SvIOK((SV*) *valref))
        {
            fprintf(stderr, "...ORI COORD NOT NUM...");
            break;
        };
*/

        sco = (int) SvIV((SV*) *valref);

        fprintf(ofh, "%2d", sco);

        if (!(l % qual_lw) || l == seq_len)
        {
            fprintf(ofh,"\n");
            if (LS_v)
            {
                fprintf(stderr,"w");
                if (!(l % J))
                {
                    fprintf(stderr," [%10ld sco]\n", l);
                }
            }
        }
	else 
	{
	    fprintf(ofh," ");
	};

    };
/*
    if (l % qual_lw)
    {
        fprintf(ofh,"\n");
*/
        if (LS_v)
            fprintf(stderr," [%10ld sco]\n", l);
/*
    };
*/

} /* save_qual */
/* */
void save_tbl(SV* seq_id, SV* bigseq, SV* seq_desc)
{

    long j, l, J, dsc_len, seq_len, fasta_lw;
    char* seq_dsc;
    char* seq_out;
    SV   *fasta_LW;

    /* check if the separator has changed */
    char* sep; /* default field separator white spcae */
    SV   *TSep;

    TSep = get_sv("TS", TRUE);
    if (! SvIOK(TSep) || TSep == NULL) { sv_setpvs(TSep, " "); }
    sep = SvPV_nolen(TSep);

    /* retrieving the corresponding perl scalar */
    fasta_LW = get_sv("fasta_LW", TRUE);

    /* looking if it is defined from perl side, */
    /*    otherwise set default values          */
    if (! SvIOK(fasta_LW) || fasta_LW == NULL) { sv_setiv(fasta_LW, 50); }

    fasta_lw = (long) sv_2iv(fasta_LW);

    /* check fasta_lw */
    if (fasta_lw < 10)
        fasta_lw = 10;
    else
        if (fasta_lw > 250)
            fasta_lw = 250;
    J = (long) (fasta_lw * 50);

    /* printing fasta sequence header */
    fprintf(ofh,"%s",SvPV_nolen(seq_id));
    fprintf(ofh,sep);

    /* print sequence char by char */
    seq_out = SvPVX(bigseq);
    seq_len = (long) strlen(seq_out); /* SvLEN(bigseq); */
    for (j = 0; j < seq_len; j++)
    {
        fprintf(ofh,"%c",seq_out[j]);
        l = j + 1;
        if (LS_v && !(l % fasta_lw))
        {
            fprintf(stderr,"w");
            if (!(l % J))
            {
                fprintf(stderr," [%10ld bp]\n", l);
            }
        }
    }
    if (LS_v && (l % fasta_lw))
        fprintf(stderr," [%10ld bp]\n", l);

    /* printing extra description fields char by char */
    if (SvOK(seq_desc))
    {
        seq_dsc = SvPVX(seq_desc);
        dsc_len = (long) strlen(seq_dsc); /* SvLEN(seq_desc); */
        if (dsc_len > 0)
        {
            fprintf(ofh,sep);
            for (j = 0; j < dsc_len; j++)
            {
                fprintf(ofh,"%c",seq_dsc[j]);
            }
        }
    }

    /* finishing record line */
    fprintf(ofh,"\n");

} /* save_tbl */
/* */
/* comparing sequences */
void pairwise_seq_comp(SV* refseqA, SV* refseqB)
{
    Inline_Stack_Vars;
      /* required to make the function able to */
      /*    return a perl-like array of values */

    char *SeqA, *SeqB, *seqA, *seqB, *aln, *asqA, *asqB, **trace;
    long n, m, i, j, c, nn, mm,
         scoP, scoN, opnG, extG,
         sco_left, sco_up, sco_diag, sco, gU, gL,
         Alen, idn, mss, gpA, gpB,
         **matrix, **Vscore, **Gscore, **Fscore, **Escore, **gaps;
    SV   *SscoP, *SscoN, *SopnG, *SextG;

    /* retrieving the corresponding perl scalar */
    SscoP = get_sv("scoP", TRUE);
    SscoN = get_sv("scoN", TRUE);
    SopnG = get_sv("opnG", TRUE);
    SextG = get_sv("extG", TRUE);

    if (LS_v)
        fprintf(stderr,"V..");

    /* looking if it is defined from perl side, */
    /*    otherwise set default values          */
    if (! SvIOK(SscoP) || SscoP == NULL) { sv_setiv(SscoP, 10); }
    if (! SvIOK(SscoN) || SscoN == NULL) { sv_setiv(SscoN,-10); }
    if (! SvIOK(SopnG) || SopnG == NULL) { sv_setiv(SopnG, -2); }
    if (! SvIOK(SextG) || SextG == NULL) { sv_setiv(SextG, -1); }

    scoP = (long) sv_2iv(SscoP);
    scoN = (long) sv_2iv(SscoN);
    opnG = (long) sv_2iv(SopnG);
    extG = (long) sv_2iv(SextG);

    if (LS_v)
        fprintf(stderr,"(Id %ld|Mm %ld|Go %ld|Ge %ld)..", scoP, scoN, opnG, extG);

    if (LS_v)
        fprintf(stderr,"S..");
    /* string scalar references were expected */
    if ((! SvROK(refseqA)) || (! SvTYPE(SvRV(refseqA)) == SVt_PV))
    {
        croak("#############\n### ERROR ### %s\n############# %s\n",
              "USAGE: void pairwise_seq_comp(>>SV*<<,SV*)",
              "       1st argument must be a reference to sequence string...");
    };
    if ((! SvROK(refseqB)) || (! SvTYPE(SvRV(refseqB)) == SVt_PV))
    {
        croak("#############\n### ERROR ### %s\n############# %s\n",
              "USAGE: void pairwise_seq_comp(SV*,>>SV*<<)",
              "       2nd argument must be a reference to sequence string...");
    };

    /* dereferencing */
    SeqA = savepv(SvPVX((SV*) SvRV(refseqA)));
    m = (long) strlen(SeqA) + 1;
    /* seqA = (char*) safemalloc((MEM_SIZE)(i * sizeof(char))); */
    Newc(0, seqA,  m + 1, char, char);
    seqA[0] = '-';
    c = 0;
    while (c < m)
    {
        seqA[c + 1] = toupper(SeqA[c]);
        c++;
    }
    seqA[c] = '\0';

    SeqB = savepv(SvPVX((SV*) SvRV(refseqB)));
    n = (long) strlen(SeqB) + 1;
    Newc(0, seqB,  n + 1, char, char);
    seqB[0] = '-';
    c = 0;
    while (c < n)
    {
        seqB[c + 1] = toupper(SeqB[c]);
        c++;
    }
    seqB[c] = '\0';

    if (LS_v)
        fprintf(stderr,"(%ldx%ld)..I..(", m, n);
    /* initializing arrays */
    init_long_matrix((long***) &matrix, m, n);
    init_long_matrix((long***) &Vscore, m, n);
    init_long_matrix((long***) &Gscore, m, n);
    init_long_matrix((long***) &Fscore, m, n);
    init_long_matrix((long***) &Escore, m, n);
    init_char_matrix((char***) &trace,  m, n);
    init_long_matrix((long***) &gaps,   m, n);

    if (LS_v)
        fprintf(stderr,")..Mtrx..");
    /* initializing scoring matrix */
    j = 0;
    while(j < n)
    {
        matrix[0][j] = gaps[0][j] = 0;  /* fill up first row with 0s */
        j++;
        /* if (LS_v)               */
        /*    fprintf(stderr,"."); */
    }
    /* if (LS_v)                 */
    /*     fprintf(stderr,"\n"); */
    i = 1;
    while(i < m)
    {
        /* fprintf(stderr,"(%ld:%ld)",i,j); */
        matrix[i][0] = gaps[i][0] = 0;  /* fill up first column with 0s */
        j = 1;
        /* if (LS_v)                */
        /*     fprintf(stderr,"."); */
        while (j < n)
        {
            if (seqA[i] == seqB[j])
            {
                matrix[i][j] = (long) scoP;
                /* if (LS_v)                */
                /*     fprintf(stderr,"+"); */
            }
            else
            {
                matrix[i][j] = (long) scoN;
                /* if (LS_v)                */
                /*     fprintf(stderr,"-"); */
            }
            j++;
            /* fprintf(stderr,"(%ld:%ld)",i,j); */
        }
        /* if (LS_v)                 */
        /*     fprintf(stderr,"\n"); */
        i++;
    }

    if (LS_v)
        fprintf(stderr,"M..");
    /* Computing alignment scores */
    Vscore[0][0] = 0;
    trace[0][0] = go_stop;
    j = 1;
    while (j < n)
    {
        /* Vscore[0][j] = Vscore[0][j-1] + opnG; */
        gU = log(j + 1) + 1;
        Vscore[0][j] = Fscore[0][j] = opnG + ((j * extG) / gU);
        trace[0][j]  = go_left;
        j++;
    }
    i = 1;
    while (i < m)
    {
        /* Vscore[i][0] = Vscore[i-1][0] + opnG; */
        gL = log(i + 1) + 1;
        Vscore[i][0] = Escore[i][0] = opnG + ((i * extG) / gL);
        trace[i][0]  = go_up;
        j = 1;
        while (j < n) {
            gU = log(gaps[i-1][j] + 1) + 1;
            gL = log(gaps[i][j-1] + 1) + 1;
            /* sco_diag = Vscore[i-1][j-1] + matrix[i][j]; */
            sco_diag = Gscore[i][j] = 
                Vscore[i-1][j-1] + matrix[i][j];
            /* sco_up = Vscore[i-1][j] + opnG; */
            sco_up   = Fscore[i][j] =
                max((Vscore[i-1][j] + opnG + (extG / gU)),
                    (Fscore[i-1][j] +        (extG / gU)));
            /* sco_left = Vscore[i][j-1] + opnG; */
            sco_left = Escore[i][j] =
                max((Vscore[i][j-1] + opnG + (extG / gL)),
                    (Escore[i][j-1] +        (extG / gL)));
            if ((sco_diag >= sco_up) && (sco_diag >= sco_left))
            {
                Vscore[i][j] = sco_diag;
                trace[i][j]  = go_diag;
                gaps[i][j]   = 0;
            }
            else
            {
                if ((sco_up >= sco_diag) && (sco_up >= sco_left))
                {
                    Vscore[i][j] = sco_up;
                    trace[i][j]  = go_up;
                    gaps[i][j]   = gaps[i-1][j] + 1;
                }
                else
                {
                    Vscore[i][j] = sco_left;
                    trace[i][j]  = go_left;
                    gaps[i][j]   = gaps[i][j-1] + 1;
                }
            }
            j++;
        }
        i++;
    }

    if (LS_v)
        fprintf(stderr,"A..");

    if (LS_V)
      {
	fprintf(stderr,"\n### Vscore ARY\n");
	for (mm = 0; mm < m; mm++)
	  {
	    for (nn = 0; nn < n; nn++)
	      {
		fprintf(stderr," %4ld", Vscore[mm][nn]);
	      }
	    fprintf(stderr,"\n");
	  }
	fprintf(stderr,"\n");
	fprintf(stderr,"### TRACE ARY\n");
	for (mm = 0; mm < m; mm++)
	  {
	    for (nn = 0; nn < n; nn++)
	      {
		fprintf(stderr," %4lc", trace[mm][nn]);
	      }
	    fprintf(stderr,"\n");
	  }
	fprintf(stderr,"\n");
	fprintf(stderr,"### GAPS ARY\n");
	for (mm = 0; mm < m; mm++)
	  {
	    for (nn = 0; nn < n; nn++)
	      {
		fprintf(stderr," %4ld", gaps[mm][nn]);
	      }
	    fprintf(stderr,"\n");
	  }
	fprintf(stderr,"\n");
      } /* if debug ON */

    /* Recovering alignment - backtracing matrices */
    i = max(m,n) * 2;
         /* aln = (char*) safemalloc((MEM_SIZE)(i * sizeof(char))); */
    Newc(0, aln,  i, char, char);
    Newc(0, asqA, i, char, char);
    Newc(0, asqB, i, char, char);
    idn = mss = gpA = gpB = sco = c = 0;
    i = m - 1;
    j = n - 1;
    while (trace[i][j] != go_stop)
    {                              /* (i + j > 0) */
        sco += Vscore[i][j];
        if (trace[i][j] == go_diag)
        {
            if (seqA[i] == seqB[j])
            {                         /*   match   */
                aln[c] = '*';
                idn++;
            }
            else
            {                         /* missmatch */
                aln[c] = '.';
                mss++;
            }
            asqA[c] = (char) seqA[i];
            asqB[c] = (char) seqB[j];
            i--;
            j--;
        } else {
            if (trace[i][j] == go_up) {
                asqA[c] = (char) seqA[i];
                asqB[c] = '-';
                i--;
                gpB++;
            } else {
                asqA[c] = '-';
                asqB[c] = (char) seqB[j];
                j--;
                gpA++;
            }
            aln[c] = ' ';
        }
        c++;
    }
    aln[c]  = '\0';
    asqA[c] = '\0';
    asqB[c] = '\0';
    /* alignment length */
    Alen = c; /* (long) strlen(aln); */

    if (LS_v)
        fprintf(stderr,"O\n");

    /* printing ALN if verbose is on */
    if (LS_v)
    {
        fprintf(stderr,  ">SqA: ");
          /* fprintf(stderr,  "%ld>%s<", Alen, asqA); */
          prt_seq(Alen, asqA);
        fprintf(stderr,">ALN: ");
          /* fprintf(stderr,  "%ld>%s<", Alen, aln);  */
          prt_seq(Alen, aln);
        fprintf(stderr,">SqB: ");
          /* fprintf(stderr,  "%ld>%s<", Alen, asqB); */
          prt_seq(Alen, asqB);
        fprintf(stderr,">ALN score: %ld\n", (long) sco);
    }

    /* if (LS_v)                  */
    /*     fprintf(stderr,"C.."); */
    /* deleting elements in the arrays plus the arrays themselves */
    free_matrix((void***) &matrix, m);
    free_matrix((void***) &Vscore, m);
    free_matrix((void***) &Gscore, m);
    free_matrix((void***) &Fscore, m);
    free_matrix((void***) &Escore, m);
    free_matrix((void***) &trace,  m);
    free_matrix((void***) &gaps,   m);

    /* returning multiple values via Inline stack */
    Inline_Stack_Reset;
    Inline_Stack_Push(sv_2mortal(newSViv(Alen)));
    Inline_Stack_Push(sv_2mortal(newSViv(idn)));
    Inline_Stack_Push(sv_2mortal(newSViv(mss)));
    Inline_Stack_Push(sv_2mortal(newSViv(gpA)));
    Inline_Stack_Push(sv_2mortal(newSViv(gpB)));
    Inline_Stack_Push(sv_2mortal(newSVpvn(asqA, c)));
    Inline_Stack_Push(sv_2mortal(newSVpvn(aln,  c)));
    Inline_Stack_Push(sv_2mortal(newSVpvn(asqB, c)));
    Inline_Stack_Push(sv_2mortal(newSViv(sco)));
    Inline_Stack_Done;
    /* Inline_Stack_Void; */

    /* freeing other vars */
    Safefree(aln);
    Safefree(asqA);
    Safefree(asqB);
    Safefree(seqA);
    Safefree(seqB);

} /* pairwise_seq_comp */
/*  */
/* */
/* comparing sequences */
void pairwise_seq_comp_maxlocal(SV* refseqA, SV* refseqB)
{
    Inline_Stack_Vars;
      /* required to make the function able to */
      /*    return a perl-like array of values */

    char *SeqA, *SeqB, *seqA, *seqB, *aln, *asqA, *asqB, **trace, tch;
    long n, m, i, j, M, N, I, J, II, JJ, c, nn, mm,
         msco, Msco, mlen, Mlen, MLen, mgaps, ii, Mii, jj, Mjj,
         scoP, scoN, opnG, extG,
         sco_left, sco_up, sco_diag, sco, gU, gL,
         Alen, idn, mss, gpA, gpB,
       **matrix, **Vscore, **Gscore, **Fscore, **Escore, **gaps, **local;
    SV   *SscoP, *SscoN, *SopnG, *SextG;

    /* retrieving the corresponding perl scalar */
    SscoP = get_sv("scoP", TRUE);
    SscoN = get_sv("scoN", TRUE);
    SopnG = get_sv("opnG", TRUE);
    SextG = get_sv("extG", TRUE);

    if (LS_v)
        fprintf(stderr,"V..");

    /* looking if it is defined from perl side, */
    /*    otherwise set default values          */
    if (! SvIOK(SscoP) || SscoP == NULL) { sv_setiv(SscoP, 10); }
    if (! SvIOK(SscoN) || SscoN == NULL) { sv_setiv(SscoN,-10); }
    if (! SvIOK(SopnG) || SopnG == NULL) { sv_setiv(SopnG, -2); }
    if (! SvIOK(SextG) || SextG == NULL) { sv_setiv(SextG, -1); }

    scoP = (long) sv_2iv(SscoP);
    scoN = (long) sv_2iv(SscoN);
    opnG = (long) sv_2iv(SopnG);
    extG = (long) sv_2iv(SextG);

    if (LS_v)
        fprintf(stderr,"(Id %ld|Mm %ld|Go %ld|Ge %ld)..", scoP, scoN, opnG, extG);

    if (LS_v)
        fprintf(stderr,"S..");
    /* string scalar references were expected */
    if ((! SvROK(refseqA)) || (! SvTYPE(SvRV(refseqA)) == SVt_PV))
    {
        croak("#############\n### ERROR ### %s\n############# %s\n",
              "USAGE: void pairwise_seq_comp(>>SV*<<,SV*)",
              "       1st argument must be a reference to sequence string...");
    };
    if ((! SvROK(refseqB)) || (! SvTYPE(SvRV(refseqB)) == SVt_PV))
    {
        croak("#############\n### ERROR ### %s\n############# %s\n",
              "USAGE: void pairwise_seq_comp(SV*,>>SV*<<)",
              "       2nd argument must be a reference to sequence string...");
    };

    /* dereferencing */
    SeqA = savepv(SvPVX((SV*) SvRV(refseqA)));
    m = (long) strlen(SeqA) + 1;
    /* seqA = (char*) safemalloc((MEM_SIZE)(i * sizeof(char))); */
    Newc(0, seqA,  m + 1, char, char);
    seqA[0] = '-';
    c = 0;
    while (c < m)
    {
        seqA[c + 1] = toupper(SeqA[c]);
        c++;
    }
    seqA[c] = '\0';

    SeqB = savepv(SvPVX((SV*) SvRV(refseqB)));
    n = (long) strlen(SeqB) + 1;
    Newc(0, seqB,  n + 1, char, char);
    seqB[0] = '-';
    c = 0;
    while (c < n)
    {
        seqB[c + 1] = toupper(SeqB[c]);
        c++;
    }
    seqB[c] = '\0';

    if (LS_v)
        fprintf(stderr,"(%ldx%ld)..I..(", m, n);
    /* initializing arrays */
    init_long_matrix((long***) &matrix, m, n);
    init_long_matrix((long***) &Vscore, m, n);
    init_long_matrix((long***) &Gscore, m, n);
    init_long_matrix((long***) &Fscore, m, n);
    init_long_matrix((long***) &Escore, m, n);
    init_char_matrix((char***) &trace,  m, n);
    init_long_matrix((long***) &gaps,   m, n);
    init_long_matrix((long***) &local,  m, n);

    if (LS_v)
        fprintf(stderr,")..Mtrx..");
    /* initializing scoring matrix */
    j = 0;
    while(j < n)
    {
        matrix[0][j] = gaps[0][j] = local[0][j] = 0;  /* fill up first row with 0s */
        j++;
        /* if (LS_v)               */
        /*    fprintf(stderr,"."); */
    }
    /* if (LS_v)                 */
    /*     fprintf(stderr,"\n"); */
    i = 1;
    while(i < m)
    {
        /* fprintf(stderr,"(%ld:%ld)",i,j); */
        matrix[i][0] = gaps[i][0] = local[i][0] = 0;  /* fill up first column with 0s */
        j = 1;
        /* if (LS_v)                */
        /*     fprintf(stderr,"."); */
        while (j < n)
        {
	  local[i][j] = 0;
            if (seqA[i] == seqB[j])
            {
                matrix[i][j] = (long) scoP;
                /* if (LS_v)                */
                /*     fprintf(stderr,"+"); */
            }
            else
            {
                matrix[i][j] = (long) scoN;
                /* if (LS_v)                */
                /*     fprintf(stderr,"-"); */
            }
            j++;
            /* fprintf(stderr,"(%ld:%ld)",i,j); */
        }
        /* if (LS_v)                 */
        /*     fprintf(stderr,"\n"); */
        i++;
    }

    if (LS_v)
        fprintf(stderr,"M..");
    /* Computing alignment scores */
    Vscore[0][0] = 0;
    trace[0][0] = go_stop;
    j = 1;
    while (j < n)
      {
	/* Vscore[0][j] = Vscore[0][j-1] + opnG; */
        /* gU = log(j + 1) + 1; */
	gU = j * extG;
	Vscore[0][j] = Fscore[0][j] = opnG + gU; /* ((j * extG) / gU); */
        trace[0][j]  = go_left;
        j++;
      }
    i = 1;
    while (i < m)
      {
        /* Vscore[i][0] = Vscore[i-1][0] + opnG; */
        /* gL = log(i + 1) + 1; */
	gL = i * extG;
	Vscore[i][0] = Escore[i][0] = opnG + gL; /* ((i * extG) / gL); */
        trace[i][0]  = go_up;
        j = 1;
        while (j < n) {
            gU = log(gaps[i-1][j] + 1) + 1;
            gL = log(gaps[i][j-1] + 1) + 1;
            /* sco_diag = Vscore[i-1][j-1] + matrix[i][j]; */
            sco_diag = Gscore[i][j] = 
                max(0,
		    Vscore[i-1][j-1] + matrix[i][j]);
            /* sco_up = Vscore[i-1][j] + opnG; */
            sco_up   = Fscore[i][j] =
                max(0,
		    max((Vscore[i-1][j] + opnG + (extG / gU)),
			(Fscore[i-1][j] +        (extG / gU))));
            /* sco_left = Vscore[i][j-1] + opnG; */
            sco_left = Escore[i][j] =
                max(0,
		    max((Vscore[i][j-1] + opnG + (extG / gL)),
			(Escore[i][j-1] +        (extG / gL))));
            if ((sco_diag >= sco_up) && (sco_diag >= sco_left))
            {
                Vscore[i][j] = sco_diag;
                trace[i][j]  = go_diag;
                gaps[i][j]   = 0;
            }
            else
            {
                if ((sco_up >= sco_diag) && (sco_up >= sco_left))
                {
                    Vscore[i][j] = sco_up;
                    trace[i][j]  = go_up;
                    gaps[i][j]   = gaps[i-1][j] + 1;
                }
                else
                {
                    Vscore[i][j] = sco_left;
                    trace[i][j]  = go_left;
                    gaps[i][j]   = gaps[i][j-1] + 1;
                }
            }
            j++;
        }
        i++;
    }

    if (LS_v)
        fprintf(stderr,"A..");

    if (LS_V)
      {
	fprintf(stderr,"\n### MATRIX ARY\n");
	for (mm = 0; mm < m; mm++)
	  {
	    for (nn = 0; nn < n; nn++)
	      {
		fprintf(stderr," %4ld", matrix[mm][nn]);
	      }
	    fprintf(stderr,"\n");
	  }
	fprintf(stderr,"\n");
	fprintf(stderr,"\n### Vscore ARY\n");
	for (mm = 0; mm < m; mm++)
	  {
	    for (nn = 0; nn < n; nn++)
	      {
		fprintf(stderr," %4ld", Vscore[mm][nn]);
	      }
	    fprintf(stderr,"\n");
	  }
	fprintf(stderr,"\n");
	fprintf(stderr,"### TRACE ARY\n");
	for (mm = 0; mm < m; mm++)
	  {
	    for (nn = 0; nn < n; nn++)
	      {
		fprintf(stderr," %4lc", trace[mm][nn]);
	      }
	    fprintf(stderr,"\n");
	  }
	fprintf(stderr,"\n");
	fprintf(stderr,"### GAPS ARY\n");
	for (mm = 0; mm < m; mm++)
	  {
	    for (nn = 0; nn < n; nn++)
	      {
		fprintf(stderr," %4ld", gaps[mm][nn]);
	      }
	    fprintf(stderr,"\n");
	  }
	fprintf(stderr,"\n");
      } /* if debug ON */

    /* Getting the highest score or the longest local alignment in the matrix */

    i = m - 1;
    j = n - 1;

    Msco = Mlen = MLen = 0;
    Mii = i;
    Mjj = j;

    I = 0;
    II = max(m, n);
    while (I < II)
    {
      JJ = J = I;
      while (J > -1) {
	M = i - (JJ - J);
	N = j - J;
	if (M > -1 && N > -1)
	  {
	    msco = mlen = mgaps = 0;
	    if (local[M][N] == 0 && Vscore[M][N] > 0)
	      {
		ii = M;
		jj = N;
		while (Vscore[ii][jj] > 0 && trace[ii][jj] != go_stop)
		  {                              /* (i + j > 0) */
		    msco = max(msco, Vscore[ii][jj]);
		    mlen++;
		    local[ii][jj] = 1;
		    if (trace[ii][jj] == go_diag)
		      {
			ii--;
			jj--;
		      }
		    else
		      {
			mgaps++;
			if (trace[ii][jj] == go_up) {
			  if (ii == M) { M--; /* mlen--; */ } /* skipping triling gaps... ? */
			  ii--;
			} else { /* go_left */
			  if (jj == N) { N--; /* mlen--; */ } /* skipping triling gaps... ? */
			  jj--;
			}
		      }
		  } /* while */

		mlen = mlen - mgaps;
		if (mlen > Mlen || (mlen == Mlen && msco > Msco)) {
		  /* getting the longest    [ mlen > Mlen ] or  */
		  /* the one scoring better [ msco > Msco ] ??? */
		  Mlen = mlen;
		  MLen = mlen + mgaps + 1;
		  Msco = msco;
		  Mii = M;
		  Mjj = N;
		}

		if (LS_V)
		  {
		    fprintf(stderr,"### LOCAL ARY   M: %-4ld N: %-4ld Sco: %-4ld Len: %-4ld [Gaps %ld]\n",M,N,msco,mlen,mgaps);
		    for (mm = 0; mm < m; mm++)
		      {
			for (nn = 0; nn < n; nn++)
			  {
			    if (mm == M && nn == N)
			      tch = '*';
			    else
			      tch = ' ';
			    fprintf(stderr," %c%1ld", tch, local[mm][nn]);
			  }
			fprintf(stderr,"\n");
		      }
		    fprintf(stderr,"\n");
		  } /* if debug ON */

	      } /* Vscore > 0 */
	    /* local[M][N] = 1; */
	  } /* M > -1 && N > -1 */
	J--; 
      }
      I++;
    }

    if (LS_v)
        fprintf(stderr,"L..");

    /* Recovering alignment - backtracing matrices */
    i = MLen * 2; /* i = max(m,n) * 2; */
         /* aln = (char*) safemalloc((MEM_SIZE)(i * sizeof(char))); */
    Newc(0, aln,  i, char, char);
    Newc(0, asqA, i, char, char);
    Newc(0, asqB, i, char, char);
    idn = mss = gpA = gpB = sco = c = 0;
    i = Mii;
    j = Mjj;
    while (Vscore[i][j] > 0 && trace[i][j] != go_stop)
    {                              /* (i + j > 0) */
        sco += Vscore[i][j];
        if (trace[i][j] == go_diag)
        {
            if (seqA[i] == seqB[j])
            {                         /*   match   */
                aln[c] = '*';
                idn++;
            }
            else
            {                         /* missmatch */
                aln[c] = '.';
                mss++;
            }
            asqA[c] = (char) seqA[i];
            asqB[c] = (char) seqB[j];
            i--;
            j--;
        } else {
            if (trace[i][j] == go_up) {
                asqA[c] = (char) seqA[i];
                asqB[c] = '-';
                i--;
                gpB++;
            } else {
                asqA[c] = '-';
                asqB[c] = (char) seqB[j];
                j--;
                gpA++;
            }
            aln[c] = ' ';
        }
        c++;
    }
    if (trace[i][j] == go_diag && seqA[i] == seqB[j])
      {
	aln[c] = '*';
	asqA[c] = (char) seqA[i];
	asqB[c] = (char) seqB[j];
        c++;
	i--;
	j--;
      }	
    aln[c]  = '\0';
    asqA[c] = '\0';
    asqB[c] = '\0';
    /* alignment length */
    Alen = c; /* (long) strlen(aln); */

    if (LS_v)
        fprintf(stderr,"O\n");

    /* printing ALN if verbose is on */
    if (LS_v)
    {
        fprintf(stderr,  ">SqA: ");
          /* fprintf(stderr,  "%ld>%s<", Alen, asqA); */
          prt_seq(Alen, asqA);
        fprintf(stderr,">ALN: ");
          /* fprintf(stderr,  "%ld>%s<", Alen, aln);  */
          prt_seq(Alen, aln);
        fprintf(stderr,">SqB: ");
          /* fprintf(stderr,  "%ld>%s<", Alen, asqB); */
          prt_seq(Alen, asqB);
        fprintf(stderr,">ALN score: %ld\n", (long) sco);
    }

    /* if (LS_v)                  */
    /*     fprintf(stderr,"C.."); */
    /* deleting elements in the arrays plus the arrays themselves */
    free_matrix((void***) &matrix, m);
    free_matrix((void***) &Vscore, m);
    free_matrix((void***) &Gscore, m);
    free_matrix((void***) &Fscore, m);
    free_matrix((void***) &Escore, m);
    free_matrix((void***) &trace,  m);
    free_matrix((void***) &gaps,   m);
    free_matrix((void***) &local,  m);

    /* returning multiple values via Inline stack */
    Inline_Stack_Reset;
    Inline_Stack_Push(sv_2mortal(newSViv(Alen)));
    Inline_Stack_Push(sv_2mortal(newSViv(idn)));
    Inline_Stack_Push(sv_2mortal(newSViv(mss)));
    Inline_Stack_Push(sv_2mortal(newSViv(gpA)));
    Inline_Stack_Push(sv_2mortal(newSViv(gpB)));
    Inline_Stack_Push(sv_2mortal(newSVpvn(asqA, c)));
    Inline_Stack_Push(sv_2mortal(newSVpvn(aln,  c)));
    Inline_Stack_Push(sv_2mortal(newSVpvn(asqB, c)));
    Inline_Stack_Push(sv_2mortal(newSViv(sco)));
    Inline_Stack_Push(sv_2mortal(newSViv(++i)));
    Inline_Stack_Push(sv_2mortal(newSViv(Mii)));
    Inline_Stack_Push(sv_2mortal(newSViv(++j)));
    Inline_Stack_Push(sv_2mortal(newSViv(Mjj)));
    Inline_Stack_Done;
    /* Inline_Stack_Void; */

    /* freeing other vars */
    Safefree(aln);
    Safefree(asqA);
    Safefree(asqB);
    Safefree(seqA);
    Safefree(seqB);

} /* pairwise_seq_comp_maxlocal */
/*  */
static void init_long_matrix(long*** ptr, long m, long n)
{
   long i;

   /* *ptr = (long**) safemalloc((MEM_SIZE)(m * sizeof(long*))); */
   Newc(0, *ptr, m, long*, long*);
   
   i = 0;
   while (i < m)
   {
       /* (*ptr)[i] = (long*) safemalloc((MEM_SIZE)(n * sizeof(long))); */
       Newc(0, (*ptr)[i], n, long, long);
       i++;
   }
   if (LS_v)
      fprintf(stderr,"X");
} /* init_long_matrix */
/* */
static void init_char_matrix(char*** ptr, long m, long n)
{
   long i;

   /* *ptr = (char**) safemalloc((MEM_SIZE)(m * sizeof(char*))); */
   Newc(0, *ptr, m, char*, char*);
   
   i = 0;
   while (i < m)
   {
       /* (*ptr)[i] = (char*) safemalloc((MEM_SIZE)(n * sizeof(char))); */
       Newc(0, (*ptr)[i], n, char, char);
       i++;
   }
   if (LS_v)
      fprintf(stderr,"X");
} /* init_char_matrix */
/* */
static long max(long a, long b)
{
   if (a >= b)
   {
       return a;
   }
   else
   {
       return b;
   }
} /* max */
/* */
static void free_matrix(void*** ptr, long m)
{
   long i;

   i = 0;
   while (i < m) {
       Safefree((*ptr)[i]);
       i++;
   }

   Safefree(*ptr);
   
} /* init_long_matrix */
/* */
static void prt_seq(long l, char* seq)
{
    while (l > 0)
    {        /* l is always 1 position larger than the char string... so that */
        l--; /* we start substracting 1 to get the real last string char      */
        fprintf(stderr, "%c", (char) seq[l]);
    } 
    fprintf(stderr,"\n");
} /* prt_seq */
/* */
/* file access */
FILE* open_input_file(char* FileName) 
{

    if (FileName[0] == '-')  /* read from stdin */
    {
        ifh = stdin;
        LS_stdin = 1;
        if (LS_V)
                fprintf(stderr,"#<# READ FROM STDIN...\n");
    }
    else                     /* read from file */
    {
        if ((ifh = fopen(FileName, "r")) == NULL)
        {
            croak("#<# ERROR #<# CANNOT OPEN FILE %s TO READ...\n", FileName);
            /* exit(1); */
        }
        LS_stdin = 0;
        if (LS_V)
                        fprintf(stderr,"#<# READ FROM %s\n",FileName);
    }

    return ifh;

} /* open_input_file */
/* */
FILE* open_output_file(char* FileName, ...)
{

    Inline_Stack_Vars;
    char mode[1];
    char mstr[10];
    char* tmod;

    strcpy(mode,"w");
    strcpy(mstr,"WRITE");
    if (Inline_Stack_Items > 1)
    {
        tmod = SvPVX(Inline_Stack_Item(1));
        if (tmod[0] == 'a' || tmod[0] == 'A')
        {
            strcpy(mode,"a");
            strcpy(mstr,"APPEND");
        }
    }

    if (FileName[0] == '-')  /* write to stdout */
    {
        ofh = stdout;
        LS_stdout = 1;
        if (LS_V)
                    fprintf(stderr,"#># WRITE TO STDOUT...\n");
    }
    else                     /* write to file */
    {
        if ((ofh = fopen(FileName, mode)) == NULL)
        {
            croak("#># ERROR #># CANNOT OPEN FILE %s TO %s...\n", FileName, mstr);
            /* exit(1); */
        }
        LS_stdout = 0;
        if (LS_V)
                        fprintf(stderr,
                    "#># %s TO %s\n", mstr, FileName);
    }

    return ofh;

} /* open_output_file */
/* */
void close_file(FILE* FileHandle, int InOut)
{

    /* if (FileName[0] != '-')*/
    if (FileHandle != NULL) {
        if ((InOut == 0 && LS_stdin == 0) || (InOut == 1 && LS_stdout == 0))
        {
            /* closing filehandle if not stdin/stdout */
            fflush(FileHandle);
            fclose(FileHandle);
        }
        else
        {
            /* force writing of unwritten buffered data */
            fflush(NULL);
        }
    }
    else
    {
        if (LS_V)
                        fprintf(stderr,"### Cannot CLOSE current filehandle...\n");
    }

} /* close_file */
/* */
void set_perlfh(SV* FileHandle, int InOut, ...)
{

    Inline_Stack_Vars;
    GV* gv;
    IO* io;
    int std_flg = 0;

    if (Inline_Stack_Items > 2)
    {
        if ((int) SvIV(Inline_Stack_Item(2)) != 0)
        {
            std_flg = 1;
        }
    }

    if (! SvTYPE(FileHandle) == SVt_PVGV )
    {
        croak("#############\n### ERROR ### %s\n############# %s\n",
              "USAGE: void set_perlfh(>>SV*<<, int)",
              "       1st argument must be a glob to filehandle...");
    };

    if (LS_V)
            fprintf(stderr,"### %s\n", SvPV_nolen(FileHandle));

    gv = (GV*) FileHandle;
    io = (IO*) GvIO(gv);

    if (InOut == 0)
    {
        if (!gv || !io || !IoIFP(io))
        {
            croak("#############\n### ERROR ### %s%s%s\n#############\n",
                  "CANNOT access to INPUT FileHandle <",
                  SvPV_nolen(FileHandle), ">...");
        }

        ifh = (FILE*) PerlIO_findFILE((PerlIO*) IoIFP(io));
              /* DO NOT ASK HOW IT WORKS BUT IT DOES */

        LS_stdin = std_flg;

        if (LS_V)
                    fprintf(stderr,"#># READ from OPENED PERL FILEHANDLE...\n");
    }
    else /* InOut == 1 */
    {
        if (!gv || !io || !IoOFP(io))
        {
            croak("#############\n### ERROR ### %s%s%s\n#############\n",
                  "CANNOT access to OUTPUT FileHandle <",
                  SvPV_nolen(FileHandle), ">...");
        }

        ofh = (FILE*) PerlIO_findFILE((PerlIO*) IoOFP(io));
              /* DO NOT ASK HOW IT WORKS BUT IT DOES */

        LS_stdout = std_flg;
      
        if (LS_V)
                    fprintf(stderr,"#># WRITE to OPENED PERL FILEHANDLE...\n");
    }

} /* set_perlfh */
/* */
/* END OF C CODE CHUNK */
