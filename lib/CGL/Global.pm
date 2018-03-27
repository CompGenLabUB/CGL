#
# CGL::Global
#
#   global perl functions,
#   maybe will be better to split into several packages.
#
# ####################################################################
#
#        Copyright (C) 2003 - Josep Francesc ABRIL FERRANDO
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
# $Id: global.pm,v 1.1 2007/12/04 10:17:59 lopep Exp lopep $
#
package global;
use strict;
use warnings;
use vars qw(
           @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $VERSION 
           $PLVER $LIBPM $PROG $VERSION $USAGE $_USAGE
           $DATE $CDATE $USER $HOST
           $T $F @skip_next @exectime %_verbose
           $ERRFH %Messages %exit_codes $EXIT_REPORT_FILE
           %CmdLineDefs %CmdLineOpts $stdin_flg $n $c $_cntN
           );

use Exporter;
$VERSION = 1.00;
@ISA = qw(Exporter);
@EXPORT = qw(
           $PLVER $PROG $VERSION $USAGE $DATE $CDATE $USER $HOST
           $T $F @skip_next %Messages %_verbose $ERRFH
           &init_timer &timing @exectime &get_date
           &init_signals &trap_signals &trap_signals_prog
           &program_started &program_finished &rpt &report &warn
           &add_cmdline_opts &parse_cmdline %CmdLineDefs %CmdLineOpts $stdin_flg
           &check_syscall_exit &the_end &EXIT %exit_codes $EXIT_REPORT_FILE
           &match_argv_num &check_file &check_dir
           &counter &counter_end $n $c $_cntN
           &min &max &sum &mean &median &stdev &getIFH &getOFH
           );
@EXPORT_OK = qw(
           &comment_line &header &left_header &right_header
           &fill_right &fill_left &fill_mid
           );
%EXPORT_TAGS = (
           Bool         => [ qw( $T $F ) ],
           Counter      => [ qw( &counter &counter_end $n $c $_cntN ) ],
           Exit         => [ qw( &EXIT %exit_codes $ERRFH ) ],
           ExecMessages => [ qw( &rpt &report &warn $ERRFH ) ],
           ExecReport   => [ qw( $PLVER $PROG $VERSION $USAGE 
                                 $DATE $CDATE $USER $HOST $ERRFH
                                 &program_started &program_finished ) ],
           Benchmark    => [ qw( &init_timer &timing @exectime ) ],
           CommandLine  => [ qw( &add_cmdline_opts &parse_cmdline
                                 &match_argv_num $stdin_flg
                                 %CmdLineDefs %CmdLineOpts %_verbose ) ],
           MathFuncts   => [ qw( &min &max ) ],
           StatFuncts   => [ qw( &sum &mean &median &stdev ) ],
           StringFill   => [ qw( &fill_right &fill_left &fill_mid ) ],
           CheckFiles   => [ qw( &check_file &check_dir ) ],
           ExitStatus   => [ qw( &check_syscall_exit &the_end &EXIT
                                 %exit_codes $EXIT_REPORT_FILE
                                 &match_argv_num $ERRFH ) ],
           GetFH        => [ qw( &getIFH &getOFH ) ],
           );
    # AdminFunc => [ qw( &connection_details &load_to_tbl_ifdef ) ],
    # );
# use lib "$LIBPERL";

###
### Setting Default Variables
###
#
# Parsing command-line options
use Getopt::Long;
Getopt::Long::Configure qw/ bundling /;
%CmdLineDefs = ();
%CmdLineOpts = (
    'version' => sub { 
            print $ERRFH "#### Hi, you are running $PROG version $VERSION ...\n";
            &EXIT('HELP');
        },
    'debug' => sub {
            ($_verbose{DEBUG}, $_verbose{RAW}) = ($T, $T);
        },
    'v|verbose' => sub {
            $_verbose{RAW} = $T;
        },
    'V|color-verbose' => sub {
            ($_verbose{RAW}, $_verbose{COLOR}) = ($T, $T);
        },
    'h|help|?' => sub {
            $USAGE =~ s/GLOBALOPTIONS/$_USAGE/o || do {
                $USAGE .= $_USAGE;
            };
            &warn('SHOW_HELP', "\nPROGRAM:   $PROG - version $VERSION\n\n".
                               $USAGE." ");
            &EXIT('HELP');
        },
    ); # default command-line options
