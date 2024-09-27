from rest_framework import serializers
from .models import Expense, ChartBar

class ExpenseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Expense
        fields = '__all__'

class ChartBarSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChartBar
        fields = '__all__'
