from flask import Flask
from flask_pymongo import pymongo
from pymongo.server_api import ServerApi
import certifi
from app import app

CONNECTION_STRING = "mongodb+srv://hmanian:mongodb-41_@bookxchange-cluster.pcalzfz.mongodb.net/?retryWrites=true&w=majority&appName=AtlasApp"
client = pymongo.MongoClient(CONNECTION_STRING, server_api=ServerApi('1'), tlsCAFile=certifi.where())
db = client.get_database('bookxchange')
user_collection = pymongo.collection.Collection(db, 'user_collection')
book_collection = pymongo.collection.Collection(db, 'book_collection')