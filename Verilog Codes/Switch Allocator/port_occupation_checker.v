module port_occupation_checker(req_port_local, req_port_west, req_port_north, req_port_east, req_port_south,
                               grant_local, grant_west, grant_north, grant_east, grant_south, load_reg);

    input req_port_local, req_port_west, req_port_north, req_port_east, req_port_south,
        grant_local, grant_west, grant_north, grant_east, grant_south;

    output load_reg;

    wire port_not_occupied, port_got_released;

    assign port_not_occupied = ~( grant_local | grant_west | grant_north | grant_east | grant_south );

    assign port_got_released =  ~((req_port_local & grant_local) | (req_port_west & grant_west) | (req_port_north & grant_north) | (req_port_east & grant_east) | (req_port_south & grant_south));

    assign load_reg = port_got_released | port_not_occupied;

endmodule