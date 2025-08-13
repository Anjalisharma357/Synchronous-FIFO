
module sync_fifo#(parameter data_width=32,parameter fifo_depth=8)(
input clk,rst_n,
input cs,wr_en,rd_en,
  input [data_width-1:0] data_in,
  output reg[data_width-1:0] data_out,
  output empty,full);
  
  parameter fifo_depth_log=$clog2(fifo_depth);//3
  reg[fifo_depth_log:0] w_ptr,r_ptr;
  reg [data_width-1:0] memory[fifo_depth-1:0];
  wire wrap_around;
  always@(posedge clk)
    begin
      if(!rst_n && cs)
        begin
          w_ptr<=0;
          r_ptr<=0;
          data_out<=0;
        end
    end
  //write operation
  always@(posedge clk)
    begin
      if(cs && wr_en && !full)
        begin
          memory[w_ptr[fifo_depth_log-1:0]]<=data_in;
          w_ptr<=w_ptr+1;
        end
    end
  //read operation
  always@(posedge clk)
    begin
      if(cs && rd_en && !empty)
        begin
          data_out[data_width-1:0]<=memory[r_ptr[fifo_depth_log-1:0]];
          r_ptr<=r_ptr+1;
        end
    end
  
  assign wrap_around=w_ptr[fifo_depth_log] ^ r_ptr[fifo_depth_log];
  assign empty=(w_ptr==r_ptr);
  assign full= (wrap_around) && (w_ptr[fifo_depth_log-1:0]==r_ptr[fifo_depth_log-1:0]);
endmodule
