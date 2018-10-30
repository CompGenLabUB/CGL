=head1 CGL::Unalias

Module to normalize gene/protein names consistenly.

=head2 USAGE

    use CGL::Unalias;
    my $dict = new CGL::Unalias;
    $dict->load();
    $dict->unalias("MAPK2");

=head2 METHODS

=over 4
=cut

package CGL::Unalias;
use strict;
use warnings;
use File::Share ':all';
use Carp qw( croak );


=item new()

Creates CGL::Unalias object. 

    - Arguments: 
        None

=cut
sub new {
    my $class = shift;
    my $self  = { @_ };
    return bless $self, $class;
}


=item load()

Loads dictionary to Unalias object.

    - Arguments: 
        (OPTIONAL) Path to dictionary file in tabular (TSV) format. 
        First column must be official symbol. All subsequent columns must be synonyms. If no dictionary is given, the HGNC dictionary will be used.

        (OPTIONAL) Skip first line toggle. 1 => skip, 0 => do not skip.

        (OPTIONAL) Separator for dictionary. Default "\t".
=cut
sub load {
    my $self      = shift;
    my $dict_file = shift // dist_file("CGL", "HGNC_gene_dictionary.txt");
    my $skip      = shift // 1; 
    my $separator = shift // "\t";
    $self->{'dictionary'} = ();

    open(my $fh, "<", $dict_file)
        or die "Can't open dictionary file: $dict_file - $!\n";
    
    <$fh> if $skip; # skip first (header) line of dictionary
    while (my $line = <$fh>) {
        chomp($line);
        my ($off, @rest) = split /$separator/, $line;
        $off = $self->clean_symbol($off);
        foreach my $alias (@rest) {
            $self->{'dictionary'}->{ $self->clean_symbol($alias) } = $off;
        }
    }
    return;
}


=item clean_symbol()

Removes strange symbols and makes gene symbols upper case.

    - Arguments: 
        String to normalize.

=cut
sub clean_symbol {
    my $self   = shift;
    my $string = shift;
    $string = uc($string);
    $string =~ s/[^\w\t\s\d]//gi;
    return $string;
}


=item unalias()

Normalizes gene names according to loaded dictionary.

    - Arguments: 
        String to normalize.

=cut
sub unalias {
    my $self   = shift;
    my $string = shift;
    if (not $self->{'dictionary'}) {
        croak("Dictionary not loaded. Use load() method first!\n")
    }
    $string = $self->clean_symbol($string);
    if (exists $self->{'dictionary'}->{$string}) {
        return $self->{'dictionary'}->{$string};
    } else {
        return $string;
    }
}

=back
=cut

1;