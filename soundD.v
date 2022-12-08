module soundD (
input clk,
input rst,
input lightD,
output reg speakerD
);


reg [31:0] counter;
reg [3:0] keepON;

// FSM to Regulate Sound with Switch
reg [1:0]S;
reg [1:0]NS;

parameter START = 2'b00,
			 PLAY = 2'b01,
			 WAIT = 2'b10,
			 WAIT2 = 2'b11;

reg [31:0] clkdivider;
			 
always @(*)
begin
	case (S)
		START:
		if (lightD == 1)
			NS = WAIT2;
		else
			NS = START;
			
		WAIT2: 
		if (keepON == 2)
			NS = WAIT2;
		else
			NS = PLAY;
		
		PLAY:
		if (lightD == 0)
			NS = WAIT;
		else
			NS = PLAY;
			
		WAIT: 
		if (keepON == 2)
			NS = START;
		else
			NS = WAIT;
		
		default NS = START;
	endcase
end

always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		counter <= 32'd0;
		keepON <= 0;
	end
	else
		case (S)
			START:
			begin
				keepON <= 4'd0;
				speakerD <= 0;
				clkdivider <= 50000000/146.83/2;
			end
			
			WAIT2: keepON <= keepON + 4'd1;
			
			PLAY: 
			begin
				keepON <= 4'd0;
				
				if (counter == 0)
				begin
					counter <= clkdivider - 1;
					speakerD <= ~speakerD;
				end
				else
					counter <= counter - 32'd1;
			end
			
			WAIT: keepON <= keepON + 4'd1;
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
	
endmodule
