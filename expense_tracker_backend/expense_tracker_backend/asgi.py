# pylint: disable=E0611

"""
ASGI config for expense_tracker_backend project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.1/howto/deployment/asgi/
"""


import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'expense_tracker_backend.settings')
import django
django.setup()

from django.core.asgi import get_asgi_application
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.auth import AuthMiddlewareStack
from channels.security.websocket import AllowedHostsOriginValidator
import expenses.routing

#os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'expense_tracker_backend.settings')
#django.setup()

#import expenses.routing

application = ProtocolTypeRouter({
    "http": get_asgi_application(),
    "websocket": AllowedHostsOriginValidator(
        AuthMiddlewareStack(
            URLRouter(
                expenses.routing.websocket_urlpatterns
            )
        )
    ),
})
