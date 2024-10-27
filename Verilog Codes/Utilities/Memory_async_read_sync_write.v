module Memory_async_read_sync_write #(parameter WIDTH = 18, parameter LENGTH = 64, parameter ADDR_WIDTH)
                                    (clk, rst, read, write, read_addr, write_addr, write_data, read_data);    
    
    input clk, rst, read, write;
    input[ADDR_WIDTH-1:0] read_addr, write_addr;
    input[WIDTH-1:0] write_data;
    output reg[WIDTH-1:0] read_data;


    reg [WIDTH-1:0] mem [0:LENGTH-1];

    integer i;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            read_data <= 0;
            for(i=0; i<LENGTH; i = i + 1)
                mem[i] <= 0;
        end
        else if(write)
            mem[write_addr] <= write_data;
        // else if(read)
            // read_data <= mem[read_addr];
        else;
    end 

    always @(*) begin
        if(read)
            read_data <= mem[read_addr];
        else;
    end
endmodule