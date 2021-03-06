class CodeMirrorImpl {
  num rootHeight = 400;
  num rootWidth = 600;
  num spacingFormat = 17;
  num scrollHeight = 400;
  num scrollWidth = 600;
  Element root; 
  Element console;
  TextAreaElement textarea;
  
  Element section;
  ButtonElement button;
  DivElement view; 
  DivElement bufferContainer; 
  var _font = "monospace";
  var _fontSize = "15px";
  var _lineHeight = "1.2"; //"1.4";
  
  CodeMirrorImpl() {
    document.style;
    
    String textareaStr = "<textarea id='editorBuffer' class='textarea' spellcheck='false' wrap='off' goog_input_chext='chext' style='color: transparent; background-color: transparent;'></textarea>";
    
    String sectionStr= """
    <section>
    <div class="container codemirrorsize" style="position: relative;" >
    <div id="mirrorbody" class="body codemirrorsize">
    <div id='textarea-container' class="textarea-container codemirrorsize">
    </div>
    <div id="scroll-container" class="scroll-y-container codemirrorsize" style="top:0; position: absolute; z-index:-1;"> 
    <div class="gutter"></div>
    <div id="editorBufferContainer" class="scroll-x-container" style="codemirrorsize">
    </div>
    </div>
    </div>
    </section>
""";
    String buttonStr = """<button id="submitButton" style="visibility: hidden;" value="Submit">Submit</button>""";
    String viewStr = """<div id="view" class="view"><div>""";
    
    console = new Element.html("<div><p id='results'></p></div>");
    textarea = new Element.html(textareaStr);       
    section = new Element.html(sectionStr);
    button = new Element.html(buttonStr);
    view = new Element.html(viewStr);
    
    root = new Element.tag("div");
    root.style.height = rootHeight;
    root.style.width = rootWidth;
    textarea.style.width = rootWidth;
    textarea.style.height = rootHeight;

    textarea.on.scroll.add(textAreaScrollHandler);
    textarea.on.keyUp.add(keyboardHandler);
    
    /*
    textarea.on.input.add((var e) {
      // TODO: create caret on input events by selected end.
      print("on.input=>textarea.selectionEnd="+textarea.selectionEnd);
    });
    textarea.on.mouseDown.add((var e) {
      print("on.mouseDown=>textarea.selectionEnd="+textarea.selectionEnd);
    });
    */
    
    
    bufferContainer = section.query('#editorBufferContainer');
    textarea.on.input.add((_) {
      
    });
    textarea.on.click.add((MouseEvent event) {
      /*
      int t=event.offsetY;
      int l=event.offsetX;
      print("t=${t}");
      print("l=${l}");
      var caret = new Element.html("<div style='top:${t};left:${l};position: absolute;overflow:scroll;overflow-x: scroll;overflow-y: scroll;  font-family:${_font};font-size:${_fontSize};line-height:${_lineHeight};'>" 
      + "|" +"</div>");
      bufferContainer.nodes.add(caret);
      */
    });
    
    root.nodes.add(view);
    view.nodes.add(button);
    view.nodes.add(section);
    view.nodes.add(console);
    view.query('#textarea-container').nodes.add(textarea);
    
  }
  
  Element getMirror() {
    return root;
  }
  
  keyboardHandler(KeyboardEvent event) {
    
    textarea.rect.then((ElementRect rect) {
      scrollHeight = rect.scroll.height;
      scrollWidth = rect.scroll.width; 
      bufferContainer.style.width = scrollWidth;
      bufferContainer.style.height = scrollHeight;
      bufferContainer.firstElementChild.style.height = scrollHeight;
      bufferContainer.firstElementChild.style.width = scrollWidth;
    });
    
    // This is where we would parse out a colored version of the string. 
    var i = 0;
    StringBuffer sb = new StringBuffer();
    
    classify.SourceFile sf = new classify.SourceFile("hi.dart", textarea.value);
    String c = classify.classifySource(sf);
    
    //textarea.value.split('\n').forEach((s){
    c.split('\n').forEach((s){
      // TODO: remove the position stuff and place that in later. 
      sb.add("<div style='top:${i}px; left:3; position: absolute;overflow:hidden;overflow-x:hidden;overflow-y:hidden;font-family:${_font};font-size:${_fontSize};line-height:${_lineHeight};'><span>" 
      + s+ "</span></div>");
      
      i+=(spacingFormat);
     
    });
    
    var codeLine = new Element.html("<div style='top:0;position: absolute;height:${scrollHeight};width:${scrollWidth};overflow:scroll;overflow-x: scroll;overflow-y: scroll;  font-family:${_font};font-size:${_fontSize};line-height:${_lineHeight};'>" 
    + sb.toString() +"</div>");
    section.query('#editorBufferContainer').nodes.forEach((var n){
      n.remove();
    });
    
    section.query('#editorBufferContainer').nodes.add(codeLine);
    
  }
  
  submitButtonHandler(var event) {
    
  }
  
  viewResizeHandler(Element element) {
    element.rect.then((ElementRect rect) {
      root.style.left = "50%";
      root.style.right = "50%";
      root.style.marginLeft = ((rect.client.width/2)-(rootWidth/2)).toString()+"px";
    });
  }
  
  editorBufferResizeHandler(ElementRect rect) {
    
  }
  
  textAreaScrollHandler(var sc) {
    if (sc != null) {
      textarea.rect.then((ElementRect rect) {
        section.query('#scroll-container').style.top = -rect.scroll.top;
        section.query('#scroll-container').style.left = -rect.scroll.left;
      });
    }
  }
  
  
}
