from flask import Flask, request
import pandas as pd
from os import abort
from uuid import uuid4, UUID
import db

user_uid = ""

app = Flask(__name__)
@app.route('/')
def flask_mongodb_atlas():
    return "flask mongodb atlas!"

# def get_user_uid():
#     return user_uid
#user sign up
@app.route('/user/signup', methods=['POST'])
def user_singup():
    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json'):
        json = request.json
    else:
        return 'content type not supported'
    
    uuid = json['uuid']
    user_email = json['user_email']
    user_phone = json['user_phone']
    user_name = json['user_name']
    user_bio = json['user_bio']

    # global user_uid = json['uuid']

    user = db.db.user_collection.insert_one({
        "uuid": uuid,
        "user_email": user_email,
        "user_phone": user_phone,
        "user_name": user_name,
        "user_bio": user_bio
    })

    return json

#user log in
@app.route('/user/<user_uid>', methods=['GET'])
def user_login(user_uid):

    user = db.db.user_collection.find({
        "uuid": user_uid
    })
    user = pd.DataFrame(list(user))
    if (user.empty):
        return "Resource Not Found", 404
    user = user.astype({"uuid": str, "_id": str})
    print(user)
    
    return user.to_json(orient='records', force_ascii=False)


if __name__ == '__main__':
    app.run(host='localhost', port=8080, debug=True)