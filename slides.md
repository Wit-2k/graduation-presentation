---
# 以 default 主题作为中性底座；具体层级由本文件的 UnoCSS 工具类控制，减少主题切换带来的版式漂移。
theme: default
title: 基于图像识别的数字实验芯片型号自动识别技术研究
info: |
  毕业设计答辩演示稿。
# 固定画布内边距，保证长中文标题和后续图表占位都落在 16:9 导出的安全区域内。
class: px-16 py-10
# 答辩场景以信息推进为主，统一转场可以避免技术章节之间出现多余的视觉噪声。
transition: slide-left
# 临场批注默认不写回文件，避免排练标记意外进入导出的评审版本。
drawings:
  persist: false
# 正文混用 Markdown 与 HTML，是为了让图表占位后续能直接替换为可控的组件或图片。
mdc: true
---

<!-- 封面使用显式字号和行高，是为了让长中文题目在浏览器预览、PDF 和 PPTX 导出中保持可预测换行。 -->
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
title: 目录
---

<!-- 目录采用五列提纲，是为了在单页 16:9 画布内完整露出全部章节，避免纵向目录在预览时裁掉最后一节。 -->
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
  <p class="text-[16px] leading-7 text-slate-500 max-w-lg text-left -translate-x-6">
    <a href="#" @click.prevent="$nav.go(16)" class="text-[21px] font-semibold text-sky-700 underline underline-offset-4">
      系统流程总览
    </a>
  </p>
</div>

---
title: 研究背景
---

<!-- 正文页统一使用可控两栏网格：左侧保持简短阅读路径，右侧预留稳定的后续图表替换区域。 -->
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
<div class="-mt-4 h-[345px] flex items-center justify-center">
  <img src="./assets/实验室实拍.jpg">
</div>
</div>

---
title: 方案探索
---

<p class="text-sm tracking-widest text-emerald-700">方案探索</p>
<!-- 方案页保留到漏检补充页的跳转，是为了答辩追问时能快速展开失败样例。 -->
<div class="mt-3 flex items-start justify-between gap-6">
  <h1 class="text-[40px] leading-tight font-semibold text-slate-900">YOLO 小样本方案难以稳定落地</h1>
  <button class="mt-2 shrink-0 border border-rose-200 bg-white/70 px-4 py-2 text-[16px] font-medium text-rose-700 hover:bg-rose-50" @click="$nav.go(17)">查看漏检问题</button>
</div>

<div class="mt-7 grid grid-cols-[0.98fr_1.02fr] gap-10 items-start">
<div class="text-[20px] leading-8 text-slate-800">

### 早期尝试

- 使用 YOLO-obb 识别旋转芯片目标。
- 直接输出芯片区域与角度信息。

### 转向原因

- 样本规模不足，复杂光照和陌生背景下漏检明显。
- 核显平台单帧推理超过 500 ms，叠加 OCR 后实时性不足。

</div>
<!-- 表格直接由浏览器渲染，是为了避免 Word 截图在导出时出现压缩、锯齿和背景残留。 -->
<div class="min-h-[345px] flex flex-col justify-center">
  <p class="mb-4 whitespace-nowrap text-center text-[15px] leading-snug text-slate-600">
    模型在不同分辨率输入下的表现，s是检出率，t是耗时（单位：毫秒）
  </p>
  <table class="three-line-table">
  <thead>
    <tr>
      <th>分辨率</th>
      <th>图 1</th>
      <th>图 2</th>
      <th>图 3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td class="resolution-cell">2560×1440</td>
      <td><span>s: 2/3</span><span>t: 544.4</span></td>
      <td><span>s: 2/4</span><span>t: 569.6</span></td>
      <td><span>s: 2/2</span><span>t: 568.8</span></td>
    </tr>
    <tr>
      <td class="resolution-cell">1920×1080</td>
      <td><span>s: 2/3</span><span>t: 470.8</span></td>
      <td><span>s: 3/4</span><span>t: 545.2</span></td>
      <td><span>s: 2/2</span><span>t: 481.1</span></td>
    </tr>
    <tr>
      <td class="resolution-cell">1280×720</td>
      <td><span>s: 2/3</span><span>t: 412.8</span></td>
      <td><span>s: 2/4</span><span>t: 400.2</span></td>
      <td><span>s: 2/2</span><span>t: 420.9</span></td>
    </tr>
  </tbody>
</table>
</div>
</div>

