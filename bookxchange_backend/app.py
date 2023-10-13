import base64
import binascii
import io
from tkinter import Image
from flask import Flask, request
import pandas as pd
from os import abort
from uuid import uuid4, UUID
import db
import requests
from flask_cors import CORS, cross_origin
from requests_toolbelt.multipart import decoder

user_uid = ""

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


@app.route('/')
def flask_mongodb_atlas():
    return "flask mongodb atlas!"

# def get_user_uid():
#     return user_uid
#user sign up

## USER ACCOUNT ROUTES 

# user sign up -- new user
@app.route('/user/signup', methods=['POST'])
@cross_origin()
def user_singup():
    content_type = request.headers.get('Content-Type')
    print(content_type);
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'
    
    uuid = json['uuid']
    user_email = json['user_email']
    # user_phone = json['user_phone']
    # user_name = json['user_name']
    # user_bio = json['user_bio']

    # global user_uid = json['uuid']

    # user = db.db.user_collection.insert_one({
    #     "uuid": uuid,
    #     "user_email": user_email,
    #     "user_phone": "",
    #     "user_name": "",
    #     "user_bio": "",
    # })
    user = db.db.user_collection.replace_one({"uuid": uuid},
        {
            "uuid": uuid,
            "user_email": user_email,
            "user_phone": "",
            "user_name": "",
            "user_bio": "",
        }, upsert=True)

    return json, 201

# user log in -- returning user
@app.route('/user/<user_uid>', methods=['GET'])
def user_login(user_uid):

    user = db.db.user_collection.find({
        "uuid": user_uid
    })
    user = pd.DataFrame(list(user))
    if (user.empty):
        return "Resource Not Found", 404
    user = user.astype({"uuid": str, "_id": str})
    user = user.drop(columns=["_id"])
    #print(user)
    
    # return user.to_json(orient='records', force_ascii=False)
    return user.to_json(orient='records')

# user account delete
@app.route('/user/delete', methods=['DELETE'])
def user_delete():
    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'
    
    uuid = json['uuid']

    user = db.db.user_collection.delete_one({
        "uuid": uuid,
    })

    return json, 204

## USER PROFILE ROUTES 

# user create profile
@app.route('/user/create_profile', methods=['PUT'])
def user_create_profile():
    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'
    
    uuid = json['uuid']
    user_name = json['user_name']
    user_bio = json['user_bio']
    user_genre = json['user_genre']

    # global user_uid = json['uuid']

    user = db.db.user_collection.find_one_and_update({"uuid": uuid}, 
        {'$set': {"user_name": user_name,
        "user_bio": user_bio,
        "user_genre": user_genre}}
    )

    return json, 201

# user update profile
@app.route('/user/update_profile', methods=['PUT'])
def user_update_profile():
    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'
    
    uuid = json['uuid']
    user_name = json['user_name']
    user_bio = json['user_bio']

    # global user_uid = json['uuid']

    user = db.db.user_collection.find_one_and_update({"uuid": uuid}, 
        {'$set': {"user_name": user_name,
        "user_bio": user_bio}}
    )

    return json, 201


@app.route('/user/save_picture', methods=['PUT'])
def user_save_picture():
    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'

    uuid = json['uuid']
    picture = json['picture']

    with open("images/%s.png" %uuid, "wb") as fh:
        fh.write(base64.b64decode(picture, validate=True))
    return json, 201


@app.route('/user/<user_uid>/get_picture', methods=['GET'])
def user_get_picture(user_uid):
    
    with open("images/%s.png" %user_uid, "rb") as f:
        base64_string = base64.b64encode(f.read())
    
    #print(user)
    
    # return user.to_json(orient='records', force_ascii=False)
    return user.to_json(orient='records')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)