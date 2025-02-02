`define IDLE 2'b00
`define FETCH 2'b01
`define EXEC 2'b10
module state(clk, reset, run, halt, cs);
    input clk, reset, run, halt;
    output [1:0] cs;
    reg [1:0] cs;

    always @ (posedge clk or negedge reset)
    if (!reset) cs <= `IDLE;
    else
        case (cs)
            `IDLE: if(run) cs <= `FETCH;
            `FETCH: cs <= `EXEC;
            `EXEC: if(halt) cs <= `IDLE;
            else cs <= `FETCH;
            default: cs <= 2'bxx;
        endcase
endmodule

module mem3(clk, load, addr, d, q);
    parameter DWIDTH=16, AWIDTH=12, WORDS=4096;

    input clk, load;
    input [AWIDTH-1:0] addr;
    input [DWIDTH-1:0] d;
    output [DWIDTH-1:0] q;
    reg [DWIDTH-1:0] q;
    reg [DWIDTH-1:0] mem [WORDS-1:0];

    always @ (posedge clk)
        begin
            if (load) mem[addr] <= d;
            q <= mem[addr];
        end
    integer i;
    initial begin
        for(i=0;i<WORDS;i=i+1)
        mem[i] = i;
    end
endmodule


module state_mem(
    input clk,
    input reset,
    input run,
    input halt,
    output [15:0] out
);
    reg [11:0] addr;
    wire [1:0] cs;
    wire [15:0] mem_data;

    state state_inst(
        .clk(clk),
        .reset(reset),
        .run(run),
        .halt(halt),
        .cs(cs)
    );

    mem3 mem_inst(
        .clk(clk),
        .load(1'b0),
        .addr(addr),
        .d(16'b0),
        .q(mem_data)
    );

    always @(posedge clk or negedge reset) begin
        if (!reset)
            addr <= 12'b0;
        else if (cs == `EXEC)
            addr <= addr + 1;
    end

    assign out = (cs == `EXEC) ? (mem_data + 2) : 16'b0;

endmodule

module state_mem_sim;
    reg clk, reset, run, halt;
    wire [15:0] out;

    state_mem state_mem_inst(
        .clk(clk),
        .reset(reset),
        .run(run),
        .halt(halt),
        .out(out)
    );

    initial begin
        $dumpfile("state_mem.vcd");
        $dumpvars(0, state_mem_sim);
    end

    initial begin
        clk = 0; halt = 0; reset = 0; run = 0;
        #100 reset = 1; run = 1;
        #900 $finish;
    end

    always #50 clk = ~clk;
endmodule