<style>
.three-line-table {
  width: 100%;
  border-collapse: collapse;
  table-layout: fixed;
  border-top: 2px solid #0f172a;
  border-bottom: 2px solid #0f172a;
  background: transparent;
  font-size: 17px;
  line-height: 1.35;
  color: #1e293b;
}

.three-line-table thead {
  border-bottom: 1.5px solid #0f172a;
}

.three-line-table tr {
  border: 0 !important;
  background: transparent !important;
}

.three-line-table th,
.three-line-table td {
  border: 0 !important;
  background: transparent !important;
  padding: 10px 8px;
  text-align: center;
  vertical-align: middle;
}

.three-line-table th {
  font-weight: 600;
}

.three-line-table td {
  padding-top: 13px;
  padding-bottom: 13px;
}

.three-line-table td span {
  display: block;
}

.three-line-table td span + span {
  margin-top: 6px;
  color: #475569;
}

.three-line-table .resolution-cell {
  width: 27%;
  font-weight: 600;
  white-space: nowrap;
  color: #0f172a;
}
</style>

---
title: 技术选型
---

<p class="text-sm tracking-widest text-emerald-700">技术选型</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">轻量 OCR 与 OpenVINO 兼顾本地部署和低延迟</h1>

<div class="mt-7 grid grid-cols-[0.95fr_1.05fr] gap-8 items-start">
<div>

<div class="text-[19px] leading-7 text-slate-800">

- 定位采用 OpenCV 纯视觉流程，避免训练与模型部署开销。
- OCR 采用 PP-OCRv5 mobile，满足本地轻量推理需求。
- RapidOCR 转 ONNX，OpenVINO 针对 Intel CPU 做底层优化。

</div>

<div class="mt-4 grid grid-cols-3 gap-3 text-center">
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
<!-- 模型配置表用 HTML 重建，是为了让长模型名在导出时保持矢量文字与可控换行。 -->
<div class="min-h-[345px] -mt-8 flex flex-col justify-center">
  <div class="w-[108%] -translate-x-[4%]">
  <p class="mb-4 whitespace-nowrap text-center text-[15px] leading-snug text-slate-600">
    模型结构概览
  </p>
  <table class="model-config-table">
    <thead>
      <tr>
        <th>模型名</th>
        <th>算法</th>
        <th>Backbone</th>
        <th>Neck</th>
        <th>Head</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td class="model-name-cell"><span>PP-</span><span>OCRv5_mobile_det</span></td>
        <td>DB</td>
        <td>PP-LCNetV3</td>
        <td>RSEFPN</td>
        <td>DBHead</td>
      </tr>
      <tr>
        <td class="model-name-cell"><span>PP-</span><span>OCRv5_mobile_rec</span></td>
        <td><span>SVTR_</span><span>LCNet</span></td>
        <td>PP-LCNetV3</td>
        <td>/</td>
        <td class="head-cell"><span>CTCHead +</span><span>NRTRHead</span></td>
      </tr>
    </tbody>
  </table>
  </div>
</div>
</div>

<style>
.model-config-table {
  width: 100%;
  border-collapse: collapse;
  table-layout: fixed;
  border-top: 2px solid #0f172a !important;
  border-bottom: 2px solid #0f172a !important;
  background: transparent;
  font-size: 14px;
  line-height: 1.35;
  color: #1e293b;
}

.model-config-table thead {
  border-bottom: 1.5px solid #0f172a !important;
}

.model-config-table tr,
.model-config-table th,
.model-config-table td {
  border: 0 !important;
  background: transparent !important;
}

.model-config-table th,
.model-config-table td {
  padding-right: 6px;
  padding-left: 6px;
  text-align: center;
  vertical-align: middle;
  white-space: nowrap;
}

.model-config-table th {
  font-weight: 600;
}

.model-config-table th:nth-child(1) {
  width: 25%;
}

.model-config-table th:nth-child(2),
.model-config-table th:nth-child(4) {
  width: 16%;
}

.model-config-table th:nth-child(5) {
  width: 22%;
}

.model-config-table th:nth-child(3) {
  width: 21%;
}

.model-config-table td {
  padding-top: 18px;
  padding-bottom: 18px;
}

.model-config-table td span {
  display: block;
}

.model-config-table td span + span {
  margin-top: 4px;
  color: inherit;
}

.model-config-table .model-name-cell {
  font-weight: 600;
}
</style>

---
title: 系统设计
---

<p class="text-sm tracking-widest text-amber-600">系统设计</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">系统被拆成采集、定位、识别、规则匹配四段</h1>

