module playMessage (
input val,
input clk,
input rst,

input KEY2,
input switch17,
input switch16,
input switch15,
input switch14,
input switch13,
input switch12,
input switch11,

output  [6:0]seg7_1,
output  [6:0]seg7_2,
output  [6:0]seg7_3,
output  [6:0]seg7_4
);

// Registers to display message on FPGA on seven-segments
reg [3:0] letter1;
reg [3:0] letter2;
reg [3:0] letter3;
reg [3:0] letter4;

// Display Message FSM
reg[26:0]counter1;
reg[26:0]counter2;
reg[26:0]counter3;

reg [2:0]S;
reg [2:0]NS;

parameter START = 3'b000,
			 MESS1 = 3'b001,
			 WAIT = 3'b010,
			 MESS2 = 3'b011,
			 WAIT2 = 3'b100,
			 MESS3 = 3'b101,
			 WAIT3 = 3'b110,
			 STOP = 3'b111;
		
always @(*)
begin
	case (S)
		START:
		if (KEY2 == 0)
			NS = STOP;
		else if (switch17 || switch16 || switch15 || switch14 || switch13 || switch12 || switch11)
			NS = START;
		else if (val == 1)
			NS = MESS1;
		else
			NS = START;

		MESS1:
		if (KEY2 == 0)
			NS = STOP;
		else if (switch17 || switch16 || switch15 || switch14 || switch13 || switch12 || switch11)
			NS = START;
		else if (val == 0)
			NS = WAIT3;
		else if (counter1 == 100000000)
			NS = WAIT;
		else
			NS = MESS1;
			
		WAIT:
		if (KEY2 == 0)
			NS = STOP;
		else if (switch17 || switch16 || switch15 || switch14 || switch13 || switch12 || switch11)
			NS = START;
		else 
			NS = MESS2;
		
		MESS2:
		if (KEY2 == 0)
			NS = STOP;
		else if (switch17 || switch16 || switch15 || switch14 || switch13 || switch12 || switch11)
			NS = START;
		else if (val == 0)
			NS = WAIT3;
		else if (counter2 == 100000000)
			NS = WAIT2;
		else
			NS = MESS2;
			
		WAIT2: 
		if (KEY2 == 0)
			NS = STOP;
		else if (switch17 || switch16 || switch15 || switch14 || switch13 || switch12 || switch11)
			NS = START;
		else
			NS = MESS3;
			
		MESS3:
		if (KEY2 == 0)
			NS = STOP;
		else if (switch17 || switch16 || switch15 || switch14 || switch13 || switch12 || switch11)
			NS = START;
		else if (val == 0 || counter3 == 100000000)
			NS = WAIT3;
		else
			NS = MESS3;	
			
		WAIT3:
		if (KEY2 == 0)
			NS = STOP;
		else if (switch17 || switch16 || switch15 || switch14 || switch13 || switch12 || switch11)
			NS = START;
		else 
			NS = START;
			
		STOP:
		if (switch17 || switch16 || switch15 || switch14 || switch13 || switch12 || switch11)
			NS = START;
		else
			NS = STOP;
			
		default NS = START;
	endcase
end

always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		counter1 <= 27'd0;
		counter2 <= 27'd0;
		counter3 <= 27'd0;
	end
	else
		case (S)
			START:
			begin
				counter1 <= 27'd0;
				counter2 <= 27'd0;
				counter3 <= 27'd0;
				letter1 <= 4'd8;
				letter2 <= 4'd8;
				letter3 <= 4'd8;
				letter4 <= 4'd8;
			end
			
			MESS1: 
			begin
				counter1 <= counter1 + 27'd1;
				letter1 <= 4'd0;
				letter2 <= 4'd1;
				letter3 <= 4'd2;
				letter4 <= 4'd3;
			end
			
			MESS2: 
			begin
				counter1 <= 27'd0;
				counter2 <= counter2 + 27'd1;
				letter1 <= 4'd2;
				letter2 <= 4'd8;
				letter3 <= 4'd8;
				letter4 <= 4'd8;
			end

			MESS3: 
			begin
				counter2 <= 27'd0;
				counter3 <= counter3 + 27'd1;
				letter1 <= 4'd4;
				letter2 <= 4'd5;
				letter3 <= 4'd6;
				letter4 <= 4'd7;
			end
			
			STOP:
			begin
				counter1 <= 27'd0;
				counter2 <= 27'd0;
				counter3 <= 27'd0;
				letter1 <= 4'd8;
				letter2 <= 4'd8;
				letter3 <= 4'd8;
				letter4 <= 4'd8;
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
sevenSeg letter11(letter1, seg7_1);
sevenSeg letter12(letter2, seg7_2);
sevenSeg letter13(letter3, seg7_3);
sevenSeg letter14(letter4, seg7_4);
	
endmodule
