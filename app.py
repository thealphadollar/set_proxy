from flask import Flask,render_template

app = Flask(__name__)


@app.route('/')
def hello_world():
    return render_template("index.html")

@app.route('/download')
def download():
    return app.send_static_file('set_proxy.sh')


if __name__ == '__main__':
    app.debug=True
    app.run(host='0.0.0.0')
