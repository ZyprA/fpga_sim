`define FT 2'b00
`define DC 2'b01
`define EX 2'b10
`define WB 2'b11

module state(clk, reset, clk_ft, clk_dc, clk_ex, clk_wb);
    input clk, reset;
    output clk_ft, clk_dc, clk_ex, clk_wb;
    reg [1:0] cs;
    always @ (posedge clk)
        if (!reset) cs <= `FT;
        else
        case (cs)
            `FT: cs <= `DC;
            `DC: cs <= `EX;
            `EX: cs <= `WB;
            `WB: cs <= `FT;
            default: cs <= 2'bxx;
        endcase
        assign clk_ft = (cs==`FT);
        assign clk_dc = (cs==`DC);
        assign clk_ex = (cs==`EX);
        assign clk_wb = (cs==`WB);
endmodule

module fetch(clk_ft, p_count, p_out);
    input clk_ft;
    input [7:0] p_count;
    output [14:0] p_out;
    prom pr(clk_ft, p_count, p_out);
endmodule

module prom(clk, addr, q);
    input clk;
    input [7:0] addr;
    output [14:0] q;
    reg [14:0] q;
    reg [14:0] mem [255:0];
    always @ (posedge clk)
        begin
            q <= mem[addr];
        end
    initial begin
        mem[0] = 15'b010000000000000;
        mem[1] = 15'b001100000000001;
        mem[2] = 15'b010000100000000;
        mem[3] = 15'b001100100000010;
        mem[4] = 15'b000100000100000;
    end
endmodule

module decode(clk_dc, p_out, op_code, op_data);
    input clk_dc;
    input [14:0] p_out;
    output [3:0] op_code;
    output [7:0] op_data;
    reg [3:0] op_code;
    reg [7:0] op_data;
    always @ (posedge clk_dc) begin
        op_code <= p_out[14:11];
        op_data <= p_out[7:0];
    end
endmodule

module reg_dc(clk_dc, n_reg_in, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, n_reg_out, reg_out);
    input clk_dc;
    input [2:0] n_reg_in;
    input [15:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
    output [2:0] n_reg_out;
    output [15:0] reg_out;
    reg [2:0] n_reg_out;
    reg [15:0] reg_out;
    always @ (posedge clk_dc) begin
        case (n_reg_in)
            3'b000: reg_out <= reg0;
            3'b001: reg_out <= reg1;
            3'b010: reg_out <= reg2;
            3'b011: reg_out <= reg3;
            3'b100: reg_out <= reg4;
            3'b101: reg_out <= reg5;
            3'b110: reg_out <= reg6;
            3'b111: reg_out <= reg7;
            default: reg_out <= 15'bxxxxxxxxxxxxxxx;
        endcase
        n_reg_out <= n_reg_in;
    end
endmodule

`define MOV 4'b0000
`define ADD 4'b0001
`define SUB 4'b0010
`define LDL 4'b0011
`define LDH 4'b0100

module exec(clk_ex, reset, op_code, reg_a, reg_b, op_data, p_count, reg_in);
    input clk_ex, reset;
    input [3:0] op_code;
    input [15:0] reg_a, reg_b;
    input [7:0] op_data;
    output [7:0] p_count;
    output [15:0] reg_in;
    reg [7:0] p_count;
    reg [15:0] reg_in;
    always @ (posedge clk_ex or negedge reset)
        if(!reset) p_count <= 0;
        else
            case (op_code)
            `MOV:
                begin
                reg_in <= reg_b;
                p_count <= p_count + 1;
                end
            `ADD:
                begin
                reg_in <= reg_a + reg_b;
                p_count <= p_count + 1;
                end
            `SUB:
                begin
                reg_in <= reg_a - reg_b;
                p_count <= p_count + 1;
                end
            `LDL:
                begin
                reg_in <= {reg_a[15:8], op_data};
                p_count <= p_count + 1;
                end
            `LDH:
                begin
                reg_in <= {op_data, reg_a[7:0]};
                p_count <= p_count + 1;
                end
            endcase
endmodule

module reg_wb(clk_wb, reset, n_reg, reg_in, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7);
    input clk_wb, reset;
    input [2:0] n_reg;
    input [15:0] reg_in;
    output [15:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
    reg [15:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
    always @ (posedge clk_wb)
    if(!reset) begin
        reg0 <= 16'h0000;
        reg1 <= 16'h0000;
        reg2 <= 16'h0000;
        reg3 <= 16'h0000;
        reg4 <= 16'h0000;
        reg5 <= 16'h0000;
        reg6 <= 16'h0000;
        reg7 <= 16'h0000;
    end
    else
        case (n_reg)
            0: reg0 <= reg_in;
            1: reg1 <= reg_in;
            2: reg2 <= reg_in;
            3: reg3 <= reg_in;
            4: reg4 <= reg_in;
            5: reg5 <= reg_in;
            6: reg6 <= reg_in;
            7: reg7 <= reg_in;
            default:
                begin
                    reg0 <= 16'hxxxx;
                    reg1 <= 16'hxxxx;
                    reg2 <= 16'hxxxx;
                    reg3 <= 16'hxxxx;
                    reg4 <= 16'hxxxx;
                    reg5 <= 16'hxxxx;
                    reg6 <= 16'hxxxx;
                    reg7 <= 16'hxxxx;
                end
        endcase
endmodule

module cpu(clk, reset, clk_ft, clk_dc, clk_ex, clk_wb, p_count, p_out, op_code, op_data, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, n_reg_a, reg_a, n_reg_b, reg_b, reg_in);
    input clk, reset;
    output clk_ft, clk_dc, clk_ex, clk_wb;
    output [7:0] p_count;
    output [14:0] p_out;
    output [3:0] op_code;
    output [7:0] op_data;
    output [15:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
    output [2:0] n_reg_a, n_reg_b;
    output [15:0] reg_a, reg_b, reg_in;
    
    state st(clk, reset, clk_ft, clk_dc, clk_ex, clk_wb);
    fetch ft(clk_ft, p_count, p_out);
    decode dc(clk_dc, p_out, op_code, op_data);
    reg_dc rdc1(clk_dc, p_out[10:8], reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, n_reg_a, reg_a);
    reg_dc rdc2(clk_dc, p_out[7:5], reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, n_reg_b, reg_b);
    exec ex(clk_ex, reset, op_code, reg_a, reg_b, op_data, p_count, reg_in);
    reg_wb rwb(clk_wb, reset, n_reg_a, reg_in, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7);
endmodule

`timescale 1ns / 1ns

module cpu_sim;
    reg clk, reset;
    wire clk_ft, clk_dc, clk_ex, clk_wb;
    wire [7:0] p_count, op_data;
    wire [14:0] p_out;
    wire [3:0] op_code;
    wire [15:0] reg0, reg1, reg2, reg3, reg4,reg5, reg6, reg7;
    wire [2:0] n_reg_a, n_reg_b;
    wire [15:0] reg_a, reg_b, reg_in;

    cpu cpuSIM(clk, reset, clk_ft, clk_dc, clk_ex, clk_wb, p_count, p_out, op_code, op_data, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, n_reg_a, reg_a, n_reg_b, reg_b, reg_in);

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, cpu_sim);
    end

    initial begin
        clk = 0;
        forever
        #50 clk=~clk;
    end

    initial begin
        reset = 1;
        #100 reset = 0;
        #100 reset = 1;
        #2500 $finish;
    end
endmodule