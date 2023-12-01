from ast import List
import base64
import binascii
import io
from json import dumps, loads
import json
from tkinter import Image
from flask import Flask, request, jsonify, redirect, url_for
import pandas as pd
#from os import abort
import os 
from uuid import uuid4, UUID
import db
import requests
from flask_cors import CORS, cross_origin
from requests_toolbelt.multipart import decoder
from bson.objectid import ObjectId

from alg import createQueue
from alg import updateQueueOnSwipe
user_uid = ""
new_book_uid = ''

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'



def set_new_book_uid(book_uid):
    new_book_uid = book_uid

def get_new_book_uid():
    return new_book_uid

@app.route('/')
def flask_mongodb_atlas():
    return "flask mongodb atlas!"

# def get_user_uid():
#     return user_uid
#user sign up


## MODERATOR ROUTES

@app.route('/moderator/all_users', methods=['GET'])
def get_all_users():

    user_list = db.db.user_collection.find({})
    user_list_df = pd.DataFrame(user_list)

    print(user_list_df.info())
    user_list_df = user_list_df.drop(columns=["_id", "user_swipe", "num_raters", "user_rating", "user_genre", "user_zipcode", "user_phone", "user_bio", "user_radius"])
    print(user_list_df.info())

    if (user_list_df.empty):
            return "Resource Not Found", 404
    
    return user_list_df.to_json(orient='records')


@app.route('/moderator/get_user/<user_uid>', methods=['GET'])
def get_mod_user(user_uid):

    user = db.db.user_collection.find_one({
        # 'uuid': str(user_uid)
        'uuid': user_uid
    })
    if (user == None):
        return "Resource Not Found", 404
    user_df = pd.DataFrame([user])
    #user_list_df = pd.DataFrame(user_list)

    #print(user_df.info())
    #user_df = user_df.drop(columns=["_id", "user_swipe", "num_raters"])
    user_df = user_df.drop(columns=["_id", "user_swipe"])
    
    
    try:
        with open("images/%s.png" %user_uid, "rb") as f:
            base64_string = base64.b64encode(f.read())
            user_df['user_picture'] = base64_string.decode('utf-8')
    except:
        user_df['user_picture'] = ""
        print("file not found");        
    
    #jsonify({'user_picture': base64_string.decode('utf-8')})

    print(user_df.info())

    if (user_df.empty):
            return "Resource Not Found", 404
    
    return user_df.to_json(orient='records')

@app.route('/moderator/delete_user/<user_uid>', methods=['DELETE'])
def mod_user_delete(user_uid):
    # content_type = request.headers.get('Content-Type')
    # if (content_type == 'application/json; charset=utf-8'):
    #     json = request.json
    # else:
    #     return 'content type not supported'
    
    print(user_uid);
    user_email = db.db.user_collection.find_one({'uuid': user_uid}, {"_id" : 0, "uuid" : 0, "user_name" : 0, "user_phone" : 0, "user_bio" : 0, "user_zipcode" : 0, "user_radius" : 0, "user_rating" : 0, "num_raters" : 0, "user_genre" : 0, "blocked_user": 0, "user_swipe": 0, "cities": 0})
    print(user_email["user_email"]);
    delete_user = db.db.user_collection.delete_one({
        'uuid': user_uid,
    })
    db.db.mod_collection.update_one(
        {
            "uuid": "pDVeA1GgkbajzI3kpopcc1Qrng02"
        },
        {
            "$addToSet": {
                "deleted_users": user_email["user_email"]
            }
        }
     );

    return user_uid, 204

@app.route('/moderator/deleted_users', methods=['GET'])
def get_deleted_users():

    user_list = db.db.mod_collection.find_one({}, {"_id" : 0, "uuid" : 0})
    delete_user_list = user_list['deleted_users'];
    print(delete_user_list);
    #print(user_list_df.info())
    # user_list_df = user_list_df.drop(columns=["_id", "user_swipe", "num_raters", "user_rating", "user_genre", "user_zipcode", "user_phone", "user_bio", "user_radius"])
    # print(user_list_df.info())

    # if (user_list_df.empty):
    #         return "Resource Not Found", 404
    
    return delete_user_list
## USER ACCOUNT ROUTES 

