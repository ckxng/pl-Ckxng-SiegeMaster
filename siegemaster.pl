#!/usr/bin/perl
# $Id$
use strict;
use warnings;
use 5.006;

package Ckxng::SiegeMaster;

=head1 NAME

siegemaster.pl / Ckxng::SiegeMaster

=head1 SYNOPSIS

siegemaster.pl [ -s servers ] [ -c concurrent ] [ -f urls.txt ]

=head1 DESCRIPTION

Launch siege processes on remote hosts.  Ssh to root via key to specified hosts
is required to use this program.

=over 4

=item B<-s, --servers=NUM>

The number of servers to deistribute load testing across.  Eight servers
are available at this time.

If this option is not specified, then defaults will be used.  (One server per
100 concurrency, then evenly distributed after that.)

=item B<-c, --concurrent=NUM>

CONCURRENT, allows you to set the concurrent number of simulated users to num.
The number of simulated users is limited to the resources on the computer
running siege.

=item B<-i, --internet>

INTERNET, generates user simulation by randomly hitting the URLs read from the
urls.txt file.

=item B<-b, --benchmark>

BENCHMARK, runs the test with NO DELAY for throughput benchmarking. By default
each simulated user is invoked with at least a one second delay. This option
removes that delay.  It is not recommended that you use this option while load
testing.

=item B<-t, --time=NUMm>

TIME, allows you to run the test for a selected period of time.  The format is
"NUMm", where NUM is a time unit and the "m" modifier is either S, M, or H for
seconds, minutes and hours.  To run siege for an hour, you could select any one
of the following  combinations: -t3600S, -t60M, -t1H.  The modifier is not case
sensitive, but it does require no space between the number and itself.

=item B<-T, --timeout=NUM>

The number of seconds before a connection is reported as a timeout.  Default is
30 seconds.

=item B<-d, --delay=NUM>

DELAY, each siege simulated users sleeps for a random interval in seconds
between 0 and NUM.

=item B<-x, --override>

Raise the safety limits.  This option should only be used by operators with a
thourough knowledge of siege and load testing.

Specify twice to disengage ALL restrictions.

=item B<-g, --tag=MESSAGE>

A string to prepend to logged output.  A good thing to use for running multiple
tests on the same day.

=item B<-v, --verbose>

Enable verbose output.  Specify multiple times for additional output.

=item B<-V, --version>

Print version and exit.

=item B<-h, --help>

Print help and exit.

=back

=head1 VERSION

0.001

=head1 REQUIRES

=over 4

=item L<Sys::Syslog>, 0.28

=item L<Getopt::Long>

=item L<Pod::Usage>

=back

=head1 EXPORT

None by default.

=cut

my $VERSION = 0.001;


############################################################

=head1 SUBROUTINES

=head2 B<< $self->new >>()

Create a Logger object with default $self->{args}

=cut

sub new {
  my $package = shift(@_);
  my $self = {
    args => {
      file       => undef,
      servers    => 1,
      tag        => "siege[$$]",
      concurrent => undef,
      timeout    => undef,
      internet   => undef,
      benchmark  => undef,
      delay      => undef,
      verbose    => undef,
      override   => undef,
      time       => undef,
      help       => undef,
      version    => undef,
      argv       => undef,
      _servers   => [
        "lt01.example.com",
        "lt02.example.com",
        "lt03.example.com",
      ],
    },
  };

  return(bless($self, $package));
}
=head2 B<run>()

Run the logger with the behavior specified by $self->{args}

=cut

sub run {
  my $self = shift(@_);

}

=head1 MAIN SUBROUTINES

=head2 B<main_version>()

Print version information found in the documentation.

-V will print version information

=head2 B<main_help>()

Print usage information found in the documentation.

-h will print basic usage

-hv will load the man page

=head2 B<main>()

Extracts commandline arguments and initializes the application and
$self->{args}.  Runs the application.

-vvv will dump the args to stderr.

=cut

sub main_version {
  use Pod::Usage;
  print pod2usage(-verbose=>99, -sections=>[qw( NAME VERSION AUTHOR COPYRIGHT LICENSE)]);
  exit;
}

sub main_help {
  use Pod::Usage;
  print $_[0]?pod2usage(-verbose=>99, -sections=>[qw( SYNOPSIS DESCRIPTION )]):pod2usage;
  exit;
}

sub main {
  use Getopt::Long;
  Getopt::Long::Configure "bundling";
  my $app = ECC::SiegeMaster->new;
  GetOptions($app->{args},
    "concurrent|c",
    "file|f=s",
    "servers|s=n",
    "timeout|T=n",
    "internet|i",
    "benchmark|b",
    "delay|d=s",
    "override|x+",
    "tag|g=s",
    "time|t=s",
    "verbose|v+",
    "version|V",
    "help|h",
  );
  @{ $app->{args}->{argv} } = @ARGV if $#ARGV >= 0;
  if($app->{args}->{verbose} && $app->{args}->{verbose} >= 3) {
    print map { sprintf("*%s: %s\n", $_, $app->{args}->{$_}||"") } keys(%{$app->{args}});
  }
  main_help $app->{args}->{verbose} if $app->{args}->{help};
  main_version if $app->{args}->{version};
  $app->run;
}
main unless caller;

=head1 AUTHOR

Cameron King <http://cameronking.me>

=head1 COPYRIGHT

Copyright 2012 Cameron C. King. All rights reserved.

=head1 LICENSE

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY CAMERON C. KING ''AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL CAMERON C. KING OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.

=cut
1;
