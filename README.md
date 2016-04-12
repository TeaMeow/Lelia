<p align="center">
  x.
</p>
<p align="center">
  <i>x.</i>
</p>

&nbsp;

# Lelia
雷莉亞是一個用來剪裁大頭貼的 JavaScript 類別，亦支援行動裝置（觸控拖曳）。

&nbsp;

# 特色

1. 不需要 jQuery 和額外函式庫。

2. 可建立預覽元素。

3. 支援 Cavans 縮圖避免行動裝置卡頓。

4. 支援縮放滑桿（Slider）。

5. 可轉換到 Base64 或 Blob。

6. 可僅取得裁切資訊（如裁切位置、縮放大小）。

&nbsp;

# 初始化

你需要先配置設定。

```javascript
var options =
{
    preview   : '.previewImg', //（可能導致 Lag）用以預覽目前裁切範圍的圖片。
    previewEco: false        , //預覽節約模式，只在放開時更換預覽圖片，避免卡頓。
    slider    : '.slider'    , //用以控制縮放的滑桿（range）元素。
    imageBox  : '.imageBox'  , //剪裁的主要容器。
    thumbBox  : '.thumbBox'  , //剪裁範圍的容器。
    loader    : '.loader'    , //讀取時會出現的元素，讀取完後隱藏。
    imgSrc    : 'test.png'   , //圖片網址，可以是 Base64 或 Blob。
    maxSize   : 512          , //圖片最大尺寸，透過此設定避免行動裝置卡頓。
    boxSize   : '100%'       , //整體的大小。
    cropSize  : 200          , //裁切框的大小。

    /** 回傳 */
    onMove    : function()   , //移動裁切圖片時的回傳函式。
    onDown    : function()   , //正要裁切圖片時的回傳函式。
    onUp      : function()   , //結束移動動作時的回傳函式。
    onCrop    : function()   , //（目前不可用）裁切時的回傳函式。
}
```

&nbsp;

接下來你需要有這樣結構的 HTML。

```html
<!-- 主要容器 -->
<div class="imageBox">

    <!-- 裁切容器 -->
    <div class="thumbBox"></div>
    <!-- / 裁切容器 -->


    <!-- 讀取指示器 -->
    <div class="loader">
        圖片讀取中。
    </div>
    <!-- / 讀取指示器 -->

</div>
<!-- / 主要容器 -->
```

# 函式

## .getDataURI()

取得目前剪裁區塊的 Base64 資料。

&nbsp;

## .getBlob()

取得目前剪裁區塊的 Blob 網址。

&nbsp;

## .getInfo()

取得目前剪裁區域的縮放、起始位置、整體大小。

會回傳一個下列陣列。

```javascript
{
    width : width
    height: height
    dim   : dim
    size  : size
    ratio : // 縮放的倍數
    dx    : // 開始裁切的X（不含倍數）
    dy    : // 開始裁切的Y（不含倍數）
    dw    : parseInt(size[0])
    dh    : parseInt(size[1])
    sh    : parseInt(this.image.height)
    sw    : parseInt(this.image.width)
}
```

&nbsp;

## .zoomVal(number)

將目前圖片縮放到 number 倍數。

&nbsp;

## .zoomIn()

將目前圖片放大 0.1 倍。

&nbsp;

## .zoomOut()

將目前圖片縮小 0.1 倍。

&nbsp;

# 可參考文件

這裡是幾個可能會啟發你的創意，或者是更有利於你使用雷莉亞的連結。

[hongkhanh/cropbox](https://github.com/hongkhanh/cropbox)

[fengyuanchen/cropperjs](https://github.com/fengyuanchen/cropperjs)