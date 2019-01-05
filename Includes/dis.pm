#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#;; Dissasembler
#;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

our $last = 0;

sub dis {
  my $a = $pos;
  my $out = $opcodes[hex($data[$a])];
  my $op = $opcodes[hex($data[$a])];
  my $out2 = $addrm[hex($data[$a])];
  my $hex .= $data[$a];
  
  $a++;

  if ($out2) {

    if ($out2 =~ /xx/) {
      if ($data[$a]) {
        if ($table == 1) {
          $output[$a] = "1\n";
        }
        $out2 =~ s/xx/$data[$a]/;
        $hex .= " $data[$a]";
       } else {
        #$out2 =~ s/xx/00/;
        $hex .= " xx";
       }
    }
    
    $a++;
    
    if ($out2 =~ /yy/) {
         if ($data[$a-2] =~ /[EC]0/i && $XYbit != 0 && $out2 =~ /^\#\$/g) {
          $out2 =~ s/yy(..)/$1 /;
         } elsif ($data[$a-2] =~ /A[02]/i && $XYbit != 0 && $out2 =~ /^\#\$/) {
          $out2 =~ s/yy(..)/$1 /;
         } elsif ( ($data[$a-2] !~ /A[02]/i && $data[$a-2] !~ /[EC]0/i) && $Abit != 0 && $out2 =~ /^\#\$/) {
          $out2 =~ s/yy(..)/$1 /;
         } else {
      
           if ($data[$a]) {
            if ($table == 1) {
              $output[$a] = "1\n";
            }
            $out2 =~ s/yy/$data[$a]/;
            $hex .= " $data[$a]";
           } else {
            $out2 =~ s/yy/xx/;
            $hex .= " xx";
           }
           $a++;
        }
    }

    if ($out2 =~ /zz/) {
       if ($data[$a]) {
        if ($table == 1) {
          $output[$a] = "1\n";
        }
        $out2 =~ s/zz/$data[$a]/;
        $hex .= " $data[$a]";
       } else {
        $out2 =~ s/zz/xx/;
        $hex .= " xx";
       }
      $a++;          
    }

    $out = "$out $out2";
  } else {
    $out = "$out        ";  # Fix spacing for single byte opcodes
  }
 
  
  my $temp = $format;
  $temp =~ s/\[opcode\]/$out/g;
  $temp =~ s/\[hex\]/$hex/g;
  my $offset = sprintf("%X", $pos);
  $temp =~ s/\[PCaddr\]/$offset/g;
  my $SNESaddr = &PCtoSNES($pos);
  $temp =~ s/\[SNESaddr\]/$SNESaddr/g;
  
  if ($op eq "RTI" || $op eq "RTL" || $op eq "RTS" || $op eq "JML" || $op eq "JMP" || $op eq "BRA" || $op eq "BRL") {
    $temp = "$temp\n";
  }
  
  $output[$pos] = "$temp\n";
  
  return $a;

}

1;
