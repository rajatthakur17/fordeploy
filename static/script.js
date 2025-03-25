function startListening(nextStep = 'command', contact = '') {
  const status = document.getElementById("status");
  
  const recognition = new (window.SpeechRecognition || window.webkitSpeechRecognition)();
  recognition.lang = 'en-IN';
  recognition.interimResults = false;
  recognition.maxAlternatives = 1;
  
  recognition.start();
  
  recognition.onstart = () => {
      status.textContent = "🎙️ Listening...";
  };
  
  recognition.onresult = (event) => {
      const speechText = event.results[0][0].transcript;
      status.textContent = "✅ You said: " + speechText;
      
      let requestBody = {};
      
      if (nextStep === 'command') {
          requestBody = { command: speechText };
      } else if (nextStep === 'contact') {
          requestBody = { command: "send whatsapp message", contact: speechText };
      } else if (nextStep === 'message') {
          requestBody = { command: "send whatsapp message", contact: contact, message: speechText };
      }
      
      fetch('/process', {
          method: 'POST',
          headers: {
              'Content-Type': 'application/json'
          },
          body: JSON.stringify(requestBody)
      })
      .then(res => res.json())
      .then(data => {
          console.log(data);
          status.textContent += " → " + data.response;
          
          if (data.next_step === 'contact') {
              status.textContent = "🎙️ Please say the contact name.";
              startListening('contact');
          } else if (data.next_step === 'message') {
              status.textContent = "🎙️ Please say the message.";
              startListening('message', data.contact);
          }
      });
  };
  
  recognition.onerror = (err) => {
      status.textContent = "❌ Error: " + err.error;
  };
}
