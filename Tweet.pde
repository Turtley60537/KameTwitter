class Tweet {
  long id;
  String text;  //テキスト
  float textW;  //テキストの幅
  String name;  //ユーザーネーム
  PImage profileImage;

  PFont font;
  float x, y, v;  //ツイートの表示位置設定
  int removeCount;  //5回のループでツイートのデータは削除される

  boolean stopFlag;  //動きが止まっているかどうか
  boolean selectFlag;  //特定のツイートアイコンを選択
  boolean favoFlag;  //ツイートをファボ
  boolean retweetFlag;  //ツイートをリツイート
  boolean removeFlag;  //removeCountに応じて要素を消すかどうか

  PImage whiteStar, orangeStar, whiteRetweet, greenRetweet;  
  ArrayList<String> picList;
  int count;

  public Tweet(Status status) {
    id = status.getId();
    text = status.getText();
    textW = textWidth(text);
    User user = status.getUser();
    name = user.getName();
    profileImage = loadImage(user.getProfileImageURL());

    font = createFont("YuGo-Bold-48", 20);

    x = width;
    y = random(height-100);
    v = random(2, 3);
    removeCount = 0;
    removeFlag = false;

    favoFlag = false;
    whiteStar = loadImage("star_white.png");
    orangeStar = loadImage("star_orange.png");
    whiteRetweet = loadImage("retweet_white.png");
    greenRetweet = loadImage("retweet_green.png");

    count = 0;
    MediaEntity[] mediaEntitys = status.getExtendedMediaEntities();
    if (mediaEntitys!=null && mediaEntitys.length>0) {
      picList = new ArrayList<String>();
      for (int i = 0; i < mediaEntitys.length; i++) {
        MediaEntity mediaEntity = mediaEntitys[i];
        String pictureURL = mediaEntity.getMediaURL();
        picList.add(pictureURL);

        println(picList.get(0));
      }
    }
  }

  void display() {
    displayPicture();
    noTint();
    displayText();
    move();
  }

  void displayPicture() {
    //取得画像の描画
    if (selectFlag) {
      if (picList!=null && picList.size()>0) {
        noTint();
        imageMode(CENTER);
        image(loadImage(picList.get(count)), width/2, height/2);
        imageMode(CORNER);
      }
    }
  }

  void displayImage() { 
    tint(255, 255, 255, 200-40*removeCount);

    if (profileImage!=null) image(profileImage, x, y, 50, 50);

    if (selectFlag) {
      noTint();
      fill(150);
      rect(x, y+55, 50, 25);
      //星マーク描画
      if (!favoFlag) {
        if (!mouseInFavo()) {
          image(whiteStar, x, y+55);
        } else {
          image(orangeStar, x, y+55);
        }
      } else {
        image(orangeStar, x, y+55);
      }
      //リツイートマーク描画
      if (!retweetFlag) {
        if (!mouseInRetweet()) {
          image(whiteRetweet, x+26, y+57);
        } else {
          image(greenRetweet, x+26, y+57);
        }
      } else {
        image(greenRetweet, x+26, y+57);
      }
    }
  }

  void displayText() {
    textFont(font);
    if (!selectFlag) fill(255, 200-40*removeCount);
    else fill(255, 255, 0);
    textSize(15);
    if (name!=null) text(name, x+70, y+10);
    textSize(20);
    if (text!=null) text(text, x+70, y+40);
  }

  void checkStop() {
    //止まっているものはあるか?
    if (stopFlag) {
      anyoneStop = true;
    }
  }

  void move() {
    //選択してたり、何も選択していないときアイコン常にマウスがあったら動きを止める
    if ((selectFlag) || (!anyoneStop&&mouseInIcon()) || (this.stopFlag&&mouseInIcon()) ) {
      stopFlag = true;
    } else {
      stopFlag = false;
    }

    if (!stopFlag)   x -= v;
    if (x<-(70+textW)) {
      x = width;
      removeCount++;
      if (removeCount==5) removeFlag = true;
    }
  }

  void pressed() {
    if (mouseInIcon() && stopFlag) {
      if (!selectFlag) selectFlag = true;
      else {
        count++;
        if (count==picList.size()) count=0;
      }
    } else if (mouseInBox()) {
      //ファボ設定
      if (mouseInFavo()) {
        favorite();
      }
      //リツイート設定
      if (mouseInRetweet()) {
        retweet();
      }
    } else {
      if (!mouseByRightFrame() || !mouseByDownFrame()) {
        selectFlag = false;
      }
    }
  }

  void favorite() {
    //ファボするとき
    if (selectFlag) {
      if (!favoFlag) {
        //ファボする時はcreateFavorite
        try {
          Status status = twitter.createFavorite(id);
          selectFlag = false;
        }
        catch(TwitterException e) {
          println(e);
        }
      } else {
        //ファボ外す時はdestroyFavorite
        try {
          Status status = twitter.destroyFavorite(id);
          selectFlag = false;
        }
        catch(TwitterException e) {
          println(e);
        }
      }
      favoFlag = favoFlag ? false : true;
    }
  }

  void retweet() {
    //リツイートするとき
    if (selectFlag) {
      if (!retweetFlag) {
        try {
          Status status = twitter.retweetStatus(id);
          selectFlag = false;
        }
        catch(TwitterException e) {
          println(e);
        }
      }
      retweetFlag = true;
    }
  }

  //以下当たり判定
  boolean mouseInIcon() {
    return mouseX>x && mouseX<x+50 && mouseY>y && mouseY<y+50;
  }
  boolean mouseInBox() {
    return mouseX>x && mouseX<x+50 && mouseY>y+55 && mouseY<y+80;
  }
  boolean mouseInFavo() {
    return mouseX>x && mouseX<x+25 && mouseY>y+55 && mouseY<y+80;
  }
  boolean mouseInRetweet() {
    return mouseX>x+25 && mouseX<x+50 && mouseY>y+55 && mouseY<y+80;
  }
}