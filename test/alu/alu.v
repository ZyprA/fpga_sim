`define ADD 5'b00000
`define SUB 5'b00001
`define MUL 5'b00010
`define SHL 5'b00011
`define SHR 5'b00100
`define BAND 5'b00101
`define BOR 5'b00110
`define BXOR 5'b00111
`define AND 5'b01000
`define OR 5'b01001
`define EQ 5'b01010
`define NE 5'b01011
`define GE 5'b01100
`define LE 5'b01101
`define GT 5'b01110
`define LT 5'b01111
`define NEG 5'b10000
`define BNOT 5'b10001
`define NOT 5'b10010

module ArithmeticLogicUnit(a, b, f, s);
    input [15:0] a, b;
    input [4:0] f;
    output [15:0] s;

    wire [15:0] x, y;

    assign x = a + 16'h8000;
    assign y = b + 16'h8000;

    function [15:0] alu;
        input [15:0] a, b;
        input [4:0] f;
        input [15:0] x, y;
        
        case (f)
            `ADD : alu = b + a;
            `SUB : alu = b - a;
            `MUL : alu = b * a;
            `SHL : alu = b << a;
            `SHR : alu = b >> a;
            `BAND : alu = b & a;
            `BOR : alu = a | b;
            `AND : alu = b && a;
            `OR : alu = b || a;
            `EQ : alu = b == a;
            `NE : alu = b != a;
            `GE : alu = x >= y;
            `LE : alu = x <= y;
            `GT : alu = x > y;
            `LT : alu = x < y;
            `NEG : alu = -a;
            `BNOT : alu = ~a;
            `NOT : alu = !a;
            default : alu = 16'hxxxx;
        endcase
    endfunction

    assign s = alu(a, b, f, x, y);

endmodule

module alu_sim;
    reg [15:0] a, b;
    reg [4:0] f;
    wire [15:0] s;

    ArithmeticLogicUnit alu(a,b,f,s);

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_sim);
    end

    initial begin
        a = 10; b = 40;
        #100 f = `ADD;
        #100 f = `SUB;
        #100 f = `MUL;
        #100 f = `SHL;
        #100 f = `SHR;
        #100 f = `BAND;
        #100 f = `BOR;
        #100 f = `AND;
        #100 f = `OR;
        #100 f = `EQ;
        #100 f = `NE;
        #100 f = `GE;
        #100 f = `LE;
        #100 f = `GT;
        #100 f = `LT;
        #100 f = `NEG;
        #100 f = `BNOT;
        #100 f = `NOT;
        #100 $finish;

    end

endmodule