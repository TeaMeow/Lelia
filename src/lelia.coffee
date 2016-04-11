###
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
###

cropbox = (options) ->
  el      = document.querySelector(options.imageBox)
  slider  = document.querySelector(options.slider)
  preivew = document.querySelector(options.preview)
  
  obj     =
    state     : {}
    ratio     : 1
    options   : options
    imageBox  : el
    thumbBox  : el.querySelector(options.thumbBox)
    loader    : el.querySelector(options.loader)
    maxSize   : options.maxSize ? 512
    onMove    : options.onMove  ? ->
    onDown    : options.onDown  ? ->
    onUp      : options.onUp    ? ->
    image     : new Image()
    
  
    
    ###
    Get Data URL
    
    
    ###
    
    getDataURI: () ->
      info   = this.getInfo();
      canvas = document.createElement 'canvas'
      
      canvas.width  = info.width
      canvas.height = info.height
      context       = canvas.getContext("2d")
      context.drawImage(this.image, 0, 0, info.sw, info.sh, info.dx, info.dy, info.dw, info.dh)
      
      return canvas.toDataURL('image/png')
    
    
    
    ###
    Get Blob
    
    
    ###
    
    getBlob: () ->
      return URL.createObjectURL(dataURItoBlob(@getDataURI()))
      
      #b64       = @getDataURI().replace 'data:image/png;base64,', ''
      #binary    = atob(b64)
      #array     = []
      #
      #for el, i in binary.length
      #  array.push binary.charCodeAt i
      #  
      #return new Blob([new Uint8Array(array)], {type: 'image/png'})
    
    
    
    ###
    Get Info
    
    
    ###
    
    getInfo: () ->
      width  = @thumbBox.clientWidth
      height = @thumbBox.clientHeight
      dim    = el.style.backgroundPosition.split ' '
      size   = el.style.backgroundSize.split     ' '
      
      return {
        width : width
        height: height
        dim   : dim
        size  : size
        ratio : parseFloat(this.ratio)
        dx    : parseInt(dim[0]) - el.clientWidth  / 2 + width  / 2
        dy    : parseInt(dim[1]) - el.clientHeight / 2 + height / 2
        dw    : parseInt(size[0])
        dh    : parseInt(size[1])
        sh    : parseInt(this.image.height)
        sw    : parseInt(this.image.width)
      }
    
    
    
    ###
    Zoom Val
    
    Set the zoom value directly.
    ###
            
    zoomVal: (val) ->
      @ratio = val
      setBackground()
      
    
    
    ###
    Zoom In
    
    Zoom in a little bit.
    ###
    
    zoomIn: ->
      @ratio *= 1.1
      setBackground()
      
    
    
    ###
    Zoom Out
    
    Zoom out a little bit.
    ###
    
    zoomOut: ->
      @ratio *= 0.9
      setBackground()
  
  
  
  ###
  Set Background
  
  
  ###
  
  setBackground = ->
    w =  parseInt(obj.image.width)  * obj.ratio
    h =  parseInt(obj.image.height) * obj.ratio
    pw = (el.clientWidth - w)  / 2
    ph = (el.clientHeight - h) / 2
    
    el.setAttribute('style', 
              'background-image: url(' + obj.image.src + '); ' + 'background-size: ' + w + 'px ' + h + 'px; ' +
              'background-position: ' + pw + 'px ' + ph + 'px; ' +
              'background-repeat: no-repeat')
  
  
  
  ###
  Start
  
  We set the image dragable when the mousedown, touchstart.
  ###
  
  start = (e) ->
    e.preventDefault()
    obj.onUp.call(@, e)
    
    obj.state.dragable = true
    obj.state.posX     = client('X', e)
    obj.state.posY     = client('Y', e)
  
  
  
  ###
  Client
  
  Get the ClientX or Y by touch event or mouse event.
  ###
  
  client = (position, e) ->
    
    if e.type is 'touchmove' or 
       e.type is 'touchdown' or 
       e.type is 'touchend'
      clientX = e.touches[0].clientX
      clientY = e.touches[0].clientY
    else
      clientX = e.clientX
      clientY = e.clientY
    
    return if position is 'X' then clientX else clientY
  
  
  
  ###
  Move
  
  The mousemove, touchmove event, and change the image position.
  ###
  
  move = (e) ->
    e.preventDefault()
    obj.onMove.call(@, e)
    
    preivew.src = obj.getDataURI()
    
    if not obj.state.dragable
      return
      
    x   = client('X', e) - obj.state.posX
    y   = client('Y', e) - obj.state.posY
    bg  = el.style.backgroundPosition.split ' '
    bgX = x + parseInt bg[0]
    bgY = y + parseInt bg[1]
    
    el.style.backgroundPosition = bgX + 'px ' + bgY + 'px';
    obj.state.posX = client('X', e)
    obj.state.posY = client('Y', e)
  
  
  
  ###
  End
  
  We set the image undragable when mouseup, touchend events.
  ###

  end = (e) ->
    e.preventDefault()
    obj.onUp.call(@, e)
    
    obj.state.dragable = false

  
  sliderr = (e) ->
    obj.zoomVal(slider.value)
    preivew.src = obj.getDataURI()
  
  
  
  ###
  Resize
  
  Resize the image by canvas, to reduce some laggy craps.
  ###
  
  resize = ->
    canvas        = document.createElement("canvas")
    canvas.width  = options.maxSize
    canvas.height = options.maxSize
    c2d           = canvas.getContext("2d")
    img           = new Image()
    img.onload    = (e) ->
      c2d.drawImage(@, 0, 0, options.maxSize, options.maxSize)
      
      # Set the main image
      obj.image.src = URL.createObjectURL(dataURItoBlob(canvas.toDataURL("image/png")))

    # Set the image src so we can start the image load event
    img.src = options.imgSrc
  
  
  
  ###
  Base 64 To Blob
  
  @see https://gist.github.com/fupslot/5015897
  ###
  
  dataURItoBlob = (dataURI, callback) ->
    # convert base64 to raw binary data held in a string
    # doesn't handle URLEncoded DataURIs - see SO answer #6850276 for code that does this
    byteString = atob(dataURI.split(',')[1])

    # separate out the mime component
    mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]

    # write the bytes of the string to an ArrayBuffer
    ab = new ArrayBuffer(byteString.length)
    ia = new Uint8Array(ab)
    
    i = 0
    while i < byteString.length
      ia[i] = byteString.charCodeAt(i)
      i++

    # write the ArrayBuffer to a blob, and you're done
    bb = new Blob([ab])
    
    return bb
  
  
  
  ###
  Bind Event
  
  Like $.on() in jQuery.
  ###
  
  bindEvent = (events, element, callback) ->
    event = events.split ' '
    
    i = 0
    while i < event.length
      element.addEventListener event[i], callback, false
      i++

  
  
  ###
  INITIALIZE
  
  
  ###
  
  obj.loader.style.display = 'block' if obj.loader isnt null
  
  obj.image.onload = ->
    obj.loader.style.display = 'none' if obj.loader isnt null
    setBackground()
    
    bindEvent 'touchstart mousedown'       , el    , start
    bindEvent 'touchmove mousemove'        , el    , move
    bindEvent 'touchend mouseup mouseleave', el    , end
    bindEvent 'input'                      , slider, sliderr
    
  # Load the image and resize it
  resize()

  return obj