import time
from django.db import connections
from django.db.utils import OperationalError
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    """Management command to wait for the database to be ready."""

    def handle(self, *args, **options):
        self.stdout.write("Waiting for database...")
        database_connection = None

        while database_connection is None:
            try:
                database_connection = connections["default"]
                database_connection.cursor()
            except OperationalError:
                self.stdout.write("Database unavailable, waiting 1 second...")
                time.sleep(1)

        self.stdout.write(self.style.SUCCESS("Database available!"))
