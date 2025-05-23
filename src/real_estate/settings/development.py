ALLOWED_HOSTS = ['*']

import sys
if not all(os.getenv(var) for var in ['POSTGRES_DB', 'POSTGRES_USER', 'POSTGRES_PASSWORD', 'POSTGRES_HOST']):
    sys.stderr.write("Error: Missing PostgreSQL environment variables!\n")
    sys.exit(1)