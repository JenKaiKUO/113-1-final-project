# 113-1-final-project
# 閃躲遊戲
### Authors: 111321077_郭仁楷
### References: 105321010_劉宜甄_105321018_陳湘蕙

## 完成功能
1. 玩家可左右移動
2. 同時有多個掉落物
3. 掉落物有不同速度，位置，大小，顏色
4. 計分制/計時制
5. 碰到扣血/Game Over
6. 新增掉落物(紅色)
7. 新增回血機制(吃紅色掉落物可以回血)



#### Input/Output unit:<br>
* 8x8 LED 矩陣，用來顯示畫面。下圖為按下 clear 的初始畫面。<br>
<img src="https://github.com/kamiry/FPGA-project-1/blob/master/images/IO1.jpg" width="300"/><br>
* 七段顯示器，用來顯示剩餘時間。<br>
<img src="https://github.com/kamiry/FPGA-project-1/blob/master/images/IO2.jpg" width="300"/><br>
* LED 陣列，用來計分。<br>
<img src="https://github.com/kamiry/FPGA-project-1/blob/master/images/IO3.jpg" width="300"/><br>

#### 功能說明:<br>
紅色與藍色玩家對戰，先贏五球 或 在時間結束後最高分者獲勝。<br>

#### 程式模組說明:<br>
module slide_game(output reg[3:0]S //控制亮燈排數,output reg [7:0]Red //紅色燈,output reg [7:0]Green //綠色燈,
output reg [7:0]Blue //藍色燈,output reg [4:0]A_count,B_count //計分,output [6:0]O //倒計時,output reg beep //叫聲,input [1:0]button //玩家一左右,input [1:0]button2 //玩家二左右,input CLk,Clear); <br><br>
*** 請說明各 I/O 變數接到哪個 FPGA I/O 裝置，例如: button, button2 -> 接到 4-bit SW <br>
*** 請加強說明程式邏輯 <br>

#### Demo video:

<a href="https://drive.google.com/file/d/1dsUKFF945moWpXyD0L86eseNf1l3repO/view?usp=sharing" title="Demo Video"><img src="https://github.com/kamiry/FPGA-project-1/blob/master/images/IO4.jpg" alt="Demo Video" width="500"/></a>

