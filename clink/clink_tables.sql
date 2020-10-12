CREATE TABLE `categories` (
  `id` int unsigned NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Название категории',
  `availability` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `categories_name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Категории товаров'

CREATE TABLE `client_payment_methods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int unsigned NOT NULL,
  `payment_method_id` int unsigned NOT NULL,
  `account_number` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `client_payment_methods_account_number_idx` (`account_number`),
  KEY `client_payment_methods_payment_method_id_fk` (`payment_method_id`),
  KEY `client_payment_methods_client_id_fk` (`client_id`),
  CONSTRAINT `client_payment_methods_client_id_fk` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `client_payment_methods_payment_method_id_fk` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Способы оплаты клиента'

CREATE TABLE `clients` (
  `id` int unsigned NOT NULL,
  `organisation` tinyint(1) DEFAULT NULL COMMENT 'Тип заказчика',
  `org_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Название организации',
  `first_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Имя клиента',
  `last_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Фамилия клиента',
  `birthday` date DEFAULT NULL COMMENT 'Дата рождения',
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Электронная почта',
  `login` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Учетная запись',
  `pass_hash` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Хэш пароля',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Номер телефона',
  `region` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Область нахождения клиента',
  `address` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Адрес клиента',
  `discount` tinyint unsigned DEFAULT NULL COMMENT 'Скидка',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `login` (`login`),
  UNIQUE KEY `clients_email_idx` (`email`),
  KEY `clients_first_name_last_name_idx` (`first_name`,`last_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Клиенты'

CREATE TABLE `deliveries` (
  `id` int unsigned NOT NULL,
  `order_id` int unsigned DEFAULT NULL,
  `invoice_id` int unsigned DEFAULT NULL,
  `tracking_number` bigint unsigned DEFAULT NULL COMMENT 'Номер для отслеживания',
  `delivery_date` date DEFAULT NULL COMMENT 'Дата доставки',
  `details` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Детали доставки',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tracking_number` (`tracking_number`),
  KEY `deliveries_tracking_number_idx` (`tracking_number`),
  KEY `deliveries_order_id_fk` (`order_id`),
  KEY `deliveries_invoice_id_fk` (`invoice_id`),
  CONSTRAINT `deliveries_invoice_id_fk` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE SET NULL,
  CONSTRAINT `deliveries_order_id_fk` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Доставки'

CREATE TABLE `delivery_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `delivery_id` int unsigned DEFAULT NULL,
  `order_item_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `delivery_items_delivery_id_fk` (`delivery_id`),
  KEY `delivery_items_order_item_id_fk` (`order_item_id`),
  CONSTRAINT `delivery_items_delivery_id_fk` FOREIGN KEY (`delivery_id`) REFERENCES `deliveries` (`id`) ON DELETE SET NULL,
  CONSTRAINT `delivery_items_order_item_id_fk` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=171 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Позиции для доставки'

CREATE TABLE `invoice_statuses` (
  `id` int unsigned NOT NULL,
  `description` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Статусы накладных'

CREATE TABLE `invoices` (
  `id` int unsigned NOT NULL,
  `order_id` int unsigned DEFAULT NULL,
  `invoice_status_id` int unsigned DEFAULT NULL,
  `invoice_date` date DEFAULT NULL COMMENT 'Дата в накладной',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `invoices_order_id_fk` (`order_id`),
  KEY `invoices_invoice_status_id_fk` (`invoice_status_id`),
  CONSTRAINT `invoices_invoice_status_id_fk` FOREIGN KEY (`invoice_status_id`) REFERENCES `invoice_statuses` (`id`) ON DELETE SET NULL,
  CONSTRAINT `invoices_order_id_fk` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Накладные'

CREATE TABLE `logs` (
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `table_name` varchar(50) DEFAULT NULL COMMENT 'Название таблицы',
  `record_id` int unsigned DEFAULT NULL COMMENT 'Идентификатор записи',
  `record_target` varchar(255) DEFAULT NULL
) ENGINE=ARCHIVE DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Таблица для сбора логов'

CREATE TABLE `manufacturers` (
  `id` int unsigned NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Название производителя',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Описание производителя',
  `logo` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Ссылка на логотип',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `manufacturers_name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Производители товаров'

CREATE TABLE `options` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int unsigned NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Название характеристики',
  `qty` int NOT NULL COMMENT 'Числовая величина',
  `measure` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Единица измерения',
  PRIMARY KEY (`id`),
  KEY `options_category_id_fk` (`category_id`),
  CONSTRAINT `options_category_id_fk` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Характеристики товаров'

CREATE TABLE `order_item_statuses` (
  `id` int unsigned NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Статус позиции',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Статусы заказанных позиций'

CREATE TABLE `order_items` (
  `id` int unsigned NOT NULL,
  `order_id` int unsigned DEFAULT NULL,
  `product_id` int unsigned DEFAULT NULL,
  `qty` mediumint unsigned DEFAULT NULL COMMENT 'Количество товара',
  `order_item_status_id` int unsigned DEFAULT NULL,
  `details` text CHARACTER SET utf8 COLLATE utf8_unicode_ci COMMENT 'Детали по позиции заказа',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `order_items_order_id_fk` (`order_id`),
  KEY `order_items_product_id_fk` (`product_id`),
  KEY `order_items_order_item_status_id_fk` (`order_item_status_id`),
  CONSTRAINT `order_items_order_id_fk` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_order_item_status_id_fk` FOREIGN KEY (`order_item_status_id`) REFERENCES `order_item_statuses` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_items_product_id_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Заказанные товары'

CREATE TABLE `order_statuses` (
  `id` int unsigned NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Статус заказа',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Статусы заказов'

CREATE TABLE `orders` (
  `id` int unsigned NOT NULL,
  `client_id` int unsigned DEFAULT NULL,
  `order_status_id` int unsigned DEFAULT NULL,
  `cost` int unsigned DEFAULT NULL COMMENT 'Стоимость заказа',
  `details` text CHARACTER SET utf8 COLLATE utf8_unicode_ci COMMENT 'Детали заказа',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `orders_client_id_fk` (`client_id`),
  KEY `orders_order_status_id_fk` (`order_status_id`),
  CONSTRAINT `orders_client_id_fk` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `orders_order_status_id_fk` FOREIGN KEY (`order_status_id`) REFERENCES `order_statuses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Заказы'

CREATE TABLE `payments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` int unsigned DEFAULT NULL,
  `payment_date` date DEFAULT NULL COMMENT 'Дата платежа',
  `amount` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `payments_invoice_id_fk` (`invoice_id`),
  CONSTRAINT `payments_invoice_id_fk` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Платежи'

CREATE TABLE `product_descriptions` (
  `id` int unsigned NOT NULL,
  `name` text CHARACTER SET utf8 COLLATE utf8_unicode_ci COMMENT 'Описание товара',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Описания товаров'

CREATE TABLE `products` (
  `id` int unsigned NOT NULL,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Название товара',
  `description_id` int unsigned DEFAULT NULL,
  `category_id` int unsigned NOT NULL,
  `manufacturer_id` int unsigned DEFAULT NULL,
  `qty` mediumint unsigned DEFAULT NULL COMMENT 'Количество товара',
  `price` decimal(8,2) DEFAULT NULL COMMENT 'Цена',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `products_name_idx` (`name`),
  KEY `products_description_id_fk` (`description_id`),
  KEY `products_category_id_fk` (`category_id`),
  KEY `products_manufacturer_id_fk` (`manufacturer_id`),
  CONSTRAINT `products_category_id_fk` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `products_description_id_fk` FOREIGN KEY (`description_id`) REFERENCES `product_descriptions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `products_manufacturer_id_fk` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Товары'
