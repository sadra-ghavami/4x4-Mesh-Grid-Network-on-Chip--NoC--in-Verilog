module router #(parameter ROUTER_ID) (clk, rst,
                                      data_in_local, req_in_local, ack_in_local, req_out_local, ack_out_local, data_out_local,
                                      data_in_west, req_in_west, ack_in_west, req_out_west, ack_out_west, data_out_west,
                                      data_in_north, req_in_north, ack_in_north, req_out_north, ack_out_north, data_out_north,
                                      data_in_east, req_in_east, ack_in_east, req_out_east, ack_out_east, data_out_east,
                                      data_in_south, req_in_south, ack_in_south, req_out_south, ack_out_south, data_out_south);

    input clk, rst;
    
    input req_in_local, req_in_west, req_in_north, req_in_east, req_in_south;

    input ack_out_local, ack_out_west, ack_out_north, ack_out_east, ack_out_south;

    input[17:0] data_in_local, data_in_west, data_in_north, data_in_east, data_in_south;


    output ack_in_local, ack_in_west, ack_in_north, ack_in_east, ack_in_south;

    output req_out_local, req_out_west, req_out_north, req_out_east, req_out_south;

    output[17:0] data_out_local, data_out_west, data_out_north, data_out_east, data_out_south;

    
    localparam[2:0] LOCAL_CHANNEL_ID = 3'b000, NORTH_CHANNEL_ID = 3'b001, SOUTH_CHANNEL_ID = 3'b010, EAST_CHANNEL_ID = 3'b011, WEST_CHANNEL_ID = 3'b100;


    wire local_req_port, local_req_out, west_req_port, west_req_out, north_req_port, north_req_out, east_req_port, east_req_out, south_req_port, south_req_out;

    wire[3:0] local_dest, west_dest, north_dest, east_dest, south_dest;

    wire[17:0] local_data_out, west_data_out, north_data_out, east_data_out, south_data_out;

    wire[2:0] local_rout, west_rout, north_rout, east_rout, south_rout;

    wire local_switch_local_ack_out, local_switch_west_ack_out, local_switch_north_ack_out, local_switch_east_ack_out, local_switch_south_ack_out;
    wire west_switch_local_ack_out, west_switch_west_ack_out, west_switch_north_ack_out, west_switch_east_ack_out, west_switch_south_ack_out;
    wire north_switch_local_ack_out, north_switch_west_ack_out, north_switch_north_ack_out, north_switch_east_ack_out, north_switch_south_ack_out;
    wire east_switch_local_ack_out, east_switch_west_ack_out, east_switch_north_ack_out, east_switch_east_ack_out, east_switch_south_ack_out;  
    wire south_switch_local_ack_out, south_switch_west_ack_out, south_switch_north_ack_out, south_switch_east_ack_out, south_switch_south_ack_out;

    wire local_switch_local_grant, local_switch_west_grant, local_switch_north_grant, local_switch_east_grant, local_switch_south_grant;
    wire west_switch_local_grant, west_switch_west_grant, west_switch_north_grant, west_switch_east_grant, west_switch_south_grant;
    wire north_switch_local_grant, north_switch_west_grant, north_switch_north_grant, north_switch_east_grant, north_switch_south_grant;
    wire east_switch_local_grant, east_switch_west_grant, east_switch_north_grant, east_switch_east_grant, east_switch_south_grant;  
    wire south_switch_local_grant, south_switch_west_grant, south_switch_north_grant, south_switch_east_grant, south_switch_south_grant;


    buffer_unit local_buf_unit(.clk(clk), .rst(rst), .data_in(data_in_local), .req_in(req_in_local), .ack_in(ack_in_local), .req_port(local_req_port),
                               .grant_port(south_switch_local_grant), .req_out(local_req_out), .ack_out(south_switch_local_ack_out), .dest(local_dest), .data_out(local_data_out));

    buffer_unit west_buf_unit(.clk(clk), .rst(rst), .data_in(data_in_west), .req_in(req_in_west), .ack_in(ack_in_west), .req_port(west_req_port),
                               .grant_port(south_switch_west_grant), .req_out(west_req_out), .ack_out(south_switch_west_ack_out), .dest(west_dest), .data_out(west_data_out));

    buffer_unit north_buf_unit(.clk(clk), .rst(rst), .data_in(data_in_north), .req_in(req_in_north), .ack_in(ack_in_north), .req_port(north_req_port),
                               .grant_port(south_switch_north_grant), .req_out(north_req_out), .ack_out(south_switch_north_ack_out), .dest(north_dest), .data_out(north_data_out));

    buffer_unit east_buf_unit(.clk(clk), .rst(rst), .data_in(data_in_east), .req_in(req_in_east), .ack_in(ack_in_east), .req_port(east_req_port),
                               .grant_port(south_switch_east_grant), .req_out(east_req_out), .ack_out(south_switch_east_ack_out), .dest(east_dest), .data_out(east_data_out));

    buffer_unit south_buf_unit(.clk(clk), .rst(rst), .data_in(data_in_south), .req_in(req_in_south), .ack_in(ack_in_south), .req_port(south_req_port),
                               .grant_port(south_switch_south_grant), .req_out(south_req_out), .ack_out(south_switch_south_ack_out), .dest(south_dest), .data_out(south_data_out));


    routing_unit #(.ROUTER_ID(ROUTER_ID)) rout_unit (.dest_l(local_dest), .dest_n(north_dest), .dest_s(south_dest), .dest_e(east_dest), .dest_w(west_dest),
                                                     .rout_l(local_rout), .rout_n(north_rout), .rout_s(south_rout), .rout_e(east_rout), .rout_w(west_rout));


    port_switch #(.PORT_ID(LOCAL_CHANNEL_ID)) local_switch (.clk(clk), .rst(rst), 
                                                            .req_port_local(local_req_port), .rout_port_local(local_rout), .req_port_west(west_req_port), 
                                                            .rout_port_west(west_rout), .req_port_north(north_req_port), .rout_port_north(north_rout), 
                                                            .req_port_east(east_req_port), .rout_port_east(east_rout), .req_port_south(south_req_port), 
                                                            .rout_port_south(south_rout), .grant_local_next(local_switch_local_grant), .grant_west_next(local_switch_west_grant),
                                                            .grant_north_next(local_switch_north_grant), .grant_east_next(local_switch_east_grant), .grant_south_next(local_switch_south_grant),
                                                            .req_out_local(local_req_out), .data_out_local(local_data_out), .req_out_west(west_req_out), .data_out_west(west_data_out),
                                                            .req_out_north(north_req_out), .data_out_north(north_data_out), .req_out_east(east_req_out), .data_out_east(east_data_out), 
                                                            .req_out_south(south_req_out), .data_out_south(south_data_out), 
                                                            .ack_out_local_next(local_switch_local_ack_out), .ack_out_west_next(local_switch_west_ack_out), .ack_out_north_next(local_switch_north_ack_out),
                                                            .ack_out_east_next(local_switch_east_ack_out), .ack_out_south_next(local_switch_south_ack_out), .ack_out_port(ack_out_local),
                                                            .req_out_port(req_out_local), .data_out_port(data_out_local), .grant_local_prev(1'b0), .grant_west_prev(1'b0), .grant_north_prev(1'b0),
                                                            .grant_east_prev(1'b0), .grant_south_prev(1'b0), .ack_out_local_prev(1'b0), .ack_out_west_prev(1'b0), .ack_out_north_prev(1'b0),
                                                            .ack_out_east_prev(1'b0), .ack_out_south_prev(1'b0));


    port_switch #(.PORT_ID(WEST_CHANNEL_ID)) west_switch   (.clk(clk), .rst(rst), 
                                                            .req_port_local(local_req_port), .rout_port_local(local_rout), .req_port_west(west_req_port), 
                                                            .rout_port_west(west_rout), .req_port_north(north_req_port), .rout_port_north(north_rout), 
                                                            .req_port_east(east_req_port), .rout_port_east(east_rout), .req_port_south(south_req_port), 
                                                            .rout_port_south(south_rout), .grant_local_next(west_switch_local_grant), .grant_west_next(west_switch_west_grant),
                                                            .grant_north_next(west_switch_north_grant), .grant_east_next(west_switch_east_grant), .grant_south_next(west_switch_south_grant),
                                                            .req_out_local(local_req_out), .data_out_local(local_data_out), .req_out_west(west_req_out), .data_out_west(west_data_out),
                                                            .req_out_north(north_req_out), .data_out_north(north_data_out), .req_out_east(east_req_out), .data_out_east(east_data_out), 
                                                            .req_out_south(south_req_out), .data_out_south(south_data_out), 
                                                            .ack_out_local_next(west_switch_local_ack_out), .ack_out_west_next(west_switch_west_ack_out), .ack_out_north_next(west_switch_north_ack_out),
                                                            .ack_out_east_next(west_switch_east_ack_out), .ack_out_south_next(west_switch_south_ack_out), .ack_out_port(ack_out_west),
                                                            .req_out_port(req_out_west), .data_out_port(data_out_west),
                                                            .grant_local_prev(local_switch_local_grant), .grant_west_prev(local_switch_west_grant), .grant_north_prev(local_switch_north_grant),
                                                            .grant_east_prev(local_switch_east_grant), .grant_south_prev(local_switch_south_grant),
                                                            .ack_out_local_prev(local_switch_local_ack_out), .ack_out_west_prev(local_switch_west_ack_out), .ack_out_north_prev(local_switch_north_ack_out),
                                                            .ack_out_east_prev(local_switch_east_ack_out), .ack_out_south_prev(local_switch_south_ack_out));


    port_switch #(.PORT_ID(NORTH_CHANNEL_ID)) north_switch (.clk(clk), .rst(rst), 
                                                            .req_port_local(local_req_port), .rout_port_local(local_rout), .req_port_west(west_req_port), 
                                                            .rout_port_west(west_rout), .req_port_north(north_req_port), .rout_port_north(north_rout), 
                                                            .req_port_east(east_req_port), .rout_port_east(east_rout), .req_port_south(south_req_port), 
                                                            .rout_port_south(south_rout), .grant_local_next(north_switch_local_grant), .grant_west_next(north_switch_west_grant),
                                                            .grant_north_next(north_switch_north_grant), .grant_east_next(north_switch_east_grant), .grant_south_next(north_switch_south_grant),
                                                            .req_out_local(local_req_out), .data_out_local(local_data_out), .req_out_west(west_req_out), .data_out_west(west_data_out),
                                                            .req_out_north(north_req_out), .data_out_north(north_data_out), .req_out_east(east_req_out), .data_out_east(east_data_out), 
                                                            .req_out_south(south_req_out), .data_out_south(south_data_out), 
                                                            .ack_out_local_next(north_switch_local_ack_out), .ack_out_west_next(north_switch_west_ack_out), .ack_out_north_next(north_switch_north_ack_out),
                                                            .ack_out_east_next(north_switch_east_ack_out), .ack_out_south_next(north_switch_south_ack_out), .ack_out_port(ack_out_north),
                                                            .req_out_port(req_out_north), .data_out_port(data_out_north),
                                                            .grant_local_prev(west_switch_local_grant), .grant_west_prev(west_switch_west_grant), .grant_north_prev(west_switch_north_grant),
                                                            .grant_east_prev(west_switch_east_grant), .grant_south_prev(west_switch_south_grant),
                                                            .ack_out_local_prev(west_switch_local_ack_out), .ack_out_west_prev(west_switch_west_ack_out), .ack_out_north_prev(west_switch_north_ack_out),
                                                            .ack_out_east_prev(west_switch_east_ack_out), .ack_out_south_prev(west_switch_south_ack_out));


    port_switch #(.PORT_ID(EAST_CHANNEL_ID)) east_switch   (.clk(clk), .rst(rst), 
                                                            .req_port_local(local_req_port), .rout_port_local(local_rout), .req_port_west(west_req_port), 
                                                            .rout_port_west(west_rout), .req_port_north(north_req_port), .rout_port_north(north_rout), 
                                                            .req_port_east(east_req_port), .rout_port_east(east_rout), .req_port_south(south_req_port), 
                                                            .rout_port_south(south_rout), .grant_local_next(east_switch_local_grant), .grant_west_next(east_switch_west_grant),
                                                            .grant_north_next(east_switch_north_grant), .grant_east_next(east_switch_east_grant), .grant_south_next(east_switch_south_grant),
                                                            .req_out_local(local_req_out), .data_out_local(local_data_out), .req_out_west(west_req_out), .data_out_west(west_data_out),
                                                            .req_out_north(north_req_out), .data_out_north(north_data_out), .req_out_east(east_req_out), .data_out_east(east_data_out), 
                                                            .req_out_south(south_req_out), .data_out_south(south_data_out), 
                                                            .ack_out_local_next(east_switch_local_ack_out), .ack_out_west_next(east_switch_west_ack_out), .ack_out_north_next(east_switch_north_ack_out),
                                                            .ack_out_east_next(east_switch_east_ack_out), .ack_out_south_next(east_switch_south_ack_out), .ack_out_port(ack_out_east),
                                                            .req_out_port(req_out_east), .data_out_port(data_out_east),
                                                            .grant_local_prev(north_switch_local_grant), .grant_west_prev(north_switch_west_grant), .grant_north_prev(north_switch_north_grant),
                                                            .grant_east_prev(north_switch_east_grant), .grant_south_prev(north_switch_south_grant),
                                                            .ack_out_local_prev(north_switch_local_ack_out), .ack_out_west_prev(north_switch_west_ack_out), .ack_out_north_prev(north_switch_north_ack_out),
                                                            .ack_out_east_prev(north_switch_east_ack_out), .ack_out_south_prev(north_switch_south_ack_out));



    port_switch #(.PORT_ID(SOUTH_CHANNEL_ID)) south_switch (.clk(clk), .rst(rst), 
                                                            .req_port_local(local_req_port), .rout_port_local(local_rout), .req_port_west(west_req_port), 
                                                            .rout_port_west(west_rout), .req_port_north(north_req_port), .rout_port_north(north_rout), 
                                                            .req_port_east(east_req_port), .rout_port_east(east_rout), .req_port_south(south_req_port), 
                                                            .rout_port_south(south_rout), .grant_local_next(south_switch_local_grant), .grant_west_next(south_switch_west_grant),
                                                            .grant_north_next(south_switch_north_grant), .grant_east_next(south_switch_east_grant), .grant_south_next(south_switch_south_grant),
                                                            .req_out_local(local_req_out), .data_out_local(local_data_out), .req_out_west(west_req_out), .data_out_west(west_data_out),
                                                            .req_out_north(north_req_out), .data_out_north(north_data_out), .req_out_east(east_req_out), .data_out_east(east_data_out), 
                                                            .req_out_south(south_req_out), .data_out_south(south_data_out), 
                                                            .ack_out_local_next(south_switch_local_ack_out), .ack_out_west_next(south_switch_west_ack_out), .ack_out_north_next(south_switch_north_ack_out),
                                                            .ack_out_east_next(south_switch_east_ack_out), .ack_out_south_next(south_switch_south_ack_out), .ack_out_port(ack_out_south),
                                                            .req_out_port(req_out_south), .data_out_port(data_out_south),
                                                            .grant_local_prev(east_switch_local_grant), .grant_west_prev(east_switch_west_grant), .grant_north_prev(east_switch_north_grant),
                                                            .grant_east_prev(east_switch_east_grant), .grant_south_prev(east_switch_south_grant),
                                                            .ack_out_local_prev(east_switch_local_ack_out), .ack_out_west_prev(east_switch_west_ack_out), .ack_out_north_prev(east_switch_north_ack_out),
                                                            .ack_out_east_prev(east_switch_east_ack_out), .ack_out_south_prev(east_switch_south_ack_out));



endmodule