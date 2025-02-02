module DFF(clk, d, q);
    input clk, d;
    output q;

    reg q;

    always @ (posedge clk)
        q <= d;

endmodule

`timescale 1ns / 1ns

module DFF_sim;
    reg clk, d;
    wire q;

    DFF dff0( clk, d, q);

        initial begin
        $dumpfile("dff.vcd");
        $dumpvars(0, DFF_sim);
    end

    initial begin
        clk = 0;
        forever begin
            #4 clk =~ clk;
        end
    end

    initial begin
        d = 0;
        #100 d = 1;
        #100 d = 0;
        #100 $finish;
    end

endmodule
