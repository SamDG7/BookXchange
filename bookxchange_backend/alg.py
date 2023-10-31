
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

encode = {'Fantasy': 0, 
            'Young-adult': 1,
            'Romance': 2,
            'New-adult': 3,
            'Science Fiction': 4, 
            'Paranormal': 5, 
            'Horror': 6, 
            'Thriller': 7, 
            'Crime and Mystery': 8, 
            'Biography': 9, 
            'Historical': 10}

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
  swiped_book = list(db.db.book_collection.find({'_id': queue[0][0]}))
  print(f'This is the users current queue: {queue}\n\n\n\n')
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
    swiped_book[1] += 30

  

  #add 1 new book to queue
    
  if not right:
    queue.append(swiped_book)

  queue.sort(key= lambda x: x[1])
  db.db.queue_collection.find_one_and_replace({'uuid': uuid}, {'$set': {
      'queue': queue
    }})
  return 1








def main():
  updateQueueOnSwipe('ds3nim2RO6MuNWkngeTRclFNfcZ2', True)
  return 0
if __name__ == "__main__":
    main()