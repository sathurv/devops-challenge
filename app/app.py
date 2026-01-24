from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello DevOps! by sathur"

@app.route("/health")
def health():
    return jsonify(status="OK")