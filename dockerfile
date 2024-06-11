FROM supabase/postgres:15.1.1.41

# Set environment variables
ENV POSTGRES_HOST /var/run/postgresql
ENV PGPORT 5432
ENV POSTGRES_PORT 5432
ENV PGPASSWORD TPPQ3jvvPQ4RLoanWnefPeFiLdYly8vr
ENV POSTGRES_PASSWORD TPPQ3jvvPQ4RLoanWnefPeFiLdYly8vr
ENV PGDATABASE postgres
ENV POSTGRES_DB postgres
ENV JWT_SECRET eac193bbed41516acbccf01c06e2e347af4c796723a25c399abb31a024a5c889
ENV JWT_EXP 3600

# Copy SQL scripts
COPY ./volumes/db/realtime.sql /docker-entrypoint-initdb.d/migrations/99-realtime.sql
COPY ./volumes/db/webhooks.sql /docker-entrypoint-initdb.d/init-scripts/98-webhooks.sql
COPY ./volumes/db/roles.sql /docker-entrypoint-initdb.d/init-scripts/99-roles.sql
COPY ./volumes/db/jwt.sql /docker-entrypoint-initdb.d/init-scripts/99-jwt.sql
COPY ./volumes/db/logs.sql /docker-entrypoint-initdb.d/migrations/99-logs.sql

# Set healthcheck
HEALTHCHECK --start-period=5s --interval=5s --timeout=5s --retries=10 \
  CMD pg_isready -U postgres -h localhost

# Set command
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf", "-c", "log_min_messages=fatal"]

# Expose the dynamically set POSTGRES_PORT
EXPOSE 5432

# Persist data and configuration
VOLUME ["./volumes/db/data:/var/lib/postgresql/data:Z", "db-config:/etc/postgresql-custom"]