module sevenseg_led(
    input [3:0] a,
    output [6:0] s
);

assign s[0] = ~(a == 1 || a == 4);
assign s[1] = ~(a == 5 || a == 6);
assign s[2] = ~(a == 2);
assign s[3] = ~(a == 1 || a == 4 || a == 7);
assign s[4] = (a == 0 || a == 2 || a == 6 || a == 8);
assign s[5] = ~(a == 1 || a == 2 || a == 3 || 7);
assign s[6] = ~(a == 0 || a == 1 || a == 7);

endmodule

`timescale 1ns / 1ns

module sevenseg_led_tb;

reg [3:0] a;
wire [6:0] s;

sevenseg_led uut (
    .a(a),
    .s(s)
);

initial begin
    $dumpfile("sevenseg_led_tb.vcd");
    $dumpvars(0, sevenseg_led_tb);
end

initial begin
    a = 0;
    #100 a = 1;
    #100 a = 2;
    #100 a = 3;
    #100 a = 4;
    #100 a = 5;
    #100 a = 6;
    #100 a = 7;
    #100 a = 8;
    #100 a = 9;
    #100 a = 0;
    #100 $finish;
end

endmodule
