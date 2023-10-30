from ast import List
import base64
import binascii
import io
from json import dumps, loads
from tkinter import Image
from flask import Flask, request, jsonify
import pandas as pd
from os import abort
from uuid import uuid4, UUID
import db
import requests
from flask_cors import CORS, cross_origin
from requests_toolbelt.multipart import decoder

from alg import createQueue
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
@app.route('/user/signup', methods=['PUT'])
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
    # user = db.db.user_collection.replace_one({"uuid": uuid},
    #     {
    #         "uuid": uuid,
    #         "user_email": user_email,
    #         "user_phone": "",
    #         "user_name": "",
    #         "user_bio": "",
    #         "user_zipcode": ""
    #     }, upsert=True)

    db.db.user_collection.replace_one({"uuid": uuid},
        {
            "uuid": uuid,
            "user_email": user_email,
            "user_phone": "",
            "user_name": "",
            "user_bio": "",
            "user_zipcode": ""
        }, upsert=True)
    
    

    return json, 201

# user log in -- returning user
@app.route('/user/<user_uid>', methods=['GET'])
def user_login(user_uid):

    # user = db.db.user_collection.find({
    #     "uuid": user_uid
    # })
    user = db.db.user_collection.find_one({
        # 'uuid': str(user_uid)
        'uuid': user_uid
    })
    user = pd.DataFrame([user])
    if (user.empty):
        return "Resource Not Found", 404
    #user = user.astype({"uuid": str, "_id": str})
    user = user.drop(columns=["_id"])
    #user = user.groupby(["uuid", "user_email", "user_phone", "user_name", "user_bio", "user_zipcode"], as_index=False).agg(lambda user_genre: ','.join(user_genre.tolist()))
    #user = user.astype({"user_genre" : list})
    #print(user)
    
    # return user.to_json(orient='records', force_ascii=False)
    return user.to_json(orient='records')
    # return loads(dumps(user))

# user account delete
@app.route('/user/delete', methods=['DELETE'])
def user_delete():
    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'
    
    uuid = json['uuid']

    db.db.user_collection.delete_one({
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
    user_zipcode = json['user_zipcode']
    print(user_name)
    print(user_bio)
    print(user_genre)
    print(user_zipcode)
    # global user_uid = json['uuid']

    # user = db.db.user_collection.find_one_and_update({"uuid": uuid}, 
    #     {'$set': {"user_name": user_name,
    #     "user_bio": user_bio,
    #     "user_genre": user_genre,
    #     "user_zipcode": user_zipcode}}
    # )

    db.db.user_collection.find_one_and_update({"uuid": uuid}, 
        {'$set': {"user_name": user_name,
        "user_bio": user_bio,
        "user_genre": user_genre,
        "user_zipcode": user_zipcode}}
    )

    q = createQueue(uuid, list(db.book_collection.find({})), user_genre)
    print(list(db.book_collection.find({})))

    db.db.queue_collection.insert_one({"uuid": uuid, "queue": q})

    return json, 201

#Temporary Route for Queue Creation
# @app.route('/queue/create_queue', methods=['PUT'])
# def create_queue():
#     content_type = request.headers.get('Content-Type')
#     if(content_type == 'application/json; charset=utf-8'):
#         json = request.json
#     else:
#         return 'content type not supported'
    
#     uuid = json['uuid']
#     q = db.db.queue_collection.insert_one({"uuid": uuid})

#     return json, 201

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
    user_zipcode = json['user_zipcode']

    # global user_uid = json['uuid']

    # user = db.db.user_collection.find_one_and_update({"uuid": uuid}, 
    #     {'$set': {"user_name": user_name,
    #     "user_bio": user_bio, "user_zipcode": user_zipcode}}
    # )

    db.db.user_collection.find_one_and_update({"uuid": uuid}, 
        {'$set': {"user_name": user_name,
        "user_bio": user_bio, "user_zipcode": user_zipcode}}
    )

    return json, 201


@app.route('/user/save_picture', methods=['POST'])
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


@app.route('/user/get_picture/<user_uid>', methods=['GET'])
def user_get_picture(user_uid):
    
    try:
        # with open("images/%s.png" %user_uid, "rb") as f:
        #     image = Image.open(f)

        with open("images/%s.png" %user_uid, "rb") as f:
            base64_string = base64.b64encode(f.read())
    
        #print(base64_string)
    except:
        print("file not found");        
    
    # return user.to_json(orient='records', force_ascii=False)
    return jsonify({'user_picture': base64_string.decode('utf-8')})





##############################
# BOOK STUFF
##############################



# user create book

@app.route('/book/create_book', methods=['PUT'])
def user_library_create_book():

    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'
    
    uuid = json['uuid']
    title = json['title']
    author = json['author']
    year = json['year']
    genre = json['genre']
    bookCover = json['book_cover']
    yourReview = json['personal_review']
    currentStatus = json['status']
    numSwaps = json['numberOfSwaps']

    book = db.db.book_collection.insert_one(
        {
            "uuid": uuid,
            "title": title,
            "author": author,
            "year": year,
            "genre": genre,
            "book_cover": bookCover,
            "personal_review": yourReview,
            "status": currentStatus,
            "numberOfSwaps": numSwaps
            
        }
    )

    newBookID = book.inserted_id

    db.db.library_collection.update_one({'uuid': uuid}, {'$push': {'book_list': newBookID}}, upsert = True)

    return json, 201









# user update book
@app.route('/book/update_book', methods=['PUT'])
def user_library_update_book():
    # (re) setter method so doesn't return anything

    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'

    uuid: json['uuid']
    bookCover: json['book_cover']
    yourReview: json['personal_review']
    currentStatus: json['status']

    book = db.db.book_collection.find_one_and_update(
        {"uuid": uuid}, 

        {'$set': {
            "book_cover": bookCover,
            "personal_review": yourReview,
            "status": currentStatus
        }}
    )

    return json, 201







""" @app.route('/library/<user_uid>', methods=['GET'])
def get_library(user_uid):
    print ("function called")
    library = db.db.library_collection.find_one({
        'uuid': user_uid
    })

    pdLibrary = pd.DataFrame([library])
    
    if (pdLibrary.empty):
        return "Resource Not Found", 404
    
    pdLibrary = pdLibrary.drop(columns=["_id"])
    pdLibrary = pdLibrary.drop(columns=["uuid"])
    
    print(pdLibrary.to_json(orient='records'))
  
    return pdLibrary.to_json(orient='records') """

@app.route('/library/<user_uid>', methods=['GET'])
def get_library(user_uid):
    print ("function called")
    library = db.db.library_collection.find_one({
        'uuid': user_uid
    })

    if library is None:
        return "Resource Not Found", 404
    
    book_ids = library.get('book_list', [])

    return jsonify(book_ids)

@app.route('/book/save_picture', methods=['POST'])
def book_save_picture():
    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'

    uuid = json['uuid']
    picture = json['picture']

    with open("libraries/%s/.png" %uuid, "wb") as fh:
        fh.write(base64.b64decode(picture, validate=True))
    return json, 201

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)