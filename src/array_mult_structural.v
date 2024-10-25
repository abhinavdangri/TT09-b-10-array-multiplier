`timescale 1ns / 1ps
// array_mult_structural.v

module array_mult_structural(
    input [3:0] m, // Multiplicand
    input [3:0] q, // Multiplier
    output [7:0] p // Product
);

    // Partial products
    wire pp00, pp01, pp02, pp03;
    wire pp10, pp11, pp12, pp13;
    wire pp20, pp21, pp22, pp23;
    wire pp30, pp31, pp32, pp33;

    // Intermediate sums and carries
    wire s1_1, c1_1;
    wire s1_2, c1_2;
    wire s1_3, c1_3;
    wire s1_4, c1_4;
    wire s2_1, c2_1;
    wire s2_2, c2_2;
    wire s2_3, c2_3;
    wire s3_1, c3_1;
    wire s3_2, c3_2;
    wire c4_1, c4_2;

    // Generate Partial Products
    assign pp00 = m[0] & q[0];
    assign pp01 = m[0] & q[1];
    assign pp02 = m[0] & q[2];
    assign pp03 = m[0] & q[3];

    assign pp10 = m[1] & q[0];
    assign pp11 = m[1] & q[1];
    assign pp12 = m[1] & q[2];
    assign pp13 = m[1] & q[3];

    assign pp20 = m[2] & q[0];
    assign pp21 = m[2] & q[1];
    assign pp22 = m[2] & q[2];
    assign pp23 = m[2] & q[3];

    assign pp30 = m[3] & q[0];
    assign pp31 = m[3] & q[1];
    assign pp32 = m[3] & q[2];
    assign pp33 = m[3] & q[3];

    // Assign the least significant bit
    assign p[0] = pp00;

    // First column of adders
    full_adder fa1_1 (
        .a(pp01),
        .b(pp10),
        .cin(1'b0),
        .sum(p[1]),
        .cout(c1_1)
    );

    full_adder fa1_2 (
        .a(pp02),
        .b(pp11),
        .cin(c1_1),
        .sum(s1_1),
        .cout(c1_2)
    );

    full_adder fa1_3 (
        .a(pp03),
        .b(pp12),
        .cin(c1_2),
        .sum(s1_2),
        .cout(c1_3)
    );

    full_adder fa1_4 (
        .a(1'b0),
        .b(pp13),
        .cin(c1_3),
        .sum(s1_3),
        .cout(c1_4)
    );

    // Second column of adders
    full_adder fa2_1 (
        .a(s1_1),
        .b(pp20),
        .cin(1'b0),
        .sum(p[2]),
        .cout(c2_1)
    );

    full_adder fa2_2 (
        .a(s1_2),
        .b(pp21),
        .cin(c2_1),
        .sum(s2_1),
        .cout(c2_2)
    );

    full_adder fa2_3 (
        .a(s1_3),
        .b(pp22),
        .cin(c2_2),
        .sum(s2_2),
        .cout(c2_3)
    );

    full_adder fa2_4 (
        .a(c1_4),
        .b(pp23),
        .cin(c2_3),
        .sum(s2_3),
        .cout(c2_4)
    );

    // Third column of adders
    full_adder fa3_1 (
        .a(s2_1),
        .b(pp30),
        .cin(1'b0),
        .sum(p[3]),
        .cout(c3_1)
    );

    full_adder fa3_2 (
        .a(s2_2),
        .b(pp31),
        .cin(c3_1),
        .sum(s3_1),
        .cout(c3_2)
    );

    full_adder fa3_3 (
        .a(s2_3),
        .b(pp32),
        .cin(c3_2),
        .sum(s3_2),
        .cout(c3_3)
    );

    full_adder fa3_4 (
        .a(c2_4),
        .b(pp33),
        .cin(c3_3),
        .sum(s3_3),
        .cout(c3_4)
    );

    // Assign the remaining product bits
    assign p[4] = s3_1;
    assign p[5] = s3_2;
    assign p[6] = s3_3;
    assign p[7] = c3_4;

endmodule

// Full Adder Module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
