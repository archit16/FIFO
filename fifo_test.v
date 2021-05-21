`timescale 1ns / 1ps
`include "fifo_1.v"
module fifo_test;

localparam dwidth = 5;
localparam awidth = 8;
localparam depth = 2**awidth;

reg [dwidth-1:0]data_in;
reg clk, rst, rd_en, wr_en;

wire [dwidth-1:0]data_out;
wire full, empty;

fifo #(.dwidth(dwidth), .awidth(awidth))
dut (
    .data_in(data_in), 
    .clk(clk), 
    .rst(rst), 
    .rd_en(rd_en), 
    .wr_en(wr_en), 
    .data_out(data_out), 
    .full(full), 
    .empty(empty));
initial
begin
    $dumpfile("fifo_waveform.vcd");
    $dumpvars; 
//   $monitorb("%d", $time,,clk,,rst,,wr,,rd,,data_in,,full,,empty,,data_out);
  clk = 0; wr_en = 0; rd_en = 0; rst = 0; data_in = -1;
  @(negedge clk) rst=1;
  @(negedge clk) rst=0;
  @(negedge clk) wr_en=1;
  @(negedge clk)
  begin
    wr_en=0;
    rd_en=1;
  end 
  @(negedge clk)
  begin
    rd_en=0;
    wr_en=1;
  end
  repeat (depth+1) @(negedge clk) data_in = data_in-1;
  @(negedge clk) begin
    wr_en = 0;
    rd_en = 1;
  end
  repeat (depth+1) @(negedge clk);
  $finish;
end
always #10 clk = ~clk;

endmodule