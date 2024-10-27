module FIFO #(parameter WIDTH = 18, parameter LENGTH = 64) (clk, rst, read, write, empty, full, data_in, data_out);
    localparam ADDR_WIDTH = $clog2(LENGTH);
    
    input clk, rst, read, write;
    input[WIDTH-1:0] data_in;
    output empty, full;
    output[WIDTH-1:0] data_out;

    wire operation, last_operation, read_en, write_en, full_internal, empty_internal, equal;
    wire [ADDR_WIDTH-1:0] start_ptr, end_ptr;

    register_ld_en #(.WIDTH(1)) Last_operation (.clk(clk), .rst(rst), .par_in(write), .ld_en(operation), .par_out(last_operation));
    counter_cnt_en #(.WIDTH(ADDR_WIDTH)) start_ptr_counter (.clk(clk), .rst(rst), .par_in(0), .cnt_en(read_en), .par_out(start_ptr), .co());
    counter_cnt_en #(.WIDTH(ADDR_WIDTH)) end_ptr_counter (.clk(clk), .rst(rst), .par_in(0), .cnt_en(write_en), .par_out(end_ptr), .co());
    Memory_async_read_sync_write #(.WIDTH(WIDTH), .LENGTH(LENGTH), .ADDR_WIDTH(ADDR_WIDTH)) memory (.clk(clk), .rst(rst), .read(read_en), .write(write_en),
                                  .read_addr(start_ptr), .write_addr(end_ptr), .write_data(data_in), .read_data(data_out));    


    assign operation = read | write;
    assign full_internal = last_operation & equal;
    assign empty_internal = ~last_operation & equal;
    assign equal = (start_ptr == end_ptr) ? 1'b1 : 1'b0;
    assign read_en = read & ~empty_internal;
    assign write_en = write & ~full_internal;
    assign full = full_internal;
    assign empty = empty_internal;


endmodule