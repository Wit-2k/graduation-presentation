---
theme: default
title: 基于图像识别的数字实验芯片型号自动识别技术研究
info: |
  毕业设计答辩演示稿。
class: px-16 py-10
transition: slide-left
drawings:
  persist: false
mdc: true
---

<div class="h-full flex flex-col justify-between">

<div>
  <p class="text-sm tracking-widest text-sky-700 mb-5">毕业设计答辩</p>
  <h1 class="text-[54px] leading-[1.12] font-semibold text-slate-900 max-w-5xl">
    基于图像识别的数字实验芯片型号自动识别技术研究
  </h1>
  <p class="mt-6 text-[24px] text-slate-500">OpenCV 纯视觉定位 · 本地轻量级 OCR · 离线实时识别</p>
</div>

<div class="grid grid-cols-2 gap-12 text-[18px] leading-8 text-slate-700">
  <div class="border-t border-slate-200 pt-5">
    <p>答辩人：陈智文</p>
    <p>学号：23223976</p>
    <p>专业：电气工程及其自动化</p>
  </div>
  <div class="border-t border-slate-200 pt-5">
    <p>指导教师：董海波 副教授</p>
    <p>电气工程学院 · 中国矿业大学</p>
    <p>2026 年 6 月</p>
  </div>
</div>

</div>

---

<h1 class="text-[42px] leading-tight font-semibold text-slate-900">汇报目录</h1>

<div class="mt-12 grid grid-cols-5 gap-5">
  <div class="border-t-3 border-sky-600 pt-5">
    <p class="text-[20px] font-semibold text-sky-700">01</p>
    <p class="mt-4 text-[22px] leading-snug font-semibold text-slate-900">研究背景<br>与意义</p>
    <p class="mt-4 text-[14px] leading-6 text-slate-500">现场痛点与系统目标</p>
  </div>
  <div class="border-t-3 border-emerald-600 pt-5">
    <p class="text-[20px] font-semibold text-emerald-700">02</p>
    <p class="mt-4 text-[22px] leading-snug font-semibold text-slate-900">方案探索<br>技术选型</p>
    <p class="mt-4 text-[14px] leading-6 text-slate-500">YOLO 到 OpenCV + OCR</p>
  </div>
  <div class="border-t-3 border-amber-500 pt-5">
    <p class="text-[20px] font-semibold text-amber-600">03</p>
    <p class="mt-4 text-[22px] leading-snug font-semibold text-slate-900">系统设计<br>核心实现</p>
    <p class="mt-4 text-[14px] leading-6 text-slate-500">抽帧、定位、缓存、匹配</p>
  </div>
  <div class="border-t-3 border-rose-500 pt-5">
    <p class="text-[20px] font-semibold text-rose-600">04</p>
    <p class="mt-4 text-[22px] leading-snug font-semibold text-slate-900">实验结果<br>分析</p>
    <p class="mt-4 text-[14px] leading-6 text-slate-500">效果、耗时、失败案例</p>
  </div>
  <div class="border-t-3 border-violet-500 pt-5">
    <p class="text-[20px] font-semibold text-violet-700">05</p>
    <p class="mt-4 text-[22px] leading-snug font-semibold text-slate-900">总结<br>展望</p>
    <p class="mt-4 text-[14px] leading-6 text-slate-500">成果闭环与后续优化</p>
  </div>
</div>

<div class="mt-14 border border-dashed border-slate-300 bg-slate-50 px-9 py-6 flex items-center justify-between">
  <div>
    <p class="text-sm tracking-widest text-slate-400">主线</p>
    <p class="mt-2 text-[26px] leading-snug font-semibold text-slate-800">看见芯片，输出标准型号</p>
  </div>
  <p class="text-[16px] leading-7 text-slate-500 max-w-md text-right">
    后续可替换为系统流程总览图或章节路线图。
  </p>
</div>

---

<p class="text-sm tracking-widest text-sky-700">研究背景</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">人工分拣的瓶颈来自小字符与复杂现场</h1>

