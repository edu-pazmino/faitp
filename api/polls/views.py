from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, serializers
from django.http import HttpResponse
from django.shortcuts import render
from rest_framework.exceptions import ValidationError 
import logging
from ftplib import FTP

logger = logging.getLogger(__name__)

# Create your views here.
def index(request):
    return HttpResponse("Hello, world. You're at the polls index.") 

class FTPCredentials(serializers.Serializer):
    host = serializers.CharField()
    user = serializers.CharField()
    password = serializers.CharField()

    def get_host(self):
        return self.validated_data['host']

    def get_user(self):
        return self.validated_data['user']

    def get_password(self):
        return self.validated_data['password']

    def __str__(self):
        return f"FTPCredentials(host='{self.validated_data['host']}', user='{self.validated_data['user']}')" 

class FileListView(APIView):
    def post(self, request):
        credentials = FTPCredentials(data=request.data)

        if not credentials.is_valid():         
            raise ValidationError(credentials.errors)

        logging.info("Connecting to: %s", credentials.get_host())
        ftp = FTP(credentials.get_host())
        ftp.login(credentials.get_user(), credentials.get_password())
        location_path = ftp.pwd()
        logging.info("Connected to %s", credentials.get_host())

        files = self.__list_files_recursive(ftp, location_path) 

        ftp.quit()

        return Response(files, status=status.HTTP_200_OK) 

    def __list_files_recursive(self, ftp, path = ""):
        """
        Lista recursivamente todos los archivos y directorios en un servidor FTP 
        y los organiza en un diccionario.

        Args:
        ftp: Objeto FTP conectado al servidor.
        path: Ruta del directorio actual.

        Returns:
        Un diccionario que representa la estructura de archivos y directorios.
        """
        tree = {}
        try:
            ftp.cwd(path)
            for item in ftp.nlst():
                try:
                    ftp.cwd(item)
                    tree[item] = self.__list_files_recursive(ftp, f"{path}/{item}")
                    ftp.cwd("..")
                except:
                    tree[item] = None  # Es un archivo
        except Exception as e:
            print(f"Error al listar archivos en {path}: {e}")
        return tree
