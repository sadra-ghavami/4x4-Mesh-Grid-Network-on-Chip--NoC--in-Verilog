module switch_allocator #(parameter[2:0] PORT_ID = 0) (clk, rst, req_port_local, rout_port_local, req_port_west, rout_port_west, req_port_north, rout_port_north, 
                                                        req_port_east, rout_port_east, req_port_south, rout_port_south, grant_local, grant_west, grant_north, grant_east, grant_south);

    input clk, rst, req_port_local, req_port_west, req_port_north, req_port_east, req_port_south;

    input[2:0] rout_port_local, rout_port_west, rout_port_north, rout_port_east, rout_port_south;

    output grant_local, grant_west, grant_north, grant_east, grant_south;

    wire grant_local_in, grant_west_in, grant_north_in, grant_east_in, grant_south_in;

    wire grant_local_out, grant_west_out, grant_north_out, grant_east_out, grant_south_out;

    wire equal_local, equal_west, equal_north, equal_east, equal_south;

    wire load_reg;

    // Comparators

    assign equal_local =  (rout_port_local == PORT_ID) ? 1'b1 : 1'b0;

    assign equal_west  =  (rout_port_west == PORT_ID) ? 1'b1 : 1'b0;

    assign equal_north =  (rout_port_north == PORT_ID) ? 1'b1 : 1'b0;

    assign equal_east  =  (rout_port_east == PORT_ID) ? 1'b1 : 1'b0;

    assign equal_south =  (rout_port_south == PORT_ID) ? 1'b1 : 1'b0;

    // And Gates

    assign grant_local_in = req_port_local & equal_local;

    assign grant_west_in  = req_port_west & equal_west & ~grant_local_in;

    assign grant_north_in  = req_port_north & equal_north & ~grant_local_in & ~grant_west_in;

    assign grant_east_in  = req_port_east & equal_east & ~grant_local_in & ~grant_west_in & ~grant_north_in;

    assign grant_south_in  = req_port_south & equal_south & ~grant_local_in & ~grant_west_in & ~grant_north_in & ~grant_east_in;  

    // Registers

    register_ld_en #(.WIDTH(1)) grant_reg_local (.clk(clk), .rst(rst), .par_in(grant_local_in), .ld_en(load_reg), .par_out(grant_local_out));

    register_ld_en #(.WIDTH(1)) grant_reg_west (.clk(clk), .rst(rst), .par_in(grant_west_in), .ld_en(load_reg), .par_out(grant_west_out));

    register_ld_en #(.WIDTH(1)) grant_reg_north (.clk(clk), .rst(rst), .par_in(grant_north_in), .ld_en(load_reg), .par_out(grant_north_out));

    register_ld_en #(.WIDTH(1)) grant_reg_east (.clk(clk), .rst(rst), .par_in(grant_east_in), .ld_en(load_reg), .par_out(grant_east_out));

    register_ld_en #(.WIDTH(1)) grant_reg_south (.clk(clk), .rst(rst), .par_in(grant_south_in), .ld_en(load_reg), .par_out(grant_south_out));

    // Port Occupation Checker

    port_occupation_checker occ_checker(.req_port_local(req_port_local), .req_port_west(req_port_west), .req_port_north(req_port_north), .req_port_east(req_port_east),
                                        .req_port_south(req_port_south), .grant_local(grant_local_out), .grant_west(grant_west_out), .grant_north(grant_north_out),
                                        .grant_east(grant_east_out), .grant_south(grant_south_out), .load_reg(load_reg));

    // assignments

    assign grant_local = grant_local_out;

    assign grant_west = grant_west_out;

    assign grant_north = grant_north_out;

    assign grant_east = grant_east_out;

    assign grant_south = grant_south_out;

endmodule