from django.urls import path
from . import consumer

websocket_urlpatterns = [
    path(r'ws/expenses/', consumer.ExpenseConsumer.as_asgi()),
    #path('ws/chartbars/$', consumer.ChartBarConsumer.as_asgi()),
]