# user sign up -- new user
@app.route('/user/signup', methods=['PUT'])
@cross_origin()
def user_singup():
    content_type = request.headers.get('Content-Type')
    print(content_type)
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

    user = db.db.user_collection.insert_one({
        "uuid": uuid,
        "user_email": user_email,
        "user_phone": "",
        "user_name": "",
        "user_bio": "",
        "user_zipcode": "",
        "user_radius": "",
        "user_rating": 0.0,
        "num_raters": 0,
        "blocked_user" : [],
        "cities": [],
        
        #"user_swipe" : property.__dict__
        "user_swipe" : []
    })
    # user = db.db.user_collection.replace_one({"uuid": uuid},
    #     {
    #         "uuid": uuid,
    #         "user_email": user_email,
    #         "user_phone": "",
    #         "user_name": "",
    #         "user_bio": "",
    #         "user_zipcode": ""
    #     }, upsert=True)

    # db.db.user_collection.replace_one({"uuid": uuid},
    #     {
    #         "uuid": uuid,
    #         "user_email": user_email,
    #         "user_phone": "",
    #         "user_name": "",
    #         "user_bio": "",
    #         "user_zipcode": "",
    #         "user_radius": "",
    #         #"user_swipe" : {},
    #         "user_swipe" : property.__dict__
    #     }, upsert=True)
    
    

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
    if (user == None):
        return "Resource Not Found", 404
    user = pd.DataFrame([user])
    # print(user);
    # print(user.empty)
    # if (user.empty):
    #     print("true")
    #     return "Resource Not Found", 404
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
    user_radius = json['user_radius']
    user_rating = json['user_rating']
    num_raters = json['num_raters']
    cities = json['cities']
  
    print(cities)
    #cities = [entry["city_name"] for entry in cities]


    # print(user_name)
    # print(user_bio)
    # print(user_genre)
    # print(user_zipcode)
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
        "user_zipcode": user_zipcode,
        "user_radius": user_radius,
        "user_rating": user_rating,
        "num_raters": num_raters,
        "cities": cities}}
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
    user_radius = json['user_radius']

    # global user_uid = json['uuid']

    # user = db.db.user_collection.find_one_and_update({"uuid": uuid}, 
    #     {'$set': {"user_name": user_name,
    #     "user_bio": user_bio, "user_zipcode": user_zipcode}}
    # )

    db.db.user_collection.find_one_and_update({"uuid": uuid}, 
        {'$set': {"user_name": user_name,
        "user_bio": user_bio, "user_zipcode": user_zipcode, "user_radius": user_radius}}
    )

    return json, 201

@app.route('/user/reset_algo', methods=['PUT'])
def user_reset_algo():
    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'
    
    uuid = json['uuid']
    user_genre = json['user_genre']

    db.db.user_collection.find_one_and_update({"uuid": uuid}, 
        {'$set': {"user_genre": user_genre}}
    )

    db.db.queue_collection.delete_one({"uuid": uuid})
    user = db.db.user_collection.find_one({"uuid": uuid})
    print(user['user_genre'])
    q = createQueue(uuid, list(db.book_collection.find({})), user['user_genre'])
    db.db.queue_collection.insert_one({"uuid": uuid, "queue": q})
    #createQueue(uuid, list(db.book_collection.find({})), user_genre)
    #(uuid, collection, preferences)

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

# user add user rating
@app.route('/user/add_userrating', methods=['PUT'])
def user_library_add_userrating():
    # (re) setter method so doesn't return anything

    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'

    uuid = json['uuid']
    userRating = json['user_rating']
    #numRaters = json['num_raters']

    user = db.user_collection.find_one({"uuid": uuid})
    currentRating = user.get("user_rating", 0)
    numRaters = user.get("num_raters", 0)

    # get current rating from backend

    total_rating = currentRating * numRaters
    total_rating = total_rating + userRating
    userRating  = total_rating / (numRaters + 1)
    numRaters = numRaters + 1
    print(userRating)
    print(numRaters)
    print(uuid)

    user = db.db.user_collection.find_one_and_update(
        {"uuid": uuid}, 

        {'$set': {
            "user_rating": userRating,
            "num_raters": numRaters
        }}
    )

    return json, 201

