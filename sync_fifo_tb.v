module tb();
  parameter data_width=32;
  parameter fifo_depth=8;
  reg clk,rst_n,cs,wr_en,rd_en;
  reg [data_width-1:0] data_in;
  wire [data_width-1:0] data_out;
  wire empty,full;
  
  sync_fifo#(data_width,fifo_depth)dut(.clk(clk),.rst_n(rst_n),.cs(cs),.wr_en(wr_en),.rd_en(rd_en),.data_in(data_in),.data_out(data_out),.empty(empty),.full(full));
  
  always
    begin
      #5 clk=~clk;//5 15 25 35... on
    end
  initial
    begin
      clk = 0;
  	  #5rst_n = 0;//5
  	  cs = 1;
  	  wr_en = 0;
  	  rd_en = 0;
  	  data_in = 0;
      #5 rst_n=1;//10....
      #2 wr_en=1;rd_en=0;//12.....
      data_in=32'd100;
      #10//22
      data_in=32'd200;
      #10 
      data_in=32'd300;
      #10 wr_en=0;rd_en=1;//32
      #10$display("data %d",data_out);
      #10$display("data %d",data_out);
      #10$display("data %d",data_out);
      #10$finish;
    end
endmodule

