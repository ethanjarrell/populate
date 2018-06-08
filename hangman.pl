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
print "Welcome to Hangman! \n";
my $dsn = "DBI:SQLite:hangman.sqlite";
my %attr = (PrintError=>0, RaiseError=>1);
# connect to the database
my $dbh = DBI->connect($dsn, \%attr);

my $query2 = "SELECT * FROM CURRENTWORD
ORDER BY REMAINING_GUESSES ASC
LIMIT 1";
my $statement2 = $dbh->prepare($query2);
$statement2->execute();
while (my @data = $statement2->fetchrow_array()) {
  $wordID = $data[0];
   $word1 = $data[1];
   $remaining_guesses1 = $data[2];
   $correct1 = $data[3];
   $incorrect1 = $data[4];
   $guessed_letters1 = $data[5];
   $right_letters1 = $data[6];
   $wrong_letters1 = $data[7];
   $remaining_letters1 = $data[8];
   $guessed_word1 = $data[9];
};
print "word is $word1 \n";
print "You have this many remaining guesses for this word: $remaining_guesses1 \n";
print "number of correct guesses so far: $correct1 \n";
print "number of incorrect guesses so far: $incorrect1 \n";
print "these are the letters you have guessed: $guessed_letters1 \n";
print "these are the letters you have guessed correctly: $right_letters1 \n";
print "these are the letters you have guessed incorrectly: $wrong_letters1 \n";
print "these are the remaining letters: $remaining_letters1 \n";
print "This is your current word: $guessed_word1 \n";
print "Please Pick a Letter: ";
my $letter = <STDIN>;
chomp $letter;
$remaining_guesses1 = $remaining_guesses1 - 1;
my $alphabet = $remaining_letters1;
sub getCorrect {
if (index($word1, $letter) != -1) {
  return 1;
} else {
  return 0;
}
};
my $getCorrect = $correct1 + getCorrect;
sub getIncorrect {
if (index($word1, $letter) != -1) {
  return 0;
} else {
  return 1;
}
};
my $getIncorrect = $incorrect1 + getIncorrect;
sub newGuessedLetters {
  $alphabet =~ s/$letter/_/;
  if ($guessed_letters1 eq ""){
    return $letter;
  } else {
    return $guessed_letters1 . $letter;
  }
}
my $newGuessed = newGuessedLetters;
sub getRightLetters {
  if (getCorrect == 1) {
    if ($right_letters1 eq ""){
      $right_letters1 = $letter;
    }
    else {
    $right_letters1 = $right_letters1 . $letter;
  }
}elsif(getCorrect == 0) {
  if ($wrong_letters1 eq ""){
    $wrong_letters1 = $letter;
  } else {
    $wrong_letters1 = $wrong_letters1 . $letter;
  }
  }
};
getRightLetters;


my @string1;
if($correct1 < 1){
@string1 = split '', $word1;
}elsif($correct1 >= 1){
@string1 = split '', $guessed_word1;
}

my @newString = ();
foreach my $x (@string1) {
  if ($x ne $letter){
    push @newString, "_";
  }else{
    push @newString, $letter;
  }
}
my $scal = join(" ", @newString);
$dbh->do("UPDATE CURRENTWORD SET REMAINING_GUESSES = $remaining_guesses1 WHERE id = $wordID");
$dbh->do("UPDATE CURRENTWORD SET CORRECT = $getCorrect WHERE id = $wordID");
$dbh->do("UPDATE CURRENTWORD SET INCORRECT = $getIncorrect WHERE id = $wordID");
$dbh->do("UPDATE CURRENTWORD SET GUESSED_LETTERS = '$newGuessed' WHERE id = $wordID");
$dbh->do("UPDATE CURRENTWORD SET RIGHT_LETTERS = '$right_letters1' WHERE id = $wordID");
$dbh->do("UPDATE CURRENTWORD SET WRONG_LETTERS = '$wrong_letters1' WHERE id = $wordID");
$dbh->do("UPDATE CURRENTWORD SET REMAINING_LETTERS = '$alphabet' WHERE id = $wordID");
$dbh->do("UPDATE CURRENTWORD SET GUESSED_WORD = '$scal' WHERE id = $wordID");