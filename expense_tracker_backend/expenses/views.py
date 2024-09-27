# pylint: disable=E1101

#from django.shortcuts import render
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework import status
from .serializers import ExpenseSerializer, ChartBarSerializer
#from django.http import JsonResponse
from .models import Expense, ChartBar

class ExpenseViewSet(viewsets.ModelViewSet):
    queryset = Expense.objects.all()
    serializer_class = ExpenseSerializer

class ChartBarViewSet(viewsets.ModelViewSet):
    queryset = ChartBar.objects.all()
    serializer_class = ChartBarSerializer