###
$_cntN = 50; # default counter elements x stderr line
$stdin_flg = $F; # by default main input is read from file
$ERRFH = \*STDERR;
($T,$F) = (1,0);
$PLVER = sprintf("v%vd",$^V);
$LIBPM = 'global.pm';
$PROG  = 'UNDEF';
$VERSION = 'UNDEF';
$USAGE = 'WARNING: Program variable "$USAGE" was not defined yet...';
$DATE  = localtime;
$CDATE = &get_date();
if (defined($ENV{USER})) {
    $USER = $ENV{USER};
} else {
    $USER = "unknown"; # chomp($USER = system("whoami"));
};
if (defined($ENV{HOSTNAME})) {
    $HOST = $ENV{HOSTNAME};
} elsif (defined($ENV{HOST})) {
    $HOST = $ENV{HOST};
} else {
    $HOST = "unknown"; # chomp($HOST = system("hostname"));
};
$HOST =~ s/\..+?\..+?$//o;
if (defined($ENV{PSRF})) {
    $EXIT_REPORT_FILE = $ENV{PSRF};
} else {
    $EXIT_REPORT_FILE = "/tmp/$$";
};
#
# Program status strings.
($_verbose{DEBUG}, $_verbose{RAW}, $_verbose{COLOR}) = ($F) x 3;
#
use Term::ANSIColor;
my $_pre_flg = $F;
my $term_width = 80;
my %mlin = (
    error_base     => sub {
                        my $str = "\<\<\<\< ERROR \>\>\>\>";
                        $_verbose{COLOR} && 
                            ($str = color("bold red").$str.color("reset"));
                        return $str." ";
                      },
    error_pre      => sub {
                        my $str = "\<\<\<";
                        $_verbose{COLOR} && 
                            ($str = color("yellow").$str.color("reset"));
                        return $str;
                      },
    error_post     => sub {
                        my $str = "\>\>\>";
                        $_verbose{COLOR} && 
                            ($str = color("yellow").$str.color("reset"));
                        return $str;
                      },
    error_len      => sub { return ($term_width - ( 16 + 3 + 3 )) },
      # error_base + error_pre + error_post
    warn_base      => sub {
                        my $str = "\<\<\< WARNING \>\>\>";
                        $_verbose{COLOR} && 
                            ($str = color("bold yellow").$str.color("reset"));
                        return $str." ";
                      },
    warn_pre       => sub {
                        my $str = "\<\<\<";
                        $_verbose{COLOR} && 
                            ($str = color("yellow").$str.color("reset"));
                        return $str;
                      },
    warn_post      => sub {
                        my $str = "\>\>\>";
                        $_verbose{COLOR} && 
                            ($str = color("yellow").$str.color("reset"));
                        return $str;
                      },
    warn_len       => sub { return ($term_width - ( 16 + 3 + 3 )) },
      # error_base + error_pre + error_post
    comment_base   => sub { return "" },
    comment_pre    => sub {
                        my $str = "###";
                        $_verbose{COLOR} && 
                            ($str = color("green").$str.color("reset"));
                        return $str;
                      },
    comment_post   => sub {
                        my $str = "###";
                        $_verbose{COLOR} && 
                            ($str = color("green").$str.color("reset"));
                        return $str;
                      },
    comment_len    => sub { return ($term_width - ( 0 + 3 + 3 )) },
      # comment_base + comment_pre + comment_post
    dbi_base       => sub {
                        my $str = "### ";
                        $_verbose{COLOR} && 
                            ($str = color("cyan").$str.color("reset"));
                        return $str;
                      },
    dbi_pre        => sub {
                        my $str = "MySQL *";
                        $_verbose{COLOR} && 
                            ($str = color("cyan").$str.color("reset"));
                        return $str;
                      },
    dbi_post       => sub {
                        my $str = "*";
                        $_verbose{COLOR} && 
                            ($str = color("cyan").$str.color("reset"));
                        return $str;
                      },
    dbi_len        => sub { return ($term_width - ( 4 + 7 + 1 )) },
      # dbi_base + dbi_pre + dbi_post
    spacer         => sub { return "###" },
    );
#
$mlin{'error_line'} = sub {
                        my $str = ('-' x $mlin{'error_len'}->());
                        $_verbose{COLOR} && 
                            ($str = color("yellow").$str.color("reset"));
                        return $str;
                      };
$mlin{'empty_error_line'} = sub { return (' ' x $mlin{'error_len'}->()) };
#
$mlin{'warn_line'} = sub { return $mlin{'error_line'}->() };
$mlin{'empty_warn_line'} = sub { return $mlin{'empty_error_line'}->() };
#
$mlin{'comment_line'} = sub {
                        my $str = ("#" x $mlin{'comment_len'}->());
                        $_verbose{COLOR} && 
                            ($str = color("green").$str.color("reset"));
                        return $str;
                      };
$mlin{'empty_comment_line'} = sub { return (' ' x $mlin{'comment_len'}->()) };
#
$mlin{'dbi_line'} = sub {
                        my $str = ("*" x $mlin{'dbi_len'}->());
                        $_verbose{COLOR} && 
                            ($str = color("cyan").$str.color("reset"));
                        return $str;
                      };
