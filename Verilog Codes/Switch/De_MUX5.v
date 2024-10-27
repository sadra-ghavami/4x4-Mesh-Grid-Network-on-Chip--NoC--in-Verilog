module De_MUX5 #(parameter WIDTH) (out1, out2, out3, out4, out5, in, sel);

    input[4:0] sel;
    input[WIDTH-1:0] in;
    output reg[WIDTH-1:0] out1, out2, out3, out4, out5;

    always @(*) begin
        out1 = 0;
        out2 = 0;
        out3 = 0;
        out4 = 0;
        out5 = 0;

        casex (sel)
            5'bxxxx1: out1 = in;
            5'bxxx1x: out2 = in;
            5'bxx1xx: out3 = in;
            5'bx1xxx: out4 = in;
            5'b1xxxx: out5 = in; 
            default:  {out1, out2, out3, out4, out5} = 0; 
        endcase
    end


endmodule