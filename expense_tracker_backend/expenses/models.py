from django.db import models

class Expense(models.Model):
    
    CATEGORY_CHOICES = [
        ('food', 'Food'),
        ('travel', 'Travel'),
        ('leisure', 'Leisure'),
        ('work', 'Work'),
    ]
    
    title = models.CharField(max_length=100)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    category = models.CharField(max_length=10, choices=CATEGORY_CHOICES)
    fecha = models.DateField()
    def __str__(self):
        return f'{self.title} - {self.amount}'

class ChartBar(models.Model):
    category = models.CharField(max_length=100, unique=True)  # Cada categoría es única
    bucket = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    def __str__(self):
        return f'{self.category} - {self.bucket}'
