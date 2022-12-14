// Music demo verilog file
// (c) fpga4fun.com 2003-2015

/* This entire module comes from fpga4fun.com.
Excerpt from the fpga4fun.com that explains 
the functionality of this module: 

The "divide by 12" module takes a variable 6 bits value (numerator)
and divides it by the fixed value 12 (denominator). 

That gives us a 3 bits quotient (0..5) 
and a 4 bits remainder (0..11). 

To divide by 12, it is easier to divide by 4 first, then by 3.
 
Dividing by 4 is trivial: we remove 2 bits out of the numerator, 
and copy it to the remainder. 

So we are left with 6-2=4 bits to divide by the value "3", 
which we do with a lookup table. */

module divide_by12(
	input [5:0] numerator,  // value to be divided by 12
	output reg [2:0] quotient, 
	output [3:0] remainder
);

reg [1:0] remainder3to2;

always @(numerator[5:2])
begin
	case(numerator[5:2])
	 0: begin quotient=0; remainder3to2=0; end
	 1: begin quotient=0; remainder3to2=1; end
	 2: begin quotient=0; remainder3to2=2; end
	 3: begin quotient=1; remainder3to2=0; end
	 4: begin quotient=1; remainder3to2=1; end
	 5: begin quotient=1; remainder3to2=2; end
	 6: begin quotient=2; remainder3to2=0; end
	 7: begin quotient=2; remainder3to2=1; end
	 8: begin quotient=2; remainder3to2=2; end
	 9: begin quotient=3; remainder3to2=0; end
	10: begin quotient=3; remainder3to2=1; end
	11: begin quotient=3; remainder3to2=2; end
	12: begin quotient=4; remainder3to2=0; end
	13: begin quotient=4; remainder3to2=1; end
	14: begin quotient=4; remainder3to2=2; end
	15: begin quotient=5; remainder3to2=0; end
	endcase
end
assign remainder[1:0] = numerator[1:0];  // the first 2 bits are copied through
assign remainder[3:2] = remainder3to2;  // and the last 2 bits come from the case statement
endmodule