module booth2 (
    input  wire        clk  ,
	input  wire        rst_n,
	input  wire [15:0] x    ,
	input  wire [15:0] y    ,
	input  wire        start,
	output reg [31:0] z    ,
	output wire        busy 
);

reg [16:0] X;
reg [16:0] Y;
reg [33:0] res;
reg [16:0] minusX;
reg [3:0] cnt;
reg       run;
wire[33:0] res1;
wire[33:0] res2;
wire[33:0] res3;
wire[33:0] res4;
wire[16:0] doubleX;
wire[16:0] minusDoubleX;


assign busy = run;
assign res1 = res + {X,17'h0};
assign res2 = res + {minusX,17'h0};
assign res3 = res + {doubleX,17'h0};
assign res4 = res + {minusDoubleX,17'h0};
assign doubleX = {X[15:0],1'b0};
assign minusDoubleX = {minusX[15:0],1'b0};


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) X <= 17'h0;
    else if(start) X <= {x[15],x};
    else X <= X;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) Y <= 17'h0;
    else if(start) Y <= {y[15],y};
    else Y <= Y;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) run <= 0;
    else if(start) run <= 1;
    else if(cnt >= 4'd8) run <= 0;
    else run <= run;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) minusX <= 17'h0;
    else if(start) begin
        minusX <= ~{x[15],x} + 17'h1;
        end
    else minusX <= minusX; 
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) res <= 34'h0;
    else if(start) res <= {17'h0,y,1'h0};
    else if(run && cnt <= 4'd7 ) begin
        case(res[2:0])
            3'b000:begin
                res <= {res[33],res[33],res[33],res[32:2]};
            end
            3'b001:begin
                res <= {res1[33],res1[33],res1[33],res1[32:2]};
            end
            3'b010:begin
                res <= {res1[33],res1[33],res1[33],res1[32:2]};
            end
            3'b011:begin
                res <= {res3[33],res3[33],res3[33],res3[32:2]};
            end
            3'b100:begin
                res <= {res4[33],res4[33],res4[33],res4[32:2]};
            end
            3'b101:begin
                res <= {res2[33],res2[33],res2[33],res2[32:2]};
            end
            3'b110:begin
                res <= {res2[33],res2[33],res2[33],res2[32:2]};
            end
            3'b111:begin
                res <= {res[33],res[33],res[33],res[32:2]};
            end
            default: res <= res;
        endcase
    end
    
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) cnt <= 4'h0;
    else if(start) cnt <= 4'h0;
    else if(run) cnt <= cnt + 1'h1;
    else cnt <= cnt;
end 

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) z <= 32'h0;
    else if(cnt >= 4'd8) z <= res[32:1];
    else z <= z;
end

endmodule