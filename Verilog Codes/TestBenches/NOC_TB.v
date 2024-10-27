`timescale 1ns/1ns

module NOC_TB();
    reg clk = 0, rst = 0;

    NOC_4x4 UUT(.clk(clk), .rst(rst));

    always #10 clk = ~clk;

    initial begin
        #2 rst = 1'b1;
        #5 rst = 1'b0;
        #5000 $stop;
    end
endmodule