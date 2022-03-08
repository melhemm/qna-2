document.addEventListener('turbolinks:load', () => {
  App.cable.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    connected() {
      this.perform('subscribed');
    },

    received(data) {
      this.appendDiv(data)
    },

    appendDiv(data) {
      const html = this.createDiv(data)
      $('.answers').append(html)
    },

    createDiv(data) {
      return ` <div class="answer-id-${data.answer.id}">
                <p>${data.answer.body}</p>
              </div>
              `
    }
  });
})
