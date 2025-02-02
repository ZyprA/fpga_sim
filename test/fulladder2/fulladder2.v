module halfadder(a,b,s,c);
    input a, b;
    output s, c;

    assign s = a ^ b;
    assign c = a & b;

endmodule

module fulladder2(a,b,cin,s,cout);
    input a, b, cin;
    output s, cout;
    wire s1, c1, c2;

    halfadder ha1(a,b,s1,c1);
    halfadder ha2(s1,cin,s,c2);

    assign cout = c1 | c2;

endmodule

module fulladder2_sim;
    reg a, b, cin;
    wire s, cout;

    fulladder2 fa(a,b,cin,s,cout);

    initial begin
        $dumpfile("fulladder2.vcd");
        $dumpvars(0, fulladder2_sim);
    end

    initial begin
        a = 0; b = 0; cin = 0;
        #100 cin = 1;
        #100 cin = 0; b = 1;
        #100 cin = 1;
        #100 a = 1; b = 0; cin = 0;
        #100 cin = 1;
        #100 cin = 0; b = 1;
        #100 cin = 1;
        #100 $finish;
    end

endmodule
