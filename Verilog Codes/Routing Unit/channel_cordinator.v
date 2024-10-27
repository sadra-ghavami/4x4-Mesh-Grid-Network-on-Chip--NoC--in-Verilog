module channel_cordinator (x_d, y_d, x_r, y_r, rout_id);
    input[1:0] x_d, y_d, x_r, y_r;
    output reg[2:0] rout_id;

    localparam[2:0] LOCAL_CHANNEL_ID = 3'b000, NORTH_CHANNEL_ID = 3'b001, SOUTH_CHANNEL_ID = 3'b010, EAST_CHANNEL_ID = 3'b011, WEST_CHANNEL_ID = 3'b100; 

    always@(*) begin

        if( (x_d == x_r) & (y_d == y_r))
            rout_id = LOCAL_CHANNEL_ID;

        else if( x_d < x_r )
            rout_id = WEST_CHANNEL_ID;

        else if( x_d > x_r )
            rout_id = EAST_CHANNEL_ID;

        else if( y_d < y_r )
            rout_id = NORTH_CHANNEL_ID;

        else if( y_d > y_r )
            rout_id = SOUTH_CHANNEL_ID;

        else
            rout_id = LOCAL_CHANNEL_ID;

    end
endmodule