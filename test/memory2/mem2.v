module mem2(clk, load, addr, d, q);
    parameter DWIDTH = 16, AWIDTH = 12, WORDS 4096;

    input clk, load;
    input [AWIDTH-1:0] addr, d;
    output [DWIDTH-1:0] q;
    reg [DWIDTH-1:0] q;
    reg [DWIDTH-1:0] mem [WORDS-1:0];

    always @ (posedge clk)
        begin
            if (load) mem[addr] <= d;
            q <= mem[addr];
        end
endmodule