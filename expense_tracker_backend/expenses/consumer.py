# pylint: disable=E1101
# pylint: disable=W0105
# pylint: disable=C0115
# pylint: disable=C0114

import json
from channels.generic.websocket import AsyncWebsocketConsumer
from django.db.models import Sum
from .models import Expense, ChartBar
#from .serializers import ExpenseSerializer, ChartBarSerializer

class ExpenseConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()
        # Agregar un mensaje de bienvenida o suscribirse a un grupo específico si es necesario
        await self.send(text_data=json.dumps({
            'message': 'Conexión WebSocket establecida'
         }))
        
    async def disconnect(self, close_code):
        pass

    async def receive(self, text_data):
        data = json.loads(text_data)
        action = data.get('action')

        if action == 'create':
            await self.create_expense(data['expense'])
        elif action == 'read':
            await self.send_expense_list()
        elif action == 'update':
            await self.update_expense(data['expense'])
        elif action == 'delete':
            await self.delete_expense(data['expense_id'])
    
    async def create_expense(self, expense_data):
        expense = Expense.objects.create(**expense_data)
        await self.update_chart_bar(expense.category)
        await self.send_expense_list()

    async def update_expense(self, expense_data):
        expense = Expense.objects.get(id=expense_data['id'])
        for attr, value in expense_data.items():
            setattr(expense, attr, value)
        expense.save()
        await self.update_chart_bar(expense.category)
        await self.send_expense_list()

    async def delete_expense(self, expense_id):
        expense = Expense.objects.get(id=expense_id)
        category = expense.category
        expense.delete()
        await self.update_chart_bar(category)
        await self.send_expense_list()

    async def send_expense_list(self):
        expenses = Expense.objects.all()
        expense_list = [expense.to_dict() for expense in expenses]
        await self.send(text_data=json.dumps({
            'action': 'update_list',
            'expenses': expense_list
        }))

    async def update_chart_bar(self, category):
        total_amount = Expense.objects.filter(category=category).aggregate(Sum('amount'))['amount__sum'] or 0
        chartbar, created = ChartBar.objects.get_or_create(category=category)
        chartbar.bucket = total_amount
        chartbar.save()
