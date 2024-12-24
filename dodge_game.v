module dodge_game(
    output reg [7:0] DATA_R, DATA_G, DATA_B,  // 分別控制紅色、綠色、藍色 LED 的資料輸出
    output reg [6:0] d7_1,                      // 控制 7 段顯示器的輸出
    output reg [2:0] COMM, Life,              // 用於 LED 行選擇與顯示玩家生命
    output reg [1:0] COMM_CLK,                // 控制 LED 行掃描的時鐘信號
    output EN,                                // 啟用信號
    input CLK, clear, Left, Right             // 時鐘、清除信號、左右移動按鍵
);

    // 內部變數宣告
    reg [7:0] plate [7:0];  // 8x8 矩陣，用於記錄掉落物位置
    reg [7:0] people [7:0]; // 8x8 矩陣，用於記錄玩家位置
	 reg [6:0] seg1, seg2;          // 7 段顯示器顯示內容
    reg [3:0] bcd_s, bcd_m; // 計時器的秒數與分鐘
    reg [2:0] random01, random02, random03,  // 生成掉落物隨機位置的隨機數
               r, r1, r2;                    // 掉落物的行索引
    reg [3:0] speed;                         // 控制掉落速度
    reg [2:0] touch;                         // 紀錄玩家碰撞次數
    byte line, count, count1;                // 玩家所在行、計數器
    integer a, b, c;                         // 分別控制三個掉落物的垂直位置
    reg display_time;                        // 顯示秒數/分數的選擇
    segment7 S0(bcd_s, A0,B0,C0,D0,E0,F0,G0);
	 segment7 S1(bcd_m, A1,B1,C1,D1,E1,F1,G1);
	 
    // 不同功能的時鐘分頻信號
    wire CLK_time;  // 控制計時器更新
    wire CLK_div;   // 控制 LED 視覺暫留
    wire CLK_mv;    // 控制掉落物與玩家移動

    // 時鐘分頻模組實例化
    divfreq div0(CLK, CLK_div);   // LED 顯示更新
    divfreq1 div1(CLK, CLK_time); // 計時器更新
    divfreq2 div2(CLK, CLK_mv);   // 遊戲邏輯更新

    // 初始化
    initial begin
        bcd_m = 0;
        bcd_s = 0;
        line = 3;
        random01 = (5 * random01 + 3) % 16;
        r = random01 % 8;
        random02 = (5 * (random02 + 1) + 3) % 16;
        r1 = random02 % 8;
        random03 = (5 * (random03 + 2) + 3) % 16;
        r2 = random03 % 8;
        a = 0;
        b = 0;
        c = 0;
        touch = 0;
        DATA_R = 8'b11111111;
        DATA_G = 8'b11111111;
        DATA_B = 8'b11111111;
        plate[0] = 8'b11111111;
        plate[1] = 8'b11111111;
        plate[2] = 8'b11111111;
        plate[3] = 8'b11111111;
        plate[4] = 8'b11111111;
        plate[5] = 8'b11111111;
        plate[6] = 8'b11111111;
        plate[7] = 8'b11111111;
        people[0] = 8'b11111111;
        people[1] = 8'b11111111;
        people[2] = 8'b11111111;
        people[3] = 8'b00111111;
        people[4] = 8'b11111111;
        people[5] = 8'b11111111;
        people[6] = 8'b11111111;
        people[7] = 8'b11111111;
        count1 = 0;
        //display_time = 1; // 初始化顯示為秒數
        speed = 4'b0001;  // 初始速度
    end

    // 計時&進位 (控制 speed 更新)
    always @(posedge CLK_time or posedge clear) begin
        if (clear) begin
            // 清除時重置計時與速度
            bcd_m <= 3'b000;
            bcd_s <= 4'b0000;
            speed <= 4'b0001;
        end else begin
            if (touch < 3) begin
                if (bcd_s >= 9) begin
                    bcd_s <= 0;
                    bcd_m <= bcd_m + 1;
                    if (speed < 4'b1111)
                        speed <= speed + 1; // 遊戲速度逐漸加快
                end else
                    bcd_s <= bcd_s + 1;
                if (bcd_m >= 9)
                    bcd_m <= 0;
            end
        end
    end

//7段顯示器的視覺暫留
always@(posedge CLK_div)
	begin
		seg1[0] = A0;
		seg1[1] = B0;
		seg1[2] = C0;
		seg1[3] = D0;
		seg1[4] = E0;
		seg1[5] = F0;
		seg1[6] = G0;
		
		seg2[0] = A1;
		seg2[1] = B1;
		seg2[2] = C1;
		seg2[3] = D1;
		seg2[4] = E1;
		seg2[5] = F1;
		seg2[6] = G1;
		
		if(count1 == 0)
			begin
				d7_1 <= seg1;
				COMM_CLK[1] <= 1'b1;
				COMM_CLK[0] <= 1'b0;
				count1 <= 1'b1;
			end
		else if(count1 == 1)
			begin
				d7_1 <= seg2;
				COMM_CLK[1] <= 1'b0;
				COMM_CLK[0] <= 1'b1;
				count1 <= 1'b0;
			end
	end


    // 主畫面的視覺暫留
    always @(posedge CLK_div) begin
        if (count >= 7)
            count <= 0;
        else
            count <= count + 1;
        COMM = count;
        EN = 1'b1;
        if (touch < 3) begin
            DATA_G <= plate[count];
            DATA_R <= people[count];
            if (touch == 0)
                Life <= 3'b111;
            else if (touch == 1)
                Life <= 3'b110;
            else if (touch == 2)
                Life <= 3'b100;
        end else begin
            DATA_R <= plate[count];
            DATA_G <= 8'b11111111;
            Life <= 3'b000;
        end
    end

    // 遊戲
 always @(posedge CLK_mv) begin
        if (clear == 1) begin
            // 遊戲重置
            touch = 0;
            line = 3; // 玩家初始位置在第3行
            a = 0;
            b = 0;
            c = 0;
            random01 = (5 * random01 + 3) % 16;
            r = random01 % 8;
            random02 = (5 * (random02 + 1) + 3) % 16;
            r1 = random02 % 8;
            random03 = (5 * (random03 + 2) + 3) % 16;
            r2 = random03 % 8;
            // 清空掉落物位置
            plate[0] = 8'b11111111;
            plate[1] = 8'b11111111;
            plate[2] = 8'b11111111;
            plate[3] = 8'b11111111;
            plate[4] = 8'b11111111;
            plate[5] = 8'b11111111;
            plate[6] = 8'b11111111;
            plate[7] = 8'b11111111;
            // 初始化玩家位置
            people[0] = 8'b11111111;
            people[1] = 8'b11111111;
            people[2] = 8'b11111111;
            people[3] = 8'b00111111;
            people[4] = 8'b11111111;
            people[5] = 8'b11111111;
            people[6] = 8'b11111111;
            people[7] = 8'b11111111;
        end
        // 如果碰撞次數小於3，遊戲繼續
        if (touch < 3) begin
            // fall object 1
            if (a % speed == 0) begin
                if (a == 0) begin
                    plate[r][a] = 1'b0;
                    a = a + 1;
                end else if (a > 0 && a <= 7) begin
                    plate[r][a - 1] = 1'b1;
                    plate[r][a] = 1'b0;
                    a = a + 1;
                end else if (a == 8) begin
                    plate[r][a - 1] = 1'b1;
                    random01 = (5 * random01 + 3) % 16;
                    r = random01 % 8;
                    a = 0;
                end
            end
            
            // fall object 2
            if (b % speed == 0) begin
                if (b == 0) begin
                    plate[r1][b] = 1'b0;
                    b = b + 1;
                end else if (b > 0 && b <= 7) begin
                    plate[r1][b - 1] = 1'b1;
                    plate[r1][b] = 1'b0;
                    b = b + 1;
                end else if (b == 8) begin
                    plate[r1][b - 1] = 1'b1;
                    random02 = (5 * (random01 + 1) + 3) % 16;
                    r1 = random02 % 8;
                    b = 0;
                end
            end
            
            // fall object 3
            if (c % speed == 0) begin
                if (c == 0) begin
                    plate[r2][c] = 1'b0;
                    c = c + 1;
                end else if (c > 0 && c <= 7) begin
                    plate[r2][c - 1] = 1'b1;
                    plate[r2][c] = 1'b0;
                    c = c + 1;
                end else if (c == 8) begin
                    plate[r2][c - 1] = 1'b1;
                    random03 = (5 * (random01 + 2) + 3) % 16;
                    r2 = random03 % 8;
                    c = 0;
                end
            end
            
            // people move
            if (Right && (line != 7)) begin
                people[line][6] = 1'b1;
                people[line][7] = 1'b1;
                line = line + 1;
            end
            if (Left && (line != 0)) begin
                people[line][6] = 1'b1;
                people[line][7] = 1'b1;
                line = line - 1;
            end
            people[line][6] = 1'b0;
            people[line][7] = 1'b0;
    
            if (plate[line][6] == 0) begin
                touch = touch + 1;
                plate[r][6] = 1'b1;
                plate[r1][6] = 1'b1;
                plate[r2][6] = 1'b1;
                a = 8;
                b = 8;
                c = 8;
            end else if (plate[line][7] == 0) begin
                touch = touch + 1;
                plate[r][7] = 1'b1;
                plate[r1][7] = 1'b1;
                plate[r2][7] = 1'b1;
                a = 8;
                b = 8;
                c = 8;
            end
        end else begin
            // 遊戲結束，顯示 "X"
				plate[0] = 8'b01111110;
				plate[1] = 8'b10111101;
				plate[2] = 8'b11011011;
				plate[3] = 8'b11100111;
				plate[4] = 8'b11100111;
				plate[5] = 8'b11011011;
				plate[6] = 8'b10111101;
				plate[7] = 8'b01111110;
        end
    end
endmodule

// 秒數或分數轉7段顯示器
module segment7(input [3:0] a, output A,B,C,D,E,F,G);
    assign A = ~(a[0]&~a[1]&~a[2] | ~a[0]&a[2] | ~a[1]&~a[2]&~a[3] | ~a[0]&a[1]&a[3]),
           B = ~(~a[0]&~a[1] | ~a[1]&~a[2] | ~a[0]&~a[2]&~a[3] | ~a[0]&a[2]&a[3]),
           C = ~(~a[0]&a[1] | ~a[1]&~a[2] | ~a[0]&a[3]),
           D = ~(a[0]&~a[1]&~a[2] | ~a[0]&~a[1]&a[2] | ~a[0]&a[2]&~a[3] | ~a[0]&a[1]&~a[2]&a[3] | ~a[1]&~a[2]&~a[3]),
           E = ~(~a[1]&~a[2]&~a[3] | ~a[0]&a[2]&~a[3]),
           F = ~(~a[0]&a[1]&~a[2] | ~a[0]&a[1]&~a[3] | a[0]&~a[1]&~a[2] | ~a[1]&~a[2]&~a[3]),
           G = ~(a[0]&~a[1]&~a[2] | ~a[0]&~a[1]&a[2] | ~a[0]&a[1]&~a[2] | ~a[0]&a[2]&~a[3]);
endmodule

// 視覺除頻器
module divfreq(input CLK, output reg CLK_div);
    reg [24:0] Count;
    always @(posedge CLK) begin
        if (Count > 5000) begin
            Count <= 25'b0;
            CLK_div <= ~CLK_div;
        end else
            Count <= Count + 1'b1;
    end
endmodule

// 計時除頻器
module divfreq1(input CLK, output reg CLK_time);
    reg [25:0] Count;
    initial begin
        CLK_time = 0;
    end
    
    always @(posedge CLK) begin
        if (Count > 25000000) begin
            Count <= 25'b0;
            CLK_time <= ~CLK_time;
        end else
            Count <= Count + 1'b1;
    end
endmodule 

// 掉落物&人物移動除頻器
module divfreq2(input CLK, output reg CLK_mv);
    reg [35:0] Count;
    initial begin
        CLK_mv = 0;
    end
    
    always @(posedge CLK) begin
        if (Count > 3500000) begin
            Count <= 35'b0;
            CLK_mv <= ~CLK_mv;
        end else
            Count <= Count + 1'b1;
    end
endmodule