
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

encode = { 'Fairy Tale': 1,
            'Mythology': 2,
            'Young-adult': 3,
            'Romance': 4,
            'Adventure': 5,
            'New-adult': 6,
            'Fiction': 7,
            'Science Fiction': 8, 
            'Paranormal': 9, 
            'Horror': 10, 
            'Thriller': 11, 
            'Crime and Mystery': 12, 
            'Biography': 13, 
            'Historical': 14,
            'Classics': 15}

def calcDistance(pref, book_pref):
  score = 0
  print(f'Comparing books with bp {book_pref} and p {pref}')
 
  for bp in book_pref:
    if bp not in pref and bp in encode:
      for p in pref:
        if p in encode:
          score += abs(encode[bp] - encode[p])
  
  return score
def createQueue(uuid, collection, preferences):
  queue = []
  user = list(db.db.user_collection.find({"uuid": uuid}))
  for doc in collection:
    if doc['uuid'] != uuid:
      current_book_genres = doc['genres']
      score = calcDistance(preferences, current_book_genres)
      queue.append([doc['_id'], score])

  queue.sort(key= lambda x: x[1])

  print(queue)

  return queue





#right is a boolean, book_id is the object ID of the book swiped on
def updateQueueOnSwipe(uuid, right):
  queue = list(db.db.queue_collection.find({"uuid": uuid}))[0]['queue']
  user_genres = list(db.db.user_collection.find({'uuid': uuid}))[0]['user_genre']
  swiped_book = list(db.db.book_collection.find({'_id': queue[0][0]}))
  print(f'This is the users current queue: {queue}\n\n\n\n')
  swiped_book_in_queue = queue[0]
  
  queue.pop(0)

  if right:    
    swiped_book_genres = swiped_book[0]['genres']

    for book in queue:
      curr_book = list(db.db.book_collection.find({'_id': book[0]}))[0]
      curr_book_genres = curr_book['genres']
      val = calcDistance(swiped_book_genres, curr_book_genres)
      if val == 0:
        book[1] -= 5
      elif val < 5:
        book[1] -=2
      elif val < 10:
        book[1] -=1
   
    queue.sort(key= lambda x: x[1])
    print(queue)
    #mark as wanted
  else:
    print(swiped_book_in_queue)
    swiped_book_in_queue[1] += 30
    print(swiped_book_in_queue)

  

  #add 1 new book to queue
  all_books = list(db.book_collection.find({}))
  new_book_found = False
  for doc in reversed(all_books):
    b = doc['_id']
    for i in queue:
      i_1 = i[0]
      if b != i_1:
        queue.append([b, calcDistance(doc['genres'], user_genres)])
        new_book_found = True
        break
    if new_book_found: break



  if not right:
    queue.append(swiped_book_in_queue)


  queue.sort(key= lambda x: x[1])
  db.db.queue_collection.find_one_and_update({'uuid': uuid}, {'$set': {
      'queue': queue
    }})
  return 1








def main():
  updateQueueOnSwipe('pD1EYTRa4CNoCNu767VYgwytfTR2', True)
  return 0
if __name__ == "__main__":
    main()