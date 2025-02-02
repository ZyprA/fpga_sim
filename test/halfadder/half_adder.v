module halfadder(a,b,s,c);
    input a, b;
    output s, c;

    assign s = a ^ b;
    assign c = a & b;

endmodule

`timescale 1ns / 1ns

module halfadder_sim;
    reg a, b;
    wire s, c;

    halfadder ha(a,b,s,c);

    initial begin
        $dumpfile("half_adder.vcd");
        $dumpvars(0, halfadder_sim);
    end

    initial begin
        a = 0; b = 0;
        #100 a = 1;
        #100 a = 0; b = 1;
        #100 a = 1;
        #100 a = 0; b = 0;
        #100 $finish;
    end

endmodule
