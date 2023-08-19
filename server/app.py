from flask import Flask, request, jsonify
import midas

app = Flask(__name__)


def process_message(message):
    return {"message": message.upper()}


@app.route("/midasai", methods=["POST"])
def process():
    try:
        data = request.get_json()
        input_message = data["message"]
        result = midas.generate(input_message)
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


if __name__ == "__main__":
    app.run(host="localhost", port=8000)
