# LEDCtrl  
[![Version](https://img.shields.io/github/tag/c0618c/LEDCtrl.svg)](https://github.com/C0618C/LEDCtrl)
[![License:MIT](https://img.shields.io/dub/l/vibe-d.svg)](https://raw.githubusercontent.com/c0618c/LEDCtrl/master/LICENSE)


## 为何有这个东西、这东西想要做些什么  
因为我需要一套能遥控30路灯光亮、灭的控制系统，可以装在模型上面。  
  ![Demo](https://raw.githubusercontent.com/C0618C/LEDCtrl/master/docs/demo.gif)   |  
上图是8×8点阵，有64个LED，将8×8LED模块拆下，接上对应的LED就能将LED分散布置在模型需要灯光的位置上  
  
### 这是用于NodeMCU Luc开发板的一个项目。项目需求为：
* 实现10路灯光控制(已完成)
* 通过Web实现控制（基本完成）
* 通过红外遥控实现控制（目前难点）
  
### 除了上述基本需求外，还有一些备选需求（量力而为），
* 通过安卓/苹果客户端控制
* 灯光亮度调节（基本完成）
* 其它感应器开关，如：人体感应器，磁性，声音，光线等
* 实现30路甚至更多灯光控制（已完成）
* 灯光分组/编程
  
### 当前项目进度、阶段、计划列表
* Web控制LED的功能完善(分组、灯光编程、或呼吸灯、流水灯等)  
* 搞清楚8×8LED点阵模块各个引脚的作用，并改接LED灯珠  
* Server控制接口文档记录及完善  
* 红外控制  

## How To Use - 如何使用
本项目同时包括一个完整的Web控制GPIO电平高低变化的例子。以及有完善的开发、编译、生成等对应的工具，适合新手测试、分析、上手之用。如何做？请耐心看下面指引。  
  
### 固件依赖模块
（暂略，可烧项目中\docs\bin下的bin文件看看）  
### 硬件准备
* NodeMcu x 1
* mirco usb 数据线 x 1
* 杜邦线 x N (非必需)
* MAX7219驱动的8×8点阵模块（SPI通信） x 1 (非必需)
### 软件准备  
* 固件——可以在线编译(https://nodemcu-build.com/) 或使用项目中\docs\bin下的bin文件（包含了本项目所需的必要模块）   
* 固件烧录——https://github.com/nodemcu/nodemcu-flasher
* IDE——https://esp8266.ru/esplorer/ 需要java环境
### 简易步骤
1. 下载本项目代码（建议下载最新的[Releases](https://github.com/C0618C/LEDCtrl/releases)。因为master分支不保证没致命错误。）
1. 将固件烧入nodemcu
1. 执行项目的Release.bat（win系统、Linux或MacOs需自行翻译）
1. 将输出文件夹Release里带后缀的文件通过ESPLorer上传到NodeMcu
1. 在ESPLorer上执行build.lua文件，将NodeMcu上的lua文件编译成lc文件（遇到错误请复位板子重试）
1. 复位板子，在Wifi里找到热点NodeMCU连上，wifi密码：779686611
1. 连上板子的设备上，用最新谷歌浏览器（其它浏览器不作保证）访问http://1.8.8.1/gpio.html ，即可打开gpio测试页
1. 通过操作页面的GPIO4开关，能控制NodeMcu板上的指示灯亮、灭。或其它GPIO的开关改变对应GPIO电平高低变化。若能跟界面一致，则部署成功。
1. 同理，通过访问http://1.8.8.1/ + web文件夹下的html文件名，即可访问对应页面
### 控制点阵
如果需要跟例子一样控制点阵，可以采取下列步骤  
1. 接线（暂略）
1. 访问http://1.8.8.1/matrix.html
注意：仅限通过SPI通信的、MAX7219驱动的8×8点阵模块，其它模块请自行摸索
