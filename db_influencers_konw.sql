-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 22, 2022 at 02:37 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_influencers_konw`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AllInfluencerActions` ()  BEGIN
    SELECT influencer.Id_influencer AS InfluencerID,
    FullName(influencer.first_name, influencer.last_name) AS FullName,
    service.name AS service,
    influenceraction.date AS Date
    FROM influencer, influenceraction, service
    WHERE influencer.Id_influencer = influenceraction.Influencer_Id_influencer
    AND influenceraction.Service_Id_service = service.Id_service
    ORDER BY Date;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetFullInfluencerData` ()  BEGIN
    SELECT FullName(influencer.first_name, influencer.last_name) AS FullName,
    InfluencerLevel(influencer.followers) AS InfluencerType,
    influencer.discount_code AS DiscountCode,
    address.city AS City
    FROM influencer, address
    WHERE influencer.Address_Id_address = address.Id_address
    ORDER BY InfluencerType;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InfluencerActions` (IN `idInf` INT)  BEGIN
    SELECT influencer.Id_influencer AS InfluencerID,
    FullName(influencer.first_name, influencer.last_name) AS FullName,
    service.name AS service,
    influenceraction.date AS Date
    FROM influencer, influenceraction, service
    WHERE influencer.Id_influencer = idInf
    AND influencer.Id_influencer = influenceraction.Influencer_Id_influencer
    AND influenceraction.Service_Id_service = service.Id_service
    ORDER BY Date;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InfluencerSalary` (IN `idInf` INT)  BEGIN
    SELECT influencer.Id_influencer AS InfluencerID,
    FullName(influencer.first_name, influencer.last_name) AS FullName,
    influenceraction.Id_influencer_action AS ActionID,
    service.name AS service,
    salary.value AS PLN,
    salary.date AS Date
    FROM influencer, influenceraction, service, salary
    WHERE influencer.Id_influencer = idInf
    AND influencer.Id_influencer = influenceraction.Influencer_Id_influencer
    AND influenceraction.Service_Id_service = service.Id_service
    AND influencer.Id_influencer = salary.Influencer_Id_influencer
    AND salary.InfluencerAction_Id_influencer_action = influenceraction.Id_influencer_action
    ORDER BY Date;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProductStock` (IN `productID` INT, IN `amount` INT)  BEGIN
    SET @MESSAGE_TEXT = 'The state of a stock is 0 for this product!';
    SET @GET_PRODUCT_AMOUNT = (SELECT product.Amount FROM product WHERE product.Id_product = productID LIMIT 1);

    IF @GET_PRODUCT_AMOUNT - amount <= 0 THEN
        SELECT @MESSAGE_TEXT;
    ELSE
          UPDATE product
          SET product.Amount = product.Amount - amount
          WHERE product.Id_product = productID;
    END IF;
   END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `AddNumbers` (`val1` INT, `val2` INT) RETURNS INT(11) RETURN val1 + val2$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FullName` (`first_name` VARCHAR(20), `last_name` VARCHAR(30)) RETURNS VARCHAR(50) CHARSET utf8 COLLATE utf8_unicode_ci RETURN CONCAT(first_name, ' ', last_name)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `InfluencerLevel` (`followers` INT(11)) RETURNS VARCHAR(20) CHARSET utf8 COLLATE utf8_unicode_ci BEGIN
    DECLARE InfluencerLvl VARCHAR(20);
    
    IF followers >= 100000 THEN SET InfluencerLvl = 'MAKROinfluencer';
    ELSEIF (followers < 100000 AND followers >= 10000) THEN SET InfluencerLvl = 'Influencer';
    ELSE SET InfluencerLvl = 'Mikroinfluencer';
    END IF;
    
    RETURN InfluencerLvl;
 END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `ValueToEuro` (`prodValue` DECIMAL(6,2), `newValue` DECIMAL(6,2)) RETURNS DECIMAL(6,2) RETURN prodValue / newValue$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `Id_address` int(11) NOT NULL,
  `Country_Id_country` int(11) DEFAULT NULL,
  `street` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `house_nr` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `post_code` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`Id_address`, `Country_Id_country`, `street`, `house_nr`, `post_code`, `city`) VALUES
(1, 1, 'Puławska', '38/15', '03-232', 'Warszawa'),
(2, 2, 'Isern-Hinnerk-Weg', '14B', '22457', 'Hamburg'),
(3, 8, 'High Park Road', '20A', 'PR9 7QL', 'Southport'),
(4, 1, 'Jurajska', '4/59', '02-699', 'Warszawa'),
(5, 1, 'Kadłubka', '42/5', '71-524', 'Szczecin'),
(6, 1, 'Aleja Krakowska', '49', '05-090', 'Sękocin Stary'),
(7, 1, 'Nowowiejska', '15', '06-500', 'Mława'),
(8, 8, 'Saxonbury Way', '94', 'PE2 9FB', 'Cambridgeshire'),
(9, 1, 'Marii Dąbrowskiej', '96/9', '97-300', 'Piotrków Trybunalski'),
(10, 1, 'Niemeńska', '66', '60-412', 'Poznań'),
(11, NULL, 'Oakstreet', '23', '1', '890FR');

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE `country` (
  `Id_country` int(11) NOT NULL,
  `long_name` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `short_name` char(3) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `country`
--

INSERT INTO `country` (`Id_country`, `long_name`, `short_name`) VALUES
(1, 'Polska', 'PL'),
(2, 'Niemcy', 'DE'),
(3, 'Rosja', 'RU'),
(4, 'Szwajcaria', 'CH'),
(5, 'Ukraina', 'UA'),
(6, 'Białoruś', 'BY'),
(7, 'Czarnogóra', 'MNE'),
(8, 'Wielka Brytania', 'GB'),
(9, 'Stany Zjednoczone', 'USA'),
(10, 'Kanada', 'CA');

-- --------------------------------------------------------

--
-- Stand-in structure for view `full_address_data`
-- (See below for the actual view)
--
CREATE TABLE `full_address_data` (
`first_name` varchar(50)
,`last_name` varchar(100)
,`street` varchar(200)
,`house_nr` varchar(10)
,`post_code` varchar(10)
,`city` varchar(100)
,`long_name` varchar(200)
);

-- --------------------------------------------------------

--
-- Table structure for table `influencer`
--

CREATE TABLE `influencer` (
  `Id_influencer` int(11) NOT NULL,
  `Address_Id_address` int(11) DEFAULT NULL,
  `first_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nickname` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `discount_code` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `followers` int(11) DEFAULT NULL,
  `account_number` varchar(26) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `influencer`
--

INSERT INTO `influencer` (`Id_influencer`, `Address_Id_address`, `first_name`, `last_name`, `nickname`, `discount_code`, `followers`, `account_number`) VALUES
(1, 4, 'Ismenka', 'Stelmaszczyk', 'ismena_stelmaszczyk', 'ismena15', 47600, NULL),
(2, 2, 'Paulina', 'Guzińska', 'paulina_guzinska', 'paulina15', 264000, NULL),
(3, 5, 'Bartosz', 'Smęda', 'smeda.triathlon', 'triathlon15', 801, NULL),
(4, 3, 'John', 'Smith', 'john_smith', 'john15', 45000, '12445588237595145212547719'),
(5, 1, 'Maria', 'Wrześniak', 'mariaaa', 'marysia15', 53000, NULL),
(6, 6, 'Klaudia', 'Michalak', 'klaudia_michalak', 'klaudia15', 4123, NULL),
(7, 7, 'Aleksander', 'Mąkosa', 'alexi', 'alexi15', 89000, NULL),
(8, 8, 'Aleksa', 'Woźnicki', 'aleksa_woznikci', 'woznikci15', 632, NULL),
(9, 9, 'Rafał', 'Piotrowski', 'rafal_p', 'rafal15', 7522, NULL),
(10, 10, 'Marcin', 'Wiesiuk', 'marcinek_w', 'marcinek15', 65002, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `influenceraction`
--

CREATE TABLE `influenceraction` (
  `Id_influencer_action` int(11) NOT NULL,
  `Influencer_Id_influencer` int(11) DEFAULT NULL,
  `Service_Id_service` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `influenceraction`
--

INSERT INTO `influenceraction` (`Id_influencer_action`, `Influencer_Id_influencer`, `Service_Id_service`, `date`) VALUES
(1, 1, 8, '2021-09-30'),
(2, 1, 8, '2021-09-30'),
(3, 1, 1, '2021-09-15'),
(4, 2, 7, '2021-10-13'),
(5, 4, 10, '2021-11-02'),
(6, 3, 10, '2021-11-14'),
(7, 5, 3, '2021-10-19'),
(8, 7, 5, '2021-11-02'),
(9, 10, 9, '2021-11-03'),
(10, 8, 6, '2021-08-10'),
(11, 1, 1, '2021-12-01'),
(13, 4, 4, '2021-12-04'),
(14, 1, 9, '2022-01-13'),
(15, 4, 1, '2022-01-01'),
(16, 4, 4, '2022-01-04'),
(17, 2, 8, NULL);

--
-- Triggers `influenceraction`
--
DELIMITER $$
CREATE TRIGGER `new_salary` AFTER INSERT ON `influenceraction` FOR EACH ROW INSERT INTO `salary` (`Id_salary`, `Influencer_Id_influencer`, `InfluencerAction_Id_influencer_action`, `value`, `date`) VALUES (NULL, NEW.Influencer_Id_influencer, NEW.Id_influencer_action,(SELECT value FROM `service` WHERE Id_service = NEW.Service_Id_service), DATE(NOW()))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `Id_product` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` decimal(6,2) DEFAULT NULL,
  `Amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`Id_product`, `name`, `price`, `Amount`) VALUES
(1, 'Modify Reductor', '129.00', 94),
(2, 'Modify Femibra', '139.00', 67),
(3, 'Gumka do włosów - lniana ', '29.00', 20),
(4, 'Gumka do włosów - lniana XL', '49.00', 30),
(5, 'Gumka do włosów - welurowa', '19.00', 20),
(6, 'Gumka do włosów - welurowa XL', '29.00', 20),
(7, 'Pełna kuracja Modify Reductor', '387.00', 10),
(8, 'Pełna kuracja Modify Femibra', '417.00', 10),
(9, 'Zestaw świąteczny Modify Reductor', '199.00', 15),
(10, 'Zestaw świąteczny Modify Femibra', '256.00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `salary`
--

CREATE TABLE `salary` (
  `Id_salary` int(11) NOT NULL,
  `Influencer_Id_influencer` int(11) DEFAULT NULL,
  `InfluencerAction_Id_influencer_action` int(11) DEFAULT NULL,
  `value` decimal(6,2) DEFAULT NULL,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `salary`
--

INSERT INTO `salary` (`Id_salary`, `Influencer_Id_influencer`, `InfluencerAction_Id_influencer_action`, `value`, `date`) VALUES
(1, 1, 1, '30.00', '2021-09-30'),
(2, 1, 2, '30.00', '2021-09-30'),
(3, 1, 3, '50.00', '2021-09-15'),
(4, 2, 4, '100.00', '2021-10-13'),
(5, 4, 5, '350.00', '2021-11-12'),
(6, 3, 6, '350.00', '2021-11-14'),
(7, 5, 7, '100.00', '2021-10-19'),
(8, 7, 8, '500.00', '2021-11-02'),
(9, 10, 9, '40.00', '2021-11-03'),
(10, 8, 10, '200.00', '2021-08-10'),
(13, 4, 13, '250.00', '2021-12-04'),
(14, 1, 14, '40.00', '2022-01-13'),
(15, 4, 15, '50.00', '2022-01-13'),
(16, 4, 16, '250.00', '2022-01-13'),
(17, 2, 17, '30.00', '2022-01-20');

-- --------------------------------------------------------

--
-- Table structure for table `service`
--

CREATE TABLE `service` (
  `Id_service` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` decimal(6,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `service`
--

INSERT INTO `service` (`Id_service`, `name`, `value`) VALUES
(1, 'Relacja ', '50.00'),
(2, 'Relacja + swipe', '150.00'),
(3, 'Post bez produktu', '100.00'),
(4, 'Post z produktem', '250.00'),
(5, 'Udział w evencie marki', '500.00'),
(6, 'Logo marki na stronie', '200.00'),
(7, 'Oznaczenie na story', '100.00'),
(8, 'Użycie kodu influencera', '30.00'),
(9, 'Polecenie zakupu bez kodu', '40.00'),
(10, 'Pakiet (post + relacja + swipe)', '350.00');

-- --------------------------------------------------------

--
-- Table structure for table `shipping`
--

CREATE TABLE `shipping` (
  `Id_shipping` int(11) NOT NULL,
  `Influencer_Id_influencer` int(11) DEFAULT NULL,
  `Product_Id_product` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `shipping`
--

INSERT INTO `shipping` (`Id_shipping`, `Influencer_Id_influencer`, `Product_Id_product`, `date`) VALUES
(1, 1, 7, '2021-09-08'),
(2, 2, 7, '2021-11-07'),
(3, 3, 9, '2021-08-18'),
(4, 4, 1, '2021-11-19'),
(5, 5, 2, '2021-10-18'),
(6, 5, 5, '2021-10-18'),
(7, 6, 10, '2020-12-12'),
(8, 7, 9, '2021-11-17'),
(9, 8, 2, '2021-07-11'),
(10, 9, 1, '2021-11-06'),
(11, 10, 9, '2021-11-15'),
(12, 1, 4, '2021-11-08'),
(13, 6, 2, '2022-01-20');

--
-- Triggers `shipping`
--
DELIMITER $$
CREATE TRIGGER `update_stock` AFTER INSERT ON `shipping` FOR EACH ROW BEGIN
	CALL ProductStock (NEW.Product_Id_product, 1);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `full_address_data`
--
DROP TABLE IF EXISTS `full_address_data`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `full_address_data`  AS SELECT `i`.`first_name` AS `first_name`, `i`.`last_name` AS `last_name`, `a`.`street` AS `street`, `a`.`house_nr` AS `house_nr`, `a`.`post_code` AS `post_code`, `a`.`city` AS `city`, `c`.`long_name` AS `long_name` FROM ((`influencer` `i` left join `address` `a` on(`i`.`Address_Id_address` = `a`.`Id_address`)) left join `country` `c` on(`a`.`Country_Id_country` = `c`.`Id_country`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`Id_address`),
  ADD KEY `Country_Id_country` (`Country_Id_country`);

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`Id_country`);

--
-- Indexes for table `influencer`
--
ALTER TABLE `influencer`
  ADD PRIMARY KEY (`Id_influencer`),
  ADD KEY `Address_Id_address` (`Address_Id_address`);

--
-- Indexes for table `influenceraction`
--
ALTER TABLE `influenceraction`
  ADD PRIMARY KEY (`Id_influencer_action`),
  ADD KEY `Influencer_Id_influencer` (`Influencer_Id_influencer`),
  ADD KEY `Service_Id_service` (`Service_Id_service`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`Id_product`);

--
-- Indexes for table `salary`
--
ALTER TABLE `salary`
  ADD PRIMARY KEY (`Id_salary`),
  ADD KEY `InfluencerAction_Id_influencer_action` (`InfluencerAction_Id_influencer_action`),
  ADD KEY `Influencer_Id_influencer` (`Influencer_Id_influencer`);

--
-- Indexes for table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`Id_service`);

--
-- Indexes for table `shipping`
--
ALTER TABLE `shipping`
  ADD PRIMARY KEY (`Id_shipping`),
  ADD KEY `Influencer_Id_influencer` (`Influencer_Id_influencer`),
  ADD KEY `Product_Id_product` (`Product_Id_product`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address`
--
ALTER TABLE `address`
  MODIFY `Id_address` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
  MODIFY `Id_country` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `influencer`
--
ALTER TABLE `influencer`
  MODIFY `Id_influencer` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `influenceraction`
--
ALTER TABLE `influenceraction`
  MODIFY `Id_influencer_action` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `Id_product` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `salary`
--
ALTER TABLE `salary`
  MODIFY `Id_salary` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `service`
--
ALTER TABLE `service`
  MODIFY `Id_service` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `shipping`
--
ALTER TABLE `shipping`
  MODIFY `Id_shipping` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `address`
--
ALTER TABLE `address`
  ADD CONSTRAINT `address_ibfk_1` FOREIGN KEY (`Country_Id_country`) REFERENCES `country` (`Id_country`);

--
-- Constraints for table `influencer`
--
ALTER TABLE `influencer`
  ADD CONSTRAINT `influencer_ibfk_1` FOREIGN KEY (`Address_Id_address`) REFERENCES `address` (`Id_address`);

--
-- Constraints for table `influenceraction`
--
ALTER TABLE `influenceraction`
  ADD CONSTRAINT `influenceraction_ibfk_1` FOREIGN KEY (`Influencer_Id_influencer`) REFERENCES `influencer` (`Id_influencer`),
  ADD CONSTRAINT `influenceraction_ibfk_2` FOREIGN KEY (`Service_Id_service`) REFERENCES `service` (`Id_service`);

--
-- Constraints for table `salary`
--
ALTER TABLE `salary`
  ADD CONSTRAINT `salary_ibfk_1` FOREIGN KEY (`InfluencerAction_Id_influencer_action`) REFERENCES `influenceraction` (`Id_influencer_action`),
  ADD CONSTRAINT `salary_ibfk_2` FOREIGN KEY (`Influencer_Id_influencer`) REFERENCES `influencer` (`Id_influencer`);

--
-- Constraints for table `shipping`
--
ALTER TABLE `shipping`
  ADD CONSTRAINT `shipping_ibfk_1` FOREIGN KEY (`Influencer_Id_influencer`) REFERENCES `influencer` (`Id_influencer`),
  ADD CONSTRAINT `shipping_ibfk_2` FOREIGN KEY (`Product_Id_product`) REFERENCES `product` (`Id_product`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
