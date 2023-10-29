
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

def createQueue(uuid, collection):
  user = list(db.db.user_collection.find({"uuid": uuid}))
  pref = []
  print(f'THIS IS THE USER:::: {user}')
  if user['user_genre']:
    pref = user['user_genre']
    
  for doc in collection:
    if doc['uuid'] != uuid:
      #process book by adding to queue
      print(doc['uuid'])


  queue = 0

  return queue