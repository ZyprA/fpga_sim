module multiplexer(din, sel, dout);
    input [2:0] din;
    input [1:0] sel;
    output dout;

    function mux;
        input [2:0] din;
        input [1:0] sel;

        if (sel == 2'b00)
            mux = din[0];
        else if (sel == 2'b01)
            mux = din[1];
        else if (sel == 2'b10)
            mux = din[2];
        else
            mux = 1'bx;
    endfunction

    assign dout = mux(din, sel);

endmodule

module multiplexer_sim;
    reg [2:0] din;
    reg [1:0] sel;
    wire dout;

    multiplexer uut(din, sel, dout);

    initial begin
        $dumpfile("multiplexer.vcd");
        $dumpvars(0, multiplexer_sim);
    end

    initial begin
        din[0] = 0; din[1] = 0; din[2] = 1; sel = 0;
        #100 sel = 0;
        #100 sel = 2;
        #100 sel = 1;
        #100 sel = 3;
        #100 $finish;
    end

endmodule