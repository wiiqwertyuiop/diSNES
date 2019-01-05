#use strict;
use warnings;
use diagnostics;
use Tie::File;
    
if ($#ARGV < 0) {
  print "
                  diSNES
                    by
               wiiqwertyuiop      
                       
         A 65816 SNES Disassembler
            
  Usage: diSNES.pl <input> <output> <options>
               
  Options:
  -t                Dissasemble tables at end.
  -s <addr>         Starting (hex PC) address.
  -e <addr>         Ending (hex PC) address.
  -n                Add another line break after return/jump opcodes 
                    (RTL, RTS, JML, etc.)
  -d                Delete file before writing.\n\n";

  exit(1);
}


our @data;
my $null;

our $newline = 0;
our $orpos;
our $pos;
my $end;
our $table = 0;
my $a = 2;

while ($a < $#ARGV+1) {   # Read options

  if ($ARGV[$a] eq "-s") {
    $a++;
    $ARGV[$a] =~ s/^0x//;
    
    if ($ARGV[$a] =~ /^[0-9A-F]+$/i) {
      $pos = hex($ARGV[$a]);
    } else {
      print "Error: Invalid address: $ARGV[$a]";
      exit(1);
    }

  } elsif ($ARGV[$a] eq "-e") {
    $a++;
    $ARGV[$a] =~ s/^0x//;
    
    if ($ARGV[$a] =~ /^[0-9A-F]+$/i) {
      $end = hex($ARGV[$a]);
    } else {
      print "Error: Invalid address: $ARGV[$a]";
      exit(1);
    }
    
  } elsif ($ARGV[$a] eq "-n") {
    $newline = 1;
  } elsif ($ARGV[$a] eq "-t") {
    $table = 1;
  } elsif ($ARGV[$a] eq "-d") {
    unlink("$ARGV[1]");
  } else {
    print "Warning: Unknown option \[$ARGV[$a]\], ignoring.\n";
  }
  
  $a++;
}

open FILE, "$ARGV[0]" or die $!;    # open input file
binmode FILE;

my $size = -s "$ARGV[0]";
our @output = ("") x $size; # set up array

print "Reading source file...\n";

my $data;

while ((read FILE, $data, 1) != 0) {  # read file
  my $buf = sprintf("%X", ord($data));
  $buf =~ s/^(.)$/0$1/g;
  push (@data, $buf);
}

close(FILE);  # close the file we are done with it

print "Done.\n";

if (!$pos) {
  $pos = 0;
}

if (!$end) {
  $end = $#data+1;
}

$orpos = $pos;

our $format = &format;

print "Dissasembling...\n";

&mainloop;

print "Done.\n";

#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#;; Subroutines
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

use Includes::OpcodeList;
use Includes::emulator;
use Includes::dis;

#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#;; Main loop
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub mainloop {
     
  my $manymoretimes = 0;
  
  while ($pos != $end && $pos < $end && $pos < $#data+1 && $manymoretimes < 150) {

    my $oldpos = $pos;
    
    if ($output[$pos] ne "") {
      $manymoretimes++;
    } else {
      $manymoretimes = 0;
    }
    
    my $q = &dis;
    if ($commands{$data[$pos]}) {
      $commands{$data[$pos]}->();
    } else {
      #print "Error: Unknown opcode \[$data[$pos]\] at 0x$pos . What is this??\n";
      #exit(1);
    }
    
    if ($oldpos == $pos) {
    
        $pos = $q;
    }
    
  }

  if ($table == 1) {
    my $i = $orpos;
    foreach (@output) {
      if ($output[$i] eq "1\n") {
        $output[$i] = "";
      } elsif ($output[$i] eq "") {
        my $m = 0;
        my $one = 0;
        
        while ($output[$i] eq "") {
        
          if ($m == 0) {
              $output[$i] = "db ";
          }
          
          $output[$i] .= "\$$data[$i]";
          
          $m++;
          
          if ($m == 8) {
            $output[$i] .= "\n";
            $m = 0;
          } elsif ((!$data[$i+1]) || ($output[$i+1] ne "")) {
            $output[$i] .= "\n";
          } else {
            $output[$i] .= ",";
          }
          
          $i++;
          last if (!$data[$i]) || $i >= $end;
          
        }
      }
      
      $i++;
      last if (!$data[$i]) || $i >= $end;
    }
  }
  
  open (MYFILE, ">>$ARGV[1]");
  print MYFILE @output;
  close (MYFILE); 
 
}


#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#;; Get output format
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub format {

  tie my @array, 'Tie::File', "Format.cfg" or die $!;
  my $temp = $array[0];
  untie @array;
  return $temp;

}

#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#;; PC to SNES addr
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub PCtoSNES {
  
  my ($input) = @_;
  
    #my $dec = hex($input);
    my $dec = $input;
    my $addr = sprintf("%d", (((($dec<<1)&8323072)|($dec&32767)|32768)));
    my $daddr = sprintf("%X", $addr); 
    if ($daddr =~ /^....$/) {
      return "00$daddr";
    } elsif ($daddr =~ /^.....$/) {
      return "0$daddr";
    } else {
      return "$daddr";
    }

}

#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#;; SNES to PC addr
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


sub SNEStoPC {

  my ($input) = @_;
  my $dec = hex($input);
  return ((($dec&8323072)>>1|($dec&32767)));

}