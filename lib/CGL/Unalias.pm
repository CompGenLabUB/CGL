=head1 NAME

CGL::Unalias - Module to normalize gene/protein names consistenly.

=cut

package CGL::Unalias;
use strict;
use warnings;
use File::Share ':all';
use Data::Dumper;

sub new {
    my $class = shift;
    my $self  = { @_ };
    return bless $self, $class;
}


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


sub clean_symbol {
    my $self = shift;
    my $string = shift;
    $string = uc($string);
    $string =~ s/[^\w\t\s\d]//gi;
    return $string;
}


sub unalias {
    my $self   = shift;
    my $string = shift;
    $string = $self->clean_symbol($string);
    if (exists $self->{'dictionary'}->{$string}) {
        return $self->{'dictionary'}->{$string};
    } else {
        return $string;
    }
}

1;