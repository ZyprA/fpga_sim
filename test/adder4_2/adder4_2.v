module fulladder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);

endmodule


module adder4(a,b,s);
    input [3:0] a, b;
    output [3:0] s;
    wire [3:0] c;

    fulladder fa0(a[0], b[0], 1'b0, s[0], c[0]);
    fulladder fa1(a[1], b[1], c[0], s[1], c[1]);
    fulladder fa2(a[2], b[2], c[1], s[2], c[2]);
    fulladder fa3(a[3], b[3], c[2], s[3], c[3]);

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