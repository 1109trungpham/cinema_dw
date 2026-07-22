### Chuẩn bị môi trường

```bash
# Tạo môi trường ảo Python
python -m venv cinema-venv
source cinema-venv/bin/activate

# Cài đặt dbt Core
pip install "dbt-postgres==1.7.4" "protobuf<5"
dbt --version
```

```bash
# Khởi động Postgres
docker compose up -d

docker exec -it postgres psql -U postgres

CREATE DATABASE cinema;
\c cinema
CREATE SCHEMA raw;
CREATE SCHEMA dev_trung;
CREATE SCHEMA analytics;

# Chạy lệnh tạo dữ liệu (cinema_dw/postgres/db.sql)
```

```bash
# Tạo dự án dbt
dbt init cinema_dw
cat ~/.dbt/profiles.yml
```
```
cinema_dw:
  outputs:
    dev:
      dbname: cinema
      host: localhost
      pass: "{{ env_var('POSTGRES_PASSWORD') }}"
      port: 5432
      schema: dev_trung
      threads: 1
      type: postgres
      user: postgres
  target: dev
```
```bash
# Chỉnh sửa profiles.yml
nano ~/.dbt/profiles.yml
```
```
cinema_dw:
  outputs:
    dev:
      dbname: cinema
      host: localhost
      pass: "{{ env_var('POSTGRES_PASSWORD') }}"
      port: 5432
      schema: "dev_{{ env_var('DBT_USER', 'trung') }}"
      threads: 1
      type: postgres
      user: postgres
    prod:
      dbname: cinema
      host: localhost
      pass: "{{ env_var('POSTGRES_PASSWORD') }}"
      port: 5432
      schema: analytics
      threads: 1
      type: postgres
      user: postgres
  target: dev
```
```bash
# Test kết nối dbt đến Postgres
export DBT_USER=trung
cd cinema_dw
dbt debug
# All checks passed!
```

```bash
# Cài đặt Packages (packages.yml)
dbt deps
```

### Chạy pipeline

#### Bước 1: Chạy lớp Staging
```bash
dbt run --select staging
```
#### Bước 2: Chạy Snapshot (SCD2)
```bash
dbt snapshot
```
#### Bước 3: Chạy lớp Intermediate
```bash
dbt run --select intermediate
```
#### Bước 4: Chạy lớp Marts (Dim/Fact)
```bash
dbt run --select marts
```

#### Test
```sql
-- TEST SCD2
UPDATE raw.customers_raw
SET city = 'Haiphong', load_ts = NOW() 
WHERE customer_id = 'C001';

INSERT INTO raw.ticket_sales_raw (ticket_id, customer_id, movie_id, quantity, price_per_ticket, revenue, payment_method, sale_ts)
VALUES
('TICK-006', 'C001', 'M003', 1, 90000.00, 90000.00, 'MoMo', NOW());


-- TEST LATE ARRIVING DATA
INSERT INTO raw.ticket_sales_raw (ticket_id, customer_id, movie_id, quantity, price_per_ticket, revenue, payment_method, sale_ts)
VALUES
('TICK-007', 'C004', 'M002', 1, 120000.00, 120000.00, 'Cash', '2026-07-20 21:22:00');
```