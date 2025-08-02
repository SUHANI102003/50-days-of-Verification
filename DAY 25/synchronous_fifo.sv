`timescale 1ns / 1ps

// Module Name: synchronous_fifo

// Description: 


module synchronous_fifo
# (parameter int DEPTH = 16,
   parameter int DATA_WIDTH = 8,
   parameter int ADDR_WIDTH = $clog2(DEPTH),
   parameter int ALMOST_FULL_THRESH = DEPTH - 2,
   parameter int ALMOST_EMPTY_THRESH = 2)
   
(
    input logic clk_i,
    input logic rst_n,
    input logic wr_en_i,
    input logic rd_en_i,
    input logic [DATA_WIDTH-1:0] wr_data_i,
    output logic [DATA_WIDTH-1:0] rd_data_o,
    output logic full_o,
    output logic empty_o,
    output logic fifo_count_o
    );
    
 // Pointers
 logic [ADDR_WIDTH-1:0] rptr;  //read pointer
 logic [ADDR_WIDTH-1:0] wptr;  // write pointer
 
 // FIFO Memory
 logic [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];
 
 // WRITE POINTER & FULL CONDITION LOGIC
 always_ff @(posedge clk_i , negedge rst_n) begin
    if(!rst_n)
        wptr <= 0;
    else begin
        if(wr_en_i && !full_o) begin
            fifo_mem[wptr] <= wr_data_i;
            wptr <= wptr + 1;            
        end
    end
 end

// READ POINTER & EMPTY CONDITION LOGIC
always_ff @(posedge clk_i , negedge rst_n) begin
    if(!rst_n) begin
        rptr <= 0;
        rd_data_o <= '0;
    end
    else begin
        if(rd_en_i && !empty_o) begin
            rd_data_o <= fifo_mem[rptr];
            rptr <= rptr + 1;            
        end
    end
 end
 
 // FIFO COUNTER LOGIC
 always_ff @(posedge clk_i , negedge rst_n) begin
    if(!rst_n) begin
        fifo_count_o <= 0;
    end
    else begin
        case({(wr_en_i && !full_o), (rd_en_i && !empty_o)})
        2'b10: fifo_count_o <= fifo_count_o + 1; 
        2'b01: fifo_count_o <= fifo_count_o - 1;
        default: fifo_count_o <= fifo_count_o;
        endcase
    end
 end
 
 // STATUS FLAGS
 assign full_o = (fifo_count_o == DEPTH);
 assign empty_o = (fifo_count_o == 0 );
 endmodule
 
interface fifo_if # (parameter DATA_WIDTH = 8);
   logic clk_i;
   logic rst_n;
   logic wr_en_i;
   logic rd_en_i;
   logic [DATA_WIDTH-1:0] wr_data_i;
   logic [DATA_WIDTH-1:0] rd_data_o;
   logic full_o;
   logic empty_o;
       
endinterface
