#!/usr/bin/perl
# Imports the md5_hex function from the Digest::MD5 module
use Digest::MD5 qw(md5_hex);

# This script takes two filepaths as input, calculates checksums, then compares
# to make sure they are the same file

sub enter_filepath {
  # 'my' creates variables that are only accessible within the current scope, 
  # e.g. this function; 'STDIN' is standard input stream
  my $filepath = <STDIN>;

  # Remove the newline character from STDIN, which includes it by default
  chomp($filepath);

  # Verify filepath that was entered
  print "You have entered: $filepath\n";

  return $filepath;
}

print "Enter the filepath of the first file: ";
$filepath1 = enter_filepath();

print "Enter the filepath of the second file: ";
$filepath2 = enter_filepath();

sub calculate_checksum {
  # Pass filepath to this function; '@_' is a special array within the subroutine
  # that holds all arguments passed to it
  my ($fp) = @_;

  # Open file for reading; create variable 'fh' (file handle) which represents
  # a connection from the script to the file; '<' represents the flow of data;
  # 'die' ends script execution in the case that the file couldn't be opened;
  # '$!' contains the system-specific error message returned by the OS,
  # e.g. "No such file", "Permission denied"
  open(my $fh, '<', $fp) or die "Could not open '$fp': $!";

  # Convert fh to binary, which ensures the checksum is calculated correctly  
  binmode($fh);

  # Declare md5 variable, create new Digest::MD5 object
  my $md5 = Digest::MD5->new;
  # Read entire contents of file and calculate MD5 checksum thereof
  $md5->addfile($fh);
  close($fh);
  # Return checksum in HEX format to be captured by below variables, which will
  # be compared to each other in the next function
  return $md5->hexdigest;
}

print "Calculating and capturing checksum1...\n";
$checksum1 = calculate_checksum($filepath1);

print "Calculating and capturing checksum2...\n";
$checksum2 = calculate_checksum($filepath2);

# Define function that will compare the two checksums
sub compare_checksums {
  my ($chksm1, $chksm2) = @_;  

  print "Comparing checksums...\n";
  print "$chksm1\n";
  print "$chksm2\n";

  if ($chksm1 eq $chksm2) {
    print "This is the same file.\n";
  } else {
    print "This is NOT the same file.\n";
  }
}

# Call final function
compare_checksums($checksum1, $checksum2);
