from ast import List
import base64
import binascii
import io
from json import dumps, loads
import json
from tkinter import Image
from flask import Flask, request, jsonify
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

    # print(library_df)
    #for i,j in library_df._id.len
    if (library_df.empty):
            return "Resource Not Found", 404
    
    
    # #library_df["book_covers"] = ""
    # #print(library_df);
    # #print(library_df.info())
    # for i in library_df.book_list:
         
    #     try:
    #         full_fp = ""
    #         mypath = './book_covers/%s' %user_uid
    #         #print(str(library_df.book_list[0]))
    #         #print(os.listdir(mypath))
    #         myList = []
    #         for i in library_df.book_list[0]:
    #         #for image_fp in os.listdir(mypath):
    #             #print(i)
    #             book_picture = str(i)
    #             print(book_picture)
    #             full_fp = os.path.join(mypath, '%s.png' %str(book_picture))
    #             #print(full_fp)
    #             #print(full_fp)
    #             with open(full_fp, "rb") as f:
    #                 base64_string = base64.b64encode(f.read())
    #                 myList.append(base64_string.decode('utf-8'))
    #                 #library_df.book_covers[i] = base64_string.decode('utf-8')
    #     except:
    #         print("file not found");    
    # library_df["book_covers"] : myList;    
        
        # return user.to_json(orient='records', force_ascii=False)
        # returnList = [];
        # for i, s in enumerate(myList):
        #     myList[i] = myList[i].decode('utf-8')
        
    
    #library_df = library_df.drop(columns=["_id"])
    #print(library_df);
    #library_df[book_list]
    #pdLibrary = pdLibrary.drop(columns=["uuid"])
    
    #print(library_df.to_json(orient='records'))
  
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
    book = db.db.book_collection.find_one({"_id": book_uid})
    book = pd.DataFrame([book])
    book = book.astype({"_id": str, "uuid": str})

    try:

        mypath = './book_covers/%s' %user_uid

        full_fp = os.path.join(mypath, '%s.png' %book_uid)
            #print(full_fp)
        with open(full_fp, "rb") as f:
            base64_string = base64.b64encode(f.read())
            book_cover_encode = (base64_string.decode('utf-8'))
        book['book_cover'] = book_cover_encode
        print(book)
    
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



@app.route('/book/delete/<book_id>', methods=['DELETE'])
def book_delete(book_id):
    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'
    

    db.db.book_collection.delete_one({
        "_id": ObjectId(book_id),
    })
    

    return json, 204

@app.route('/library/delete_book/<uuid>/<book_id>', methods=['PUT'])
def library_delete_book(uuid, book_id):

    content_type = request.headers.get('Content-Type')
    if(content_type == 'application/json; charset=utf-8'):
        json = request.json
    else:
        return 'content type not supported'
    
    db.db.library_collection.update_one(
        {'uuid': uuid},
        {'$pull':
         {'book_list': ObjectId(book_id)}
        }
    )

    try:
        mypath = './book_covers/%s/%s.png' % (uuid, book_id)
        print(mypath)
        os.remove(mypath)
    except:
        print("book not found");  

    return json, 201
    

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)