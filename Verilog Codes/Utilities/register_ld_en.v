module register_ld_en #(parameter WIDTH = 1) (clk, rst, par_in, ld_en, par_out);
    input clk, rst, ld_en;
    input[WIDTH-1:0] par_in;
    output reg[WIDTH-1:0] par_out;

    always @(posedge clk, posedge rst) begin
        if(rst)
            par_out <= 0;
        else if(ld_en)
            par_out <= par_in;
    end
endmodule