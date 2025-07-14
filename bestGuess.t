#!/usr/bin/env perl

use warnings;
use strict;

use Test::Class;
use Test::More;
# use Test::MockModule; # unused, but left for reference
use Test::Output;

use lib '.';
use bestGuess;

use base qw(Test::Class);

sub test_uniq : Tests {
  my @actual = bestGuess::uniq qw(h e l l o w o r l d);
  my @expected = qw(h e l o w r d);
  is_deeply \@actual, \@expected;
}

sub test_make_histogram : Tests {
  my $module = new bestGuess;
  $module->make_histogram('hello', 'world');

  is_deeply $module->{candidates}, {
    world => 0,
  };
  is_deeply $module->{histogram}, {
    d => 1,
    e => 1,
    h => 1,
    l => 3,
    o => 2,
    r => 1,
    w => 1,
  };
}

sub test_split_by_letter : Tests {
  my @actual = bestGuess->new->split_by_letter('hello');
  my @expected = qw(h e l l o);
  is_deeply \@actual, \@expected;
}

sub test_score_candidates : Tests {
  my $module = new bestGuess;
  $module->make_histogram('hello', 'world');

  $module->score_candidates();

  is_deeply $module->{candidates}, {
    world => 8, # 1 + 1 + 2 + 1 + 3 + 1
  };
}

sub test_rank_guesses : Tests {
  my $module = new bestGuess;
  $module->{candidates} = {
    two => 2,
    one => 1,
    four => 4,
    three => 3,
  };

  my @actual = $module->rank_guesses();

  is_deeply \@actual, [
    'four',
    'three',
    'two',
    'one',
  ];
}

sub test_make_best_guesses : Tests {
  my $module = new bestGuess;
  $module->{candidates} = {
    aaaa => 3,
    aabb => 2,
    bbbb => 1,
  };
  my @sorted_candidates = qw(aaaa aabb bbbb);

  my $expected = "Best Guesses:\n"
    . "1. aaaa: 3\n"
    . "2. bbbb: 1\n";
  stdout_is { $module->make_best_guesses(@sorted_candidates) } $expected;
}

sub test_has_no_matching_characters_true : Tests {
  my $actual = bestGuess->new->has_no_matching_characters('aaaaa', 'bbbbb');
  is $actual, 1;
}

sub test_has_no_matching_characters_false : Tests {
  my $actual = bestGuess->new->has_no_matching_characters('hello', 'world');
  is $actual, 0;
}

Test::Class->runtests();
