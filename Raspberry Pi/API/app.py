from flask import Flask, jsonify, render_template
import datetime

app = Flask(__name__)

tasks = [
	{
		'id': 1,
		'title': u'Create API',
		'description': u'Create API for iOS Application',
		'done': True
	},
	{
		'id': 2,
		'title': u'Create iOS Application',
		'description': u'Need to create Weather Station iOS Application',
		'done': False
	}
]


@app.route('/api/v1.0/tasks', methods=['GET'])
def get_tasks():
    return jsonify({'tasks': tasks})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