# user add blocked user
@app.route('/user/add_blockeduser', methods=['PUT'])
def user_library_add_blockeduser():
    # (re) setter method so doesn't return anything

    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'

    uuid = json['uuid']
    blockedUser = json['blocked_user']
   
    user = db.db.user_collection.find_one_and_update(
        {"uuid": uuid}, 

        {'$addToSet': {
            "blocked_user": blockedUser
        }}
    )

    return json, 201

# Route to get a user's cities
@app.route('/user/get_cities/<uuid>', methods=['GET'])
def get_cities(uuid):

    user = db.db.user_collection.find_one({
        'uuid': uuid
    })

    if user is None:
        return "Resource Not Found", 404

    # Extract relevant information (cities) from the user document
    cities = user.get('cities', '')

    # Create a JSON response with the extracted information
    response = {
        'cities': cities,
    }

    return jsonify(response)


##############################
# BOOK STUFF
##############################



# user create book

@app.route('/book/create_book', methods=['POST'])
def user_library_create_book():

    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'
    
    uuid = json['uuid']
    title = json['title']
    author = json['author']
    #year = json['year']
    genres = json['genres']
    isbn13 = json['isbn13']
    bookStatus = json['book_status']
    book_cover = json['book_cover']

    #yourReview = json['personal_review']
    #currentStatus = json['status']
    #numSwaps = json['numberOfSwaps']

    book = db.db.book_collection.insert_one (
        {
            "uuid": uuid,
            "title": title,
            "author": author,
            #"year": year,
            "genres": genres,
            "isbn13": isbn13,
            "book_status": bookStatus,
            #"book_cover": bookCover,
            #"personal_review": yourReview,
            #"status": currentStatus,
            #"numberOfSwaps": numSwaps  
        }
    )
    set_new_book_uid(book.inserted_id)
    newBookID = book.inserted_id

    new_book_uid = str(newBookID)
    #print(new_book_uid)

    path = './book_covers/%s' %uuid
    if not os.path.exists(path):
        os.mkdir(path)

    # if not new_book_uid :
    #     return json, 404
    # print(type(newBookID.toString()))
    # print("new book uid" + newBookID.toString())
    #book_id = str(newBookID)
    with open("book_covers/" + uuid + "/" + new_book_uid + ".png", "wb") as fh:
   
    #with open(os.path.join(path, "/%s.png") %new_book_uid, "wb") as fh:
        fh.write(base64.b64decode(book_cover, validate=True))

    #new_book_uid = newBookID
    db.db.library_collection.update_one({'uuid': uuid}, {'$push': {'book_list': newBookID}}, upsert = True)

    return json, 201




# user update book
@app.route('/book/update_book', methods=['PUT'])
def user_library_update_book():
    # (re) setter method so doesn't return anything

    content_type = request.headers.get('Content-Type')
    #if(content_type == 'application/json; charset=utf-8'):
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'

    book_uid = json['book_uid']
    title = json['title']
    author = json['author']
    isbn13 = json['isbn13']
    genres = json['genres']  

    update_fields = {}

    if len(title) != 0:
        update_fields['title'] = title
    
    if len(author) != 0:
        update_fields['author'] = author
        
    if len(isbn13) != 0:
        update_fields['isbn13'] = isbn13
    
    if genres:
        update_fields['genres'] = genres

    book = db.db.book_collection.find_one_and_update(
        {"_id": ObjectId(book_uid)}, 

        {'$set': 
            # "title": title,
            # "author": author,
            # "isbn13": isbn13,
            # "genres": genres,
            update_fields
        }
    )

    return json, 201

# user update bookstatus
@app.route('/book/update_bookstatus', methods=['PUT'])
def user_library_update_bookstatus():
    # (re) setter method so doesn't return anything

    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'

    book_uid = json['book_uid']
    bookStatus = json['bookStatus']

    book = db.db.book_collection.find_one_and_update(
        {"_id": ObjectId(book_uid)}, 

        {'$set': {
            "book_status": bookStatus,
        }}
    )

    return json, 201


