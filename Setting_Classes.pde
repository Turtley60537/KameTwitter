class MyStatusListener extends StatusAdapter {
  public void onStatus(Status s) {
    tweets.add(new Tweet(s));
  }
}


class OAuthRestAPI {
  OAuthRestAPI() {
    //Configurationを生成するためのビルダーオブジェクトを生成
    ConfigurationBuilder cb = new ConfigurationBuilder();

    //キー設定
    cb.setOAuthConsumerKey(consumerKey);
    cb.setOAuthConsumerSecret(consumerSecret);
    cb.setOAuthAccessToken(accessToken);
    cb.setOAuthAccessTokenSecret(accessTokenSecret);

    //Twitterのインスタンスを生成
    twitter = new TwitterFactory(cb.build()).getInstance();
  }
}


class OAuthStreamingAPI {
  OAuthStreamingAPI() {
    //Configurationを生成するためのビルダーオブジェクトを生成
    ConfigurationBuilder builder = new ConfigurationBuilder();

    //キー設定
    builder.setOAuthConsumerKey(consumerKey);
    builder.setOAuthConsumerSecret(consumerSecret);
    builder.setOAuthAccessToken(accessToken);
    builder.setOAuthAccessTokenSecret(accessTokenSecret);

    //TwitterStreamのインスタンスを生成
    TwitterStreamFactory streamFactory = new TwitterStreamFactory(builder.build());
    stream = streamFactory.getInstance();

    //イベントを受け取るリスナーオブジェクトを設定
    stream.addListener(new MyStatusListener());

    //取得ツイートを自分のフォローする人のツイートに設定
    stream.user();
  }
}


class SettingJPanel {
  SettingJPanel() {
    panel = new JPanel();

    label = new JLabel("ツイート入力");
    panel.add(label);
    layout = new BoxLayout(panel, BoxLayout.Y_AXIS);

    text1 = new JTextField();
    panel.add(text1);
    //panel.setBackgroundImage(image);

    font = createFont("STXihei-30.vlw", 30);
  }
}