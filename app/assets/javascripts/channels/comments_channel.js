App.cable.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
  connected() {
    this.perform('subscribed');
  },

  received(data) {
    if(data.comment.user_id !== gon.current_user_id){
      $('.' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id + '-comments .list').append('<p>' + data.comment.body + '</p>')
    }
  }
});
