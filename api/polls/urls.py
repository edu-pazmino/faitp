from django.urls import path
from polls import views


urlpatterns = [
    path('files', views.FileListView.as_view()),
    path('/', views.index, name='index'),
]