@app.route('/library/<user_uid>', methods=['GET'])
def get_library(user_uid):
    #print ("function called")
    library = db.db.library_collection.find_one({
        'uuid': user_uid
    })
    library_df = pd.DataFrame(columns=['book_list', 'book_covers'])
    print(library)
    print(library['book_list'])
    book_cover_encode = ""
    #row_dict = {}
    book_list_add = []
    book_cover_add = []
    for i in library['book_list']:
        # try:
            full_fp = ""
            mypath = './book_covers/%s' %user_uid
            #print(str(library_df.book_list[0]))
            #print(os.listdir(mypath))
            #myList = []
            #for image_fp in os.listdir(mypath):
                #print(i)
            book_picture = str(i)
            #print(book_picture)
            full_fp = os.path.join(mypath, '%s.png' %book_picture)
            print(full_fp)
            #print(full_fp)
            with open(full_fp, "rb") as f:
                base64_string = base64.b64encode(f.read())
                book_cover_encode = (base64_string.decode('utf-8'))
                    #library_df.book_covers[i] = base64_string.decode('utf-8')
            #row_dict = {"book_list": str(i), "book_covers": str(book_cover_encode)}
            book_list_add.append(str(i))
            book_cover_add.append(str(book_cover_encode))
        # except:
        #     print("file not found"); 
        
        #library_df = library_df.add({row_dict})
    #print(book_list_add)
    #print(book_cover_add)
    library_df = pd.DataFrame({'book_list': book_list_add, 'book_covers': book_cover_add})

    if (library_df.empty):
            return "Resource Not Found", 404
    
    return library_df.to_json(orient='records')
    #return "test"

# @app.route('/library/<user_uid>', methods=['GET'])
# def get_library(user_uid):
#     print ("function called")
#     library = db.db.library_collection.find_one({
#         'uuid': user_uid
#     })

#     if library is None:
#         return "Resource Not Found", 404
    
#     book_ids = library.get('book_list', [])

#     return jsonify(book_ids)

@app.route('/book/save_picture', methods=['POST'])
def book_save_picture():
    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'

    uuid = json['uuid']
    book_cover = json['book_cover']

    path = './book_covers/%s' %uuid
    if not os.path.exists(path):
        os.mkdir(path)

    # if not new_book_uid :
    #     return json, 404
    print("new bok uid" + new_book_uid)
    with open("book_covers/" + uuid + "/" + new_book_uid + ".png", "wb") as fh:
   
    #with open(os.path.join(path, "/%s.png") %new_book_uid, "wb") as fh:
        fh.write(base64.b64decode(book_cover, validate=True))

    return json, 201

@app.route('/book/get_pictures/<user_uid>', methods=['GET'])
def book_get_pictures(user_uid):
    
    try:
        full_fp = ""
        mypath = './book_covers/%s'% user_uid
        #print(mypath)
        myList = []
        # with open("images/%s.png" %user_uid, "rb") as f:
        #     image = Image.open(f)
        print(os.listdir(mypath))
        for image_fp in os.listdir(mypath):
            #print(image_fp)
            #print()
            #print(os.path.join(mypath, image_fp))
            full_fp = os.path.join(mypath, image_fp)
            print(full_fp)
            with open(full_fp, "rb") as f:
                base64_string = base64.b64encode(f.read())
                myList.append(base64_string)
       #print(myList)
        returnList = [];
        for i, s in enumerate(myList):
            myList[i] = myList[i].decode('utf-8')
        
        #print()
    except:
        print("file not found");
        return(myList)        
    
    # return user.to_json(orient='records', force_ascii=False)
    

    #print(type(myList[1]))
    #print(type(myList))
    #print(myList)
    #return jsonify({'user_picture': myList})
    #return json.dumps(myList)
    #return json.dumps({'book_covers': myList})
    return ({'book_covers': myList})

@app.route('/book/get_picture/<book_uid>', methods=['GET'])
def book_get_swapped_picture(book_uid):
    book = db.db.book_collection.find_one({"_id": ObjectId(book_uid)});
    mypath = './book_covers/%s' %(book['uuid'])
    print(mypath)
    full_fp = os.path.join(mypath, '%s.png' %book_uid)
    print(full_fp)
    try:
    #     full_fp = ""
    #     print(book['uuid'])
    #     mypath = './book_covers/%s'% book['uuid']
    #     full_fp = os.path.join(mypath, book_uid)
    #     print(full_fp + ".png")
    #     with open(full_fp, "rb") as f:
    #         base64_string = base64.b64encode(f.read())
    #         base64_string = base64_string.decode('utf-8')

        
        
            #print(full_fp)
        with open(full_fp, "rb") as f:
            base64_string = base64.b64encode(f.read())
            book_image = (base64_string.decode('utf-8'))
    except:
        base64_string = "";
        print("file not found");
    return jsonify({'book_picture': book_image})

