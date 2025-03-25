from flask import Flask, render_template, request, jsonify
import webbrowser
import time
import pyttsx3
import pyautogui
import pyperclip

app = Flask(__name__)

def say(text):
    engine = pyttsx3.init()
    engine.say(text)
    engine.runAndWait()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/process', methods=['POST'])
def process():
    data = request.get_json()
    command = data.get('command', '').lower()
    contact = data.get('contact', '').strip()
    message = data.get('message', '').strip()
    
    print("Received command:", command)

    if "open youtube" in command:
        say("Opening YouTube")
        webbrowser.open("https://www.youtube.com/")
    elif "open chat gpt" in command:
        say("Opening ChatGPT")
        webbrowser.open("https://chat.openai.com/")
    elif "send whatsapp message" in command:
        if not contact:
            say("Who do you want to message?")
            return jsonify({'response': 'Who do you want to message?', 'next_step': 'contact'})
        elif not message:
            say("What is your message?")
            return jsonify({'response': 'What is your message?', 'next_step': 'message', 'contact': contact})
        else:
            send_whatsapp_message(contact, message)
            return jsonify({'response': f"Message sent to {contact}"})
    elif "exit" in command:
        say("Exiting...")
        return jsonify({'response': 'Exiting...'})
    else:
        say("Sorry, I didn't understand that.")

    return jsonify({'response': f"Processed command: {command}"})

def send_whatsapp_message(contact, message):
    say(f"Sending message to {contact}")
    webbrowser.open("https://web.whatsapp.com")
    time.sleep(25)

    pyautogui.click(300, 250)
    time.sleep(2)
    pyautogui.hotkey("ctrl", "a")
    pyautogui.press("backspace")
    pyperclip.copy(contact)
    pyautogui.hotkey("ctrl", "v")
    time.sleep(5)
    pyautogui.press("down")
    time.sleep(1)
    pyautogui.press("enter")
    time.sleep(5)
    pyautogui.click(1173, 950)
    time.sleep(1)
    pyautogui.write(message, interval=0.05)
    pyautogui.press("enter")
    say("Message sent.")

if __name__ == '__main__':
    print("✅ Starting Flask app on 0.0.0.0:5000")
    app.run(host='0.0.0.0', port=5000)