<!-- 四张职责卡片替代架构占位图，是为了和目录中的系统流程图形成互补：这里强调模块分工而不是完整流程。 -->
<div class="mt-8 grid grid-cols-2 gap-5">
  <div class="min-h-[155px] rounded-[6px] border border-sky-100 bg-sky-50/80 p-6">
    <p class="text-[18px] font-semibold text-sky-800">采集</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">前端使用 Gradio 与浏览器摄像头抽帧，控制输入频率。</p>
  </div>
  <div class="min-h-[155px] rounded-[6px] border border-emerald-100 bg-emerald-50/80 p-6">
    <p class="text-[18px] font-semibold text-emerald-800">定位</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">OpenCV 负责多芯片定位、过滤、排序与透视裁剪。</p>
  </div>
  <div class="min-h-[155px] rounded-[6px] border border-amber-100 bg-amber-50/80 p-6">
    <p class="text-[18px] font-semibold text-amber-800">识别</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">FastAPI 推理服务常驻内存，减少重复加载模型成本。</p>
  </div>
  <div class="min-h-[155px] rounded-[6px] border border-violet-100 bg-violet-50/80 p-6">
    <p class="text-[18px] font-semibold text-violet-800">规则匹配</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">规则库将 OCR 原始文本映射为标准芯片型号。</p>
  </div>
</div>

---
title: 核心机制 01
---

<p class="text-sm tracking-widest text-amber-600">核心机制 01</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">帧差计算可以减少推理次数</h1>

<!-- 正文改为三张卡片，是为了把“抽帧、判断、复用”三个动作拆开讲，流程图则留到补充页展开。 -->
<div class="mt-8 grid grid-cols-3 gap-5">
  <div class="min-h-[178px] rounded-[6px] border border-sky-100 bg-sky-50/80 p-6">
    <p class="text-[18px] font-semibold text-sky-800">关键帧抽取</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">浏览器每 1 秒抽取关键帧，避免持续视频流传输。</p>
  </div>
  <div class="min-h-[178px] rounded-[6px] border border-amber-100 bg-amber-50/80 p-6">
    <p class="text-[18px] font-semibold text-amber-800">变化判断</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">后端计算平均亮度差和显著变化像素比例，判断画面是否稳定。</p>
  </div>
  <div class="min-h-[178px] rounded-[6px] border border-emerald-100 bg-emerald-50/80 p-6">
    <p class="text-[18px] font-semibold text-emerald-800">结果复用</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">画面稳定且上帧结果已匹配时，直接复用历史识别结果。</p>
  </div>
</div>

<div class="mt-9 flex items-end justify-between gap-8">
  <div class="border-l-4 border-amber-500 pl-5 text-[19px] leading-8 text-slate-700">
    连续视频被转换为按需触发的识别请求，减少无效推理。
  </div>
  <button class="shrink-0 border border-amber-200 bg-white/70 px-5 py-2.5 text-[17px] font-medium text-amber-700 hover:bg-amber-50" @click="$nav.go(18)">查看流程图</button>
</div>

---
title: 核心机制 02
---

<p class="text-sm tracking-widest text-amber-600">核心机制 02</p>
<!-- 卡片页保留流程图入口，是为了先讲定位分割的四个判断动作，再按需展开完整流程。 -->
<div class="mt-3 flex items-start justify-between gap-6">
  <h1 class="text-[40px] leading-tight font-semibold text-slate-900">多路掩码比单一阈值更适合实验室光照</h1>
  <button class="mt-2 shrink-0 border border-amber-200 bg-white/70 px-5 py-2.5 text-[17px] font-medium text-amber-700 hover:bg-amber-50" @click="$nav.go(19)">查看流程图</button>
</div>

<div class="mt-6 grid grid-cols-2 gap-4">
  <div class="min-h-[140px] rounded-[6px] border border-sky-100 bg-sky-50/80 p-6">
    <p class="text-[18px] font-semibold text-sky-800">增强边界</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">灰度化与对比度增强提升芯片边界可见性。</p>
  </div>
  <div class="min-h-[140px] rounded-[6px] border border-emerald-100 bg-emerald-50/80 p-6">
    <p class="text-[18px] font-semibold text-emerald-800">生成候选</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">暗区掩码与边缘结构掩码共同生成候选区域。</p>
  </div>
  <div class="min-h-[140px] rounded-[6px] border border-amber-100 bg-amber-50/80 p-6">
    <p class="text-[18px] font-semibold text-amber-800">过滤轮廓</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">轮廓经过面积、长宽比、填充率和特征评分过滤。</p>
  </div>
  <div class="min-h-[140px] rounded-[6px] border border-violet-100 bg-violet-50/80 p-6">
    <p class="text-[18px] font-semibold text-violet-800">裁剪输出</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">NMS 去重后排序，输出背景干净的标准化裁剪图。</p>
  </div>
