# from pymongo.mongo_client import MongoClient
# from pymongo.server_api import ServerApi
# uri = "mongodb+srv://hmanian:mongodb41@bookxchange-aws.vyswccw.mongodb.net/?retryWrites=true&w=majority&appName=AtlasApp"
# # Create a new client and connect to the server
# client = MongoClient(uri, server_api=ServerApi('1'))
# # Send a ping to confirm a successful connection
# try:
#     client.admin.command('ping')
#     print("Pinged your deployment. You successfully connected to MongoDB!")
# except Exception as e:
#     print(e)

# from pymongo import MongoClient
# def get_db_handle(db_name, host, port, username, password):

#  client = MongoClient(host=host,
#                       port=int(port),
#                       username=username,
#                       password=password
#                      )
#  db_handle = client['db_name']
#  return db_handle, client

# import pymongo

# url = 'mongodb://localhost:27017'

# client = pymongo.MongoClient(url)
# db = client['bookxchange']

from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
import certifi
#uri = "mongodb+srv://hmanian:mongodb-41_@bookxchange-cluster.pcalzfz.mongodb.net/?retryWrites=true&w=majority&appName=AtlasApp"
uri = "mongodb+srv://hmanian:mongodb-41_@bookxchange-cluster.pcalzfz.mongodb.net/"
# Create a new client and connect to the server
#client = MongoClient(uri, server_api=ServerApi('1'))
client = MongoClient(uri, tlsCAFile=certifi.where())
db = client['bookxchange']
# Send a ping to confirm a successful connection
try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)