
CREATE TABLE raw.movies_raw (
    movie_id    TEXT,
    title       TEXT,
    genre       TEXT,
    duration    INT,
    load_ts     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO raw.movies_raw (movie_id, title, genre, duration, load_ts)
VALUES
('M001', 'Boys Over Flowers', 'Romance and Drama', 700, '2026-07-01 07:00:00'),
('M002', 'City Hunter', 'Action and Romance', 850, '2026-07-01 07:00:00'),
('M003', 'Legend of the Blue Sea', 'Drama and Comedy', 950, '2026-07-01 07:00:00'),
('M004', 'The Heirs', 'Drama', 870, '2026-07-01 07:00:00'),
('M005', 'The K2', 'Romance and Action', 820, '2026-07-01 07:00:00'),
('M006', 'Queen of Tears', 'Drama', 930, '2026-07-01 07:00:00'),
('M007', 'IRIS', 'Romance and Action', 1020, '2026-07-01 07:00:00'),
('M008', 'Titanic', 'Romance', 140, '2026-07-01 07:00:00'),
('M009', 'Kungfu Panda', 'Animation', 2240, '2026-07-01 07:00:00'),
('M010', 'Fast and Furious', 'Action', 170, '2026-07-01 07:00:00'),
('M011', 'Nhà Bà Nữ', 'Comedy', 160, '2026-07-01 07:00:00'),
('M012', 'Bố già', 'Comedy', 170, '2026-07-01 07:00:00');


CREATE TABLE raw.customers_raw (
    customer_id TEXT,
    gender      TEXT,
    city        TEXT,
    load_ts     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO raw.customers_raw (customer_id, gender, city, load_ts)
VALUES
('C001', 'M', 'Hue', '2026-07-20 07:00:00'),
('C002', 'M', 'Hue', '2026-07-20 07:00:00'),
('C003', 'M', 'Hanoi', '2026-07-20 07:00:00'),
('C004', 'M', 'Danang', '2026-07-20 07:00:00'),
('C005', 'F', 'HCMC', '2026-07-20 07:00:00'),
('C006', 'F', 'HCMC', '2026-07-20 07:00:00'),
('C007', 'F', 'Hanoi', '2026-07-20 07:00:00'),
('C008', 'F', 'Danang', '2026-07-20 07:00:00');


CREATE TABLE raw.ticket_sales_raw (
    ticket_id       TEXT,        -- Mã vé
    customer_id     TEXT,        -- FK tham chiếu sang customer
    movie_id        TEXT,        -- FK tham chiếu sang movie
    quantity        INT,            -- Số lượng vé mua trong giao dịch
    price_per_ticket NUMERIC(12,2), -- Giá mỗi vé tại thời điểm bán
    revenue         NUMERIC(12,2),  -- Tổng tiền = quantity * price_per_ticket
    payment_method  TEXT,        -- Phương thức thanh toán (Cash, Credit Card, MoMo, ...)
    sale_ts         TIMESTAMP,   -- Thời điểm khách hàng thực hiện giao dịch
    load_ts         TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Thời điểm Airflow/ETL ghi vào DB
);

INSERT INTO raw.ticket_sales_raw (ticket_id, customer_id, movie_id, quantity, price_per_ticket, revenue, payment_method, sale_ts)
VALUES
-- Giao dịch chuẩn
('TICK-001', 'C001', 'M001', 2, 100000.00, 200000.00, 'MoMo', '2026-07-20 14:20:00'),
('TICK-002', 'C002', 'M002', 1, 120000.00, 120000.00, 'Credit Card', '2026-07-20 15:10:00'),
('TICK-003', 'C005', 'M003', 3, 90000.00,  270000.00, 'Cash', '2026-07-20 18:00:00'),
-- Case Late-Arriving Customer: Mã khách C999 CHƯA CÓ trong bảng customers_raw
('TICK-004', 'C999', 'M001', 1, 100000.00, 100000.00, 'MoMo', '2026-07-20 19:30:00'),
-- Case Late-Arriving Movie: Mã phim M999 CHƯA CÓ trong bảng movies_raw
('TICK-005', 'C003', 'M999', 2, 150000.00, 300000.00, 'Cash', '2026-07-20 20:00:00');