</div>

---
title: 核心机制 03
---

<p class="text-sm tracking-widest text-amber-600">核心机制 03</p>
<div class="mt-3 flex items-start justify-between gap-6">
  <h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">缓存与多变体预处理共同降低排队延迟</h1>
  <button class="mt-2 shrink-0 border border-amber-200 bg-white/70 px-5 py-2.5 text-[17px] font-medium text-amber-700 hover:bg-amber-50" @click="$nav.go(20)">查看流程图</button>
</div>

<div class="mt-2 grid grid-cols-[0.98fr_1.02fr] gap-10 items-start">
<div class="text-[20px] leading-8 text-slate-800">

- 单芯片缓存使用 IoU 与灰度指纹双重约束，避免位置未变时重复 OCR。
- 只对发生位移或识别失败的芯片重新推理。
- 预处理生成 original、upscaled、CLAHE、laser_dark、laser_bright、blackhat 等变体。
- 优先使用 laser_dark，失败后再自动回退。

</div>

<div class="min-h-0 h-full flex flex-col items-center justify-center gap-5">
  <figure class="w-[60%]">
    <img src="./assets/upscaled.jpg" class="w-full h-auto object-contain" />
    <figcaption class="mt-2 text-center text-[15px] leading-snug text-slate-500">upscaled 变体示例</figcaption>
  </figure>
  <figure class="w-[60%]">
    <img src="./assets/laser_dark.jpg" class="w-full h-auto object-contain" />
    <figcaption class="mt-2 text-center text-[15px] leading-snug text-slate-500">laser_dark 变体示例</figcaption>
  </figure>
</div>
</div>

---
title: 核心机制 04
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

</div>
<div class="-mt-8 h-[360px] flex items-center justify-center">
  <img src="./assets/型号匹配.svg">
</div>
</div>

---
title: 实验结果
---

<p class="text-sm tracking-widest text-rose-600">实验结果</p>

<div class="mt-3 flex items-start justify-between gap-6">
  <h1 class="text-[40px] leading-tight font-semibold text-slate-900">多芯片场景下定位与识别达到可用水平</h1>
  <button class="mt-2 shrink-0 border border-amber-200 bg-white/70 px-5 py-2.5 text-[17px] font-medium text-amber-700 hover:bg-amber-50" @click="$nav.go(21)">查看示例</button>
</div>

<!-- 结果页改为三张卡片，是为了在图表示例页之外先并列呈现实验条件、速度和质量三个结论。 -->
<div class="mt-8 grid grid-cols-3 gap-5">
  <div class="min-h-[190px] rounded-[6px] border border-sky-100 bg-sky-50/80 p-6">
    <p class="text-[18px] font-semibold text-sky-800">测试环境</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">海康威视摄像头 2560 × 1440，Intel i5-12500H 核显。</p>
  </div>
  <div class="min-h-[190px] rounded-[6px] border border-rose-100 bg-rose-50/80 p-6">
    <p class="text-[18px] font-semibold text-rose-800">分割耗时</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">单帧约 300-500 ms，且不随芯片数量线性增加。</p>
  </div>
  <div class="min-h-[190px] rounded-[6px] border border-emerald-100 bg-emerald-50/80 p-6">
    <p class="text-[18px] font-semibold text-emerald-800">文本质量</p>
    <p class="mt-4 text-[21px] leading-8 text-slate-800">laser_dark 变体增强激光打标字符，提升 OCR 原始文本质量。</p>
  </div>
</div>

<div class="mt-9 border-l-4 border-rose-500 pl-5 text-[19px] leading-8 text-slate-700">
系统重点是在受限算力下稳定跑完整链路，而不是追求单模型极限精度。
</div>

---
title: 耗时分析
---

<p class="text-sm tracking-widest text-rose-600">耗时分析</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">帧差与缓存显著压缩后端请求量</h1>

