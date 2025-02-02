module counter(clk, reset, q);
    input clk, reset;
    output [3:0] q;
    reg [3:0] q;

    always @(posedge clk or negedge reset)
        if (!reset) q <= 0;
        else q <= q + 1;
endmodule

module counter_sim;
    reg clk, reset;
    wire [3:0] q;

    counter counter_inst(clk, reset, q);

    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_sim);
    end
    
    initial begin
        clk = 0;
        forever begin
            #50 clk = ~clk;
        end
    end

    initial begin
        reset = 0;
        #100 reset = 1;
        #100 reset = 0;
        #100 $finish;
    end
endmodule