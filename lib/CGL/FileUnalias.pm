package CGL::FileUnalias;
use strict;
use warnings;
use File::Share ':all';
use Carp qw( croak carp );

=item new()

Creates CGL::FileUnalias object. 

    - Arguments: 
        CGL::Unalias
        filename

=cut
sub new {
    my $class           = shift;
    my $unalias         = shift;
    my $input_filename  = shift // "";
    my $output_filename = shift // "";
    my $self  = { 
        "unalias"         => $unalias,
        "input_filename"  => $input_filename,
        "output_filename" => $output_filename
    };
    return bless $self, $class;
}

sub unalias_file {
    my $self = shift;
    my $cols = shift // [ 1 ];
    my $separator = shift // "\t";
    my $verbose = shift // 0;

    my $input_fh  = $self->open_input_stream();
    my $output_fh = $self->open_output_stream();

    $self->read_and_unalias_file($input_fh, $output_fh, $cols, $separator);
    return;
}

sub read_and_unalias_file {
    my $self      = shift;
    my $input_fh  = shift;
    my $output_fh = shift;
    my $cols      = shift; 
    my $separator = shift;

    while (<$input_fh>) {
        chomp;
        my @file_cols = split /$separator/;
        next if /^#/;
        next if /^[\s\t]+$/;
        foreach my $col (@{ $cols }) {
            $self->unalias_column(\@file_cols, $col);
        }
        $self->print_unaliased_line(\@file_cols, $separator,  $output_fh);
    }
    return;
}

sub unalias_column {
    my $self = shift;
    my $cols = shift;
    my $col  = shift;

    if (scalar(@{ $cols }) < ($col + 1)) {
        print STDERR "# WARNING: Column specified exceeds number of columns in input file (", 
                     $col + 1, 
                     " vs ", 
                     scalar(@{ $cols }), ")\n";
    } else {
        $cols->[$col] = $self->{"unalias"}->unalias($cols->[$col]);
    }
    return;
}


sub print_unaliased_line {
    my $self      = shift;
    my $cols      = shift;
    my $separator = shift;
    my $ofh       = shift;
    print $ofh join($separator, @{ $cols }), "\n";
    return;
}


sub open_input_stream {
    my $self = shift;
    my $ifh = $self->open_stream($self->{"input_filename"}, "<");
    return $ifh;
}

sub open_output_stream {
    my $self = shift;
    my $ofh = $self->open_stream($self->{"output_filename"}, ">");
    return $ofh;
}

sub open_stream {
    my $self      = shift;
    my $filename  = shift;
    my $mode      = shift // "<";
    my $fh;

    if ($filename) {
        print STDERR "\t# Reading file $filename.\n" if $self->{'verbose'};
        open $fh, $mode, $filename
            or die "Can't open $filename! : $!\n";
    } else {
        if ($mode eq "<") {
            $fh = *STDIN;
        } elsif ($mode eq ">") {
            $fh = *STDOUT;
        } else {
            croak("Failed to open stream: \$mode can only be '<' or '>'!.");
        }
    }
    return $fh;
}

1;