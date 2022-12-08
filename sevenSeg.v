module sevenSeg (
input [3:0]i,
output reg [6:0]o
);


// HEX out - rewire DE2
//  ---a---
// |       |
// f       b
// |       |
//  ---g---
// |       |
// e       c
// |       |
//  ---d---

always @(*)
begin
	case (i)	    // abcdefg
      4'd0: 	o = 7'b0011000; //P
		4'd1: 	o = 7'b1110001; //L
		4'd2: 	o = 7'b0001000; //A
		4'd3: 	o = 7'b1000100; //y
		4'd4: 	o = 7'b1101010; //n
		4'd5: 	o = 7'b0000001; //O
		4'd6: 	o = 7'b1110000; //t
		4'd7: 	o = 7'b0110000; //E
		4'd8:		o = 7'b1111111; //nothing
		4'd9:		o = 7'b1000010; //D
		default:	o = 7'b0000001;
	endcase
end

endmodule
