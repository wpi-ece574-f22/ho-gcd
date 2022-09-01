module gcd(
    input wire[7:0] a,
    input wire[7:0] b,
    input wire ld,
    input wire clk,
    input wire reset,
    output wire[7:0] q,
    output wire rdy);

    reg [7:0] areg, areg_next;
    reg [7:0] breg, breg_next;

    reg [7:0] qvar;
    reg rdyvar;

    localparam Sidle = 0, Sactive = 1;

    reg state, state_next;

    always @(posedge clk, posedge reset)
       if (reset)
          begin
          state <= Sidle;
          areg  <= 8'b0;
          breg  <= 8'b0;
          end
       else
          begin
          state <= state_next;
          areg  <= areg_next;
          breg  <= breg_next;
          end

    assign rdy = rdyvar;
    assign q   = qvar;

    always @(*)
      begin
      areg_next  = areg;
      breg_next  = breg;
      state_next = state;
      qvar       = 8'd0;
      rdyvar     = 1'd0;

      case (state)

        Sidle:
          if (ld)
            begin
            areg_next = a;
            breg_next = b;
            state_next = Sactive;
            end

        Sactive:
          if (areg == breg)
             begin
             state_next = Sidle;
             qvar       = areg;
             rdyvar     = 1'b1;
             end
          else
             begin
             areg_next = (areg > breg) ? areg - breg : areg;
             breg_next = (breg > areg) ? breg - areg : breg;
             end

        default:
          state_next = Sidle;

      endcase
      end
      
endmodule
