from flask import Flask, render_template
import requests

app = Flask(__name__)

@app.route('/')
def index():
    data = requests.get('http://data-generator:5001/data').json()
    return render_template('index.html', data=data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

