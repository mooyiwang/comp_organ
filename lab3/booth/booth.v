module booth (
    input  wire        clk  ,
	input  wire        rst_n,
	input  wire [15:0] x    ,
	input  wire [15:0] y    ,
	input  wire        start,
	output reg  [31:0] z    ,
	output wire        busy 
);

reg [15:0] X;
reg [15:0] Y;
reg [32:0] res;
reg [15:0] minusX;
reg [4:0] cnt;
reg       run;
wire[32:0] res1;
wire[32:0] res2;


assign busy = run;
assign res1 = res + {X,17'h0};
assign res2 = res + {minusX,17'h0};


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) X <= 16'h0;
    else if(start) X <= x;
    else X <= X;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) Y <= 16'h0;
    else if(start) Y <= y;
    else Y <= Y;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) run <= 0;
    else if(start) run <= 1;
    else if(cnt >= 5'd16) run <= 0;
    else run <= run;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) minusX <= 16'h0;
    else if(start) begin
        minusX <= ~x + 16'h1;
        end
    else minusX <= minusX; 
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) res <= 33'h0;
    else if(start) res <= {16'h0,y,1'h0};
    else if(run && cnt <= 5'd15 ) begin
        case(res[1:0])
            2'b00:begin
                res <= {res[32],res[32],res[31:1]};
            end
            2'b01:begin
                res <= {res1[32],res1[32],res1[31:1]};
            end
            2'b10:begin
                res <= {res2[32],res2[32],res2[31:1]};
            end
            2'b11:begin
                res <= {res[32],res[32],res[31:1]};
            end
            default: res <= res;
        endcase
    end
    
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) cnt <= 5'h0;
    else if(start) cnt <= 5'h0;
    else if(run) cnt <= cnt + 1'h1;
    else cnt <= cnt;
end 

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) z <= 32'h0;
    else if(cnt >= 5'd16) z <= res[32:1];
    else z <= z;
end
endmodule