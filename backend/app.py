"""Entry point to the webservice """
from flask import Flask, jsonify, make_response

app = Flask(__name__)


next_request_id = 0


def add_default_headers(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response


@app.route('/compute', methods=['POST'])
def compute():
    global next_request_id
    response = jsonify({"requestID": next_request_id})
    next_request_id += 1
    return add_default_headers(response)

def not_available(request_id):
    return make_response(jsonify("Result not available"), 404)

@app.route('/status/<int:request_id>')
def status(request_id):
    if request_id == 0:
        response = jsonify({"requestID" : request_id, "status" : "Complete"})
    elif request_id >= 0 and request_id < next_request_id:
        response = jsonify({"requestID" : request_id, "status" : "Computing"})
    else:
        response = not_available(request_id)
    return add_default_headers(response)

@app.route('/result/<int:request_id>')
def result(request_id):
    if request_id == 0:
        response = jsonify({"requestID" : request_id, "result" : "Very very happy"})
    else:
        response = not_available(request_id)
    return add_default_headers(response)


@app.route('/')
def index():
    return "Nothing to see here, move along"
