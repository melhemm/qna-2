App.cable.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
  connected() {
    this.perform('subscribed');
  },

  received(data) {
    $('.answers').append(` 
                          <div class="answer-id-${data.answer.id}">
                            <p>${data.answer.body}</p>
                          </div>`
                          )
  },
});