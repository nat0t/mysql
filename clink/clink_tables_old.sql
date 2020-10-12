DROP TABLE IF EXISTS products;
CREATE TABLE products (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL COMMENT 'Название товара',
	description_id INT UNSIGNED,
	category_id INT UNSIGNED NOT NULL,
	manufacturer_id INT UNSIGNED,
	qty MEDIUMINT UNSIGNED COMMENT 'Количество товара',  
	price DECIMAL(8,2) COMMENT 'Цена',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Товары';

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL COMMENT 'Название категории',
	availability BOOLEAN COMMENT 'Доступность товаров из категории',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Категории товаров';

DROP TABLE IF EXISTS options;
CREATE TABLE options (
	id SERIAL PRIMARY KEY,
	category_id INT UNSIGNED NOT NULL,
	name VARCHAR(50) NOT NULL COMMENT 'Название характеристики',
	qty INT NOT NULL COMMENT 'Числовая величина',
	measure VARCHAR(10) COMMENT 'Единица измерения'
) COMMENT = 'Характеристики товаров';	

DROP TABLE IF EXISTS product_descriptions;
CREATE TABLE product_descriptions (
	id SERIAL PRIMARY KEY,
	name TEXT COMMENT 'Описание товара'
) COMMENT = 'Описания товаров';

DROP TABLE IF EXISTS manufacturers;
CREATE TABLE manufacturers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL COMMENT 'Название производителя',
	description VARCHAR(255) COMMENT 'Описание производителя',
	logo VARCHAR(255) COMMENT 'Ссылка на логотип',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Производители товаров';

DROP TABLE IF EXISTS clients;
CREATE TABLE clients (
	id SERIAL PRIMARY KEY,
	organisation BOOLEAN COMMENT 'Тип заказчика',
	org_name VARCHAR(100) COMMENT 'Название организации',
	first_name VARCHAR(100) COMMENT 'Имя клиента',
	last_name VARCHAR(100) COMMENT 'Фамилия клиента',
	birthday DATE COMMENT 'Дата рождения',
	email VARCHAR(100) NOT NULL UNIQUE COMMENT 'Электронная почта',
	login VARCHAR(50) NOT NULL UNIQUE COMMENT 'Учетная запись',
	pass_hash VARCHAR(255) NOT NULL COMMENT 'Хэш пароля',
	phone VARCHAR(20) NOT NULL COMMENT 'Номер телефона',
	region VARCHAR(100) COMMENT 'Область нахождения клиента',
	address VARCHAR(100) COMMENT 'Адрес клиента',
	discount TINYINT UNSIGNED COMMENT 'Скидка',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Клиенты';

DROP TABLE IF EXISTS payment_methods;
CREATE TABLE payment_methods (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) COMMENT 'Способ оплаты'
) COMMENT = 'Способы оплаты';

DROP TABLE IF EXISTS client_payment_methods;
CREATE TABLE client_payment_methods (
	id SERIAL PRIMARY KEY,
	client_id INT UNSIGNED NOT NULL,
	payment_method_id INT UNSIGNED NOT NULL,
	account_number TINYINT UNSIGNED COMMENT 'Номер счета/карты и т.п.'
) COMMENT = 'Способы оплаты клиента'; 

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	id SERIAL PRIMARY KEY,
	client_id INT UNSIGNED,
	order_status_id TINYINT UNSIGNED,
	cost INT UNSIGNED COMMENT 'Стоимость заказа',
	details TEXT COMMENT 'Детали заказа',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
	id SERIAL PRIMARY KEY,
	order_id INT UNSIGNED,
	product_id INT UNSIGNED,
	qty MEDIUMINT UNSIGNED COMMENT 'Количество товара',
	order_item_status_id TINYINT UNSIGNED,
	details TEXT COMMENT 'Детали по позиции заказа',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Заказанные товары';

DROP TABLE IF EXISTS order_statuses;
CREATE TABLE order_statuses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) COMMENT 'Статус заказа'
) COMMENT = 'Статусы заказов';

DROP TABLE IF EXISTS order_item_statuses;
CREATE TABLE order_item_statuses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) COMMENT 'Статус позиции'
) COMMENT = 'Статусы заказанных позиций';

DROP TABLE IF EXISTS deliveries;
CREATE TABLE deliveries (
	id SERIAL PRIMARY KEY,
	order_id INT UNSIGNED,
	invoice_id INT UNSIGNED,
	tracking_number BIGINT UNSIGNED UNIQUE COMMENT 'Номер для отслеживания',
	delivery_date DATE COMMENT 'Дата доставки',
	details VARCHAR(255) COMMENT 'Детали доставки'
) COMMENT = 'Доставки';

DROP TABLE IF EXISTS delivery_items;
CREATE TABLE delivery_items (
	id SERIAL PRIMARY KEY,
	delivery_id INT UNSIGNED,
	order_item_id INT UNSIGNED
) COMMENT = 'Позиции для доставки';

DROP TABLE IF EXISTS invoices;
CREATE TABLE invoices (
	id SERIAL PRIMARY KEY,
	order_id INT UNSIGNED,
	invoice_status_id TINYINT UNSIGNED,
	invoice_date DATE COMMENT 'Дата в накладной',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Накладные';

DROP TABLE IF EXISTS invoice_statuses;
CREATE TABLE invoice_statuses (
	id SERIAL PRIMARY KEY,
	description VARCHAR(20) COMMENT 'Статус накладной'
) COMMENT = 'Статусы накладных';

DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
	id SERIAL PRIMARY KEY,
	invoice_id INT UNSIGNED,
	payment_date DATE COMMENT 'Дата платежа',
	amount BIGINT UNSIGNED COMMENT 'Сумма платежа',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Платежи';

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	`timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP,
	table_name VARCHAR(50) COMMENT 'Название таблицы',
	record_id INT UNSIGNED COMMENT 'Идентификатор записи',
	record_target VARCHAR(255)
) COMMENT 'Таблица для сбора логов' ENGINE=Archive;
