import twitter4j.*;
import twitter4j.api.*;
import twitter4j.auth.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.management.*;
import twitter4j.util.*;
import twitter4j.util.function.*;

import java.awt.*;
import javax.swing.*;
import java.applet.Applet;

//キー設定　自分のキーを入力
final String consumerKey = "ここにConsumerKeyを入力"; 
final String consumerSecret = "ここにConsumerSecretを入力";
final String accessToken = "ここにAccessTokenを入力";
final String accessTokenSecret = "ここにAccessTokenSecretを入力";

ArrayList<Tweet> tweets;

//RestAPIのクラス
Twitter twitter;
OAuthRestAPI oAuthRestAPI;

//StreamAPIのクラス
TwitterStream stream;
OAuthStreamingAPI oAuthStreamingAPI;

Button button;  //画像設定のクラス
CreateTweet createTweet;  //ツイートをするためのクラス
Limitation limitation;  //取得制限のクラス
String nowHashtag;  //現在のハッシュタグの表示

boolean anyoneStop = false;  //止まっているツイートはあるか?あるなら他のツイートは止まらない
boolean makeFilter = false;  //制限の状態のフラグ

SettingJPanel settingJPanel;  //JPanelのクラス
//JPanelの要素
JPanel panel;
BoxLayout layout;
JFrame frame;
JLabel label;
JTextField text1;
String inputText;
PFont font;

//スクリーンサイズ変更の要素
boolean resizeFlag = false;
Screen screen;

void setup() {
  size(1000, 700);
  tweets = new ArrayList<Tweet>();
  oAuthRestAPI = new OAuthRestAPI();
  oAuthStreamingAPI = new OAuthStreamingAPI();
  settingJPanel = new SettingJPanel();
  button = new Button();
  createTweet = new CreateTweet();
  limitation = new Limitation();
  screen = new Screen();
} 

void draw() {
  background(0);
  if (tweets.size() > 0) {
    anyoneStop = false;
    for ( int i=0; i<tweets.size(); i++) tweets.get(i).checkStop();  //静止しているツイートが存在するかの判定
    for (int i=0; i<tweets.size(); i++)  tweets.get(i).display();  //ツイート文を描画
    for (int i=0; i<tweets.size(); i++) tweets.get(i).displayImage();  //ツイートアイコンの描画
  }

  button.display();  //各種ボタンの描画

  //ツイートの削除
  for (int i=0; i<tweets.size(); i++) {
    if (tweets.get(i).removeFlag) tweets.remove(i);
  }

  //カーソル変更
  if (mouseByRightFrame() || mouseByDownFrame()) cursor(CROSS);
  else cursor(ARROW);

  //スクリーンサイズ変更
  if (resizeFlag) {
    screen.changeSize();
  }
}

void mousePressed() {
  //ツイートするとき
  if (mouseInMyTweetBox()) createTweet.send();

  //Homeを取得するとき
  if (mouseInHouse()) limitation.home();

  //特定のワードで検索するとき
  if (mouseInHashmark()) limitation.hashtag();

  //ツイートのアイコンを押したとき
  for (int i=0; i<tweets.size(); i++) tweets.get(i).pressed();

  //スクリーンサイズの変更のため
  if (mouseByRightFrame()) {
    screen.rightPressed();
  }
  if (mouseByDownFrame()) {
    screen.downPressed();
  }
}

void mouseReleased() {
  //スクリーンサイズ変更終了
  screen.released();
}

//以下当たり判定
boolean mouseInMyTweetBox() {
  return mouseX>0 && mouseX<50 && mouseY>0 && mouseY<50;
}

boolean mouseInHouse() {
  return mouseX>50 && mouseX<100 && mouseY>0 && mouseY<50;
}

boolean mouseInHashmark() {
  return mouseX>100 && mouseX<150 && mouseY>0 && mouseY<50;
}

boolean mouseByRightFrame() {
  return mouseX>width-20 && mouseX<=width;
}

boolean mouseByDownFrame() {
  return mouseY>height-20 && mouseY<=height;
}