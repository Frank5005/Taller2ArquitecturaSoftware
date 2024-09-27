# pylint: disable=E1101

from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from .models import Expense, ChartBar
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from django.db import models


@receiver(post_save, sender=Expense)
def update_chartbar_on_save(sender, instance, created, **kwargs):
    """
    Actualiza el bucket en ChartBar cuando se crea o actualiza un Expense.
    """
    category = instance.category
    # Recalcula el bucket basado en todos los expenses de esa categoría
    total_amount = Expense.objects.filter(category=category).aggregate(models.Sum('amount'))['amount__sum'] or 0
    chartbar, _ = ChartBar.objects.get_or_create(category=category)
    chartbar.bucket = total_amount
    chartbar.save()

@receiver(post_delete, sender=Expense)
def update_chartbar_on_delete(sender, instance, **kwargs):
    """
    Actualiza el bucket en ChartBar cuando se elimina un Expense.
    """
    category = instance.category
    # Recalcula el bucket basado en todos los expenses restantes de esa categoría
    total_amount = Expense.objects.filter(category=category).aggregate(models.Sum('amount'))['amount__sum'] or 0
    chartbar, _ = ChartBar.objects.get_or_create(category=category)
    chartbar.bucket = total_amount
    chartbar.save()

def send_chartbar_update():
    channel_layer = get_channel_layer()
    async_to_sync(channel_layer.group_send)(
        "chartbar_updates",  # Nombre del grupo
        {
            'type': 'send_chartbars_update'
        }
    )

@receiver(post_save, sender=ChartBar)
def notify_chartbar_update(sender, instance, **kwargs):
    send_chartbar_update()

@receiver(post_delete, sender=ChartBar)
def notify_chartbar_delete(sender, instance, **kwargs):
    send_chartbar_update()
