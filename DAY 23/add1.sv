`timescale 1ns / 1ps


module add1(
input clk,
input [3:0] a,b,
output reg [4:0] sum
    );
always@(posedge clk) begin
    sum <= a+b;
end
endmodule

