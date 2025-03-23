function startListening() {
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
      const command = event.results[0][0].transcript;
      status.textContent = "✅ You said: " + command;
  
      fetch('/process', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ command })
      })
      .then(res => res.json())
      .then(data => {
        console.log(data);
        status.textContent += " → " + data.response;
      });
    };
  
    recognition.onerror = (err) => {
      status.textContent = "❌ Error: " + err.error;
    };
  }
  