module iic_infrastructure(
    output sda_i,
    input  sda_o,
    input  sda_t,
    output scl_i,
    input  scl_o,
    input  scl_t,
    inout  sda,
    inout  scl
  );
  IOBUF iobuf_sda(
    .O (sda_i),
    .IO(sda),
    .I (sda_o),
    .T (sda_t)
  );
  IOBUF iobuf_scl(
    .O (scl_i),
    .IO(scl),
    .I (scl_o),
    .T (scl_t)
  );
endmodule
