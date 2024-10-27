module MUX5 #(parameter WIDTH) (in1, in2, in3, in4, in5, out, sel);
    input[WIDTH-1:0] in1, in2, in3, in4, in5;
    input[4:0] sel;
    output reg[WIDTH-1:0] out;

    always @(*) begin
        casex (sel)
            5'bxxxx1: out = in1;
            5'bxxx1x: out = in2;
            5'bxx1xx: out = in3;
            5'bx1xxx: out = in4;
            5'b1xxxx: out = in5; 
            default:  out = 0; 
        endcase
    end
endmodule