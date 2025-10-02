module Mul_Mod (
    input  [22:0] A,
    input  [22:0] B,
    output [23:0] Z
);

    wire [28:0] mult1 = A * B[22:17];
    wire [39:0] mult2 = A * B[16:0];
    wire [45:0] U = (mult1 << 17) + mult2;

    wire [23:0] Y = U[23:0];

    wire [23:0] V = U[45:22];
    wire [24:0] row1;
    wire [9:0]  row2;
    assign row1 = V + V[23:10];
    assign row2 = V[9:0];

    wire [34:0] big1 = {row1, row2};

    wire [25:0] pre_big2 = (V << 1) + V + V[23:1];
    wire [13:0] big2 = pre_big2[25:12];

    wire [34:0] pre_W = big1 + big2;
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
 