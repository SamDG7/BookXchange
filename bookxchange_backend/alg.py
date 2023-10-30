
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
  for bp in book_pref:
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
      
      queue.append((doc['_id'], score))
      print(doc['uuid'])

  
  queue = queue.sort(key= lambda x: x[1])
  print(queue)
  return queue