<div class="mt-7 grid grid-cols-[0.98fr_1.02fr] gap-10 items-start">
<div>

<div class="text-[20px] leading-8 text-slate-800">

- 芯片种类多、周转快，人工核对耗时且容易出错。
- 表面字符小、字迹细暗，光照不均和反光会进一步放大识别难度。
- 云端 OCR 有延迟与隐私顾虑，通用模型难适配实验室非标准场景。

</div>

<div class="mt-7 border-l-4 border-sky-600 pl-5 text-[19px] leading-8 text-slate-700">
目标是构建本地运行、低延迟、易部署的自动识别系统。
</div>

</div>
<div class="h-[345px] border border-dashed border-slate-300 bg-slate-50 flex items-center justify-center text-[18px] text-slate-400">
  后续补图：实验室芯片与拍摄场景
</div>
</div>

---

<p class="text-sm tracking-widest text-emerald-700">方案探索</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">YOLO 小样本方案难以稳定落地</h1>

<div class="mt-7 grid grid-cols-[0.98fr_1.02fr] gap-10 items-start">
<div class="text-[20px] leading-8 text-slate-800">

### 早期尝试

- 使用 YOLO-obb 识别旋转芯片目标。
- 直接输出芯片区域与角度信息。

### 转向原因

- 样本规模不足，复杂光照和陌生背景下漏检明显。
- 核显平台单帧推理超过 500 ms，叠加 OCR 后实时性不足。

</div>
<div class="h-[345px] border border-dashed border-slate-300 bg-slate-50 flex items-center justify-center text-[18px] text-slate-400">
  后续补图：YOLO 与 OpenCV 方案对比
</div>
</div>

---

<p class="text-sm tracking-widest text-emerald-700">技术选型</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">轻量 OCR 与 OpenVINO 兼顾本地部署和低延迟</h1>

<div class="mt-7 grid grid-cols-[1fr_1fr] gap-10 items-start">
<div>

<div class="text-[20px] leading-8 text-slate-800">

- 定位采用 OpenCV 纯视觉流程，避免训练与模型部署开销。
- OCR 采用 PP-OCRv5 mobile，满足本地轻量推理需求。
- RapidOCR 转 ONNX，OpenVINO 针对 Intel CPU 做底层优化。

</div>

<div class="mt-6 grid grid-cols-3 gap-3 text-center">
  <div class="border border-sky-200 bg-sky-50 py-3">
    <p class="text-[28px] font-semibold text-sky-700">470</p>
    <p class="text-xs text-slate-500 mt-1">ms · OpenVINO</p>
  </div>
  <div class="border border-slate-200 py-3">
    <p class="text-[28px] font-semibold text-slate-500">1345</p>
    <p class="text-xs text-slate-500 mt-1">ms · ONNX Runtime</p>
  </div>
  <div class="border border-slate-200 py-3">
    <p class="text-[28px] font-semibold text-slate-500">2039</p>
    <p class="text-xs text-slate-500 mt-1">ms · PyTorch</p>
  </div>
</div>

</div>
<div class="h-[345px] border border-dashed border-slate-300 bg-slate-50 flex items-center justify-center text-[18px] text-slate-400">
  后续补图：模型与推理框架链路
</div>
</div>

---

<p class="text-sm tracking-widest text-amber-600">系统设计</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">系统被拆成采集、定位、识别、规则匹配四段</h1>

<div class="mt-7 grid grid-cols-[0.98fr_1.02fr] gap-10 items-start">
<div class="text-[20px] leading-8 text-slate-800">

- 前端使用 Gradio 与浏览器摄像头抽帧，控制输入频率。
- OpenCV 负责多芯片定位、过滤、排序与透视裁剪。
- FastAPI 推理服务常驻内存，减少重复加载模型成本。
- 规则库将 OCR 原始文本映射为标准芯片型号。

</div>
<div class="h-[345px] border border-dashed border-slate-300 bg-slate-50 flex items-center justify-center text-[18px] text-slate-400">
  后续补图：系统总体架构图
</div>
</div>

