module buffer_unit(clk, rst, data_in, req_in, ack_in, req_port, grant_port,
                    req_out, ack_out, dest, data_out);

    input clk, rst, req_in, grant_port, ack_out;
    input[17:0] data_in;

    output ack_in, req_port, req_out;
    output[3:0] dest;
    output[17:0] data_out;

    wire[3:0] flit_dest;
    wire[1:0] flit_type;
    wire load_dest, read, write, empty, full;
    

    FIFO #(.WIDTH(18), .LENGTH(64)) FIFO_unit (.clk(clk), .rst(rst), .read(read), .write(write), .empty(empty), .full(full), .data_in(data_in), .data_out(data_out));

    buffer_unit_controller controller(.clk(clk), .rst(rst), .req_in(req_in), .ack_in(ack_in), .flit_type(flit_type), .read(read), .write(write), .empty(empty),
                                      .full(full), .load_dest(load_dest), .req_out(req_out), .ack_out(ack_out), .req_port(req_port), .grant_port(grant_port));

    register_ld_en #(.WIDTH(4)) dest_node (.clk(clk), .rst(rst), .par_in(flit_dest), .ld_en(load_dest), .par_out(dest));


    assign flit_type = data_in[17:16];
    assign flit_dest = data_in[3:0];

endmodule