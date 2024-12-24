# 113-1-final-project
# 閃躲遊戲
### Authors: 111321077_郭仁楷
### References: 105321024_許瀚文_105321022_沈哲緯

## 完成功能
1. 玩家可左右移動
2. 同時有多個掉落物
3. 掉落物有不同速度，位置，大小
4. 計分制
5. 碰到扣血/Game Over
6. 新增加速機制(隨著遊戲時間增加，掉落物速度越來越快)


#### Input/Output unit:<br>
*FPGA配置
* 8x8 LED 矩陣，用來顯示遊戲畫面。<br>
<img src="https://github.com/JenKaiKUO/113-1-final-project/blob/73882a70e310f725580134e9ddc53cf97f161d93/%E6%95%B4%E9%AB%94%E9%85%8D%E7%BD%AE.jpg" width="500"/><br>
* LED 陣列，用來顯示玩家血量。<br>
<img src="https://github.com/JenKaiKUO/113-1-final-project/blob/ea3f8c4d48780a2e4082ba9b23bc4865a5d84d0a/%E9%A1%AF%E7%A4%BA%E7%94%9F%E5%91%BD%E5%80%BC.jpg" width="500"/><br>
* 玩家初始血量為3，當玩家碰到掉落物時血量-1，血量為0時遊戲結束，畫面顯示"X"。<br>
<img src="https://github.com/JenKaiKUO/113-1-final-project/blob/9b4113063715d4a7c5a35925cf60c758b0ac0557/%E7%B5%90%E6%9D%9F%E7%95%AB%E9%9D%A2.jpg" width="500"/><br>


#### 程式模組說明:<br>
module slide_game(output reg[3:0]S //控制亮燈排數,output reg [7:0]Red //紅色燈,output reg [7:0]Green //綠色燈,
output reg [7:0]Blue //藍色燈,output reg [4:0]A_count,B_count //計分,output [6:0]O //倒計時,output reg beep //叫聲,input [1:0]button //玩家一左右,input [1:0]button2 //玩家二左右,input CLk,Clear); <br><br>
*** 請說明各 I/O 變數接到哪個 FPGA I/O 裝置，例如: button, button2 -> 接到 4-bit SW <br>
*** 請加強說明程式邏輯 <br>

#### Demo video:
* https://drive.google.com/file/d/1I0IOu6iZooMxrQU9HbarO3l-C_LdoXjv/view?usp=sharing


