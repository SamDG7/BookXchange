
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


def calcDistance(pref, book_pref):

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
  
  score = 0
  print(f'Comparing books with bp {book_pref} and p {pref}')
 
  for bp in book_pref:
    if bp not in pref and bp in encode:
      for p in pref:
        score += abs(encode[bp] - encode[p])
  
  return score


def createQueue(uuid, collection, preferences):
  queue = []
  user = list(db.db.user_collection.find({"uuid": uuid}))

  print(f'THIS IS THE USER:::: {user}')
  print(f'PREFERENCESEFSE:::{preferences}')

  for doc in collection:
    if doc['uuid'] != uuid:
      current_book_genres = doc['genres']
      score = calcDistance(preferences, current_book_genres)
      print((doc['_id'], score))
      queue.append([doc['_id'], score])
      print(doc['uuid'])

  queue.sort(key= lambda x: x[1])

  print(queue)

  return queue

#right is a boolean, book_id is the object ID of the book swiped on
def updateQueueOnSwipe(uuid, book_id, right):
  queue = list(db.db.queue_collection.find({"uuid": uuid}))
  book = list(db.db.book_collection.find({"_id": book_id}))

  book_genres = book['genres']
  if right:
    for c, b in enumerate(queue):
      #move books similar to the one swiped on up in the queue, except for the first 5 books remaing constant
      if c > 5:
        iterative_book = list(db.db.book_collection.find({"_id": b[0]}))
        book_score = b[1];
        overlap = sum(el in iterative_book['genres'] for el in book_genres)

        if overlap > 0:
          #decrease by 2
          ...
        elif overlap > 2:
          #decrease by 4
          ...
      ...
  else:
    #move similar books down in queue, except for the first five docts
    ...


  return 1