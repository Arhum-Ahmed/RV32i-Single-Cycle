module main(input logic clk, reset);

    logic [31:0] add_out, add_in, inst, rdata1, rdata2, waddr, wdata, alu_out, se_out,  alu_b, dm_out, m21_pc_in, alu_a, wr_bk;
    logic [3:0] alu_sel, mask;
    logic [2:0] br_type;
    logic [1:0] wb_sel;
    logic cs_dm, rd_dm, sel_alu_b, sel_alu_a, br_o, wren;

    inst_mem Inst_Mem ( .mem_in(add_out[31:2]), .mem_out(inst));
    adder ADD (.pc_in(add_out), .constant(32'd4), .adder_out(add_in));
    mux21 m21_pc ( .a(add_in), .b(alu_out), .sel(br_o), .out(m21_pc_in));
    pc PC (.add_in(m21_pc_in), .clk(clk), .reset(reset), .add_out(add_out));
    reg_file Reg_File ( .raddr1(inst[19:15]), .raddr2(inst[24:20]), .waddr(inst[11:7]), .wdata(wr_bk), .wren(wren), .clk(clk), .reset(reset),.rdata1(rdata1), .rdata2(rdata2));
    imm_gen IMMG (.inst(inst), .se_out(se_out));
    mux21 m21_alu_a (.a(add_out), .b(rdata1), .sel(sel_alu_a), .out(alu_a));
    mux21 m21_alu_b (.a(rdata2), .b(se_out), .sel(sel_alu_b), .out(alu_b));
    Alu ALU ( .operand_a(alu_a), .operand_b(alu_b), .sel(alu_sel), .alu_out(alu_out));
    LSU lsu ( .inst(inst), .alu_out(alu_out[1:0]) , .mask(mask), .cs(cs_dm), .rd(rd_dm));
    data_mem DM ( .addr(alu_out), .data_wr(rdata2), .cs(cs_dm), .rd(rd_dm), .clk(clk), .mask(mask), .data_rd(dm_out) );
    mux31 m31 ( .a(add_out + 32'd4), .b(alu_out), .c(dm_out), .sel(wb_sel) , .out(wr_bk));
    controller CTRL ( .instruction(inst), .wren(wren), .alu_sel(alu_sel), .alu_b_sel(sel_alu_b), .alu_a_sel(sel_alu_a), .br_type(br_type), .wb_sel(wb_sel));
    branch br ( .op_a(rdata1), .op_b(rdata2), .br_type(br_type), .branch_out(br_o));



endmodule