$mlin{'empty_dbi_line'} = sub { return (' ' x $mlin{'dbi_len'}->()) };
#
%Messages = (
    # ERROR MESSAGES
    WARN => sub {
             return
               &right_header(
                     $mlin{'warn_len'}->(),$mlin{'warn_base'}->(),
                 $mlin{'warn_pre'}->(),$mlin{'warn_post'}->(),
                 $mlin{'warn_line'}->(),
                 &prespc(@_),
                 $mlin{'warn_line'}->(),
                 );
         },
    ERROR => sub {
             return
               &right_header(
                     $mlin{'error_len'}->(),$mlin{'error_base'}->(),
                 $mlin{'error_pre'}->(),$mlin{'error_post'}->(),
                 $mlin{'error_line'}->(),
                 &prespc(@_),
                 $mlin{'error_line'}->(),
                 );
         },
    ENVNOTDEF    => sub {
             my $mssg = shift || '';
             return
               &header(
                 $mlin{'error_len'}->(),$mlin{'error_base'}->(),
                 $mlin{'error_pre'}->(),$mlin{'error_post'}->(),
                 $mlin{'error_line'}->(),$mlin{'empty_error_line'}->(),
                 "Following environment variable is NOT defined: $mssg",
                 $mlin{'empty_error_line'}->(),$mlin{'error_line'}->(),           
                 );
         },
    USER_HALT    => sub {
             my $name = shift;
             return
               &header(
                 $mlin{'warn_len'}->(),$mlin{'warn_base'}->(),
                 $mlin{'warn_pre'}->(),$mlin{'warn_post'}->(),
                 $mlin{'warn_line'}->(),$mlin{'empty_warn_line'}->(),
                 "$name has been stopped by user !!!",
                 "---------- Exiting NOW !!! ----------",
                 $mlin{'empty_warn_line'}->(),$mlin{'warn_line'}->(),
                 );
         },
    PROCESS_HALT => sub {
             my $name = shift;
             return
               &header(
                 $mlin{'warn_len'}->(),$mlin{'warn_base'}->(),
                 $mlin{'warn_pre'}->(),$mlin{'warn_post'}->(),
                 $mlin{'warn_line'}->(),$mlin{'empty_warn_line'}->(),
                 "------- $name is down !!! -------",
                 "---------- Exiting NOW !!! ----------",
                 $mlin{'empty_warn_line'}->(),$mlin{'warn_line'}->(),
                 );
         },
    CHILD_EXIT => sub {
             my ($cxprg,$cxpid) = @_;
             return
               &header(
                     $mlin{'warn_len'}->(),$mlin{'warn_base'}->(),
                 $mlin{'warn_pre'}->(),$mlin{'warn_post'}->(),
                 $mlin{'warn_line'}->(),$mlin{'empty_warn_line'}->(),
                 "---- $cxprg main loop child reaper ----",
                 "Child process >>$cxpid<< has died !!!",
                 $mlin{'empty_warn_line'}->(),$mlin{'warn_line'}->(),
                 );
         },
    CHILD_KILLED => sub {
             my ($cxprg,$cxpid) = @_;
             return
               &header(
                     $mlin{'warn_len'}->(),$mlin{'warn_base'}->(),
                 $mlin{'warn_pre'}->(),$mlin{'warn_post'}->(),
                 $mlin{'warn_line'}->(),$mlin{'empty_warn_line'}->(),
                 "---- $cxprg main loop child reaper ----",
                 "Child process >>$cxpid<< has died !!!",
                 $mlin{'empty_warn_line'}->(),$mlin{'warn_line'}->(),
                 );
         },
    CMDLINE_OPT_ERR => sub {
             my $mssg = shift || '';
             $mssg =~ s/^\s*//o;
             $mssg =~ s/\s*$//o;
             return
               &right_header(
                     $mlin{'warn_len'}->(),$mlin{'warn_base'}->(),
                 $mlin{'warn_pre'}->(),$mlin{'warn_post'}->(),
                 $mlin{'warn_line'}->(),
                 &prespc("Error trapped while processing command-line:",
                         (" "x8)."--> $mssg <--"),
                 $mlin{'warn_line'}->(),
                 );
         },
    CMDLINE_ERROR   => sub {
             my ($name,@mssg) = @_;
             return
               &right_header(
                     $mlin{'error_len'}->(),$mlin{'error_base'}->(),
                 $mlin{'error_pre'}->(),$mlin{'error_post'}->(),
                 $mlin{'error_line'}->(),
                 &prespc(@mssg, "",
                         "Please, check your command-line options!!!",
                         (" "x8)."Type \"$name --help\" for help..."),
                 $mlin{'error_line'}->(),
                 );
         },
    # WORKING MESSAGES
    HEADER       => sub {
             my @mssg = @_;
             (scalar(@mssg) > 0) || ($mssg[0] = '');
             return
               &header(
                     $mlin{'comment_len'}->(),$mlin{'comment_base'}->(),
                 $mlin{'comment_pre'}->(),$mlin{'comment_post'}->(),
                 $mlin{'comment_line'}->(),
                 "", @mssg, "",
                 $mlin{'comment_line'}->(),
                 );
         },
    DBIHEADER    => sub {
             my @mssg = @_ || ('');
             return
               &right_header(
                     $mlin{'dbi_len'}->(),$mlin{'dbi_base'}->(),
                 $mlin{'dbi_pre'}->(),$mlin{'dbi_post'}->(),
                 $mlin{'dbi_line'}->(),
                 &prespc(@mssg),
                 $mlin{'dbi_line'}->(),
                 );
         },
    DBIMSG       => sub {
             my @mssg = @_ || ('');
             return &comment_line($mlin{'dbi_len'}->(),$mlin{'dbi_base'}->(),
                                  $mlin{'dbi_pre'}->(),@mssg);
         },
    DBICMD       => sub {
             my @mssg = split /[\n]/o, shift;
             @mssg = map { s/^\s{6}//o; $_ } @mssg;
             return &comment_line($mlin{'dbi_len'}->(),$mlin{'dbi_base'}->(),
                                  $mlin{'dbi_pre'}->(),@mssg);
         },
    SHOW_HELP    => sub {
             my @mssg = split /[\n]/o, shift;
             return 
               &right_header(
                     $mlin{'comment_len'}->(),$mlin{'comment_base'}->(),
                 $mlin{'comment_pre'}->(),$mlin{'comment_post'}->(),
                 $mlin{'comment_line'}->(),
                 &prespc(@mssg),
                 $mlin{'comment_line'}->(),
                 );
         },
   ); # %Messages
%exit_codes = (
    'OK' => { 
         CODE  =>   0,
         SHORT => "Everything was OK",
         MSG   => sub { return $exit_codes{'OK'}{SHORT} },
         },
    'KO' => { 
         CODE  =>   1,
         SHORT => "Errors found (not specified)",
         MSG   => sub { return $exit_codes{'KO'}{SHORT} },
         },
    'HELP' => { 
         CODE  =>   2,
         SHORT => "User requested script usage via command-line options",
         MSG   => sub { return $exit_codes{'HELP'}{SHORT} },
         },
    'UNAVAILABLE' => { 
         CODE  =>   3,
         SHORT => "Could not find/create status file",
         MSG   => sub { return $exit_codes{'UNAVAILABLE'}{SHORT} },
         },
    'USERHALT' => { 
         CODE  =>   4,
         SHORT => "Process halted by user ([[CTRL+C]])",
         MSG   => sub { return $exit_codes{'USERHALT'}{SHORT} },
         },
    'PROGHALT' => { 
         CODE  =>   5,
         SHORT => "Process halted by program (kill -9)",
         MSG   => sub { return $exit_codes{'PROGHALT'}{SHORT} },
         },
    'PROGDOWN' => { 
         CODE  =>   6,
         SHORT => "Process is down",
         MSG   => sub { return $exit_codes{'PROGDOWN'}{SHORT} },
         },
    'NOFORK' => { 
         CODE  =>   8,
         SHORT => "Could not fork child",
         MSG   => sub { return $exit_codes{'NOFORK'}{SHORT} },
         },
    'RSH' => { 
         CODE  =>  10,
         SHORT => "RSH command failed",
         MSG   => sub { return $exit_codes{'RSH'}{SHORT} },
         },
    'SSH' => { 
         CODE  =>  11,
         SHORT => "SSH command failed",
         MSG   => sub { return $exit_codes{'SSH'}{SHORT} },
         },
    'PBS' => { 
         CODE  =>  12,
         SHORT => "PBS command failed",
         MSG   => sub { return $exit_codes{'PBS'}{SHORT} },
         },
    'NOTRUN' => { 
         CODE  =>  13,
         SHORT => "Program was not executed",
         MSG   => sub { return $exit_codes{'NOTRUN'}{SHORT} },
         },
    'CMDKO' => { 
         CODE  =>  14,
         SHORT => "Command not found or failed...",
         MSG   => sub { return $exit_codes{'CMDKO'}{SHORT} },
         },
    'CKO' => { 
         CODE  =>  15,
         SHORT => "C program failed...",
         MSG   => sub { return $exit_codes{'CKO'}{SHORT} },
         },
    'PERLKO' => { 
         CODE  =>  16,
         SHORT => "PERL script failed...",
         MSG   => sub { return $exit_codes{'PERLKO'}{SHORT} },
         },
    'GAWKKO' => { 
         CODE  =>  17,
         SHORT => "GAWK script failed...",
         MSG   => sub { return $exit_codes{'GAWKKO'}{SHORT} },
         },
    'BASHKO' => { 
         CODE  =>  18,
         SHORT => "BASH script failed...",
         MSG   => sub { return $exit_codes{'BASHKO'}{SHORT} },
         },
    'FUNCKO' => { 
         CODE  =>  19,
         SHORT => "BASH user defined function failed...",
         MSG   => sub { return $exit_codes{'FUNCKO'}{SHORT} },
         },
    'NOFILE' => { 
         CODE  =>  20,
         SHORT => "File not found",
         MSG   => sub { return $exit_codes{'NOFILE'}{SHORT} },
         },
    'NOREADFILE' => { 
         CODE  =>  22,
         SHORT => "Could not open file to read",
         MSG   => sub { return $exit_codes{'NOREADFILE'}{SHORT} },
         },
    'NOWRITEFILE' => { 
         CODE  =>  24,
         SHORT => "Could not open file to write",
         MSG   => sub { return $exit_codes{'NOWRITEFILE'}{SHORT} },
         },
    'NOAPPENDFILE' => { 
         CODE  =>  26,
         SHORT => "Could not open file to append",
         MSG   => sub { return $exit_codes{'NOAPPENDFILE'}{SHORT} },
         },
    'EMPTYFILE' => { 
         CODE  =>  28,
         SHORT => "File was found empty...",
         MSG   => sub { return $exit_codes{'NOAPPENDFILE'}{SHORT} },
         },
    'NODIR' => { 
         CODE  =>  30,
         SHORT => "Directory not found",
         MSG   => sub { return $exit_codes{'NODIR'}{SHORT} },
         },
    'NOREADDIR' => { 
         CODE  =>  32,
         SHORT => "Could not open directory to read",
         MSG   => sub { return $exit_codes{'NOREADDIR'}{SHORT} },
         },
    'NOWRITEDIR' => { 
         CODE  =>  34,
         SHORT => "Could not open directory to write",
         MSG   => sub { return $exit_codes{'NOWRITEDIR'}{SHORT} },
         },
    'NONEWDIR' => { 
         CODE  =>  36,
         SHORT => "Could not create new directory",
         MSG   => sub { return $exit_codes{'NONEWDIR'}{SHORT} },
         },
    'EMPTYDIR' => { 
         CODE  =>  38,
         SHORT => "Dir was found empty...",
         MSG   => sub { return $exit_codes{'NONEWDIR'}{SHORT} },
         },
    'NOBASHPIPE' => { 
         CODE  =>  40,
         SHORT => "Error found in bash pipe",
         MSG   => sub { return $exit_codes{'NOBASHPIPE'}{SHORT} },
         },
    'NOREADPIPE' => { 
         CODE  =>  42,
         SHORT => "Could not open pipe to read",
         MSG   => sub { return $exit_codes{'NOREADPIPE'}{SHORT} },
         },
    'NOWRITEPIPE' => { 
         CODE  =>  44,
         SHORT => "Could not open pipe to write",
         MSG   => sub { return $exit_codes{'NOWRITEPIPE'}{SHORT} },
         },
    'NOSTDIN'  => { 
         CODE  =>  46,
         SHORT => "Could not read from STDIN",
         MSG   => sub { return $exit_codes{'NOSTDIN'}{SHORT} },
         },
    'NOSTDOUT' => { 
         CODE  =>  48,
         SHORT => "Could not write to STDOUT",
         MSG   => sub { return $exit_codes{'NOSTDOUT'}{SHORT} },
         },
    'COMMANDLINE' => { 
         CODE  =>  60,
         SHORT => "Error trapped when parsing commandline options",
         MSG   => sub { return $exit_codes{'COMMANDLINE'}{SHORT} },
         },
    'BADCMDLINEOPT' => { 
         CODE  =>  62,
         SHORT => "Wrong command-line option forced program exit",
         MSG   => sub { return $exit_codes{'BADCMDLINEOPT'}{SHORT} },
         },
    'NOCMDLINEFILE' => { 
         CODE  =>  64,
         SHORT => "Missing file names from command-line...",
         MSG   => sub { return $exit_codes{'NOCMDLINEFILE'}{SHORT} },
         },
    'ENVERROR' => { 
         CODE  =>  70,
         SHORT => "Error trapped when setting shell environment",
         MSG   => sub { return $exit_codes{'ENVERROR'}{SHORT} },
         },
    'ENVUNDEFVAR' => { 
         CODE  =>  72,
         SHORT => "Environment variable not defined",
         MSG   => sub { return $exit_codes{'ENVUNDEFVAR'}{SHORT} },
         },
    'DBCONNECT' => { 
         CODE  => 100,
         SHORT => "Could not connect to DataBase",
         MSG   => sub { return $exit_codes{'DBCONNECT'}{SHORT} },
         },
    'NOTRANSACTION' => { 
         CODE  => 110,
         SHORT => "Could not process transaction",
         MSG   => sub { return $exit_codes{'NOTRANSACTION'}{SHORT} },
         },
    'NOCMD' => { 
         CODE  => 127,
         SHORT => "Command not found",
         MSG   => sub { return $exit_codes{'NOCMD'}{SHORT} },
         },
    'UNDEF' => { 
         CODE  => 255,
         SHORT => "Unknown exit status (not defined)",
         MSG   => sub { return $exit_codes{'UNDEF'}{SHORT} },
         },
    );
%{ $exit_codes{'CODES'} } = ( map { $exit_codes{$_}{'CODE'}, $_ }
                              keys %exit_codes );
$_USAGE =<<"+++EOH+++";
  The following command-line options are set by default
  when using \"$LIBPM\":

           -h, --help  Shows this help.
            --version  Shows version for current script. 
        -v, --verbose  Execution messages are sent to STDERR.
  -V, --color-verbose  Messages are text-coloured to highlight
                       different kinds of messages.
              --debug  All execution messages are sent to STDERR,
                       including dumps of the internal data structures.
+++EOH+++

###
### Shareable functions
###
#
# Timing definitions
use Benchmark;
@exectime = ();
sub init_timer() {
    my $refary = shift;
    @{ $refary } = (new Benchmark);
    return;
} # init_timer
sub timing() {
    my ($refary,$tmp) = @_;
    my $flg = defined($tmp) || $F;
    push @{ $refary } , (new Benchmark);
    my $mx = $#{ $refary };
    # partial time 
    $flg || do {
        return timestr(timediff($refary->[$mx],$refary->[($mx - 1)]));
    };
    # total time
    return timestr(timediff($refary->[$mx],$refary->[0]));
} # timing
sub get_date() {
    return
        sprintf("%04d%02d%02d%02d%02d%02d",
                sub { $_[5] + 1900, $_[4] + 1, $_[3], $_[2], $_[1], $_[0]
                      }->(localtime) );
} # get_date
#
# Trapping signals
use POSIX qw( :signal_h :errno_h :sys_wait_h );
sub init_signals() {
    $SIG{HUP}  = \&trap_signals_prog;
    $SIG{ABRT} = \&trap_signals;
    $SIG{INT}  = \&trap_signals;
    $SIG{QUIT} = \&trap_signals;
    $SIG{TERM} = \&trap_signals;
    $SIG{KILL} = \&trap_signals;
    $SIG{CHLD} = \&child_reaper; # 'IGNORE';
    @skip_next = ($F, undef);
} # init_signals
sub trap_signals() {
    print $ERRFH $Messages{'USER_HALT'}->($PROG);
    @skip_next = ($T, $F);
} # trap_signals
sub trap_signals_prog() {
    print $ERRFH $Messages{'PROCESS_HALT'}->($PROG);
    @skip_next = ($T, $T);
} # trap_signals_prog
sub child_reaper() {
    my $cpid;
    $cpid = waitpid(-1, &WNOHANG);
    if (($cpid != -1) && WIFEXITED($?)) {
        # $skip_next[2] = $T;
        print $ERRFH $Messages{'CHILD_EXIT'}->($PROG, $cpid);
    };
    $SIG{CHLD} = \&child_reaper;
} # child_reaper
#
# Reporting program status and messages
sub comment_line() {
    my ($tlen,$base,$pre,@lns) = @_;
    my ($comment,$ln);
    foreach $ln (@lns) {
        $ln =~ s/^$/ /o; 
        $comment .= "$base$pre $ln\n";
        };
    return $comment;
} # header
sub header() {
    my ($tlen,$base,$pre,$post,@lns) = @_;
    my $comment = $_pre_flg ? $mlin{'spacer'}->()."\n" : '';
    $_pre_flg || ($_pre_flg = $T); 
    foreach my $ln (@lns) { 
        $comment .= "$base$pre".
                    (&fill_mid($ln,$tlen," "))."$post\n";
        };
    return $comment;
} # header
sub left_header() {
    my ($tlen,$base,$pre,$post,@lns) = @_;
    my $comment = $_pre_flg ? $mlin{'spacer'}->()."\n" : '';
    $_pre_flg || ($_pre_flg = $T); 
    foreach my $ln (@lns) { 
        $comment .= "$base$pre".
                    (&fill_left($ln,$tlen," "))."$post\n";
        };
    return $comment;
} # left_header
sub right_header() {
    my ($tlen,$base,$pre,$post,@lns) = @_;
    my $comment = $_pre_flg ? $mlin{'spacer'}->()."\n" : '';
    $_pre_flg || ($_pre_flg = $T); 
    foreach my $ln (@lns) { 
        $comment .= "$base$pre".
                    (&fill_right($ln,$tlen," "))."$post\n";
        };
    return $comment;
} # right_header
sub program_started() {
    my $prog = shift;
    scalar(@exectime) || &init_timer(\@exectime);
    &report('HEADER',"RUNNING $prog",'',"Host: $HOST",
                     "User: $USER","Perl: $PLVER",'',"Date: $DATE");
} # program_started
sub program_finished() {
    my $prog = shift;
    my $txt = &timing(\@exectime,$T);
    # $txt =~ s/(secs)\s+(\()/$1\n$2/o;
    $txt =~ s{^\s*(\d+)\s+wallclock\s+secs\s+(\()\s*}{\n$2}o && do {
        $txt = sprintf("Total Execution Time: %02d:%02d:%02d (%d secs)%s",
                  sub { ($_[2]-1, $_[1], $_[0]) }->(localtime($1)),$1,$txt);
    };
    &report('HEADER',"$prog HAS FINISHED",'',(split /\n/o, $txt));
} # program_finished
#
# Checking for exact ARGV number
sub match_argv_num() {
    my ($arg,$num) = @_;
    (scalar(@{ $arg }) != $num) && do {
        # print $ERRFH $Messages{'CMDLINE_ERROR'}->($PROG,"@ARGV");
        print $ERRFH "## $PROG ## EXITING NOW: CHECK COMMAND-LINE OPTIONS!!!\n";
        &EXIT('COMMANDLINE');
    };
} # match_argv_num
sub add_cmdline_opts() {
    my %NewOpts = @_;
    foreach my $k (keys %NewOpts) {
        defined($global::CmdLineOpts{$k}) && do {
            &warn('WARN', "ALREADY DEFINED COMMAND-LINE SWITCH >>$k<< !!!");
            next;
        };
        $global::CmdLineOpts{$k} = $NewOpts{$k};
    };
} # add_cmdline_opts
sub parse_cmdline() {
    # we ensure here that options hash always exist 
    # (and that it has a default option: 'help')
    my $_argvstring = "@ARGV";
    # looking for STDIN "-" to avoid problems with GetOptions
    my $cmdln_stdin = undef;
    for (my $a = 0; $a <= $#ARGV; $a++) { 
        next unless $ARGV[$a] =~ /^-$/o;
        $cmdln_stdin = $a - $#ARGV;
        splice(@ARGV,$a,1);
    };    
    # parsing command-line
    $SIG{__WARN__} = sub {
            &warn('CMDLINE_OPT_ERR',$_[0]);
        };
    GetOptions(%CmdLineOpts) || do {
            # &program_started($PROG);
            &warn('CMDLINE_ERROR',$PROG,"$PROG $_argvstring ");
            &EXIT('COMMANDLINE');
        };
    $SIG{__WARN__} = 'DEFAULT';
    # if "-" return to its position on cmd-line
    my $t = scalar(@ARGV);
    defined($cmdln_stdin) && do {
        abs($cmdln_stdin) > $t && ($cmdln_stdin = -$t);
            $cmdln_stdin > 0  && ($cmdln_stdin = 0 );
        $t += $cmdln_stdin;
        splice(@ARGV,$t,0,'-');
    };
} # parse_cmdline
#
sub getIFH() {
    my $file = shift;
    my ($fstr,$ferr,$sflg);
    local *D;
    defined($file) || do {
        &warn('WARN', "FILE NAME NOT DEFINED !!!\n");
        &EXIT('NOFILE');
    };
    ($file ne '-') || do {
        &rpt("## Input Stream set to STDIN...\n") if $_verbose{'DEBUG'};
        return (*STDIN, 2);
    };
    if ($file =~ /\|\s*$/o) {
        $fstr = $file;
        $ferr = 'NOREADPIPE';
        $sflg = 1;
    } elsif (! -e $file) {
        &warn('WARN', "INPUT File does not exist: \"$file\"\n");
        &EXIT('NOFILE');
    } elsif ($file =~ /\.gz\s*$/io) {
        $fstr = "gunzip -c $file |";
        $ferr = 'NOREADPIPE';
        $sflg = 1;
    } elsif ($file =~ /\.zip\s*$/io) {
        $fstr = "unzip -c $file |";
        $ferr = 'NOREADPIPE';
        $sflg = 1;
    } elsif ($file =~ /\.bz2\s*$/io) {
        $fstr = "bunzip2 -c $file |";
        $ferr = 'NOREADPIPE';
        $sflg = 1;
    } elsif ($file =~ /\.z\s*$/io) {
        $fstr = "uncompress -c $file |";
        $ferr = 'NOREADPIPE';
        $sflg = 1;
    } else {
        $fstr = "< $file";
        $ferr = 'NOREADFILE';
        $sflg = 0;
    };
    open(D, $fstr) || do {
        &warn('WARN', "Cannot open input stream \"$fstr\"\n");
        &EXIT($ferr);
    };
    &rpt("## Input Stream set to: \"$fstr\"\n") if $_verbose{'DEBUG'};
    return (*D, $sflg);
} # getIFH
#
sub getOFH() {
    my $file = shift;
    my ($fstr,$ferr,$sflg);
    local *D;
    defined($file) || do {
        &warn('WARN', "FILE NAME NOT DEFINED !!!\n");
        &EXIT('NOFILE');
    };
    ($file ne '-') || do {
        &rpt("## Output Stream set to STDOUT...\n") if $_verbose{'DEBUG'};
        return (*STDOUT, 2);
    };
    if ($file =~ /^\s*\|/o) {
        $fstr = $file;
        $ferr = 'NOWRITEPIPE';
        $sflg = 1;
    } elsif ($file =~ /\.gz\s*$/io) {
        $fstr = "| gzip --stdout --best - > $file";
        $ferr = 'NOWRITEPIPE';
        $sflg = 1;
    } elsif ($file =~ /\.zip\s*$/io) {
        $fstr = "| zip -c -9 - > $file";
        $ferr = 'NOWRITEPIPE';
        $sflg = 1;
    } elsif ($file =~ /\.bz2\s*$/io) {
        $fstr = "| bzip2 --stdout --best - > $file";
        $ferr = 'NOWRITEPIPE';
        $sflg = 1;
    } elsif ($file =~ /\.z\s*$/io) {
        $fstr = "| compress -c - > $file";
        $ferr = 'NOWRITEPIPE';
        $sflg = 1;
    } else {
        $fstr = "> $file";
        $ferr = 'NOWRITEFILE';
        $sflg = 0;
    };
    open(D, $fstr) || do {
        &warn('WARN', "Cannot open output stream \"$fstr\"\n");
        &EXIT($ferr);
    };
    &rpt("## Output Stream set to: \"$fstr\"\n") if $_verbose{'DEBUG'};
    return (*D, $sflg);
} # getOFH
#
sub check_dir() {
    my (@odir) = @_;
    (scalar(@odir) == 0) && (return 0);
    my @okdir = ();
    foreach my $thisdir (@odir) {
        ( -e $thisdir && -d _ ) || do {
            print $ERRFH "# Making directory: $thisdir\n";
            (mkdir $thisdir) || do {
                print $ERRFH "# Error making directory \"$thisdir\": SKIPPING !!!\n";
                push @okdir, $F;
                next;
            };
            push @okdir, $T;
            next;
        };
        print $ERRFH "# Directory \"$thisdir\" ALREADY EXIST...\n";
        push @okdir, $T; 
    }; # foreach $d
    return @okdir;
} # check_dir
# 
# Checking exit status for sys calls
sub check_syscall_exit() {
    my $prog_exit = 0xffff & shift;
    my ($exitflg,$exitstr) = ($F,'');
    $exitstr = sprintf("Command returned %#04x : ", $prog_exit);
    if ($prog_exit == 0) {
        $exitflg = $T;
        $exitstr .= "ran with normal exit ...";
    }
    elsif ($prog_exit == 0xff00) {
        $exitstr .= "command failed: $! ...";
    }
    elsif (($prog_exit & 0xff) == 00) {
        $prog_exit >>= 8;
        $exitstr .= "ran with non-zero exit status $prog_exit ...";
    }
    else {
        $exitstr .= "ran with ";
        if ($prog_exit &   0x80) {
            $prog_exit &= ~0x80;
            $exitstr .= "coredump from ";
            };
        $exitstr .= "signal $prog_exit ...";
    };
    return ($exitflg,$exitstr,$prog_exit);
} # check_syscall_exit
# 
sub EXIT() {
    my $k = shift || 'UNDEF';
    exit($exit_codes{$k}{CODE});
} # EXIT 
# Return to program caller a "normalized" error code
sub the_end() { 
    my $k = shift || 'UNDEF';
    defined($exit_codes{$k}) || ($k = 'UNDEF');
    ($k eq 'OK' || $k eq 'KO') || do {
        $exit_codes{$k}{MSG}->();
    };
    open(XRF,"> $EXIT_REPORT_FILE") || do {
        &EXIT('UNAVAILABLE');
    };
    print XRF $exit_codes{$k}{CODE};
    close(XRF);
    &EXIT($k);
} # the_end
# 
# General functions
sub fill_right() { return $_[0].($_[2] x ($_[1] - length($_[0]))) }
sub fill_left()  { return ($_[2] x ($_[1] - length($_[0]))).$_[0] }
sub fill_mid()   { 
    my $l = length($_[0]);
    my $k = int(($_[1] - $l)/2);
    return ($_[2] x $k).$_[0].($_[2] x ($_[1] - ($l + $k)));
} # fill_mid
sub prespc() { return ( map { " $_" } @_ ); } 
sub rpt() { print $ERRFH @_ if $_verbose{RAW}; }
sub report() {
    my $c = shift @_;
    print $ERRFH sprintf($Messages{$c}->(@_)) if $_verbose{RAW};
} # report
sub warn() {
    my $c = shift @_;
    my $cc = sprintf($Messages{$c}->(@_));
    print $ERRFH $cc; 
    print STDERR $cc if (*$ERRFH ne *STDERR);
} # warn
#
sub sum() { # $sum = &sum(\@ary)
    my ($ary, $res);
    $ary = shift;
    foreach (@$ary) { $res += $_; };
    return $res;
} # sum
#
sub mean() { # $mean = &mean(\@ary)
    my ($ary, $sum, $res, $n);
    ($ary, $sum) = @_; # $ary = shift;
    $res = defined($sum) ? $sum : &sum($ary);
    ($n = scalar(@$ary)) > 0 &&
        return sprintf("%.4f", $res / $n);
    return 'NaN' ;
} # mean
#
sub median() { # $median = &median(\@ary) # ODD-MEDIAN
    my ($ary, @Ary, $n);
    $ary = shift;
    @Ary = sort { $a <=> $b } @$ary;
         # must ensure that sort works "numerically" always
    ($n = scalar(@Ary)) > 0 &&
        return sprintf("%.4f", $Ary[($n - (0,0,1,0)[$n & 3]) / 2]);
    return 'NaN' ;
} # odd_median
#
sub stdev() { # $stdev = &stdev(\@ary) # STANDARD DEVIATION
    my ($ary, $Mean, $mean);
    ($ary, $Mean) = @_; # $ary = shift;
    $mean = defined($Mean) ? $Mean : &mean($ary);
    $mean ne 'NaN' &&
        return sprintf("%.4f",
                       sqrt( &mean( [ map { ( $_ - $mean ) ** 2 } @$ary ] ) )
		       );
                     # sqrt( &mean( [ map $_ ** 2, @$ary ] ) - ($mean ** 2)));
    return 'NaN' ;
} # odd_median
# 
sub max() {
    my $z = shift @_;
    foreach my $l (@_) { $z = $l if $l > $z };
    return $z;
} # max
sub min() {
    my $z = shift @_;
    foreach my $l (@_) { $z = $l if $l < $z };
    return $z;
} # min
#
#
sub counter() { # $_[0]~current_pos++ $_[1]~char
    $_verbose{RAW} || return;
    print $ERRFH "$_[1]";
    (($_[0] % $_cntN) == 0) && (print $ERRFH "[".&fill_left($_[0],6,"0")."]\n");
} # counter
#
sub counter_end() { # $_[0]~current_pos   $_[1]~char
    $_verbose{RAW} || return;
    (($_[0] % $_cntN) != 0) && (print $ERRFH "[".&fill_left($_[0],6,"0")."]\n");
} # counter_end

#
# Exiting from "global" package
1;
