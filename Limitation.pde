class Limitation {
  
  void home() {
    //HOMEの取得
    if (makeFilter) stream.user();
    makeFilter = false;
  }

  void hashtag() {
    //制限の設定
    if (!makeFilter) {
      label.setText("Set tweets' filter");
      text1.setText("#");
      panel.setLayout(layout);
      int result = JOptionPane.showConfirmDialog(
        null, 
        panel, 
        "SettingFilter", 
        JOptionPane.OK_CANCEL_OPTION, 
        JOptionPane.QUESTION_MESSAGE
        );

      println(result);
      println(text1.getText());
      inputText = text1.getText();
      if (result==JOptionPane.OK_OPTION) {
        stream.filter(text1.getText());
        nowHashtag = text1.getText();
        text1.setText(null);
        makeFilter = true;
      }
    }
  }
}