module piano (
input start,
input clk,
input rst,

input switch17,
input switch16,
input switch15,
input switch14,
input switch13,
input switch12,
input switch11,

input KEY2,

output LEDR17,
output LEDR16,
output LEDR15,
output LEDR14,
output LEDR13,
output LEDR12,
output LEDR11,
output LEDG4,

output speakerA,
output speakerB,
output speakerC,
output speakerD,
output speakerE,
output speakerF,
output speakerG,
output speakerH,

output  [6:0]seg7_1,
output  [6:0]seg7_2,
output  [6:0]seg7_3,
output  [6:0]seg7_4,

output  [6:0]seg7_5,
output  [6:0]seg7_6,
output  [6:0]seg7_7,
output  [6:0]seg7_8
);

// Connecting the LEDs the switches
wire lightA;
assign lightA = LEDR17;

wire lightB;
assign lightB = LEDR16;

wire lightC;
assign lightC = LEDR15;

wire lightD;
assign lightD = LEDR14;

wire lightE;
assign lightE = LEDR13;

wire lightF;
assign lightF = LEDR12;

wire lightG;
assign lightG = LEDR11;


// Instantiation for Default Message
playMessage play(start, clk, rst, KEY2, switch17, switch16, switch15, switch14, switch13, switch12, switch11, seg7_1, seg7_2, seg7_3, seg7_4);

// Instantiation to make the Switches turn on the Lights
lightUp lights(switch17, switch16, switch15, switch14, switch13, switch12, switch11, LEDR17, LEDR16, LEDR15, LEDR14, LEDR13, LEDR12, LEDR11);

// Instantiations to produce sound for each note
soundA noteA(clk, rst, lightA, speakerA);
soundB noteB(clk, rst, lightB, speakerB);
soundC noteC(clk, rst, lightC, speakerC);
soundD noteD(clk, rst, lightD, speakerD);
soundE noteE(clk, rst, lightE, speakerE);
soundF noteF(clk, rst, lightF, speakerF);
soundG noteG(clk, rst, lightG, speakerG);

// Instantiation to get to Playback Mode and Play the Rudolph Song
music thx(start, clk, rst, KEY2, speakerH, LEDG4, seg7_5, seg7_6, seg7_7, seg7_8); 

endmodule