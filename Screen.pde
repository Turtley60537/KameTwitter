class Screen {
  int distX, distY, screenRight, screenDown;
  boolean rightResizeFlag = false;
  boolean downResizeFlag = false;

  //スクリーンサイズを変更
  void changeSize() {
    if (rightResizeFlag) {
      screenRight = mouseX+distX;
      if (!downResizeFlag) screenDown = height;
      if (screenRight<=400) screenRight = 400;
    }
    if (downResizeFlag) {
      if (!rightResizeFlag) screenRight = width;
      screenDown = mouseY+distY;
      if (screenDown<=150) screenDown = 150;
    }
    surface.setSize(screenRight, screenDown);
  }

  //右端クリック
  void rightPressed() {
    distX = width-mouseX;
    resizeFlag = true;
    rightResizeFlag = true;
  }

  //下端クリック
  void downPressed() {
    distY = height-mouseY;
    resizeFlag = true;
    downResizeFlag = true;
  }

  void released() {
    if (resizeFlag) resizeFlag = false;
    if (rightResizeFlag) rightResizeFlag = false;
    if (downResizeFlag) downResizeFlag = false;
  }
}