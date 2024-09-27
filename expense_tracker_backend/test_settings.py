import os
import django
from django.conf import settings

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'expense_tracker_backend.settings')

django.setup()

print("INSTALLED_APPS:", settings.INSTALLED_APPS)
