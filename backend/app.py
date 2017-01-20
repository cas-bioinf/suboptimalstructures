"""Entry point to the webservice """
from flask import Flask, jsonify, make_response

app = Flask(__name__)


next_request_id = 0


@app.after_request
def add_default_headers(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response


@app.route('/compute', methods=['POST'])
def compute():
    global next_request_id
    response = jsonify({"requestID": str(next_request_id)})
    next_request_id += 1
    return response

def not_available(request_id):
    return make_response(jsonify("Result not available"), 404)

@app.route('/status/<int:request_id>')
def status(request_id):
    if request_id == 0:
        response = jsonify({"requestID" : str(request_id), "status" : "Complete"})
    elif request_id >= 0 and request_id < next_request_id:
        response = jsonify({"requestID" : str(request_id), "status" : "Running"})
    else:
        response = not_available(str(request_id))
    return response

@app.route('/result/<int:request_id>')
def result(request_id):
    if request_id == 0:
        response = jsonify({"requestID" : str(request_id), "result" : "Very very happy"})
    else:
        response = not_available(request_id)
    return response


@app.route('/')
def index():
    return "Nothing to see here, move along"
