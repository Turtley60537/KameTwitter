class Button {
  PImage tweetIcon, house, hashmark;  //左上のアイコン, 家マーク
  
  Button() {
    tweetIcon = loadImage("twitter.png");
    house = loadImage("house50.png");
    hashmark = loadImage("hashmark.png");
  }
  
  void display() {
    noTint();
    image(tweetIcon, 0, 0);

    if (makeFilter) tint(255, 255, 255, 100);
    else noTint();
    image(house, 50, -3);

    if (makeFilter) noTint();
    else tint(255, 255, 255, 100);
    image(hashmark, 100, 0);
    if (makeFilter) {
      textFont(font);
      fill(255, 200);
      text(nowHashtag, 170, 35);
      noFill();
    }
  }
}