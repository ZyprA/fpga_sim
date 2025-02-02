module mem3(clk, load, addr, d, q);
    parameter DWIDTH = 16, AWIDTH = 12, WORDS = 4096;

    input clk, load;
    input [AWIDTH-1:0] addr;
    input [DWIDTH-1:0] d;
    output [DWIDTH-1:0] q;
    reg [DWIDTH-1:0] q;
    reg [DWIDTH-1:0] mem [0:WORDS-1];

    always @ (posedge clk)
        begin
          if (load) mem[addr] <= d;
          q <= mem[addr];
        end

        integer i;
        initial begin
            for (i = 0; i < WORDS; i = i + 1)
                mem[i] = i;
        end
endmodule