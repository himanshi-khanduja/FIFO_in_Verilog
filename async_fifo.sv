module Async_fifo (
  input rst,
  input wr_en,
  input rd_en,
  input clk_w,clk_r,
  input [7:0] data_in,
  output reg[7:0] data_out,
  output reg [7:0] fifo_counter,
  output wire buf_empty,
  output wire buf_full);
   
  
  reg [7:0] rd_ptr,wr_ptr; 
  reg [7:0] buf_mem [63:0];
  
  assign buf_empty = (fifo_counter==0);
  assign buf_full = (fifo_counter==1);
  
  always@(posedge clk_w or negedge rst) begin
    if(rst)
      fifo_counter<=0;
    else if(!buf_full && wr_en && !rd_en)
      fifo_counter= fifo_counter+1;
  end
  
  always@(posedge clk_r or negedge rst)begin
    if(rst)
      fifo_counter<=0;
  else if(!buf_empty && rd_en && !wr_en)
    fifo_counter= fifo_counter-1;
  end
  //output
  always @(posedge clk_w or negedge rst) begin
    if(rst)
      data_out<=0;
    else if(rd_en && !buf_empty && !wr_en)
           data_out<= buf_mem[rd_ptr];
  end
  // write 
  
  always @(posedge clk_w) begin
    if(wr_en && !buf_full && !rd_en)
      buf_mem[wr_ptr]<= data_in;
  end
  
  // pointer 
  
  always@(posedge clk_w or negedge rst)begin
    if(rst)
       wr_ptr <=0;
     else if(wr_en && !buf_full && !rd_en)
       wr_ptr <= wr_ptr+1;
   end    
  
   always@(posedge clk_r or negedge rst)begin
    if(rst)
       rd_ptr <=0;
     else if(!wr_en && !buf_empty && rd_en)
       rd_ptr <= rd_ptr+1;
   end    
endmodule
