#!/usr/bin/perl
use DBI;
use strict;
use warnings;
my $wordID;
my $word1;
my $remaining_guesses1;
my $correct1;
my $incorrect1;
my $guessed_letters1;
my $right_letters1;
my $wrong_letters1;
my $remaining_letters1;
my $guessed_word1;
my $dsn = "DBI:SQLite:hangman.sqlite";
my %attr = (PrintError=>0, RaiseError=>1);
# connect to the database
my $dbh = DBI->connect($dsn, \%attr);


$dbh->do('PRAGMA foreign_keys = ON');
$dbh->do('PRAGMA foreign_keys');
my @ddl = (
    'CREATE TABLE CURRENTWORD (
        id INTEGER UNIQUE NOT NULL,
        WORD TEXT,
        REMAINING_GUESSES INTEGER,
        CORRECT INTEGER,
        INCORRECT INTEGER,
        GUESSED_LETTERS TEXT,
        RIGHT_LETTERS TEXT,
        WRONG_LETTERS TEXT,
        REMAINING_LETTERS TEXT,
        GUESSED_WORD TEXT,
        ACTIVE TEXT,
        PRIMARY KEY(id)
    )',
    
);
for my $sql (@ddl) {
    $dbh->do($sql);
}

my $filename = 'words.txt';
# connect to and open the json file
my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $filename)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my @words = split ", ", $json_text;

foreach my $xr (@words) {
  my $length = length $xr;

  my @array = split //, $xr;

  my @array2 = ();
  foreach my $x (@array) {
    push @array2, "_"
  };


  my $str = join ' ', @array2;
  my $query = "insert into CURRENTWORD (WORD, REMAINING_GUESSES, CORRECT, INCORRECT, GUESSED_LETTERS, RIGHT_LETTERS, WRONG_LETTERS, REMAINING_LETTERS, GUESSED_WORD, ACTIVE)
    values (?,?,?,?,?,?,?,?,?,?) ";
   my $statement = $dbh->prepare($query);
   $statement->execute($xr, 10, 0, 0, "", "", "", "abcdefghijklmnopqrstuvwxyz", $str, "no");
};