---

<p class="text-sm tracking-widest text-amber-600">核心机制 01</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">帧差让推理只在有必要时触发</h1>

<div class="mt-7 grid grid-cols-[0.98fr_1.02fr] gap-10 items-start">
<div>

<div class="text-[20px] leading-8 text-slate-800">

- 浏览器每 1 秒抽取关键帧，避免持续视频流传输。
- 后端计算平均亮度差和显著变化像素比例，判断画面是否稳定。
- 画面稳定且上帧结果已匹配时，直接复用历史识别结果。

</div>

<div class="mt-7 border-l-4 border-amber-500 pl-5 text-[19px] leading-8 text-slate-700">
连续视频被转换为按需触发的识别请求，减少无效推理。
</div>

</div>
<div class="h-[345px] border border-dashed border-slate-300 bg-slate-50 flex items-center justify-center text-[18px] text-slate-400">
  后续补图：帧差判断流程
</div>
</div>

---

<p class="text-sm tracking-widest text-amber-600">核心机制 02</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">多路掩码比单一阈值更适合实验室光照</h1>

<div class="mt-7 grid grid-cols-[0.98fr_1.02fr] gap-10 items-start">
<div class="text-[20px] leading-8 text-slate-800">

- 灰度化与对比度增强提升芯片边界可见性。
- 暗区掩码与边缘结构掩码共同生成候选区域。
- 轮廓经过面积、长宽比、填充率和特征评分过滤。
- NMS 去重后排序，输出背景干净的标准化裁剪图。

</div>
<div class="h-[345px] border border-dashed border-slate-300 bg-slate-50 flex items-center justify-center text-[18px] text-slate-400">
  后续补图：多芯片定位与分割效果
</div>
</div>

---

<p class="text-sm tracking-widest text-amber-600">核心机制 03</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">缓存与多变体预处理共同降低排队延迟</h1>

<div class="mt-7 grid grid-cols-[0.98fr_1.02fr] gap-10 items-start">
<div class="text-[20px] leading-8 text-slate-800">

- 单芯片缓存使用 IoU 与灰度指纹双重约束，避免位置未变时重复 OCR。
- 只对发生位移或识别失败的芯片重新推理。
- 预处理生成原图、放大、CLAHE、laser_dark、黑帽增强等变体。
- 优先使用 laser_dark，失败后再自动回退。

</div>
<div class="h-[345px] border border-dashed border-slate-300 bg-slate-50 flex items-center justify-center text-[18px] text-slate-400">
  后续补图：缓存命中与预处理变体
</div>
</div>

---

<p class="text-sm tracking-widest text-amber-600">核心机制 04</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">规则库把 OCR 文本收敛为标准型号</h1>

<div class="mt-7 grid grid-cols-[0.98fr_1.02fr] gap-10 items-start">
<div>

<div class="text-[20px] leading-8 text-slate-800">

- OCR 原始结果常见字符缺失、空格干扰和 0/O、1/I 混淆。
- CSV 作为人工维护源，SQLite 作为运行时缓存。
- 正则清洗后按优先级匹配 74 系列、CD 系列等命名规律。
- 未匹配文本保留，便于后续人工补充规则。

</div>

<div class="mt-6 text-[18px] text-slate-600">
示例输出：<span class="font-mono text-[20px] text-slate-900">SN74LS138N</span>
</div>

</div>
<div class="h-[345px] border border-dashed border-slate-300 bg-slate-50 flex items-center justify-center text-[18px] text-slate-400">
  后续补图：规则匹配与标准化流程
</div>
</div>

---

<p class="text-sm tracking-widest text-rose-600">实验结果</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">多芯片场景下定位与识别达到可用水平</h1>

<div class="mt-7 grid grid-cols-[0.98fr_1.02fr] gap-10 items-start">
<div>

<div class="text-[20px] leading-8 text-slate-800">

- 测试环境：海康威视摄像头 2560 × 1440，Intel i5-12500H 核显。
- 单帧分割耗时约 300-500 ms，且不随芯片数量线性增加。
- laser_dark 变体可增强激光打标字符，提升 OCR 原始文本质量。

