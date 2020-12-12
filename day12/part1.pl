#!/usr/bin/perl
use strict;
use warnings;
use 5.030;
no warnings 'experimental';

my @dir = ("E", "S", "W", "N");
my %deg2ind = (90 => 1, 180 => 2, 270 => 3);

sub navigate {
  my ($instruction, %state) = @_; 
  $instruction =~ s/F/@dir[$state{f}]/;
  my ($op, $arg) = split /(?<=.{1})/s, $instruction, 2;
  given($op) {
    when (/N/) { $state{y} += $arg; }
    when (/S/) { $state{y} -= $arg; }
    when (/E/) { $state{x} += $arg; }
    when (/W/) { $state{x} -= $arg; }
    when (/L/) { $state{f} = ($state{f} - $deg2ind{$arg}) % 4; }
    when (/R/) { $state{f} = ($state{f} + $deg2ind{$arg}) % 4; }
  }
  return %state;
}

my %ship = (x => 0, y => 0, f => 0);
while (<>) {
  chomp;
  %ship = navigate $_, %ship;
}

my $part1 = abs($ship{x}) + abs($ship{y});
say "Yet another P...art 1: $part1";
