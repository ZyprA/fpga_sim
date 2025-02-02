`define IDLE 2'b00
`define FETCH 2'b01
`define EXEC 2'b10

module state(clk, reset, run, halt, cs);
    input clk, reset, run, halt;
    output reg [1:0] cs;

    always @ (posedge clk or negedge reset)
        if (!reset) cs <= `IDLE;
        else
            case (cs)
                `IDLE: if(run) cs <= `FETCH;
                `FETCH: cs <= `EXEC;
                `EXEC: if (halt) cs <= `IDLE;
                else cs <= `FETCH;
                default: cs <= 2'bxx;
            endcase
endmodule

module state_sim;
    reg clk, reset, run, halt;
    wire [1:0] cs;

    state state_inst(clk, reset, run, halt, cs);

    initial begin
        $dumpfile("state.vcd");
        $dumpvars(0, state_sim);
    end

    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    initial begin
        reset = 0;
        run = 0;
        halt = 0;
        #100 reset = 1;
        #100 run = 1;
        #100 run = 0;
        #100 halt = 1;
        #100 halt = 0;
        #100 $finish;
    end
endmodule