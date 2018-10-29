=head1 CGL::Unalias

Module to normalize gene/protein names consistenly.

=head2 USAGE

    use CGL::Unalias;
    my $dict = new CGL::Unalias;
    $dict->load();
    $dict->unalias("MAPK4");

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

=cut
sub load {
    my $self      = shift;
    my $dict_file = "";
    $self->{'dictionary'} = ();
    if (scalar(@_)) {
        # Use the provided file as dictionary
        $dict_file = shift;
    } else {
        # Use dictionary saved on install directory
        $dict_file = dist_file("CGL", "HGNC_gene_dictionary.txt");
    }

    open(my $fh, "<", $dict_file)
        or die "Can't open dictionary file: $dict_file - $!\n";
    <$fh>; # skip first line
    while (my $line = <$fh>) {
        chomp($line);
        my ($off, @rest) = split /\t/, $line;
        foreach my $alias (@rest) {
            $self->{'dictionary'}->{ $self->clean_symbol($alias) } = $self->clean_symbol($off);
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
    my $self = shift;
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