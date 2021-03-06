// Generated by CoffeeScript 1.10.0

/*
        ,gggg,                                    
      d8" "8I            ,dPYb,                  
      88  ,dP            IP'`Yb                  
   8888888P"             I8  8I  gg              
      88                 I8  8'  ""              
      88         ,ggg,   I8 dP   gg     ,gggg,gg 
 ,aa,_88        i8" "8i  I8dP    88    dP"  "Y8I 
dP" "88P        I8, ,8I  I8P     88   i8'    ,8I 
Yb,_,d88b,,_    `YbadP' ,d8b,_ _,88,_,d8,   ,d8b,
 "Y8P"  "Y88888888P"Y8888P'"Y888P""Y8P"Y8888P"`Y8

       Created by ezgoing    on 14/9/2014.
       Forked  by YamiOdymel on 11/4/2016.
       
             MIT LICENSE FUCK YEAH.
 */
var cropbox;

cropbox = function(options) {
  var bindEvent, client, dataURItoBlob, el, end, move, obj, preivew, ref, ref1, ref2, ref3, resize, setBackground, slider, sliderr, start;
  el = document.querySelector(options.imageBox);
  slider = document.querySelector(options.slider);
  preivew = document.querySelector(options.preview);
  obj = {
    state: {},
    ratio: 1,
    options: options,
    imageBox: el,
    thumbBox: el.querySelector(options.thumbBox),
    loader: el.querySelector(options.loader),
    maxSize: (ref = options.maxSize) != null ? ref : 512,
    onMove: (ref1 = options.onMove) != null ? ref1 : function() {},
    onDown: (ref2 = options.onDown) != null ? ref2 : function() {},
    onUp: (ref3 = options.onUp) != null ? ref3 : function() {},
    image: new Image(),

    /*
    Get Data URL
     */
    getDataURI: function() {
      var canvas, context, info;
      info = this.getInfo();
      canvas = document.createElement('canvas');
      canvas.width = info.width;
      canvas.height = info.height;
      context = canvas.getContext("2d");
      context.drawImage(this.image, 0, 0, info.sw, info.sh, info.dx, info.dy, info.dw, info.dh);
      return canvas.toDataURL('image/png');
    },

    /*
    Get Blob
     */
    getBlob: function() {
      return URL.createObjectURL(dataURItoBlob(this.getDataURI()));
    },

    /*
    Get Info
     */
    getInfo: function() {
      var dim, height, size, width;
      width = this.thumbBox.clientWidth;
      height = this.thumbBox.clientHeight;
      dim = el.style.backgroundPosition.split(' ');
      size = el.style.backgroundSize.split(' ');
      return {
        width: width,
        height: height,
        dim: dim,
        size: size,
        ratio: parseFloat(this.ratio),
        dx: parseInt(dim[0]) - el.clientWidth / 2 + width / 2,
        dy: parseInt(dim[1]) - el.clientHeight / 2 + height / 2,
        dw: parseInt(size[0]),
        dh: parseInt(size[1]),
        sh: parseInt(this.image.height),
        sw: parseInt(this.image.width)
      };
    },

    /*
    Zoom Val
    
    Set the zoom value directly.
     */
    zoomVal: function(val) {
      this.ratio = val;
      return setBackground();
    },

    /*
    Zoom In
    
    Zoom in a little bit.
     */
    zoomIn: function() {
      this.ratio *= 1.1;
      return setBackground();
    },

    /*
    Zoom Out
    
    Zoom out a little bit.
     */
    zoomOut: function() {
      this.ratio *= 0.9;
      return setBackground();
    }
  };

  /*
  Set Background
   */
  setBackground = function() {
    var h, ph, pw, w;
    w = parseInt(obj.image.width) * obj.ratio;
    h = parseInt(obj.image.height) * obj.ratio;
    pw = (el.clientWidth - w) / 2;
    ph = (el.clientHeight - h) / 2;
    return el.setAttribute('style', 'background-image: url(' + obj.image.src + '); ' + 'background-size: ' + w + 'px ' + h + 'px; ' + 'background-position: ' + pw + 'px ' + ph + 'px; ' + 'background-repeat: no-repeat');
  };

  /*
  Start
  
  We set the image dragable when the mousedown, touchstart.
   */
  start = function(e) {
    e.preventDefault();
    obj.onUp.call(this, e);
    obj.state.dragable = true;
    obj.state.posX = client('X', e);
    return obj.state.posY = client('Y', e);
  };

  /*
  Client
  
  Get the ClientX or Y by touch event or mouse event.
   */
  client = function(position, e) {
    var clientX, clientY;
    if (e.type === 'touchmove' || e.type === 'touchdown' || e.type === 'touchend') {
      clientX = e.touches[0].clientX;
      clientY = e.touches[0].clientY;
    } else {
      clientX = e.clientX;
      clientY = e.clientY;
    }
    if (position === 'X') {
      return clientX;
    } else {
      return clientY;
    }
  };

  /*
  Move
  
  The mousemove, touchmove event, and change the image position.
   */
  move = function(e) {
    var bg, bgX, bgY, x, y;
    e.preventDefault();
    obj.onMove.call(this, e);
    preivew.src = obj.getDataURI();
    if (!obj.state.dragable) {
      return;
    }
    x = client('X', e) - obj.state.posX;
    y = client('Y', e) - obj.state.posY;
    bg = el.style.backgroundPosition.split(' ');
    bgX = x + parseInt(bg[0]);
    bgY = y + parseInt(bg[1]);
    el.style.backgroundPosition = bgX + 'px ' + bgY + 'px';
    obj.state.posX = client('X', e);
    return obj.state.posY = client('Y', e);
  };

  /*
  End
  
  We set the image undragable when mouseup, touchend events.
   */
  end = function(e) {
    e.preventDefault();
    obj.onUp.call(this, e);
    return obj.state.dragable = false;
  };
  sliderr = function(e) {
    obj.zoomVal(slider.value);
    return preivew.src = obj.getDataURI();
  };

  /*
  Resize
  
  Resize the image by canvas, to reduce some laggy craps.
   */
  resize = function() {
    var c2d, canvas, img;
    canvas = document.createElement("canvas");
    canvas.width = options.maxSize;
    canvas.height = options.maxSize;
    c2d = canvas.getContext("2d");
    img = new Image();
    img.onload = function(e) {
      c2d.drawImage(this, 0, 0, options.maxSize, options.maxSize);
      return obj.image.src = URL.createObjectURL(dataURItoBlob(canvas.toDataURL("image/png")));
    };
    return img.src = options.imgSrc;
  };

  /*
  Base 64 To Blob
  
  @see https://gist.github.com/fupslot/5015897
   */
  dataURItoBlob = function(dataURI, callback) {
    var ab, bb, byteString, i, ia, mimeString;
    byteString = atob(dataURI.split(',')[1]);
    mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];
    ab = new ArrayBuffer(byteString.length);
    ia = new Uint8Array(ab);
    i = 0;
    while (i < byteString.length) {
      ia[i] = byteString.charCodeAt(i);
      i++;
    }
    bb = new Blob([ab]);
    return bb;
  };

  /*
  Bind Event
  
  Like $.on() in jQuery.
   */
  bindEvent = function(events, element, callback) {
    var event, i, results;
    event = events.split(' ');
    i = 0;
    results = [];
    while (i < event.length) {
      element.addEventListener(event[i], callback, false);
      results.push(i++);
    }
    return results;
  };

  /*
  INITIALIZE
   */
  if (obj.loader !== null) {
    obj.loader.style.display = 'block';
  }
  obj.image.onload = function() {
    if (obj.loader !== null) {
      obj.loader.style.display = 'none';
    }
    setBackground();
    bindEvent('touchstart mousedown', el, start);
    bindEvent('touchmove mousemove', el, move);
    bindEvent('touchend mouseup mouseleave', el, end);
    return bindEvent('input', slider, sliderr);
  };
  resize();
  return obj;
};
