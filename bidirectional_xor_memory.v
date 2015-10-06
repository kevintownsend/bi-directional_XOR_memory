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
wire [WIDTH - 1:0] q_internal [0:PORTS - 1][0:PORTS - 1];
genvar g0, g1;
generate for(g0 = 0; g0 < PORTS; g0 = g0 + 1)
for(g1 = 0; g1 < PORTS; g1 = g1 + 1)
    simple_dual_port_ram #(WIDTH, DEPTH) g_ram(clk, wr_r[g0], addr_r[g0], d_internal[g0], addr[(g1 + 1) * LOG2_DEPTH - 1 -:LOG2_DEPTH], q_internal[g0][g1]);
endgenerate

reg [WIDTH - 1:0] intermediate_value [0:PORTS - 1];
integer i, j;
always @* begin
    for(i = 0; i < PORTS; i = i + 1) begin
        intermediate_value[i] = 0;
        for(j = 0; j < PORTS; j = j + 1) begin
            if(i != j)
                intermediate_value[i] = intermediate_value[i] ^ q_internal[j][i];
        end
        d_internal[i] = intermediate_value[i] ^ d_r[i];
    end
end

generate for(g0 = 0; g0 < PORTS; g0 = g0 + 1)
    assign q[(g0 + 1) * WIDTH - 1 -: WIDTH] = intermediate_value[g0] ^ q_internal[g0][g0];
endgenerate

`include "common.vh"
endmodule