<!-- 左右容器对应“原因”和“效果”，是为了让耗时瓶颈与优化收益在同一视线上直接对照。 -->
<div class="mt-7 grid grid-cols-2 gap-7">
  <section class="min-h-[365px] rounded-[6px] border border-slate-200 bg-white/70 p-5">
    <p class="text-[18px] font-semibold text-slate-700">耗时来源</p>
    <div class="mt-8 grid grid-cols-2 gap-4">
      <div class="min-h-[255px] rounded-[6px] border border-rose-100 bg-rose-50/80 p-5">
        <p class="text-[18px] font-semibold text-rose-800">单帧处理</p>
        <p class="mt-7 text-[18px] leading-8 text-slate-800">分割约 300 ms，OCR 推理约 450 ms。</p>
      </div>
      <div class="min-h-[255px] rounded-[6px] border border-amber-100 bg-amber-50/80 p-5">
        <p class="text-[18px] font-semibold text-amber-800">积压风险</p>
        <p class="mt-7 text-[18px] leading-8 text-slate-800">连续并发模式 10 秒内请求 9-11 次，易形成积压。</p>
      </div>
    </div>
  </section>

  <section class="min-h-[365px] rounded-[6px] border border-slate-200 bg-white/70 p-5">
    <p class="text-[18px] font-semibold text-slate-700">请求压缩效果</p>
    <div class="mt-8 grid grid-cols-2 gap-4 text-center">
      <div class="min-h-[255px] rounded-[6px] border border-sky-200 bg-sky-50/80 flex flex-col items-center justify-center">
        <p class="text-[44px] font-semibold text-sky-700">3-5</p>
        <p class="mt-3 text-[17px] text-slate-500">帧差 + 缓存请求</p>
      </div>
      <div class="min-h-[255px] rounded-[6px] border border-slate-200 bg-white/80 flex flex-col items-center justify-center">
        <p class="text-[44px] font-semibold text-slate-500">9-11</p>
        <p class="mt-3 text-[17px] text-slate-500">连续并发请求</p>
      </div>      
    </div>
  </section>
</div>

---
title: 局限分析
---

<p class="text-sm tracking-widest text-rose-600">局限分析</p>
<h1 class="mt-3 text-[40px] leading-tight font-semibold text-slate-900">主要失败来自几何边界与极端成像条件</h1>

<!-- 失败案例页用图片替代抽象列表，是为了让局限来源直接对应到可见现象。 -->
<div class="relative mt-2 grid grid-cols-2 gap-x-3 gap-y-4">
  <div class="pointer-events-none absolute left-1/2 top-1/2 h-[175px] -translate-y-1/2 border-l border-slate-200"></div>
  <figure>
    <img src="./assets/贴边无法检出.png" class="image-cell" />
    <figcaption class="mt-1 text-center text-[14px] leading-snug text-slate-600">贴边芯片轮廓不完整，易被几何过滤剔除。</figcaption>
  </figure>
  <figure>
    <img src="./assets/检出但识别失败.png" class="image-cell" />
    <figcaption class="mt-1 text-center text-[14px] leading-snug text-slate-600">光照不足时字符对比度不足，OCR 特征难以提取。</figcaption>
  </figure>
  <figure>
    <img src="./assets/芯片框误合并.png" class="image-cell" />
    <figcaption class="mt-1 text-center text-[14px] leading-snug text-slate-600">芯片距离过近时，形态学闭运算可能合并相邻目标。</figcaption>
  </figure>
  <figure>
    <img src="./assets/大芯片难检出.png" class="image-cell" />
    <figcaption class="mt-1 text-center text-[14px] leading-snug text-slate-600">大角度大尺寸芯片会混入更多背景，导致评分下降。</figcaption>
  </figure>
</div>

<style>
.image-cell {
  width: 100%;
  height: 160px;
  object-fit: contain;
}
</style>

---
title: 总结与展望
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
title: 致谢
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

---
title: 系统流程图
routeAlias: system-workflow
hideInToc: true
---

<div class="h-full grid grid-cols-[0.42fr_0.58fr] gap-10">
  <div class="flex flex-col justify-between">
    <div class="pt-28">
      <p class="text-[22px] tracking-widest text-sky-400">补充图示</p>
      <h1 class="mt-7 text-[54px] leading-tight font-semibold text-slate-900">系统流程图</h1>
    </div>
    <button class="mb-4 w-fit border border-slate-300 px-6 py-3 text-[22px] text-slate-700 hover:bg-slate-50" @click="$nav.go(2)">返回目录</button>
  </div>
  <div class="min-h-0 h-full flex items-center justify-center">
    <img src="./assets/系统流程图.svg" class="h-[80vh] max-h-full max-w-full object-contain" />
  </div>
