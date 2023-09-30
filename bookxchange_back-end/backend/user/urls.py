from django.urls import path
from . import views

urlpatterns = [
    path('', views.index),
    #path('add/', views.add_person),
    path('show_test/', views.get_all_test),
    path('show_user/', views.get_all_user),
]