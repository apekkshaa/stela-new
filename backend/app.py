from flask import Flask, request, jsonify
from roles import Student, Faculty, Admin
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/dashboard": {"origins": "*"}}, supports_credentials=True)


@app.route('/dashboard', methods=['POST'])
def dashboard():
    data = request.json
    username = data.get("username")
    email = data.get("email")
    role = data.get("role")

    role_map = {
        "student": Student,
        "faculty": Faculty,
        "admin": Admin
    }

    if role.lower() not in role_map:
        return jsonify({"error": "Invalid role"}), 400

    user_class = role_map[role.lower()]
    user = user_class(username, email)
    return jsonify(user.get_dashboard())

if __name__ == '__main__':
    app.run(debug=True)