</div>

---
title: YOLO漏检展示
routeAlias: miss-detection
hideInToc: true
---

<!-- 右侧只固定图片宽度，不固定高度，是为了保留原图比例并避免上下贴边。 -->
<div class="h-full grid grid-cols-[0.42fr_0.58fr] gap-10">
  <div class="flex flex-col justify-between">
    <div class="pt-28">
      <p class="text-[22px] tracking-widest text-sky-400">补充图示</p>
      <h1 class="mt-7 text-[54px] leading-tight font-semibold text-slate-900">YOLO漏检展示</h1>
    </div>
    <button class="mb-4 w-fit border border-slate-300 px-6 py-3 text-[22px] text-slate-700 hover:bg-slate-50" @click="$nav.go(4)">返回</button>
  </div>
  <div class="min-h-0 h-full flex flex-col items-center justify-center gap-7">
    <img src="./assets/漏检1.jpg" class="w-[86%] h-auto object-contain" />
    <img src="./assets/漏检2.jpg" class="w-[86%] h-auto object-contain" />
  </div>
</div>

---
title: 帧差计算流程图
routeAlias: frame-diff
hideInToc: true
---

<div class="h-full grid grid-cols-[0.42fr_0.58fr] gap-10">
  <div class="flex flex-col justify-between">
    <div class="pt-28">
      <p class="text-[22px] tracking-widest text-sky-400">补充图示</p>
      <h1 class="mt-7 text-[54px] leading-tight font-semibold text-slate-900">帧差计算</h1>
    </div>
    <button class="mb-4 w-fit border border-slate-300 px-6 py-3 text-[22px] text-slate-700 hover:bg-slate-50" @click="$nav.go(7)">返回</button>
  </div>
  <div class="min-h-0 h-full flex items-center justify-center">
    <img src="./assets/帧差计算.svg" class="h-[80vh] max-h-full max-w-full object-contain" />
  </div>
</div>

---
title: 分割流程图
routeAlias: segmentation
hideInToc: true
---

<div class="h-full grid grid-cols-[0.42fr_0.58fr] gap-10">
  <div class="flex flex-col justify-between">
    <div class="pt-28">
      <p class="text-[22px] tracking-widest text-sky-400">补充图示</p>
      <h1 class="mt-7 text-[54px] leading-tight font-semibold text-slate-900">多芯片分割</h1>
    </div>
    <button class="mb-4 w-fit border border-slate-300 px-6 py-3 text-[22px] text-slate-700 hover:bg-slate-50" @click="$nav.go(8)">返回</button>
  </div>
  <div class="min-h-0 h-full flex items-center justify-center">
    <img src="./assets/分割流程图.svg" class="h-[80vh] max-h-full max-w-full object-contain" />
  </div>
</div>

---
title: 预处理流程图
routeAlias: pre-processing
hideInToc: true
---

<div class="h-full grid grid-cols-[0.42fr_0.58fr] gap-10">
  <div class="flex flex-col justify-between">
    <div class="pt-28">
      <p class="text-[22px] tracking-widest text-sky-400">补充图示</p>
      <h1 class="mt-7 text-[54px] leading-tight font-semibold text-slate-900">OCR预处理</h1>
    </div>
    <button class="mb-4 w-fit border border-slate-300 px-6 py-3 text-[22px] text-slate-700 hover:bg-slate-50" @click="$nav.go(9)">返回</button>
  </div>
  <div class="min-h-0 h-full flex items-center justify-center">
    <img src="./assets/预处理流程图.svg" class="h-[80vh] max-h-full max-w-full object-contain" />
  </div>
</div>

---
title: 识别结果示例
routeAlias: results-page-example
hideInToc: true
---

<p class="text-sm tracking-widest text-sky-600">补充图示</p>
<div class="mt-2 flex items-start justify-between gap-6">
  <h1 class="text-[40px] leading-tight font-semibold text-slate-900">识别结果示例</h1>
  <button class="mt-2 shrink-0 border border-slate-300 bg-white/70 px-5 py-2.5 text-[17px] font-medium text-slate-700 hover:bg-slate-50" @click="$nav.go(11)">返回</button>
</div>

<!-- 示例图页固定图片区高度，是为了让高分辨率截图完整缩放进 16:9 画布，而不是按原始像素溢出页面。 -->
<div class="h-[400px] flex items-center justify-center">
  <img src="./assets/三芯片常规.png" class="h-[370px] w-auto max-w-full object-contain" />
</div>
