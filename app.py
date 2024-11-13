from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///paths.db"
db = SQLAlchemy(app)

class Path(db.Model):
    __tablename__ = "paths"
    id = db.Column(db.Integer, primary_key=True)
    color = db.Column(db.String, nullable=False)
    points = db.relationship("PathPoint", backref="path", cascade="all, delete-orphan")

class PathPoint(db.Model):
    __tablename__ = "path_points"
    id = db.Column(db.Integer, primary_key=True)
    path_id = db.Column(db.Integer, db.ForeignKey("paths.id"), nullable=False)
    x = db.Column(db.Float, nullable=False)
    y = db.Column(db.Float, nullable=False)

with app.app_context():
    db.create_all()

@app.route("/upload_paths", methods=["POST"])
def upload_paths():
    data = request.get_json()
    for path_data in data:
        path = Path(color=path_data["color"])
        db.session.add(path)
        db.session.commit()

        for point in path_data["points"]:
            path_point = PathPoint(path_id=path.id, x=point["x"], y=point["y"])
            db.session.add(path_point)

    db.session.commit()
    return jsonify({"message": "Paths uploaded successfully"}), 201

@app.route("/get_paths", methods=["GET"])
def get_paths():
    paths = Path.query.all()
    result = []
    for path in paths:
        points = [{"x": point.x, "y": point.y} for point in path.points]
        result.append({"id": path.id, "color": path.color, "points": points})
    return jsonify(result)

if __name__ == "__main__":
    app.run(debug=True)
