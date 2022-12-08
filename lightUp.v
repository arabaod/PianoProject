module lightUp (

input switch17,
input switch16,
input switch15,
input switch14,
input switch13,
input switch12,
input switch11,

output reg LEDR17,
output reg LEDR16,
output reg LEDR15,
output reg LEDR14,
output reg LEDR13,
output reg LEDR12,
output reg LEDR11
);

always @(*)
begin
	if (switch17) 
		LEDR17 = 1;
	else
		LEDR17 = 0;
		
	if (switch16) 
		LEDR16 = 1;
	else
		LEDR16 = 0;
		
	if (switch15) 
		LEDR15 = 1;
	else
		LEDR15 = 0;
		
	if (switch14) 
		LEDR14 = 1;
	else
		LEDR14 = 0;
		
	if (switch13) 
		LEDR13 = 1;
	else
		LEDR13 = 0;
		
	if (switch12) 
		LEDR12 = 1;
	else
		LEDR12 = 0;
		
	if (switch11) 
		LEDR11 = 1;
	else
		LEDR11 = 0;
end

endmodule
