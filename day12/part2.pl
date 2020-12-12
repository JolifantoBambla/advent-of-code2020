#!/usr/bin/perl
use strict;
use warnings;
use 5.030;
no warnings 'experimental';

use Math::Trig;

sub rotate {
  my ($deg, $x, $y) = @_;
  my $rad = deg2rad $deg;
  return (
    cos($rad) * $x - sin($rad) * $y,
    sin($rad) * $x + cos($rad) * $y
  ); 
}

sub navigate {
  my ($instruction, %state) = @_;
  my ($op, $arg) = split /(?<=.{1})/s, $instruction, 2;
  given($op) {
    when (/N/) { $state{wy} += $arg; }
    when (/S/) { $state{wy} -= $arg; }
    when (/E/) { $state{wx} += $arg; }
    when (/W/) { $state{wx} -= $arg; }
    when (/L/) { ($state{wx}, $state{wy}) = rotate $arg, $state{wx}, $state{wy}; }
    when (/R/) { ($state{wx}, $state{wy}) = rotate -$arg, $state{wx}, $state{wy}; }
    when (/F/) {
      $state{sx} += $state{wx} * $arg;
      $state{sy} += $state{wy} * $arg; 
    }
  }
  return %state;
}

my %ship = (wx => 10, wy => 1, sx => 0, sy => 0);
while (<>) {
  chomp;
  %ship = navigate $_, %ship;
}

my $part2 = abs($ship{sx}) + abs($ship{sy});
say "Yet another P...art 2: $part2";
