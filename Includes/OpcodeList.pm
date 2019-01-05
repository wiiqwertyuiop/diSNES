our @opcodes = (

	## 0x00-0F
	'BRK', 'ORA', 'COP', 'ORA', 'TSB', 'ORA', 'ASL', 'ORA',
	'PHP', 'ORA', 'ASL A', 'PHD', 'TSB', 'ORA', 'ASL', 'ORA',
	
	## 0x10-1F
	'BPL', 'ORA', 'ORA', 'ORA', 'TRB', 'ORA', 'ASL', 'ORA',
	'CLC', 'ORA', 'INC A', 'TCS', 'TRB', 'ORA', 'ASL', 'ORA',

	## 0x20-2F
	'JSR', 'AND', 'JSL', 'AND', 'BIT', 'AND', 'ROL', 'AND',
	'PLP', 'AND', 'ROL A', 'PLD', 'BIT', 'AND', 'ROL', 'AND',

	## 0x30-3F
	'BMI', 'AND', 'AND', 'AND', 'BIT', 'AND', 'ROL', 'AND',
	'SEC', 'AND', 'DEC A', 'TSC', 'BIT', 'AND', 'ROL', 'AND',

	## 0x40-4F
	'RTI', 'EOR', 'WDM', 'EOR', 'MVP', 'EOR', 'LSR', 'EOR',
	'PHA', 'EOR', 'LSR A', 'PHK', 'JMP', 'EOR', 'LSR', 'EOR',

	## 0x50-5F
	'BVC', 'EOR', 'EOR', 'EOR', 'MVN', 'EOR', 'LSR', 'EOR',
	'CLI', 'EOR', 'PHY', 'TCD', 'JML', 'EOR', 'LSR', 'EOR',

	## 0x60-6F
	'RTS', 'ADC', 'PER', 'ADC', 'STZ', 'ADC', 'ROR', 'ADC',
	'PLA', 'ADC', 'ROR A', 'RTL', 'JMP', 'ADC', 'ROR', 'ADC',

	## 0x70-7F
	'BVS', 'ADC', 'ADC', 'ADC', 'STZ', 'ADC', 'ROR', 'ADC',
	'SEI', 'ADC', 'PLY', 'TDC', 'JMP', 'ADC', 'ROR' ,'ADC',

	## 0x80-8F
	'BRA', 'STA', 'BRL', 'STA', 'STY', 'STA', 'STX', 'STA',
	'DEY', 'BIT', 'TXA', 'PHB', 'STY', 'STA', 'STX', 'STA',

	## 0x90-9F
	'BCC', 'STA', 'STA', 'STA', 'STY', 'STA', 'STX', 'STA',
	'TYA', 'STA', 'TXS', 'TXY', 'STZ', 'STA', 'STZ', 'STA',
	
	## 0xA0-AF
	'LDY', 'LDA', 'LDX', 'LDA', 'LDY', 'LDA', 'LDX', 'LDA',
	'TAY', 'LDA', 'TAX', 'PLB', 'LDY', 'LDA', 'LDX', 'LDA',

	## 0xB0-BF
	'BCS', 'LDA', 'LDA', 'LDA', 'LDY', 'LDA', 'LDX', 'LDA',
	'CLV', 'LDA', 'TSX', 'TYX', 'LDY', 'LDA', 'LDX', 'LDA',

	## 0xC0-CF
	'CPY', 'CMP', 'REP', 'CMP', 'CPY', 'CMP', 'DEC', 'CMP',
	'INY', 'CMP', 'DEX', 'WAI', 'CPY', 'CMP', 'DEC', 'CMP',

	## 0xD0-DF
	'BNE', 'CMP', 'CMP', 'CMP', 'PEI', 'CMP', 'DEC', 'CMP',
	'CLD', 'CMP', 'PHX', 'STP', 'JML', 'CMP', 'DEC', 'CMP',

	## 0xE0-EF
	'CPX', 'SBC', 'SEP', 'SBC', 'CPX', 'SBC', 'INC', 'SBC',
	'INX', 'SBC', 'NOP', 'XBA', 'CPX', 'SBC', 'INC', 'SBC',

	## 0xF0-FF
	'BEQ', 'SBC', 'SBC', 'SBC', 'PEA', 'SBC', 'INC', 'SBC',
	'SED', 'SBC', 'PLX', 'XCE', 'JSR', 'SBC', 'INC', 'SBC'
	
	);

