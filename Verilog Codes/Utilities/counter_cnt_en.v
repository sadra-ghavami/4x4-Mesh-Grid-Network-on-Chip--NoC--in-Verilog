
module counter_cnt_en #(parameter WIDTH = 6) (clk, rst, par_in, cnt_en, par_out, co);
    input clk, rst, cnt_en;
    input[WIDTH-1:0] par_in;
    output [WIDTH-1:0] par_out;
    output co;
    
    wire co_internal;
    reg [WIDTH-1:0] par_out_internal;

    always @(posedge clk, posedge rst) begin
        if(rst)
            par_out_internal <= par_in;

        else if(cnt_en) begin
            if(co_internal)
                par_out_internal <= par_in;
            else
                par_out_internal <= par_out_internal + 1;
        end
        else;
    end
    
    assign co_internal = &{par_out_internal};
    assign par_out = par_out_internal;
    assign co = co_internal;


endmodule