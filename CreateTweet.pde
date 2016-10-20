class CreateTweet {
  void send() {
    label.setText("Write your tweet");
    text1.setText("");
    panel.setLayout(layout);
    int result = JOptionPane.showConfirmDialog(
      null, 
      panel, 
      "MakingTweets", 
      JOptionPane.OK_CANCEL_OPTION, 
      JOptionPane.QUESTION_MESSAGE
      );

    println(result);
    println(text1.getText());
    inputText = text1.getText();
    if (result==JOptionPane.OK_OPTION) {
      try {
        Status status = twitter.updateStatus(inputText);
        println("Successfully updated the status to [" + status.getText() + "].");
      }
      catch ( TwitterException e) {
        println(e.getStatusCode());
      }
      text1.setText(null);
    }
  }
}