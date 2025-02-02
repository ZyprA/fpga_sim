module multiplexer(a, b, c, f, s);
    input a, b, c;
    input [1:0] f;
    output s;

    function mux;
        input [1:0] s1;
        input d0, d1, d2;

        case (s1)
            2'b00 : mux = d0;
            2'b01 : mux = d1;
            2'b10 : mux = d2;
            default : mux = 1'bx;
        endcase
    endfunction

    assign s = mux(f,a,b,c);

endmodule


`timescale 1ns / 1ns

module multiplexer_sim;
    reg a, b, c;
    reg [1:0] f;
    wire s;

    multiplexer uut(a, b, c, f, s);

    initial begin
        $dumpfile("multiplexer.vcd");
        $dumpvars(0, multiplexer_sim);
    end

    initial begin
        a = 0; b = 0; c = 1; f = 0;
        #100 f = 0;
        #100 f = 2;
        #100 f = 1;
        #100 f = 3;
        #100 $finish;
    end

endmodule