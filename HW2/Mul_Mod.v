module Adder64_RCA4(
    input  [63:0] x,
    input  [63:0] y,
    input 	   c_in,
    output [63:0] s,
    output    c_out
);
    wire c_1, c_2, c_3, c_4, c_5, c_6, c_7, c_8, c_9, c_10, c_11, c_12, c_13, c_14, c_15;
    RCA  fa0_3 (.x(x[3:0]),   .y(y[3:0]),   .c_in(c_in), .s(s[3:0]), .c_out(c_1));
    RCA  fa4_7 (.x(x[7:4]),   .y(y[7:4]),   .c_in(c_1), .s(s[7:4]), .c_out(c_2));
    RCA  fa8_11(.x(x[11:8]),  .y(y[11:8]),  .c_in(c_2), .s(s[11:8]), .c_out(c_3));
    RCA fa12_15(.x(x[15:12]), .y(y[15:12]), .c_in(c_3), .s(s[15:12]), .c_out(c_4));
    RCA fa16_19(.x(x[19:16]), .y(y[19:16]), .c_in(c_4), .s(s[19:16]), .c_out(c_5));
    RCA fa20_23(.x(x[23:20]), .y(y[23:20]), .c_in(c_5), .s(s[23:20]), .c_out(c_6));
    RCA fa24_27(.x(x[27:24]), .y(y[27:24]), .c_in(c_6), .s(s[27:24]), .c_out(c_7));
    RCA fa28_31(.x(x[31:28]), .y(y[31:28]), .c_in(c_7), .s(s[31:28]), .c_out(c_8));
    RCA fa32_35(.x(x[35:32]), .y(y[35:32]), .c_in(c_8), .s(s[35:32]), .c_out(c_9));
    RCA fa36_39(.x(x[39:36]), .y(y[39:36]), .c_in(c_9), .s(s[39:36]), .c_out(c_10));
    RCA fa40_43(.x(x[43:40]), .y(y[43:40]), .c_in(c_10), .s(s[43:40]), .c_out(c_11));
    RCA fa44_47(.x(x[47:44]), .y(y[47:44]), .c_in(c_11), .s(s[47:44]), .c_out(c_12));
    RCA fa48_51(.x(x[51:48]), .y(y[51:48]), .c_in(c_12), .s(s[51:48]), .c_out(c_13));
    RCA fa52_55(.x(x[55:52]), .y(y[55:52]), .c_in(c_13), .s(s[55:52]), .c_out(c_14));
    RCA fa56_59(.x(x[59:56]), .y(y[59:56]), .c_in(c_14), .s(s[59:56]), .c_out(c_15));
    RCA fa60_63(.x(x[63:60]), .y(y[63:60]), .c_in(c_15), .s(s[63:60]), .c_out(c_out));
endmodule

module Mul_Mod (
    input  [22:0] A,
    input  [22:0] B,
    output [23:0] Z
);
    
    wire [28:0] pre_mult1 = (A * B[22:17]);
    wire [45:0] mult1 = pre_mult1  << 17;
    wire [39:0] mult2 = A * B[16:0];
    // // // wire [45:0] U = mult1 + mult2;
    wire [63:0] adder1_s;
    Adder64_RCA4 adder1(.x({18'b0, mult1}), .y({24'b0, mult2}), .c_in(1'b0), .s(adder1_s), .c_out());
    wire [45:0] U = adder1_s[45:0];
    // // //
    wire [23:0] Y = U[23:0];
    wire [23:0] V = U[45:22];
    wire [24:0] row1;
    wire [9:0]  row2;
    // // // assign row1 = V + V[23:10];
    wire [63:0] adder2_s;
    Adder64_RCA4 adder2(.x({40'b0, V}), .y({50'b0, V[23:10]}), .c_in(1'b0), .s(adder2_s), .c_out());
    assign row1 = adder2_s[24:0];
    // // //
    assign row2 = V[9:0];
    wire [34:0] big1 = {row1, row2};

    // // // wire [25:0] pre_big2 = (V << 1) + V + V[23:1];
    wire [24:0] V_sll = (V << 1);
    wire [63:0] adder3_s;
    wire [63:0] adder4_s;
    Adder64_RCA4 adder3(.x({39'b0, V_sll}), .y({40'b0, V}), .c_in(1'b0), .s(adder3_s), .c_out());
    Adder64_RCA4 adder4(.x(adder3_s), .y({41'b0, V[23:1]}), .c_in(1'b0), .s(adder4_s), .c_out());
    wire [25:0] pre_big2 = adder4_s[25:0];
    // // //
    wire [13:0] big2 = pre_big2[25:12];

    // // // wire [34:0] pre_W = big1 + big2;
    wire [63:0] adder5_s;
    Adder64_RCA4 adder5(.x({29'b0, big1}), .y({50'b0, big2}), .c_in(1'b0), .s(adder5_s), .c_out());
    wire [34:0] pre_W = adder5_s[34:0];
    // // //

    // W 分開
    wire [23:0] W = pre_W[34:11];
    wire [10:0] sub1 = W[23:13] - W[10:0];
    wire [23:0] X;
    assign X[12:0] = W[12:0];
    assign X[22:13] = sub1[9:0];
    assign X[23] = sub1[10] ^ W[0];
    // concat 合併成X 完畢

    // Y[23:0] 減掉 X[23:0]
    wire [23:0] sub2 = Y - X;
    localparam [23:0] Q = 24'd8380417;
    // wire [23:0] sub3 = sub2 - Q;
    wire [24:0] sub3 = {1'b0, sub2} - {1'b0, Q};
    assign Z = sub3[24] ? sub2 : sub3[23:0];

endmodule
 