#THIS IS THE TEMP QUEUE BACKEND

@app.route('/book/get_next/<user_uid>/<right>', methods=['GET'])
def get_book_cover(user_uid, right):
    if (right == "false"):
        updateQueueOnSwipe(user_uid, False)
    elif (right == "true"): 
        updateQueueOnSwipe(user_uid, True)
    
        
    #queue = list(db.db.queue_collection.find({"uuid": user_uid}))[0]['queue'];
    # if index < 0 or index >= len(queue):
    #     return jsonify({'error': 'Invalid index'})
    
    book_uid = (db.db.queue_collection.find({"uuid": user_uid}))[0]['queue'][0][0];
    print(book_uid)
    if db.db.book_collection.count_documents({"_id": ObjectId(book_uid)}) == 0:
        return "Book not found", 404;
    book = db.db.book_collection.find_one({"_id": ObjectId(book_uid)})
    book = pd.DataFrame([book])
    #if 
    print(book.info())
    book = book.astype({"_id": str, "uuid": str})
    print(book['title'])
    #print(book['uuid'].to_string(index=False))

    try:

        mypath = './book_covers/%s' %(book['uuid'].to_string(index=False))

        full_fp = os.path.join(mypath, '%s.png' %book_uid)
        print(full_fp)
            #print(full_fp)
        with open(full_fp, "rb") as f:
            base64_string = base64.b64encode(f.read())
            book_cover_encode = (base64_string.decode('utf-8'))
        book['book_cover'] = book_cover_encode
        #print(book)
    
        #print(base64_string)
    except:
        print("file not found");     
    
    

    return book.to_json(orient='records')

@app.route('/book/<book_id>', methods=['GET'])
def get_book_info(book_id):

    book = db.db.book_collection.find_one({
        '_id': ObjectId(book_id)
    })
    book = pd.DataFrame([book])
    book = book.astype({"_id": str, "uuid": str})
    print(book)
    return book.to_json(orient='records')



@app.route('/book/delete/', methods=['DELETE'])
def book_delete():
    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
    #if(content_type == 'application/json'):
        json = request.json
    else:
        return 'content type not supported'
    
    book_uid = json['book_uid']
    

    db.db.book_collection.delete_one({
        "_id": ObjectId(book_uid),
    })
    

    return json, 204

@app.route('/library/delete_book/', methods=['PUT'])
def library_delete_book():

    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
    #if(content_type == 'application/json'):
        json = request.json
    else:
        return 'content type not supported'
    
    uuid = json['uuid']
    book_uid = json['book_uid']
    
    db.db.library_collection.update_one(
        {'uuid': uuid},
        {'$pull':
         {'book_list': ObjectId(book_uid)}
        }
    )

    try:
        mypath = './book_covers/%s/%s.png' % (uuid, book_uid)
        print(mypath)
        os.remove(mypath)
    except:
        print("book not found");  

    return json, 201
    

