// Music demo verilog file
// (c) fpga4fun.com 2003-2015

/* This part of the code comes from fpga4fun.com.
   CODE BEGINS HERE!                              */

module music(
input start,
input clk,
input rst,
input KEY2,

output reg speakerH,
output reg LEDG4,

output  [6:0]seg7_5,
output  [6:0]seg7_6,
output  [6:0]seg7_7,
output  [6:0]seg7_8
);

// Registers to display message on FPGA on seven-segments
reg [3:0] letter1;
reg [3:0] letter2;
reg [3:0] letter3;
reg [3:0] letter4;

// It's Counting Time! Again!
reg [31:0] tone;
reg [31:0] counter;
reg [26:0] countDONE;
reg [26:0] countNOTE;

/* This part of the code comes from fpga4fun.com.
   CODE BEGINS HERE!                              */
reg [8:0] counter_note;
reg [7:0] counter_octave;

wire [2:0] octave;
wire [3:0] note;
wire [7:0] fullnote;

musicROM get_fullnote(.clk(clk), .address(tone[29:22]), .note(fullnote));
divide_by12 get_octave_and_note(.numerator(fullnote[5:0]), .quotient(octave), .remainder(note));

reg [8:0] clkdivider;
always @(*)
begin
	case(note)
	 0: clkdivider = 9'd511;//A
	 1: clkdivider = 9'd482;// A#/Bb
	 2: clkdivider = 9'd455;//B
	 3: clkdivider = 9'd430;//C
	 4: clkdivider = 9'd405;// C#/Db
	 5: clkdivider = 9'd383;//D
	 6: clkdivider = 9'd361;// D#/Eb
	 7: clkdivider = 9'd341;//E
	 8: clkdivider = 9'd322;//F
	 9: clkdivider = 9'd303;// F#/Gb
	10: clkdivider = 9'd286;//G
	11: clkdivider = 9'd270;// G#/Ab
	default: clkdivider = 9'd0;
	endcase
end
/* fpga4fun.com CODE ENDS HERE!                    */

reg [3:0]S;
reg [3:0]NS;

parameter START = 4'b0000,
			 WAIT = 4'b0001,
			 SHOW = 4'b0010,
			 WAIT4 = 4'b0011,
			 DONE = 4'b0111,
			 WAIT3 = 4'b0110;
		
always @(*)
begin
	case (S)
		START:
		if (KEY2 == 0 && start == 1)
			NS = WAIT;
		else
			NS = START;
			
		WAIT: 
		if (start == 0)
			NS = START;
		else if (KEY2 == 0)
			NS = WAIT;
		else
			NS = SHOW;

		SHOW:
		if (start == 0)
			NS = START;
		else if (KEY2 == 0)
			NS = WAIT;
		else if (countNOTE == 150000000)
			NS = WAIT;
		else if (fullnote == 0)
			NS = WAIT4;
		else
			NS = SHOW;
			
		WAIT4:
		if (start == 0)
			NS = START;
		else if (KEY2 == 0)
			NS = WAIT;	
		else
			NS = DONE;
		
		DONE:
		if (start == 0)
			NS = START;
		else if (KEY2 == 0)
			NS = WAIT;
		else if (countDONE == 50000000)
			NS = WAIT3;
		else
			NS = DONE;

		WAIT3:
		if (start == 0)
			NS = START;
		else if (KEY2 == 0)
			NS = WAIT;
		else
			NS = START;
			
		default NS = START;
	endcase
end

always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		countDONE <= 27'd0;
		LEDG4 <= 0;
		countNOTE <= 27'd0;
	end
	else
		case (S)
			START:
			begin
				LEDG4 <= 0;
				letter1 <= 4'd8;
				letter2 <= 4'd8;
				letter3 <= 4'd8;
				letter4 <= 4'd8;
			end
			
			WAIT: tone[29:22] <= 8'd0;
			
			SHOW: 
			begin
				letter1 <= 4'd0;
				letter2 <= 4'd1;
				letter3 <= 4'd2;
				letter4 <= 4'd3;
				
				if (countNOTE == 150000000) countNOTE <= 27'd0;
				
				/* This part of the code comes from fpga4fun.com.
					CODE BEGINS HERE!                             */
				tone <= tone + 31'd1;
				counter_note <= counter_note == 0 ? clkdivider : counter_note - 9'd1;
	
				if(counter_note == 0) counter_octave <= counter_octave== 0 ? 8'd255 >> octave : counter_octave - 8'd1;
				if(counter_note == 0 && counter_octave == 0 && fullnote != 0 && tone[21:18]!= 0) speakerH <= ~speakerH;
				/* fpga4fun.com CODE ENDS HERE!                    */
				
				countNOTE <= countNOTE + 27'd1;
			end
			
			DONE: 
			begin
				LEDG4 <= 1;
				letter1 <= 4'd9;
				letter2 <= 4'd5;
				letter3 <= 4'd4;
				letter4 <= 4'd7;
				countDONE <= countDONE + 27'd1;
			end			
		endcase
end

/* FSM init and NS always */
always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		S <= START;
	end
	else
	begin
		S <= NS;
	end
end

// Instantiating modules to show default message
sevenSeg letterZ(letter1, seg7_5);
sevenSeg letterY(letter2, seg7_6);
sevenSeg letterX(letter3, seg7_7);
sevenSeg letterW(letter4, seg7_8);

endmodule




