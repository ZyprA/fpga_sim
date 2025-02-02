`define NORMAL 2'b00
`define SEC 2'b01
`define MIN 2'b10
`define HOUR 2'b11

module state_watch(clk, reset, SW1, SW2, SW3, cs, sec_reset, min_inc, hour_inc);
    input clk, reset, SW1, SW2, SW3;
    output reg [1:0] cs;
    output sec_reset, min_inc, hour_inc;

    always @(posedge clk or negedge reset)
        if (!reset) cs <= `NORMAL;
        else
            case (cs)
                `NORMAL: 
                if (SW2)
                    cs <= `SEC;
                else
                    cs <= `NORMAL;
                `SEC:
                if (SW2)
                    cs <= `NORMAL;
                else if (SW3)
                    cs <= `HOUR;
                else
                    cs <= `SEC;
                `HOUR:
                if (SW2)
                    cs <= `NORMAL;
                else if (SW3)
                    cs <= `MIN;
                else
                    cs <= `HOUR;
                `MIN:
                if (SW2)
                    cs <= `NORMAL;
                else if (SW3)
                    cs <= `SEC;
                else
                    cs <= `MIN;
                default:
                    cs <= 2'bxx;
            endcase
    assign sec_reset = (cs == `SEC) && SW1;
    assign min_inc = (cs == `MIN) && SW1;
    assign hour_inc = (cs == `HOUR) && SW1;
endmodule

module state_watch_sim;
    reg clk, reset, SW1, SW2, SW3;
    wire [1:0] cs;
    wire sec_reset, min_inc, hour_inc;

    state_watch state_watch_inst(clk, reset, SW1, SW2, SW3, cs, sec_reset, min_inc, hour_inc);

    initial begin
        $dumpfile("state_watch.vcd");
        $dumpvars(0, state_watch_sim);
    end

    initial begin
        clk = 0;
        forever #11 clk = ~clk;
    end

    initial begin
        reset = 0;
        SW1 = 0;
        SW2 = 0;
        SW3 = 0;
        #100 reset = 1;
        #100 SW2 = 1;
        #30 SW2 = 0;
        #100 SW3 = 1;
        #30 SW3 = 0;
        #100 SW3 = 1;
        #30 SW3 = 0;
        #100 SW3 = 1; 
        #30 SW3 = 0;
        #100 SW1 = 1;
        #100 $finish;
    end

endmodule