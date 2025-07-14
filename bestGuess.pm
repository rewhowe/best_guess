package bestGuess;

use strict;
use warnings;
no warnings 'utf8'; ## no critic (ProhibitNoWarnings)
use utf8;
# List::MoreUtils qw(uniq);
use English qw(-no_match_vars);

use constant {
  WORD_LENGTH => 5,
  RANKINGS_TO_SHOW => 20,
};

##
# Compatibility implementation for default Perl installation.
# Can be imported from List::MoreUtils if available.
sub uniq {
  my %h = map { $_ => 1 } @_;
  grep { delete %h{$_} } @_;
}

sub new {
  bless {
    histogram  => {},
    candidates => {},
  }, shift;
}

sub main {
  my $self = shift;

  my $filepath = shift @ARGV;
  die "Missing filepath\n" unless defined $filepath;
  my @words = $self->read_from_file($filepath);

  $self->make_histogram(@words);
  $self->score_candidates();
  my @sorted_candidates = $self->rank_guesses();
  $self->make_best_guesses(@sorted_candidates);
}

sub read_from_file {
  my ($self, $filepath) = @_;

  my @lines;
  eval {
    open my $fh, '<:encoding(utf-8)', $filepath or die;
    while (<$fh>) {
      chomp;
      push @lines, $_;
    }
    close $fh or die;
  };
  die "Could not read from $filepath" if $@;

  @lines;
}

##
# Creates a histogram of each letter occurrence.
# Also creates a candidate list for best guesses (only if the word contains no
# duplicate letters).
sub make_histogram {
  my ($self, @words) = @_;

  foreach my $word (@words) {
    next if length $word != WORD_LENGTH;

    $self->{candidates}->{$word} = 0 if $word eq join '', uniq($self->split_by_letter($word));

    foreach ($self->split_by_letter($word)) {
      $self->{histogram}->{$_} ||= 0;
      $self->{histogram}->{$_} += 1;
    }
  }

  foreach (sort keys %{$self->{histogram}}) {
    print "$_: $self->{histogram}->{$_}\n";
  }
}

sub split_by_letter {
  my ($self, $word) = @_;
  split //ms, $word;
}

##
# Score each candidate by the total of occurrences of each letter.
sub score_candidates {
  my $self = shift;

  foreach my $candidate (sort keys %{$self->{candidates}}) {
    foreach ($self->split_by_letter($candidate)) {
      $self->{candidates}->{$candidate} += $self->{histogram}->{$_};
    }
  }
}

sub rank_guesses {
  my $self = shift;

  my @sorted_candidates = sort { $self->{candidates}->{$b} <=> $self->{candidates}->{$a} } keys %{$self->{candidates}};

  print "Ranking:\n";
  for (0 .. RANKINGS_TO_SHOW) {
    my $candidate = $sorted_candidates[$_];
    last unless defined $candidate;
    print "$candidate: $self->{candidates}->{$candidate}\n";
  }

  @sorted_candidates;
}

##
# Creates a list of best guesses using candidates with the highest score,
# skipping words which share a letter with previous best guesses.
sub make_best_guesses {
  my ($self, @sorted_candidates) = @_;

  print "Best Guesses:\n";

  my $guess_num = 1;
  while (@sorted_candidates) {
    my $next_guess = shift @sorted_candidates;
    last unless defined $next_guess;
    print "$guess_num. $next_guess: $self->{candidates}->{$next_guess}\n";

    @sorted_candidates = grep { $self->has_no_matching_characters($next_guess, $_) } @sorted_candidates;
    $guess_num++;
  }
}

sub has_no_matching_characters {
  my ($self, $a, $b) = @_;
  foreach ($self->split_by_letter($b)) {
    return 0 if index($a, $_) != -1;
  }
  1;
}

bestGuess->new->main() unless caller;

1;
