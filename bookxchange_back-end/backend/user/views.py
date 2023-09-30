from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import test_collection
from .models import user_collection
from bson.json_util import dumps, loads
import pymongo


# Create your views here.

def index(request):
    return HttpResponse("App is running")


# adds a new test_collection
# def add_person(request):
#     records = {
#         "user_name": "Jane Doe",
#         "profile_name": "jdoe"
#     }
#     test_collection.insert_one(records)

#     return HttpResponse("New person is added")

# SELECT * FROM test_collection 
@api_view(['GET'])
def get_all_test(request):
    cursor = HttpResponse(dumps(list(test_collection.find())))
    cursor['Content-Type'] = 'application/json'
    return cursor

# SELECT * FROM user_collection
@api_view(['GET'])
def get_all_user(request):
    cursor = HttpResponse(dumps(list(user_collection.find())))
    cursor['Content-Type'] = 'application/json'
    return cursor


