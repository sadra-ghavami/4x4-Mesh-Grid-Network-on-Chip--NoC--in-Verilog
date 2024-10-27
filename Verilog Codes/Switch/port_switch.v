module port_switch #(parameter[2:0] PORT_ID = 0) (clk, rst, req_port_local, rout_port_local, req_port_west, rout_port_west, req_port_north, rout_port_north, 
                                                  req_port_east, rout_port_east, req_port_south, rout_port_south, grant_local_next, grant_west_next, grant_north_next, grant_east_next, grant_south_next,
                                                  req_out_local, data_out_local, req_out_west, data_out_west, req_out_north, data_out_north, req_out_east, data_out_east, 
                                                  req_out_south, data_out_south, ack_out_local_next, ack_out_west_next, ack_out_north_next, ack_out_east_next, ack_out_south_next, ack_out_port,
                                                  req_out_port, data_out_port, grant_local_prev, grant_west_prev, grant_north_prev, grant_east_prev, grant_south_prev,
                                                  ack_out_local_prev, ack_out_west_prev, ack_out_north_prev, ack_out_east_prev, ack_out_south_prev);

    input clk, rst, req_port_local, req_port_west, req_port_north, req_port_east, req_port_south;

    input[2:0] rout_port_local, rout_port_west, rout_port_north, rout_port_east, rout_port_south;

    input req_out_local, req_out_west, req_out_north, req_out_east, req_out_south;

    input[17:0] data_out_local, data_out_west, data_out_north, data_out_east, data_out_south;

    input grant_local_prev, grant_west_prev, grant_north_prev, grant_east_prev, grant_south_prev;

    input ack_out_local_prev, ack_out_west_prev, ack_out_north_prev, ack_out_east_prev, ack_out_south_prev;

    input ack_out_port;

    

    output grant_local_next, grant_west_next, grant_north_next, grant_east_next, grant_south_next;

    output req_out_port;

    output ack_out_local_next, ack_out_west_next, ack_out_north_next, ack_out_east_next, ack_out_south_next;
    
    output[17:0] data_out_port;

    

    wire grant_local, grant_west, grant_north, grant_east, grant_south;

    wire ack_out_local, ack_out_west, ack_out_north, ack_out_east, ack_out_south;


    switch_allocator #(.PORT_ID(PORT_ID)) allocator (.clk(clk), .rst(rst), .req_port_local(req_port_local), .rout_port_local(rout_port_local), .req_port_west(req_port_west),
                                                     .rout_port_west(rout_port_west), .req_port_north(req_port_north), .rout_port_north(rout_port_north), .req_port_east(req_port_east),
                                                     .rout_port_east(rout_port_east), .req_port_south(req_port_south), .rout_port_south(rout_port_south), .grant_local(grant_local),
                                                     .grant_west(grant_west), .grant_north(grant_north), .grant_east(grant_east), .grant_south(grant_south));


    MUX5 #(.WIDTH(19)) mux (.in1({req_out_local, data_out_local}), .in2({req_out_west, data_out_west}), .in3({req_out_north, data_out_north}),
                            .in4({req_out_east, data_out_east}), .in5({req_out_south, data_out_south}), .out({req_out_port, data_out_port}),
                            .sel({grant_south, grant_east, grant_north, grant_west, grant_local}));

    De_MUX5 #(.WIDTH(1)) de_mux (.out1(ack_out_local), .out2(ack_out_west), .out3(ack_out_north), .out4(ack_out_east), .out5(ack_out_south), .in(ack_out_port),
                                 .sel({grant_south, grant_east, grant_north, grant_west, grant_local}));


    assign grant_local_next = grant_local | grant_local_prev;
    assign grant_west_next = grant_west | grant_west_prev;
    assign grant_north_next = grant_north | grant_north_prev;
    assign grant_east_next = grant_east | grant_east_prev;
    assign grant_south_next = grant_south | grant_south_prev;

    assign ack_out_local_next = ack_out_local | ack_out_local_prev;
    assign ack_out_west_next = ack_out_west | ack_out_west_prev;
    assign ack_out_north_next = ack_out_north | ack_out_north_prev;
    assign ack_out_east_next = ack_out_east | ack_out_east_prev;
    assign ack_out_south_next = ack_out_south | ack_out_south_prev;

endmodule

