from flask import Flask, jsonify
import random

app = Flask(__name__)

@app.route('/data')
def generate_data():
    data = [{'name': f'Item {i}', 'value': random.randint(1, 100)} for i in range(1, 11)]
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)

