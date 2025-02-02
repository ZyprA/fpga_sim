module fulladder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);

endmodule

module fulladder_sim;
    reg a, b, cin;
    wire s, cout;

    fulladder fa(a,b,cin,s,cout);

    initial begin
        $dumpfile("fulladder.vcd");
        $dumpvars(0, fulladder_sim);
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
