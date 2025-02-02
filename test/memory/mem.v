module mem(clk, load, addr, d, q);
    input clk, load;
    input [15:0] addr, d;
    output [15:0] q;
    reg [15:0] q;
    reg [15:0] mem [4095:0];

    always @ (posedge clk)
        begin
            if (load) mem[addr] <= d;
            q <= mem[addr];
        end
endmodule

module mem_sim;
    reg clk, load;
    reg [15:0] addr, d;
    wire [15:0] q;

    mem m(clk, load, addr, d, q);

    initial begin
        $dumpfile("mem.vcd");
        $dumpvars(0, mem_sim);
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        load = 1; addr = 1; d = 23;
        #100 load = 0; addr = 0;
        #100 addr = 1; d = 1;
        #100 load = 1; addr = 1; d = 2;
        #100 load = 0; addr = 1;
        #100 $finish;
    end

endmodule

