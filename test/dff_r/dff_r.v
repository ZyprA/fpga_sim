module DFF_R(clk, reset, d, q);
    input clk, reset, d;
    output q;
    reg q;

    always @(posedge clk or negedge reset)
        if (!reset) q <= 0;
        else q <= d;
endmodule