# check match every time user swipes
@app.route('/book/check_match', methods=['PUT'])
def book_check_match():
    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'
    
    uuid = json['uuid']
    book_uid = json['book_uid']
    book_user_id = json['book_user_id']

    result = db.db.user_collection.update_one({"uuid": uuid, "user_swipe.book_user_id": book_user_id}, {"$push": {"user_swipe.$.book_list": book_uid}})
    print(result)

    if result.modified_count == 0:
        db.db.user_collection.update_one(
        {
            "uuid": uuid
        },
        {
            "$addToSet": {
                "user_swipe": {
                    "book_user_id": book_user_id,
                    "book_list": [book_uid]
                }
            }
        }
     );
    
    if db.db.user_collection.count_documents({"uuid": book_user_id}) == 0:
        return {"match" : False}
    
    match_user_swipes = db.db.user_collection.find_one({"uuid": book_user_id}, {"_id" : 0, "uuid" : 0, "user_email" : 0, "user_name" : 0, "user_phone" : 0, "user_bio" : 0, "user_zipcode" : 0, "user_radius" : 0, "user_rating" : 0, "num_raters" : 0, "user_genre" : 0})
    print(book_user_id);
    print(book_uid);
    print("this is the match_user_list\n")
    print(match_user_swipes['user_swipe'])
    if len(match_user_swipes['user_swipe']) == 0:
        return {"match" : False}

    for book_swipe in (match_user_swipes['user_swipe']):
        print(book_swipe);

       
        
        if book_swipe.get('book_user_id') == uuid :
            #found_match = True
            result = db.db.match_collection.update_one({"uuid": uuid, "matches.match_user_id": book_user_id}, {"$push": {"matches.$.match_list": book_uid}})
            if result.modified_count == 0:
                db.db.match_collection.update_one(
                {
                    "uuid": uuid
                },
                {
                    "$addToSet": {
                        "matches": {
                            "match_user_id": book_user_id,
                            "match_list": [book_uid]
                        }
                    }
                }, upsert=True
                );
            # result = db.db.match_collection.update_one({"uuid": book_user_id, "matches.match_user_id": uuid}, {"$push": {"matches.$.match_list": book_swipe.get('book_list')}})
            # if result.modified_count == 0:
            db.db.match_collection.update_one(
            {
                "uuid": book_user_id
            },
            {
                "$addToSet": {
                    "matches": {
                        "match_user_id": uuid,
                        "match_list": book_swipe.get('book_list')
                    }
                }
            }, upsert=True
            );
            #return redirect(url_for('book/return_match',match = True))
            return {"match" : True}
    
    #return redirect(url_for('book/return_match',match = False))
    return {"match" : False}

@app.route('/user/chat/<user_uid>', methods=['GET'])
def get_chat_users(user_uid):
    user_match_doc = db.db.match_collection.find_one({"uuid": user_uid})
    user_matches = user_match_doc['matches']
    print(user_matches)
    user_match_list = []
    email_match_list = []
    for match in user_matches:
        if match['match_user_id'] not in user_match_list:
            user_match_list.append(match['match_user_id'])
            user = db.db.user_collection.find_one({"uuid": match['match_user_id']})
            email_match_list.append(user['user_email'])
            #user_match_list[""]
            #email_match_list.append(user['user_email'])


    return email_match_list
        
@app.route('/user/matched_books/<user_uid>', methods=['GET'])
def get_matched_books(user_uid):
    user_match_doc = db.db.match_collection.find_one({"uuid": user_uid})
    user_matches = user_match_doc['matches']
    user_match_covers = []
    user_match_books = []
    for matches in user_matches:
        match_id = matches['match_user_id']
        for i in matches['match_list']:
            if i not in user_match_books:
                full_fp = ""
                mypath = './book_covers/%s' %match_id
                book_picture = str(i)

                full_fp = os.path.join(mypath, '%s.png' %book_picture)
                print(full_fp)
                try :
                    with open(full_fp, "rb") as f:
                        base64_string = base64.b64encode(f.read())
                        book_cover_encode = (base64_string.decode('utf-8'))
                except: 
                    book_cover_encode = ""
                
                user_match_books.append(str(i))
                user_match_covers.append(str(book_cover_encode))
    
    library_df = pd.DataFrame({'book_list': user_match_books, 'book_covers': user_match_covers})

    if (library_df.empty):
            return "Resource Not Found", 404
    
    return library_df.to_json(orient='records')



# Route to get another user's about me, community rating, and bio
@app.route('/user/profile/<other_user_uid>', methods=['GET'])
def get_other_user_profile(other_user_uid):
    user = db.db.user_collection.find_one({
        'uuid': other_user_uid
    })

    if user is None:
        return "Resource Not Found", 404

    # Extract relevant information (about me, bio, community rating) from the user document
    about_me = user.get('user_about_me', '')
    bio = user.get('user_bio', '')
    userRating = user.get('user_rating', 0.0)
    
    try:
        with open("images/%s.png" %other_user_uid, "rb") as f:
            base64_string = base64.b64encode(f.read())
            base64_string = base64_string.decode('utf-8')
    except:
        base64_string = "";
        print("file not found");        
    
    # return user.to_json(orient='records', force_ascii=False)
    #return jsonify({'user_picture': base64_string.decode('utf-8')})

    # Create a JSON response with the extracted information
    response = {
        'user_about_me': about_me,
        'user_bio': bio,
        'user_rating': userRating,
        'user_picture': base64_string,
    }

    return jsonify(response)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)