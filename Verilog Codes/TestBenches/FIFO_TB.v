`timescale 1ns/1ns

module FIFO_TB();
    reg clk = 0, rst = 0, read = 0, write = 0;
    reg[17:0] data_in;
    wire empty, full;
    wire[17:0] data_out;

    reg[17:0] data [0:63];

    FIFO #(.WIDTH(18), .LENGTH(64)) UUT (.clk(clk), .rst(rst), .read(read), .write(write), .empty(empty), .full(full), .data_in(data_in), .data_out(data_out));
    
    always #10 clk <= ~clk;

    integer i;
    initial begin
        #2 rst = 1'b1;
        #5 rst = 1'b0;
        #20;
        #0 read = 1'b1;
        #20 read = 1'b0;
        for(i=0; i<64; i = i + 1) begin
            @(posedge clk) begin 
                #2 data[i] = $random;
                #0 data_in = data[i];
                #0 write = 1'b1;
            end
        end

        @(posedge clk) #2 data_in = $random;

        @(posedge clk) #2 write = 1'b0;
        #2 $stop;

        for(i=0; i<64; i = i + 1) begin
            #2 read = 1'b1;
            @(posedge clk) begin
                if(data_out == data[i])
                    $display("Read value is correct: \t %d", data_out);
                else
                    $display("Read value is incorrect: \t data out : %d \t expected data : %d", data_out, data[i]);
            end 
        end
        #2 read = 1'b0;
        #2 $stop;        
    end
endmodule