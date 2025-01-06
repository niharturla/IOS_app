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
@app.route("/process_paths", methods=["POST"])
def process_paths():
    data = request.json  # List of paths (each path is a list of {"x": float, "y": float})
    if not data:
        return jsonify({"error": "No path data received"}), 400

    processed_paths = []
    for path in data:
        points = np.array([[point["x"], point["y"]] for point in path])  # Convert to NumPy array

        # Example processing: Normalize the path to fit within a unit square
        min_coords = np.min(points, axis=0)
        max_coords = np.max(points, axis=0)
        normalized_points = (points - min_coords) / (max_coords - min_coords)

        # Convert back to a list of dictionaries for JSON response
        processed_path = [{"x": float(x), "y": float(y)} for x, y in normalized_points]
        processed_paths.append(processed_path)

    return jsonify({"processed_paths": processed_paths}), 200



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
