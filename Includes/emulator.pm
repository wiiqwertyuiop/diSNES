#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#;; This is the basic emulaotr that allows
#;; this program to step through code
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#;; Defines:

our $XYbit = 1;  # If non-zero X and Y are 16-bit
our $Abit = 1;   # If non-zero A is 16-bit
our @stack;
our @pros;
our @PHP;
our @PHL;
our $CB = 0;  # Current bank we are in
our $P = 52;

#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#;; Each opcode's code
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sub PHP {

  push (@PHP, $Abit);
  push (@PHP, $XYbit); 
    
}

sub PLP {

  $XYbit = $PHP[$#PHP];
  pop (@PHP);
  $Abit = $PHP[$#PHP];
  pop (@PHP);
}

sub BRK {

  print "Warning: BRK hit at 0x$pos .\nContinue? (y or n):\n";
  chop(my $temp = <STDIN>);
  if ($temp ne "y") {
    $pos = $#data+1;
  } else {
      $pos = $stack[$#stack+1];
      pop(@stack);
      $XYbit = pop (@pros);
      $Abit = pop (@pros);
  }
}

sub STP {

  print "Warning: STP hit at 0x$pos .\nContinue? (y or n):\n";
  chop(my $temp = <STDIN>);
  if ($temp ne "y") {
    $pos = $#data+1;
  } else {
      $pos = $stack[$#stack+1];
      pop(@stack);
  }
}

sub COP {

  print "Warning: COP hit at 0x$pos .\nContinue? (y or n):\n";
  chop(my $temp = <STDIN>);
  if ($temp ne "y") {
    $pos = $#data+1;
  } else {
      $pos = $stack[$#stack+1];
      pop(@stack);
  }
}

sub JSR {
  
   
  my $temp = SNEStoPC("$CB$data[$pos+2]$data[$pos+1]");
  
  if (!$output[$temp]) {
   push(@stack, $pos+3);
   $pos = $temp;
  } else {
   #pop(@stack);
   if ($data[$pos] eq "4C") {
     &RTS;
   }
  }
}

sub JSL {

  my $temp = SNEStoPC("$data[$pos+3]$data[$pos+2]$data[$pos+1]");
  
  if (!$output[$temp]) {
   push(@stack, $pos+4);
   $CB = $data[$pos+3];
   $pos = $temp;
  } else {
   if ($data[$pos] eq "5C") {
     &RTL;
   }
  }
}

sub RTS {
 
 $pos = $stack[$#stack];
 pop(@stack);

  if ($stack[$#stack]) {

     if ($stack[$#stack] eq "FLAG2") {
        push(@PHP, $PHL[$#PHL]);
        pop(@PHL);
        push(@PHP, $PHL[$#PHL]);
        pop(@PHL);
        
     }
     
    if ($stack[$#stack] eq "FLAG" || $stack[$#stack] eq "FLAG2") {
      $XYbit = $pros[$#pros];
      pop (@pros);
      $Abit = $pros[$#pros];
      pop (@pros);
      pop(@stack);
   }
   

   
 }
}

sub RTL {
  $pos = $stack[$#stack];
  pop(@stack);
}

sub REP {
  my $temp = ($P&hex($data[$pos+1]));
  
  if ($temp != 0) {
    $P = ($P-$temp);
  }
  
  $Abit = ($P&32);
  $XYbit = ($P&16);
}

sub SEP {
  $P = ($P|hex($data[$pos+1]));
  $Abit = ($P&32);
  $XYbit = ($P&16);
}

sub PTR {
  &RTS;
  &RTS;
}

sub PTRL {
  &RTL;
  &RTL;
}


sub BEQ {
  
  my $temp = hex($data[$pos+1]); 
  if ($temp >= 128) {
    $temp = (($pos)-($temp^255)+1);
  } else {
    $temp = ($pos+2)+$temp;
  }
    
  if (!$output[$temp]) {
    push (@pros, $Abit);
    push (@pros, $XYbit);
    
    if ($#PHP > 0) {
      push(@PHL, $PHP[$#PHP-1]);
      push(@PHL, $PHP[$#PHP]);
      push(@stack, "FLAG2");
    } else {
      push(@stack, "FLAG");
    }
    
    push(@stack, $pos+2);
    
    
    $pos = $temp;
  } else {
    if ($#stack > 0) {
     if ( ($pos+2) == $stack[$#stack]) {
        $pos = $stack[$#stack];
        pop(@stack);
        
        if ($stack[$#stack] eq "FLAG" || $stack[$#stack] eq "FLAG2") {
          pop(@stack);
        }
        
        $XYbit = $pros[$#pros];
        pop (@pros);
        $Abit = $pros[$#pros];
        pop (@pros);
      }
    }
  }
  
}

sub BRA {
  
  my $temp = hex($data[$pos+1]); 
  if ($temp >= 128) {
    $temp = (($pos)-($temp^255)+1);
  } else {
    $temp = ($pos+2)+$temp;
  }
    
  if (!$output[$temp]) {
    #push (@pros, $Abit);
    #push (@pros, $XYbit); 
    #push(@stack, $pos+2);
    $pos = $temp;
  } else {
    if ($#stack < 0) {
      $pos = $#data+1;
    } else {
      &RTS;
    }
  }
  
}

sub BRL {
  my $temp = hex("$data[$pos+2]$data[$pos+1]");
  push(@stack, $pos);
  if ($temp >= 32768) {
    $pos = ($pos+2)-(1+($temp^65535));
  } else {
    $pos = ($pos+2)+$temp;
  }
}

#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#;; Jump table
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
our %commands = (
  "00" => \&BRK,
  "02" => \&COP,
  "08" => \&PHP,
  "10" => \&BEQ,
  "20" => \&JSR,
  "22" => \&JSL,
  "28" => \&PLP,
  "30" => \&BEQ,
  "4C" => \&JSR,
  "50" => \&BEQ,
  "5C" => \&JSL,
  "60" => \&RTS,
  "6B" => \&RTS,
  "6C" => \&PTR,
  "70" => \&BEQ,
  "7C" => \&PTR,
  "80" => \&BRA,
  "82" => \&BRL,
  "90" => \&BEQ,
  "B0" => \&BEQ,
  "C2" => \&REP,
  "D0" => \&BEQ,
  "DC" => \&PTRL,
  "DB" => \&STP,
  "E2" => \&SEP,
  "F0" => \&BEQ,
  
);


1;