our @addrm = (

  ## 0x00-0F
	'#$xx', '($xx,x)', '#$xx', '$xx,s', '$xx', '$xx', '$xx', '[$xx]',
	 '', '#$yyxx', '', '', '$yyxx', '$yyxx', '$yyxx', '$zzyyxx',

	## 0x10-1F
	'$xx', '($xx),y', '($xx)', '($xx,s),y', '$xx', '$xx,x', '$xx,x', '[$xx],y',
	'', '$yyxx,y', '', '', '$yyxx', '$yyxx,x', '$yyxx,x', '$zzyyxx,x',

	##0x20-2F
	'$yyxx', '($xx,x)', '$zzyyxx', '$xx,s', '$xx', '$xx', '$xx', '[$xx]',
	'', '#$yyxx', '', '', '$yyxx', '$yyxx', '$yyxx', '$zzyyxx',

	## 0x30-3F
	'$xx', '($xx),y', '($xx)', '($xx,s),y', '$xx,x', '$xx,x', '$xx,x', '[$xx],y',
	'', '$yyxx,y', '', '', '$yyxx,x', '$yyxx,x', '$yyxx,x', '$zzyyxx,x',

	## 0x40-4F
	'', '($xx,x)', '#$xx', '$xx,s', '$xx, $yy', '$xx', '$xx', '[$xx]',
	'', '#$yyxx', '', '', '$yyxx', '$yyxx', '$yyxx', '$zzyyxx',

	## 0x50-5F
	'$xx', '($xx),y', '($xx)', '($xx,s),y', '$xx, $yy', '$xx,x', '$xx,x', '[$xx],y',
	'', '$yyxx,y', '', '', '$zzyyxx', '$yyxx,x', '$yyxx,x', '$zzyyxx,x',

	## 0x60-6F
	'', '($xx,x)', '$yyxx', '$xx,s', '$xx', '$xx', '$xx', '[$xx]',
	'', '#$yyxx', '', '', '($yyxx)', '$yyxx', '$yyxx', '$zzyyxx',

	## 0x70-7F
	'$xx', '($xx),y', '($xx)', '($xx,s),y', '$xx,x', '$xx,x', '$xx,x', '[$xx],y',
	'', '$yyxx,y', '', '', '($yyxx,x)', '$yyxx,x', '$yyxx,x', '$zzyyxx,x',

	## 0x80-8F
	'$xx', '($xx,x)', '$yyxx', '$xx,s', '$xx', '$xx', '$xx', '[$xx]',
	'', '#$yyxx', '', '', '$yyxx', '$yyxx', '$yyxx', '$zzyyxx',

	## 0x90-9F
	'$xx', '($xx),y', '($xx)', '($xx,s),y', '$xx,x', '$xx,x', '$xx,y', '[$xx],y',
	'', '$yyxx,y', '', '', '$yyxx', '$yyxx,x', '$yyxx,x', '$zzyyxx,x',

	## 0xA0-AF
	'#$yyxx', '($xx,x)', '#$yyxx', '$xx,s', '$xx', '$xx', '$xx', '[$xx]',
	'', '#$yyxx', '', '', '$yyxx', '$yyxx', '$yyxx', '$zzyyxx',

	## 0xB0-BF
	'$xx', '($xx),y', '($xx)', '($xx,s),y', '$xx,x', '$xx,x', '$xx,y', '[$xx],y',
	'', '$yyxx,y', '', '', '$yyxx,x', '$yyxx,x', '$yyxx,y', '$zzyyxx,x',

	## 0xC0-CF
	'#$yyxx', '($xx,x)', '#$xx', '$xx,s', '$xx', '$xx', '$xx', '[$xx]',
	'', '#$yyxx', '', '', '$yyxx', '$yyxx', '$yyxx', '$zzyyxx',

	## 0xD0-DF
	'$xx', '($xx),y', '($xx)', '($xx,s),y', '($xx)', '$xx,x', '$xx,x', '[$xx],y',
	'', '$yyxx,y', '', '', '[$yyxx]', '$yyxx,x', '$yyxx,x', '$zzyyxx,x',

	## 0xE0-EF
	'#$yyxx', '($xx,x)', '#$xx', '$xx,s', '$xx', '$xx', '$xx', '[$xx]',
	'', '#$yyxx', '', '', '$yyxx', '$yyxx', '$yyxx', '$zzyyxx',

	## 0xF0-FF
	'$xx', '($xx),y', '($xx)', '($xx,s),y', '$yyxx', '$xx,x', '$xx,x', '[$xx],y',
	'', '$yyxx,y', '', '', '($yyxx,x)', '$yyxx,x', '$yyxx,x', '$zzyyxx,x'

);