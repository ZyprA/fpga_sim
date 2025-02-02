module adder4(a, b, s);
    input [3:0] a, b;
    output [3:0] s;

    assign s = a + b;

endmodule

module adder4_sim;
    reg [3:0] a, b;
    wire [3:0] s;

    adder4 a4(a, b, s);

    initial begin
        $dumpfile("adder4.vcd");
        $dumpvars(0, adder4_sim);
    end

    initial begin
        a = 4'b0000; b = 4'b0000;
        #100 a = 4'b0001;
        #100 a = 4'b0010;
        #100 b = 4'b0111;
        #100 a = 4'b1101;
        #100 a = 4'b1011;
        #100 $finish;
    end

endmodule