module bidirectional_xor_memory(clk, wr, addr, d, q);
parameter PORTS = 4;
parameter DEPTH = 512;
parameter WIDTH = 64;
parameter LOG2_DEPTH = log2(DEPTH - 1);
input clk;
input [0:PORTS - 1] wr;
input [PORTS * LOG2_DEPTH - 1:0] addr;
input [PORTS * WIDTH - 1:0] d;
output [PORTS * WIDTH - 1:0] q;

reg [0:PORTS - 1] wr_r;
reg [LOG2_DEPTH - 1:0] addr_r [0:PORTS - 1];
reg [WIDTH - 1:0] d_r [0:PORTS - 1];
integer i;
always @(posedge clk) begin
    wr_r <= wr;
    for(i = 0; i < PORTS; i = i + 1) begin
        addr_r[i] = addr[(i + 1) * LOG2_DEPTH - 1 -:LOG2_DEPTH];
        d_r[i] = d[(i + 1) * WIDTH - 1 -:WIDTH];
    end
end

reg [WIDTH - 1:0] d_internal [0:PORTS - 1];
//TODO

`include "common.vh"
endmodule