</div>

<div class="mt-7 border-l-4 border-rose-500 pl-5 text-[19px] leading-8 text-slate-700">
系统重点是在受限算力下稳定跑完整链路，而不是追求单模型极限精度。
</div>

</div>
<div class="h-[345px] border border-dashed border-slate-300 bg-slate-50 flex items-center justify-center text-[18px] text-slate-400">
  后续补图：分割结果与识别效果
</div>
</div>

---

<p class="text-sm tracking-widest text-rose-600">耗时分析</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">帧差与缓存显著压缩后端请求量</h1>

<div class="mt-7 grid grid-cols-[0.98fr_1.02fr] gap-10 items-start">
<div>

<div class="text-[20px] leading-8 text-slate-800">

- 分割约 300 ms，OCR 推理约 450 ms。
- 连续并发模式 10 秒内请求 9-11 次，易形成积压。
- 帧差 + 缓存将请求压缩到 3-5 次，交互更接近准实时。

</div>

<div class="mt-6 grid grid-cols-2 gap-4 text-center">
  <div class="border border-slate-200 py-4">
    <p class="text-[34px] font-semibold text-slate-500">9-11</p>
    <p class="text-[15px] text-slate-500 mt-1">连续并发请求</p>
  </div>
  <div class="border border-sky-200 bg-sky-50 py-4">
    <p class="text-[34px] font-semibold text-sky-700">3-5</p>
    <p class="text-[15px] text-slate-500 mt-1">帧差 + 缓存请求</p>
  </div>
</div>

</div>
<div class="h-[345px] border border-dashed border-slate-300 bg-slate-50 flex items-center justify-center text-[18px] text-slate-400">
  后续补图：请求次数与耗时对比
</div>
</div>

---

<p class="text-sm tracking-widest text-rose-600">局限分析</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">主要失败来自几何边界与极端成像条件</h1>

<div class="mt-7 grid grid-cols-[0.98fr_1.02fr] gap-10 items-start">
<div class="text-[20px] leading-8 text-slate-800">

- 贴边芯片轮廓不完整，易被几何过滤剔除。
- 光照极弱时字符对比度不足，OCR 特征难以提取。
- 芯片距离过近时，形态学闭运算可能合并相邻目标。
- 大角度大尺寸芯片会混入更多背景，导致评分下降。

</div>
<div class="h-[345px] border border-dashed border-slate-300 bg-slate-50 flex items-center justify-center text-[18px] text-slate-400">
  后续补图：失败案例汇总
</div>
</div>

---

<p class="text-sm tracking-widest text-violet-700">总结与展望</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">本文完成了从视觉定位到标准输出的闭环</h1>

<div class="mt-7 grid grid-cols-2 gap-12 items-start">
<div class="text-[20px] leading-8 text-slate-800">

### 主要工作

- 提出 OpenCV 纯视觉定位与本地轻量 OCR 的工程方案。
- 设计帧差判断、灰度指纹缓存和多变体预处理机制。
- 构建 CSV-SQLite 规则库，实现标准型号输出。

</div>
<div class="text-[20px] leading-8 text-slate-800">

### 后续方向

- 引入旋转框评分与引脚辅助特征，减少大角度漏检。
- 增加异步推理队列与 INT8 量化，进一步降低延迟。
- 使用模糊匹配与编辑距离，降低规则维护成本。

</div>
</div>

---
layout: center
class: text-center
---

<p class="text-sm tracking-widest text-sky-700 mb-6">致谢</p>

<h1 class="text-[48px] leading-tight font-semibold text-slate-900">谢谢各位专家</h1>

<div class="mt-8 text-[24px] leading-10 text-slate-700">
  <p>感谢董海波副教授的悉心指导。</p>
  <p>感谢电气工程学院各位老师的培养。</p>
  <p>恳请各位专家批评指正。</p>
</div>

<p class="mt-14 text-[46px] font-semibold text-slate-900">Q & A</p>
