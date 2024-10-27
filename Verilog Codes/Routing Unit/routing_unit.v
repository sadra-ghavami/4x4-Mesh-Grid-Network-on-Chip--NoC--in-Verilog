
module routing_unit #(parameter[3:0] ROUTER_ID = 0) (dest_l, dest_n, dest_s, dest_e, dest_w, rout_l, rout_n, rout_s, rout_e, rout_w);
    
    input[3:0] dest_l, dest_n, dest_s, dest_e, dest_w;
    output[2:0] rout_l, rout_n, rout_s, rout_e, rout_w;

    wire[1:0] x_r, y_r;
    wire[1:0] x_l, y_l, x_n, y_n, x_s, y_s, x_e, y_e, x_w, y_w;


    channel_cordinator cordinator_local(.x_d(x_l), .y_d(y_l), .x_r(x_r), .y_r(y_r), .rout_id(rout_l));

    channel_cordinator cordinator_north(.x_d(x_n), .y_d(y_n), .x_r(x_r), .y_r(y_r), .rout_id(rout_n));

    channel_cordinator cordinator_south(.x_d(x_s), .y_d(y_s), .x_r(x_r), .y_r(y_r), .rout_id(rout_s));

    channel_cordinator cordinator_east(.x_d(x_e), .y_d(y_e), .x_r(x_r), .y_r(y_r), .rout_id(rout_e));

    channel_cordinator cordinator_west(.x_d(x_w), .y_d(y_w), .x_r(x_r), .y_r(y_r), .rout_id(rout_w));


    assign {y_r, x_r} = ROUTER_ID;
    assign {y_l, x_l, y_n, x_n, y_s, x_s, y_e, x_e, y_w, x_w} = {dest_l, dest_n, dest_s, dest_e, dest_w};

endmodule