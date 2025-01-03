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
* FPGA配置
* 8x8 LED 矩陣，用來顯示遊戲畫面。<br>
<img src="https://github.com/JenKaiKUO/113-1-final-project/blob/73882a70e310f725580134e9ddc53cf97f161d93/%E6%95%B4%E9%AB%94%E9%85%8D%E7%BD%AE.jpg" width="500"/><br>
* LED 陣列，用來顯示玩家血量。<br>
<img src="https://github.com/JenKaiKUO/113-1-final-project/blob/ea3f8c4d48780a2e4082ba9b23bc4865a5d84d0a/%E9%A1%AF%E7%A4%BA%E7%94%9F%E5%91%BD%E5%80%BC.jpg" width="500"/><br>
* 玩家初始血量為3，當玩家碰到掉落物時血量-1，血量為0時遊戲結束，畫面顯示"X"。<br>
<img src="https://github.com/JenKaiKUO/113-1-final-project/blob/9b4113063715d4a7c5a35925cf60c758b0ac0557/%E7%B5%90%E6%9D%9F%E7%95%AB%E9%9D%A2.jpg" width="500"/><br>


#### 程式模組說明:<br>
### 輸入輸出變數（I/O Variables）
1. **輸出變數**:
   - `DATA_R, DATA_G, DATA_B`: 控制遊戲中的 LED 矩陣顯示，顯示玩家的位置、掉落物的位置。
   - `d7_1`: 控制 7 段顯示器的顯示，顯示遊戲中的時間。
   - `COMM`: 控制 8x8 LED 矩陣的行選擇。通過這個變數來切換顯示的行。
   - `Life`: 顯示玩家的血量在 7 段顯示器上。
   - `COMM_CLK`: 控制 LED 行掃描的clock信號。
   - `EN`: 啟用信號，用來啟動顯示8x8 LED 矩陣。

2. **輸入變數**:
   - `CLK`: 時鐘信號，用於驅動所有模組的更新。
   - `clear`: 清除信號，輸入 1 時，重置遊戲狀態。
   - `Left, Right`: 左右移動按鍵，控制玩家移動。

### 內部變數：
1. `plate[7:0]`: 8x8 矩陣，用於記錄掉落物的位置。每一行表示一個掉落物的位置，1 表示該位置有掉落物，0 則表示空白。
2. `people[7:0]`: 8x8 矩陣，用於記錄玩家的位置。
3. `seg1, seg2`: 用來顯示秒數和分鐘的 7 段顯示器。
4. `bcd_s, bcd_m`: 計時器的秒數和分鐘數。
5. `random01, random02, random03`: 隨機數，用於生成掉落物的隨機位置。
6. `r, r1, r2`: 掉落物的行索引。
7. `speed`: 控制掉落物的速度，隨著遊戲進行逐漸加快。
8. `touch`: 紀錄玩家的碰撞次數，一旦達到 3 次，遊戲結束。

### 程式邏輯：
1. **時鐘分頻**：
   - `CLK_time`, `CLK_div`, 和 `CLK_mv` 分別用於計時、LED 更新和遊戲邏輯更新。這些時鐘分頻模組會確保遊戲中各部分的更新頻率是合理的。

2. **初始化**：
   - 遊戲開始時，所有的計時器、掉落物、玩家位置和其他內部變數都會被初始化。

3. **計時與進位邏輯**：
   - 每當 `CLK_time` 發生邊緣觸發，計時器會增加，並且根據秒數更新遊戲速度（`speed`）。當秒數達到 9 時，分鐘數會增加，並且遊戲速度會逐漸加快。

4. **7段顯示器更新**：
   - 每當 `CLK_div` 發生邊緣觸發，7 段顯示器的內容會更新。這個模組負責顯示時間或分數，並進行視覺暫留，以顯示遊戲狀態。

5. **主畫面更新**：
   - 根據玩家的碰撞次數（`touch`），更新遊戲畫面。當玩家未碰撞時，顯示掉落物和玩家位置，並根據剩餘生命顯示不同的 LED。

6. **遊戲邏輯**：
   - 當 `CLK_mv` 時鐘信號觸發時，遊戲邏輯會更新。這包括掉落物的移動、玩家的移動、以及檢查玩家是否碰撞。若碰撞次數達到 3 次，則遊戲結束並顯示遊戲結束畫面。

### I/O 接線：
- **按鍵**：
   - `Left, Right`: 這些按鍵連接到 FPGA 的按鍵，控制玩家的左右移動。
   
- **顯示**：
   - `DATA_R, DATA_G, DATA_B`: 連接到 8x8 LED 矩陣。
   - `d7_1`: 連接到 7 段顯示器，顯示時間和分數。
   - `COMM, Life`: 連接到 LED 。

- **其他控制信號**：
   - `EN`: 啟用信號，可能接到其他顯示模組的使能端，控制顯示啟動。

### 除頻器：
- `divfreq`, `divfreq1`, 和 `divfreq2` 三個時鐘分頻模組用來分別控制遊戲的不同更新區域（計時、LED 顯示更新和遊戲邏輯更新）。

#### Demo video:
* https://drive.google.com/file/d/1I0IOu6iZooMxrQU9HbarO3l-C_LdoXjv/view?usp=sharing


