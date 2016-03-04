-- phpMyAdmin SQL Dump
-- version 4.0.10.14
-- http://www.phpmyadmin.net
--
-- Client: localhost
-- Généré le: Ven 04 Mars 2016 à 10:41
-- Version du serveur: 5.5.46
-- Version de PHP: 5.6.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `trickers`
--

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET utf8 NOT NULL,
  `sport_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_name_sport` (`sport_id`,`name`),
  KEY `fk_categories_sports1_idx` (`sport_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=35 ;

--
-- Contenu de la table `categories`
--

INSERT INTO `categories` (`id`, `name`, `sport_id`) VALUES
(4, 'flat', 1),
(2, 'jib', 1),
(1, 'kicker', 1),
(33, 'other', 1),
(3, 'pipe', 1),
(8, 'flat', 2),
(6, 'jib', 2),
(5, 'kicker', 2),
(34, 'other', 2),
(7, 'pipe', 2),
(31, 'flat', 3),
(29, 'jump', 3),
(32, 'other', 3),
(23, 'pipes', 3),
(30, 'vert', 3),
(27, 'flat', 4),
(25, 'jump', 4),
(28, 'others', 4),
(24, 'pipes', 4),
(26, 'vert', 4),
(9, 'freestyle', 5),
(21, 'jib', 6),
(20, 'jump', 6),
(22, 'waves', 6),
(16, 'all', 7),
(10, 'dirt', 8),
(14, 'flat', 8),
(11, 'street', 8),
(15, 'vert', 8),
(17, 'All', 9);

-- --------------------------------------------------------

--
-- Structure de la table `error_types`
--

CREATE TABLE IF NOT EXISTS `error_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `description` text CHARACTER SET utf8,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=5 ;

--
-- Contenu de la table `error_types`
--

INSERT INTO `error_types` (`id`, `name`, `description`) VALUES
(1, 'Invalid sport, category or trick', 'The tag is invalid for one of the following reason: - The sport or the category is not the good one - The trick is not the good one'),
(2, 'Invalid time range', 'The trick and the category is good, but the time range is not.'),
(3, 'Invalid video', 'The video cannot be played'),
(4, 'Others', 'Any other errors');

-- --------------------------------------------------------

--
-- Structure de la table `playlists`
--

CREATE TABLE IF NOT EXISTS `playlists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) COLLATE utf8_polish_ci NOT NULL,
  `description` varchar(1000) COLLATE utf8_polish_ci DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `status` enum('public','private','blocked') COLLATE utf8_polish_ci NOT NULL,
  `count_points` int(11) NOT NULL DEFAULT '0',
  `count_up` int(11) NOT NULL DEFAULT '0',
  `slug` varchar(255) COLLATE utf8_polish_ci NOT NULL,
  `count_tags` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_playlists_users1_idx` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=29 ;

--
-- Contenu de la table `playlists`
--

INSERT INTO `playlists` (`id`, `title`, `description`, `created`, `modified`, `user_id`, `status`, `count_points`, `count_up`, `slug`, `count_tags`) VALUES
(3, 'Amazing flips', 'Gather the most amazing flips in all sports !', '2016-02-29 08:00:24', '2016-02-29 17:15:22', NULL, 'public', 1, 1, '', 7),
(23, 'AAAAAAAAAAA', 'test', '2016-02-29 21:05:53', '2016-02-29 21:05:53', NULL, 'public', 0, 0, '', 2),
(25, 'Teste', 'ETzt', '2016-02-29 21:17:39', '2016-02-29 21:17:39', NULL, 'public', 0, 0, '', 2),
(26, 'zaraz', 'rzaraz', '2016-02-29 21:18:55', '2016-02-29 21:18:55', NULL, 'public', 0, 0, '', 2),
(28, 'Les figures préférées de Jean', 'C''est trop beau', '2016-03-01 17:16:48', '2016-03-01 17:16:48', NULL, 'public', 1, 1, '', 2);

-- --------------------------------------------------------

--
-- Structure de la table `playlist_points`
--

CREATE TABLE IF NOT EXISTS `playlist_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `playlist_id` int(11) NOT NULL,
  `value` tinyint(2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_rate_per_user` (`playlist_id`,`user_id`),
  KEY `fk_users_has_playlists_playlists1_idx` (`playlist_id`),
  KEY `fk_users_has_playlists_users1_idx` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=12 ;

--
-- Déclencheurs `playlist_points`
--
DROP TRIGGER IF EXISTS `playlist_points_AFTER_INSERT`;
DELIMITER //
CREATE TRIGGER `playlist_points_AFTER_INSERT` AFTER INSERT ON `playlist_points`
 FOR EACH ROW BEGIN
	UPDATE playlists SET 
		count_points = count_points + NEW.`value`, 
		count_up = count_up + GREATEST(NEW.`value`, 0)
		WHERE id = NEW.playlist_id; 
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `playlist_points_AFTER_UPDATE`;
DELIMITER //
CREATE TRIGGER `playlist_points_AFTER_UPDATE` AFTER UPDATE ON `playlist_points`
 FOR EACH ROW BEGIN
	IF OLD.`value` IS NOT NULL AND NEW.`value` IS NOT NULL AND NEW.`value` != OLD.`value` THEN
		UPDATE playlists 
			SET count_points = (count_points + NEW.`value` - OLD.`value`),  
				count_up = count_up + GREATEST(NEW.`value`, 0) 
            WHERE id = NEW.playlist_id; 
	END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `playlist_video_tags`
--

CREATE TABLE IF NOT EXISTS `playlist_video_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playlist_id` int(11) NOT NULL,
  `video_tag_id` int(11) NOT NULL,
  `position` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_fields` (`playlist_id`,`video_tag_id`),
  KEY `fk_playlists_has_video_tags_video_tags1_idx` (`video_tag_id`),
  KEY `fk_playlists_has_video_tags_playlists1_idx` (`playlist_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=45 ;

--
-- Contenu de la table `playlist_video_tags`
--

INSERT INTO `playlist_video_tags` (`id`, `playlist_id`, `video_tag_id`, `position`) VALUES
(10, 3, 124, 4),
(11, 3, 55, 2),
(12, 3, 168, 1),
(13, 3, 180, 5),
(14, 3, 182, 3),
(30, 3, 126, 6),
(31, 3, 170, 7),
(34, 23, 186, 1),
(36, 25, 48, 1),
(37, 26, 20, 1),
(38, 26, 18, 2),
(39, 23, 18, 2),
(40, 25, 18, 2),
(43, 28, 67, 2),
(44, 28, 48, 1);

--
-- Déclencheurs `playlist_video_tags`
--
DROP TRIGGER IF EXISTS `playlist_video_tags_AFTER_DELETE`;
DELIMITER //
CREATE TRIGGER `playlist_video_tags_AFTER_DELETE` AFTER DELETE ON `playlist_video_tags`
 FOR EACH ROW BEGIN
	UPDATE playlists SET count_tags = count_tags - 1 WHERE id = OLD.playlist_id;
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `playlist_video_tags_AFTER_INSERT`;
DELIMITER //
CREATE TRIGGER `playlist_video_tags_AFTER_INSERT` AFTER INSERT ON `playlist_video_tags`
 FOR EACH ROW BEGIN
	UPDATE playlists SET count_tags = count_tags + 1 WHERE id = NEW.playlist_id;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `report_errors`
--

CREATE TABLE IF NOT EXISTS `report_errors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `error_type_id` int(11) NOT NULL,
  `video_tag_id` int(11) NOT NULL,
  `comment` text CHARACTER SET utf8,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','accepted','ignored') CHARACTER SET utf8 DEFAULT 'pending',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_error_report_user` (`user_id`,`video_tag_id`,`status`),
  KEY `fk_report_users1_idx` (`user_id`),
  KEY `fk_report_video_tags1_idx` (`video_tag_id`),
  KEY `fk_report_errors_error_types1_idx` (`error_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=19 ;

--
-- Contenu de la table `report_errors`
--

INSERT INTO `report_errors` (`id`, `user_id`, `error_type_id`, `video_tag_id`, `comment`, `created`, `status`) VALUES
(4, NULL, 4, 12, 'This is a melon grab not a mute grab...', '2016-01-08 13:20:39', 'pending'),
(13, NULL, 4, 67, NULL, '2016-01-15 10:37:59', 'pending'),
(18, NULL, 4, 57, NULL, '2016-01-15 10:48:32', 'pending');

--
-- Déclencheurs `report_errors`
--
DROP TRIGGER IF EXISTS `report_errors_AFTER_DELETE`;
DELIMITER //
CREATE TRIGGER `report_errors_AFTER_DELETE` AFTER DELETE ON `report_errors`
 FOR EACH ROW BEGIN
	IF OLD.video_tag_id IS NOT NULL THEN
		UPDATE video_tags SET count_report_errors = count_report_errors - 1 WHERE id = OLD.video_tag_id;
	END IF;
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `report_errors_AFTER_INSERT`;
DELIMITER //
CREATE TRIGGER `report_errors_AFTER_INSERT` AFTER INSERT ON `report_errors`
 FOR EACH ROW BEGIN
	UPDATE video_tags SET count_report_errors = count_report_errors + 1 WHERE id = NEW.video_tag_id;
	UPDATE users SET count_report_errors = count_report_errors + 1 WHERE id = NEW.user_id;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `riders`
--

CREATE TABLE IF NOT EXISTS `riders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(45) CHARACTER SET utf8 NOT NULL,
  `lastname` varchar(45) CHARACTER SET utf8 NOT NULL,
  `picture` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `picture_dir` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `level` int(11) NOT NULL DEFAULT '0',
  `count_tags` int(11) NOT NULL DEFAULT '0',
  `slug` varchar(255) CHARACTER SET utf8 NOT NULL,
  `status` enum('validated','pending') CHARACTER SET utf8 DEFAULT NULL,
  `nationality` varchar(3) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug_UNIQUE` (`slug`),
  UNIQUE KEY `rider_UNIQUE` (`firstname`,`lastname`,`nationality`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  KEY `fk_riders_users1_idx` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=52 ;

--
-- Contenu de la table `riders`
--

INSERT INTO `riders` (`id`, `firstname`, `lastname`, `picture`, `picture_dir`, `user_id`, `level`, `count_tags`, `slug`, `status`, `nationality`) VALUES
(3, 'marck', 'mcmorris', NULL, '', NULL, 1, 9, 'marck-mcmorris-can', NULL, 'can'),
(4, 'sebastien', 'toutant', NULL, NULL, NULL, 1, 33, 'sebastien-toutant', NULL, 'can'),
(14, 'thomas', 'delfino', NULL, NULL, NULL, 1, 0, 'thomas-delfino-fr', NULL, 'fr'),
(19, 'xavier', 'de le rue', NULL, NULL, NULL, 2, 0, 'xavier-de-le-rue-fr', NULL, 'fr'),
(20, 'victor', 'de le rue', NULL, NULL, NULL, 2, 6, 'victor-de-le-rue-fr', NULL, 'fr'),
(22, 'maxence', 'parrot', NULL, NULL, NULL, 3, 7, 'maxence-parrot-ca', NULL, 'ca'),
(23, 'torstein', 'horgmo', NULL, NULL, NULL, 3, 12, 'torstein-horgmo-no', NULL, 'no'),
(24, 'jesper', 'tjäder', NULL, NULL, NULL, 3, 6, 'jesper-tjaeder-se', NULL, 'se'),
(25, 'marcus', 'kleveland', NULL, NULL, NULL, 3, 1, 'marcus-kleveland-no', NULL, 'no'),
(33, 'billy', 'morgan', NULL, NULL, NULL, 3, 4, 'billy-morgan-gb', NULL, 'gb'),
(41, 'yuki', 'kadono', NULL, NULL, NULL, 3, 4, 'yuki-kadono-jp', NULL, 'jp'),
(42, 'josh', 'sheehan', NULL, NULL, NULL, 3, 1, 'josh-sheehan-au', NULL, 'au'),
(43, 'gavin', 'godfrey', NULL, NULL, NULL, 3, 1, 'gavin-godfrey-us', NULL, 'us'),
(44, 'ethen godfrey', 'roberts', NULL, NULL, NULL, 3, 2, 'ethen-godfrey-roberts-us', NULL, 'us'),
(45, 'danny', 'torres', NULL, NULL, NULL, 3, 1, 'danny-torres-es', NULL, 'es'),
(46, 'manuel', 'diaz', NULL, NULL, NULL, 3, 1, 'manuel-diaz-cl', NULL, 'cl'),
(47, 'jeff', 'langley', NULL, NULL, NULL, 3, 1, 'jeff-langley-us', NULL, 'us'),
(48, 'mike', 'clark', NULL, NULL, NULL, 3, 1, 'mike-clark-us', NULL, 'us'),
(49, 'jordy', 'smith', NULL, NULL, NULL, 3, 1, 'jordy-smith-za', NULL, 'za'),
(50, 'lasse', 'hammer', NULL, NULL, NULL, 2, 1, 'lasse-hammer-dk', NULL, 'dk'),
(51, 'tom', 'wallish', NULL, NULL, NULL, 3, 0, 'tom-wallish-us', NULL, 'us');

-- --------------------------------------------------------

--
-- Structure de la table `social_accounts`
--

CREATE TABLE IF NOT EXISTS `social_accounts` (
  `user_id` int(11) NOT NULL,
  `social_provider_id` varchar(45) CHARACTER SET utf8 NOT NULL,
  `provider_uid` varchar(255) CHARACTER SET utf8 NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`,`social_provider_id`),
  UNIQUE KEY `unique_provider_and_uid` (`social_provider_id`,`provider_uid`),
  KEY `fk_social_accounts_users1_idx` (`user_id`),
  KEY `fk_social_accounts_scoial_providers1_idx` (`social_provider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `social_providers`
--

CREATE TABLE IF NOT EXISTS `social_providers` (
  `id` varchar(45) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Contenu de la table `social_providers`
--

INSERT INTO `social_providers` (`id`) VALUES
('facebook');

-- --------------------------------------------------------

--
-- Structure de la table `sports`
--

CREATE TABLE IF NOT EXISTS `sports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET utf8 NOT NULL,
  `status` enum('public','private') CHARACTER SET utf8 DEFAULT 'public',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=10 ;

--
-- Contenu de la table `sports`
--

INSERT INTO `sports` (`id`, `name`, `status`) VALUES
(1, 'snowboard', 'public'),
(2, 'ski', 'public'),
(3, 'skate', 'public'),
(4, 'roller', 'public'),
(5, 'motocross', 'public'),
(6, 'wakeboard', 'public'),
(7, 'surf', 'public'),
(8, 'bmx', 'public'),
(9, 'parkour', 'public');

-- --------------------------------------------------------

--
-- Structure de la table `tags`
--

CREATE TABLE IF NOT EXISTS `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(120) CHARACTER SET utf8 NOT NULL,
  `count_ref` int(11) NOT NULL DEFAULT '0',
  `sport_id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `slug` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tags_sports1_idx` (`sport_id`),
  KEY `fk_tags_categories1_idx` (`category_id`),
  KEY `fk_tags_users1_idx` (`user_id`),
  KEY `unique_tag` (`name`,`category_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=129 ;

--
-- Contenu de la table `tags`
--

INSERT INTO `tags` (`id`, `name`, `count_ref`, `sport_id`, `category_id`, `user_id`, `created`, `slug`) VALUES
(1, 'frontside 360', -1, 1, 1, NULL, '2015-12-26 09:01:35', '-frontside_36011-1'),
(3, 'backside 360', 0, 1, 1, NULL, '2015-12-26 09:01:35', '-backside_36011-1'),
(4, 'backside 180', 0, 1, 1, NULL, '2015-12-26 09:01:35', '-backside_18011-1'),
(5, 'backside 540', 0, 1, 1, NULL, '2015-12-26 09:01:35', '-backside_54011-1'),
(10, 'backside rodeo 540 indy', 0, 1, 1, NULL, '2015-12-27 09:46:26', '-backside_rodeo_540_indy11-1'),
(11, 'frontside 720 mute', 0, 1, 1, NULL, '2015-12-27 15:05:05', '-frontside_720_mute11-1'),
(13, 'frontside 540 mute', 0, 1, 1, NULL, '2015-12-27 15:09:26', '-frontside_540_mute11-1'),
(14, 'superman double front', 0, 2, 5, NULL, '2015-12-28 10:25:00', '-superman-double-front55-5'),
(15, 'switch 360 mute', 0, 2, 5, NULL, '2015-12-28 10:29:33', '-switch-360-mute55-5'),
(16, 'backside 720 mute', 1, 1, 1, NULL, '2015-12-28 16:19:32', '-backside-720-mute11-1'),
(17, 'backside 540 melon', 1, 1, 1, NULL, '2015-12-28 16:21:34', '-backside-540-melon11-1'),
(18, 'backside triple cork 1440 mute', 2, 1, 1, NULL, '2015-12-28 16:43:43', '-backside-triple-cork-1440-mute11-1'),
(19, 'double underflip indy', 1, 1, 1, NULL, '2016-01-05 18:01:16', '-double-underflip-indy11-1'),
(22, 'backside 540 nose grab', 1, 1, 1, NULL, '2016-01-05 22:53:34', '-backside-540-nose-grab11-1'),
(23, 'backside double cork 1080 mute', 4, 1, 1, NULL, '2016-01-05 22:57:03', '-backside-double-cork-1080-mute11-1'),
(24, 'backside double bio 1080 indy', 1, 1, 1, NULL, '2016-01-06 09:00:34', '-backside-double-bio-1080-indy11-1'),
(25, 'backside 1260 mute', 0, 1, 1, NULL, '2016-01-07 12:15:15', '-backside-1260-mute11-1'),
(27, 'double backflip', 3, 2, 5, NULL, '2016-01-08 09:37:20', '-double-backflip55-5'),
(28, 'backside 720 method', 0, 1, 1, NULL, '2016-01-08 10:42:36', '-backside-720-method11-1'),
(29, 'frontflip', 0, 2, 8, NULL, '2016-01-09 23:30:10', '-frontflip88-8'),
(30, 'frontflip superman', 0, 2, 5, NULL, '2016-01-09 23:35:55', '-frontflip-superman55-5'),
(31, 'double backflip on one ski', 0, 2, 5, NULL, '2016-01-09 23:38:13', '-double-backflip-on-one-ski55-5'),
(33, 'backside bio 720 nose grab', 0, 1, 1, NULL, '2016-01-10 22:29:19', '-backside-bio-720-nose-grab11-1'),
(34, 'backside 180 mute', 1, 1, 1, NULL, '2016-01-10 22:32:58', '-backside-180-mute11-1'),
(35, 'frontside double cork 1080 stalefish', 1, 1, 1, NULL, '2016-01-10 22:39:44', '-frontside-double-cork-1080-stalefish11-1'),
(36, 'frontside cork 900 tail grab', 1, 1, 1, NULL, '2016-01-10 22:41:23', '-frontside-cork-900-tail-grab11-1'),
(37, 'backside double rodeo 1260 stalefish', 1, 1, 1, NULL, '2016-01-10 23:50:11', '-backside-double-rodeo-1260-stalefish11-1'),
(38, 'frontside 1080 indy', 1, 1, 1, NULL, '2016-01-10 23:51:43', '-frontside-1080-indy11-1'),
(39, 'backside 540 indy', 1, 1, 1, NULL, '2016-01-10 23:55:48', '-backside-540-indy11-1'),
(40, 'frontside 720 tail grab', 1, 1, 1, NULL, '2016-01-10 23:57:29', '-frontside-720-tail-grab11-1'),
(41, 'frontside double cork 1080 mute', 4, 1, 1, NULL, '2016-01-10 23:59:30', '-frontside-double-cork-1080-mute11-1'),
(48, 'double backflip', 0, 5, 9, NULL, '2016-01-14 11:21:59', '-double-backflip99-9'),
(49, 'frontside double cork 1260 stalefish', 1, 1, 1, NULL, '2016-01-14 16:22:53', '-frontside-double-cork-1260-stalefish11-1'),
(50, 'frontside underflip 540 indy', 1, 1, 2, NULL, '2016-01-14 16:27:24', '-frontside-underflip-540-indy22-2'),
(52, 'backside rodeo 540 melon', 1, 1, 2, NULL, '2016-01-14 16:32:08', '-backside-rodeo-540-melon22-2'),
(53, 'backside 180 shifty', -1, 1, 1, NULL, '2016-01-14 23:11:35', '-backside-180-shifty11-1'),
(54, 'kiss of death backflip', 0, 5, 9, NULL, '2016-01-14 23:53:00', '-kiss-of-death-backflip99-9'),
(56, 'double grab', 1, 5, 9, NULL, '2016-01-14 23:58:36', '-double-grab99-9'),
(57, 'double underflip 1260 indy', 0, 1, 1, NULL, '2016-01-15 14:25:35', '-double-underflip-1260-indy11-1'),
(58, 'double backflip melon', 2, 1, 1, NULL, '2016-01-24 17:12:30', '-double-backflip-melon11-1'),
(59, 'double backside rodeo 900 melon', 3, 1, 1, NULL, '2016-01-24 17:14:07', '-double-backside-rodeo-900-melon11-1'),
(60, 'frontside 180', 1, 1, 1, NULL, '2016-01-24 17:16:01', '-frontside-18011-1'),
(61, 'backflip indy out', 1, 1, 2, NULL, '2016-01-24 17:17:38', '-backflip-indy-out22-2'),
(62, 'double backflip indy', 2, 1, 1, NULL, '2016-01-24 17:19:25', '-double-backflip-indy11-1'),
(63, 'backside 1080 mute', 3, 1, 1, NULL, '2016-02-03 22:11:58', '-backside-1080-mute11-1'),
(65, 'backside triple cork 1620 mute', 0, 1, 1, NULL, '2016-02-04 14:49:16', '-backside-triple-cork-1620-mute11-1'),
(66, 'backside 360 in', 1, 1, 2, NULL, '2016-02-04 19:54:56', '-backside-360-in22-2'),
(67, 'backside cork 1080 indy', 1, 1, 1, NULL, '2016-02-05 00:59:11', '-backside-cork-1080-indy11-1'),
(69, 'fronstide 360 stalefish', 1, 1, 1, NULL, '2016-02-06 08:43:43', '-fronstide-360-stalefish11-1'),
(71, 'frontside 360 double shifty', 1, 1, 1, NULL, '2016-02-06 12:12:07', '-frontside-360-double-shifty11-1'),
(75, 'to delete', 0, 1, 1, NULL, '2016-02-12 12:57:24', '-to-delete11-1'),
(76, 'frontside 270 in to 270 out', 0, 1, 2, NULL, '2016-02-12 16:16:06', '-frontside-270-in-to-270-out22-2'),
(77, 'frontside 270 in', 1, 1, 2, NULL, '2016-02-12 17:04:59', '-frontside-270-in22-2'),
(78, 'cab 270 in to 270 out', 1, 1, 2, NULL, '2016-02-12 17:57:54', '-cab-270-in-to-270-out22-2'),
(79, 'backside 270 in hardway', 1, 1, 2, NULL, '2016-02-12 17:59:10', '-backside-270-in-hardway22-2'),
(80, 'cab 270 in', 2, 1, 2, NULL, '2016-02-12 18:44:12', '-cab-270-in22-2'),
(82, 'switch 1260 melon', 1, 1, 1, NULL, '2016-02-12 18:48:14', '-switch-1260-melon11-1'),
(83, 'switch backlip to 270 out', 1, 1, 2, NULL, '2016-02-12 18:49:52', '-switch-backlip-to-270-out22-2'),
(84, '270 out', 1, 1, 2, NULL, '2016-02-12 18:50:59', '-270-out22-2'),
(85, 'switch quadruple underflip 1620 indy', 1, 1, 1, NULL, '2016-02-12 19:26:27', '-switch-quadruple-underflip-1620-indy11-1'),
(86, 'rodeo in', 1, 2, 5, NULL, '2016-02-13 16:45:25', '-rodeo-in55-5'),
(87, 'switch double frontflipt nose grab', 1, 2, 5, NULL, '2016-02-13 16:55:19', '-switch-double-frontflipt-nose-grab55-5'),
(88, 'hand drag double cork 1080 safety', 1, 2, 5, NULL, '2016-02-13 16:57:20', '-hand-drag-double-cork-1080-safety55-5'),
(89, 'backside quadruple cork 1800 mindy', 1, 1, 1, NULL, '2016-02-14 11:39:29', '-backside-quadruple-cork-1800-mindy11-1'),
(90, 'cab 900 mute', 1, 1, 1, NULL, '2016-02-14 13:21:00', '-cab-900-mute22-2'),
(91, 'backside double cork 1080 nose grab', 1, 1, 1, NULL, '2016-02-14 13:23:01', '-backside-double-cork-1080-nose-grab11-1'),
(92, 'backside 180 in to 180 out', 1, 1, 2, NULL, '2016-02-14 13:27:49', '-backside-180-in-to-180-out22-2'),
(93, 'cab double underflip 900 indy', 1, 1, 1, NULL, '2016-02-14 13:30:07', '-cab-double-underflip-900-indy11-1'),
(94, 'cab double cork 1080 mute', 2, 1, 1, NULL, '2016-02-14 13:31:25', '-cab-double-cork-1080-mute11-1'),
(95, 'cab double cork 1260 stalefish', 1, 1, 1, NULL, '2016-02-14 13:33:22', '-cab-double-cork-1260-stalefish11-1'),
(96, 'frontside 360 mute', 1, 1, 1, NULL, '2016-02-14 13:38:34', '-frontside-360-mute11-1'),
(97, 'frontside double underflip 900 indy', 1, 1, 1, NULL, '2016-02-15 16:55:58', '-frontside-double-underflip-900-indy11-1'),
(98, 'no spin', 1, 1, 1, NULL, '2016-02-15 16:59:36', '-no-spin11-1'),
(99, 'backside triple rodeo melon', 1, 1, 1, NULL, '2016-02-15 17:02:44', '-backside-triple-rodeo-melon11-1'),
(104, 'testtest', 0, 1, 1, NULL, '2016-02-16 18:12:11', NULL),
(105, 'frontside 270 in hardway', 1, 1, 2, NULL, '2016-02-17 17:47:46', '-frontside-270-in-hardway22-2'),
(106, 'cab double cork 900 indy', 1, 1, 1, NULL, '2016-02-17 17:56:30', '-cab-double-cork-900-indy11-1'),
(107, 'frontside  900 mute', 1, 1, 1, NULL, '2016-02-17 18:23:02', '-frontside-900-mute11-1'),
(108, 'switch 270 in to 270 out', 1, 1, 2, NULL, '2016-02-17 18:48:02', '-switch-270-in-to-270-out22-2'),
(109, 'cab 1080 mute', 1, 1, 1, NULL, '2016-02-17 18:54:59', '-cab-1080-mute11-1'),
(110, 'switch triple cork 1620 stalefish', 1, 1, 1, NULL, '2016-02-17 18:58:20', '-switch-triple-cork-1620-stalefish11-1'),
(111, 'testtesttest', 0, 1, 1, NULL, '2016-02-18 14:16:58', '-testtesttest11-1'),
(112, 'triple backflip', 1, 5, 9, NULL, '2016-02-18 16:41:44', '-triple-backflip99-9'),
(113, 'test', 0, 1, 4, NULL, '2016-02-21 10:18:42', '-test44-4'),
(114, 'triple backflip', 3, 8, 10, NULL, '2016-02-21 12:30:02', '-triple-backflip1010-10'),
(115, 'test', 0, 8, 10, NULL, '2016-02-21 12:38:15', '-test1010-10'),
(116, 'triple backflip', -1, 4, 24, NULL, '2016-02-21 12:55:02', '-triple-backflip2424-24'),
(117, 'frontside 900 tail grab', 2, 1, 1, NULL, '2016-02-22 12:39:33', '-frontside-900-tail-grab11-1'),
(118, 'mute  double roll to revert', 1, 6, 22, NULL, '2016-02-22 22:03:44', '-mute-double-roll-to-revert2222-22'),
(119, 'double backflip', 1, 8, 10, NULL, '2016-02-22 22:09:06', '-double-backflip1010-10'),
(120, 'rodeo flip', 1, 7, 16, NULL, '2016-02-22 22:15:58', '-rodeo-flip1616-16'),
(121, 'double frontflip', 1, 9, 17, NULL, '2016-02-22 22:27:13', '-double-frontflip1717-17'),
(122, 'backside air', 1, 1, 1, NULL, '2016-02-23 13:39:47', '-backside-air11-1'),
(123, 'backside lip slide', 0, 1, 2, NULL, '2016-02-23 19:28:14', '-backside-lip-slide22-2'),
(124, 'frontside lip-slide', 0, 1, 2, NULL, '2016-02-23 19:40:30', '-frontside-lip-slide22-2'),
(125, 'nose press to 180 to tail press', 0, 1, 2, NULL, '2016-02-23 19:57:10', '-nose-press-to-180-to-tail-press22-2'),
(126, 'backside 720 mute', 0, 1, 3, NULL, '2016-02-23 19:58:39', '-backside-720-mute33-3'),
(127, 'test', 1, 3, 31, NULL, '2016-02-27 20:42:57', 'test-31'),
(128, 'nose butter 360', 0, 2, 8, NULL, '2016-03-01 16:58:34', 'nose-butter-360-8');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `username` varchar(45) CHARACTER SET utf8 NOT NULL,
  `password` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `status` enum('activated','banned','blocked','created') CHARACTER SET utf8 NOT NULL,
  `count_tags` int(11) NOT NULL DEFAULT '0',
  `count_report_errors` int(11) DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `provider` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `provider_uid` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `count_tags_validated` int(11) NOT NULL DEFAULT '0',
  `count_tags_rejected` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `provider_and_uid` (`provider`,`provider_uid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=13 ;

--
-- Déclencheurs `users`
--
DROP TRIGGER IF EXISTS `users_AFTER_DELETE`;
DELIMITER //
CREATE TRIGGER `users_AFTER_DELETE` AFTER DELETE ON `users`
 FOR EACH ROW BEGIN
	DELETE FROM playlists WHERE user_id = OLD.id AND (`status` = 'private' OR ( 
		`status` = 'public' AND count_tags < 2));
	DELETE FROM video_tags WHERE user_id = OLD.id AND `status` IN ('blocked', 'rejected');
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `videos`
--

CREATE TABLE IF NOT EXISTS `videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `video_url` varchar(255) CHARACTER SET utf8 NOT NULL,
  `provider_id` varchar(45) CHARACTER SET utf8 NOT NULL,
  `count_tags` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `status` enum('public','private') CHARACTER SET utf8 NOT NULL,
  `duration` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_video_provider` (`video_url`,`provider_id`),
  KEY `fk_videos_sources_idx` (`provider_id`),
  KEY `fk_videos_users1_idx` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=154 ;

--
-- Contenu de la table `videos`
--

INSERT INTO `videos` (`id`, `video_url`, `provider_id`, `count_tags`, `user_id`, `created`, `modified`, `status`, `duration`) VALUES
(45, 'NNDT7p_sHBI', 'youtube', 4, NULL, '2015-12-26 09:07:23', '2016-02-06 13:17:24', 'public', 140),
(48, 'DuFIVZo7WIM', 'youtube', 0, NULL, '2015-12-26 11:40:08', '2016-02-06 13:17:25', 'public', 5474),
(49, 'VEQ-s679a10', 'youtube', 0, NULL, '2015-12-26 11:51:17', '2016-02-06 13:17:25', 'public', 121),
(56, 'FCpZKsTqmkc', 'youtube', 9, NULL, '2015-12-27 09:18:57', '2016-02-18 16:33:33', 'public', 240),
(57, '7-Mi5mG4BsQ', 'youtube', 1, NULL, '2015-12-28 10:23:33', '2016-02-06 13:17:26', 'public', 350),
(58, 'eeCoNywb45U', 'youtube', 1, NULL, '2015-12-28 10:26:09', '2016-02-06 13:17:27', 'public', 261),
(59, '1MQfbMoCfb4', 'youtube', 2, NULL, '2015-12-28 15:54:54', '2016-02-06 13:17:27', 'public', 277),
(60, 'Ofc9hh0NWe8', 'youtube', 30, NULL, '2015-12-28 16:17:49', '2016-02-23 20:08:39', 'public', 244),
(82, '6mEHw5q6Yfs', 'youtube', 0, NULL, '2016-01-05 20:45:02', '2016-02-06 13:17:28', 'public', 1812),
(102, 'xb5LHuZGXi0', 'youtube', 0, NULL, '2016-01-05 20:55:44', '2016-02-06 13:17:29', 'public', 131),
(103, 'k7-3xEpyAgo', 'youtube', 1, NULL, '2016-01-08 09:35:12', '2016-02-06 13:17:29', 'public', 51),
(104, 'yrynZrGpQMY', 'youtube', 3, NULL, '2016-01-08 10:38:44', '2016-02-06 13:17:30', 'public', 357),
(105, 'vbWkr7PWRfA', 'youtube', 3, NULL, '2016-01-08 14:08:09', '2016-02-06 13:17:30', 'public', 3488),
(106, 'W3JXdLmxSHk', 'youtube', 3, NULL, '2016-01-09 23:28:05', '2016-02-06 13:17:30', 'public', 157),
(107, 'Txyns-zD4n0', 'youtube', 1, NULL, '2016-01-10 19:14:46', '2016-02-06 13:17:31', 'public', 749),
(108, 'rSHHzrgWUqk', 'youtube', 0, NULL, '2016-01-10 22:25:56', '2016-02-06 13:17:32', 'public', 275),
(109, '0B_BpxmusXA', 'youtube', 9, NULL, '2016-01-10 22:27:17', '2016-02-07 12:58:30', 'public', 235),
(110, 'OprCOLuUPzY', 'youtube', 6, NULL, '2016-01-10 23:53:16', '2016-02-06 13:17:32', 'public', 213),
(111, 'PTfNhcoVH1g', 'youtube', 1, NULL, '2016-01-12 10:04:41', '2016-02-06 13:17:33', 'public', 3017),
(112, '0o-xXXMXX1Q', 'youtube', 1, NULL, '2016-01-14 11:21:13', '2016-02-06 13:17:34', 'public', 165),
(113, 'hDnGPpHEM6U', 'youtube', 14, NULL, '2016-01-14 16:20:22', '2016-02-23 13:39:47', 'public', 294),
(114, 'FAjxL5km4wU', 'youtube', 1, NULL, '2016-01-14 23:10:32', '2016-02-06 13:17:35', 'private', 0),
(115, 'QFUsEjZ6ppU', 'youtube', 7, NULL, '2016-01-24 16:28:50', '2016-02-12 10:42:45', 'public', 234),
(116, 'b8LNh5iO0Hk', 'youtube', 3, NULL, '2016-02-05 00:36:22', '2016-02-06 13:17:35', 'public', 374),
(117, 'S7FL8JN2s60', 'youtube', 0, NULL, '2016-02-05 20:01:50', '2016-02-06 13:17:36', 'public', 106),
(118, 'e4tEOuDXA7Y', 'youtube', 0, NULL, '2016-02-05 20:12:13', '2016-02-06 13:17:36', 'public', 177),
(119, 'GW_lV0dW6nA', 'youtube', 1, NULL, '2016-02-06 12:10:34', '2016-02-06 13:17:37', 'public', 11),
(120, 'KoHzXi7Usl8', 'youtube', 0, NULL, '2016-02-12 10:40:44', NULL, 'public', 160),
(121, 'GF6Ct6B1yfM', 'youtube', 0, NULL, '2016-02-12 10:41:51', NULL, 'public', 652),
(122, 'SK3QUktvWbI', 'youtube', 0, NULL, '2016-02-12 13:40:53', NULL, 'public', 321),
(123, 'aK_u64s2zNA', 'youtube', 9, NULL, '2016-02-12 16:12:17', '2016-02-12 18:24:53', 'public', 150),
(124, '4efHnJ-T6co', 'youtube', 6, NULL, '2016-02-12 18:40:21', '2016-02-14 11:20:17', 'public', 204),
(125, 'vUNyKJKMYg4', 'youtube', 4, NULL, '2016-02-12 18:56:18', '2016-02-17 18:23:02', 'public', 127),
(126, 'KSdx9gNmqlc', 'youtube', 1, NULL, '2016-02-12 19:24:35', '2016-02-12 19:26:27', 'public', 73),
(127, '4rtoQzPM_KA', 'youtube', 0, NULL, '2016-02-13 09:52:01', NULL, 'public', 1209),
(128, 'K4lt74KUpAA', 'youtube', 5, NULL, '2016-02-13 16:41:32', '2016-02-13 16:58:34', 'public', 230),
(129, 'jaA_nnfzrFE', 'youtube', 16, NULL, '2016-02-14 11:30:15', '2016-02-16 18:12:19', 'public', 128),
(130, 'OiCyAEcZsks', 'youtube', 0, NULL, '2016-02-15 09:38:35', NULL, 'public', 54),
(131, 'e9YqaZhIL8s', 'youtube', 0, NULL, '2016-02-15 16:42:51', NULL, 'public', 152),
(132, 'wAfSClKOUBI', 'youtube', 4, NULL, '2016-02-15 16:44:28', '2016-02-15 17:02:44', 'public', 152),
(133, 'HlLZKTa9SGI', 'youtube', 4, NULL, '2016-02-17 18:44:12', '2016-02-17 19:02:23', 'public', 79),
(134, 'KIpW5m4qOjU', 'youtube', 0, NULL, '2016-02-17 23:56:42', NULL, 'public', 440),
(135, 'WFLwxGB1qFI', 'youtube', 1, NULL, '2016-02-18 16:39:14', '2016-02-18 16:41:44', 'public', 83),
(136, 'ZKvhxapM5zo', 'youtube', 0, NULL, '2016-02-19 09:45:52', NULL, 'public', 204),
(137, '24348649', 'vimeo', 1, NULL, '2016-02-19 09:57:20', '2016-02-21 10:35:21', 'public', 71),
(138, 'mvpMyZCLAIA', 'youtube', 3, NULL, '2016-02-21 12:17:37', '2016-02-21 12:38:15', 'public', 259),
(139, '92609491', 'vimeo', 0, NULL, '2016-02-21 12:43:57', NULL, 'public', 169),
(140, 'rcZWiVSmv7U', 'youtube', 1, NULL, '2016-02-21 12:50:51', '2016-02-21 12:55:03', 'public', 18),
(141, 'T1zEBh5HLH8', 'youtube', 1, NULL, '2016-02-21 13:33:10', '2016-02-21 13:35:08', 'public', 3072),
(142, 'flvbfuAX1_U', 'youtube', 1, NULL, '2016-02-22 12:06:54', '2016-02-22 12:09:38', 'public', 89),
(143, 'JfpiuzlLUx4', 'youtube', 0, NULL, '2016-02-22 21:57:23', NULL, 'public', 30),
(144, 'yZdx1MCJySc', 'youtube', 1, NULL, '2016-02-22 22:00:36', '2016-02-22 22:03:44', 'public', 49),
(145, '7idj9R43tZA', 'youtube', 1, NULL, '2016-02-22 22:05:44', '2016-02-22 22:09:06', 'public', 108),
(146, 'jVIDlndAWhw', 'youtube', 1, NULL, '2016-02-22 22:14:12', '2016-02-22 22:15:58', 'public', 125),
(147, 'fPcqmiz8zJ0', 'youtube', 1, NULL, '2016-02-22 22:18:11', '2016-02-22 22:27:13', 'public', 6),
(148, '125896742', 'vimeo', 0, NULL, '2016-02-23 15:50:30', NULL, 'public', 406),
(149, '97945205', 'vimeo', 0, NULL, '2016-02-27 16:47:51', NULL, 'public', 0),
(150, '97762449', 'vimeo', 1, NULL, '2016-02-27 18:30:04', '2016-02-27 20:42:58', 'public', 129),
(151, 'U6lpBi39N78', 'youtube', 0, NULL, '2016-03-01 10:48:59', NULL, 'public', 2103),
(152, 'gpErRnCYoyg', 'youtube', 0, NULL, '2016-03-01 16:46:18', NULL, 'public', 1922),
(153, 'LdLa06_fbvQ', 'youtube', 2, NULL, '2016-03-01 16:50:35', '2016-03-01 17:05:15', 'public', 243);

--
-- Déclencheurs `videos`
--
DROP TRIGGER IF EXISTS `videos_AFTER_INSERT`;
DELIMITER //
CREATE TRIGGER `videos_AFTER_INSERT` AFTER INSERT ON `videos`
 FOR EACH ROW BEGIN

END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `videos_BEFORE_UPDATE`;
DELIMITER //
CREATE TRIGGER `videos_BEFORE_UPDATE` BEFORE UPDATE ON `videos`
 FOR EACH ROW BEGIN
	SET NEW.modified := CURRENT_TIMESTAMP;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `video_providers`
--

CREATE TABLE IF NOT EXISTS `video_providers` (
  `name` varchar(45) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Contenu de la table `video_providers`
--

INSERT INTO `video_providers` (`name`) VALUES
('vimeo'),
('youtube');

-- --------------------------------------------------------

--
-- Structure de la table `video_tags`
--

CREATE TABLE IF NOT EXISTS `video_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `video_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `rider_id` int(11) DEFAULT NULL,
  `begin` decimal(5,2) NOT NULL,
  `end` decimal(5,2) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `count_points` int(11) NOT NULL DEFAULT '0',
  `count_up` int(11) NOT NULL DEFAULT '0',
  `count_report_errors` int(11) NOT NULL DEFAULT '0',
  `status` enum('pending','validated','rejected','blocked','duplicate') COLLATE utf8_polish_ci DEFAULT NULL,
  `count_fake` int(11) NOT NULL DEFAULT '0',
  `count_accurate` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_users_has_videos_videos1_idx` (`video_id`),
  KEY `fk_users_has_videos_users1_idx` (`user_id`),
  KEY `fk_users_has_videos_tags1_idx` (`tag_id`),
  KEY `fk_video_tags_riders1_idx` (`rider_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=194 ;

--
-- Contenu de la table `video_tags`
--

INSERT INTO `video_tags` (`id`, `video_id`, `tag_id`, `user_id`, `rider_id`, `begin`, `end`, `created`, `modified`, `count_points`, `count_up`, `count_report_errors`, `status`, `count_fake`, `count_accurate`) VALUES
(11, 56, 10, NULL, NULL, '32.13', '38.24', '2015-12-27 09:46:26', NULL, 1, 0, 0, 'pending', 0, 1),
(12, 56, 11, NULL, NULL, '61.13', '64.63', '2015-12-27 15:05:05', NULL, 1, 0, 1, 'pending', 0, 1),
(16, 58, 15, NULL, NULL, '112.62', '116.38', '2015-12-28 10:29:33', NULL, 1, 0, 0, 'pending', 1, 0),
(18, 60, 16, NULL, 4, '4.50', '12.55', '2015-12-28 16:19:32', NULL, 2, 0, 0, 'validated', 0, 0),
(19, 60, 17, NULL, 4, '34.50', '40.00', '2015-12-28 16:21:35', NULL, 2, 0, 0, 'validated', 0, 0),
(20, 60, 18, NULL, 4, '178.00', '187.76', '2015-12-28 16:43:43', NULL, 1, 0, 0, 'validated', 0, 0),
(21, 60, 19, NULL, 4, '28.00', '34.00', '2016-01-05 18:01:17', NULL, 1, 0, 0, 'validated', 0, 0),
(46, 60, 22, NULL, 4, '150.00', '162.00', '2016-01-05 22:53:34', NULL, 1, 0, 0, 'validated', 0, 0),
(47, 60, 23, NULL, 4, '193.50', '212.30', '2016-01-05 22:57:03', NULL, 1, 0, 0, 'validated', 0, 0),
(48, 60, 24, NULL, 4, '56.17', '62.17', '2016-01-06 09:00:35', NULL, 2, 0, 0, 'validated', 0, 0),
(53, 59, 25, NULL, NULL, '85.00', '98.78', '2016-01-07 12:15:17', NULL, 1, 0, 0, 'pending', 0, 2),
(55, 103, 27, NULL, 24, '17.50', '41.50', '2016-01-08 09:37:20', NULL, 2, 0, 0, 'validated', 0, 0),
(56, 104, 11, NULL, NULL, '57.00', '61.50', '2016-01-08 10:40:46', NULL, 2, 0, 0, 'pending', 0, 1),
(57, 104, 28, NULL, NULL, '68.50', '73.00', '2016-01-08 10:42:36', NULL, 1, 0, 1, 'pending', 0, 1),
(58, 104, 27, NULL, NULL, '267.00', '273.00', '2016-01-08 19:44:28', NULL, 1, 0, 0, 'pending', 0, 1),
(59, 106, 29, NULL, NULL, '56.00', '59.00', '2016-01-09 23:30:10', NULL, 0, 0, 0, 'pending', 0, 1),
(60, 106, 30, NULL, NULL, '22.00', '24.50', '2016-01-09 23:35:55', NULL, 0, 0, 0, 'pending', 0, 1),
(61, 106, 31, NULL, NULL, '81.69', '84.92', '2016-01-09 23:38:13', NULL, 1, 0, 0, 'pending', 0, 1),
(62, 107, 66, NULL, NULL, '390.67', '396.50', '2016-01-10 19:17:23', NULL, 0, 0, 0, 'pending', 0, 1),
(64, 109, 34, NULL, 20, '95.50', '98.00', '2016-01-10 22:32:58', NULL, 1, 0, 0, 'validated', 0, 0),
(65, 109, 23, NULL, 20, '115.00', '122.36', '2016-01-10 22:38:23', NULL, 2, 0, 0, 'validated', 0, 0),
(66, 109, 35, NULL, 20, '129.30', '135.22', '2016-01-10 22:39:44', NULL, 0, 0, 0, 'validated', 0, 0),
(67, 109, 36, NULL, 20, '138.50', '142.13', '2016-01-10 22:41:23', NULL, 3, 0, 1, 'validated', 0, 0),
(68, 109, 37, NULL, 20, '174.00', '179.69', '2016-01-10 23:50:11', NULL, 1, 0, 0, 'validated', 0, 0),
(69, 109, 38, NULL, 20, '217.00', '221.14', '2016-01-10 23:51:44', NULL, 0, 0, 0, 'validated', 0, 0),
(70, 110, 39, NULL, 23, '68.00', '72.00', '2016-01-10 23:55:48', NULL, 0, 0, 0, 'validated', 0, 0),
(71, 110, 40, NULL, 23, '95.50', '99.50', '2016-01-10 23:57:30', NULL, 0, 0, 0, 'validated', 0, 0),
(72, 110, 41, NULL, 23, '141.00', '146.00', '2016-01-10 23:59:30', NULL, 0, 0, 0, 'validated', 0, 0),
(73, 110, 41, NULL, 23, '23.02', '29.57', '2016-01-11 00:03:26', NULL, 1, 0, 0, 'validated', 0, 0),
(77, 112, 48, NULL, NULL, '29.00', '33.50', '2016-01-14 11:22:00', NULL, 1, 0, 0, 'pending', 0, 1),
(78, 113, 49, NULL, 4, '16.52', '20.93', '2016-01-14 16:22:53', '2016-02-22 22:47:38', 1, 0, 0, 'validated', 0, 2),
(79, 113, 23, NULL, 4, '27.45', '31.33', '2016-01-14 16:24:34', '2016-02-22 22:48:26', 0, 0, 0, 'validated', 1, 1),
(80, 113, 50, NULL, 4, '93.00', '99.50', '2016-01-14 16:27:24', '2016-02-22 22:48:20', 0, 0, 0, 'validated', 1, 1),
(81, 113, 117, NULL, 4, '108.25', '114.01', '2016-01-14 16:29:51', '2016-02-22 22:49:18', 0, 0, 0, 'validated', 1, 1),
(82, 113, 52, NULL, NULL, '208.00', '213.50', '2016-01-14 16:32:09', NULL, 1, 0, 0, 'pending', 1, 0),
(83, 113, 18, NULL, 4, '225.00', '241.50', '2016-01-14 16:33:25', NULL, 1, 0, 0, 'validated', 0, 0),
(85, 105, 54, NULL, NULL, '251.30', '258.30', '2016-01-14 23:53:00', NULL, 1, 0, 0, 'pending', 0, 1),
(86, 105, 54, NULL, NULL, '322.36', '326.60', '2016-01-14 23:54:09', NULL, 1, 0, 0, 'pending', 0, 1),
(87, 105, 56, NULL, 45, '492.66', '496.84', '2016-01-14 23:58:37', NULL, 0, 0, 0, 'validated', 0, 1),
(88, 113, 57, NULL, NULL, '102.50', '107.50', '2016-01-15 14:25:35', NULL, 0, 0, 0, 'pending', 1, 0),
(89, 115, 58, NULL, 3, '86.06', '92.56', '2016-01-24 17:12:31', '2016-02-22 22:49:37', 1, 0, 0, 'validated', 0, 2),
(90, 115, 59, NULL, 3, '118.00', '123.50', '2016-01-24 17:14:07', '2016-02-22 22:49:43', 0, 0, 0, 'validated', 0, 2),
(91, 115, 60, NULL, 3, '152.94', '155.94', '2016-01-24 17:16:01', '2016-02-22 22:49:46', 0, 0, 0, 'validated', 0, 2),
(92, 115, 61, NULL, 3, '171.91', '176.91', '2016-01-24 17:17:38', '2016-02-22 22:49:48', 0, 0, 0, 'validated', 0, 2),
(93, 115, 62, NULL, 3, '216.00', '219.50', '2016-01-24 17:19:25', '2016-02-22 22:49:50', 0, 0, 0, 'validated', 0, 2),
(94, 113, 63, NULL, 4, '219.45', '224.00', '2016-02-03 22:11:58', '2016-02-22 22:49:13', 0, 0, 0, 'validated', 0, 2),
(96, 113, 66, NULL, 4, '245.50', '248.50', '2016-02-04 19:54:56', NULL, 0, 0, 0, 'validated', 0, 0),
(97, 116, 67, NULL, 23, '53.50', '62.32', '2016-02-05 00:59:11', '2016-02-22 22:38:28', 0, 0, 0, 'validated', 1, 1),
(99, 116, 69, NULL, 23, '49.30', '53.30', '2016-02-06 08:43:43', '2016-02-22 22:38:33', 0, 0, 0, 'validated', 1, 1),
(100, 119, 71, NULL, NULL, '4.50', '9.50', '2016-02-06 12:12:07', '2016-02-22 22:50:12', 0, 0, 0, 'validated', 1, 1),
(107, 123, 78, NULL, 22, '2.16', '6.15', '2016-02-12 17:57:54', NULL, 0, 0, 0, 'validated', 0, 0),
(108, 123, 79, NULL, 22, '8.42', '11.93', '2016-02-12 17:59:10', NULL, 0, 0, 0, 'validated', 0, 0),
(109, 123, 77, NULL, 22, '13.50', '17.00', '2016-02-12 18:15:25', NULL, 0, 0, 0, 'validated', 0, 0),
(110, 123, 41, NULL, 22, '18.50', '23.57', '2016-02-12 18:18:38', NULL, 0, 0, 0, 'validated', 0, 0),
(111, 123, 59, NULL, 22, '24.00', '29.00', '2016-02-12 18:20:01', NULL, 0, 0, 0, 'validated', 0, 0),
(112, 123, 18, NULL, 22, '35.00', '41.34', '2016-02-12 18:24:53', NULL, 0, 0, 0, 'validated', 0, 0),
(113, 124, 80, NULL, 23, '26.45', '30.45', '2016-02-12 18:44:12', NULL, 0, 0, 0, 'validated', 0, 0),
(114, 124, 94, NULL, 23, '41.50', '48.00', '2016-02-12 18:46:09', NULL, 0, 0, 0, 'validated', 0, 0),
(115, 124, 82, NULL, 23, '49.00', '54.00', '2016-02-12 18:48:14', NULL, 0, 0, 0, 'validated', 0, 0),
(116, 124, 83, NULL, 23, '32.09', '35.05', '2016-02-12 18:49:52', NULL, 0, 0, 0, 'validated', 0, 0),
(117, 124, 84, NULL, 23, '36.00', '40.50', '2016-02-12 18:50:59', NULL, 0, 0, 0, 'validated', 0, 0),
(118, 125, 62, NULL, 3, '51.00', '55.30', '2016-02-12 18:57:37', NULL, 1, 0, 0, 'validated', 0, 0),
(119, 126, 85, NULL, 22, '17.00', '53.50', '2016-02-12 19:26:27', NULL, 0, 0, 0, 'validated', 0, 0),
(120, 128, 27, NULL, 24, '25.50', '30.50', '2016-02-13 16:43:18', NULL, 1, 0, 0, 'validated', 0, 0),
(121, 128, 86, NULL, 24, '111.00', '117.00', '2016-02-13 16:45:25', NULL, 1, 0, 0, 'validated', 0, 0),
(122, 128, 87, NULL, 24, '139.00', '151.00', '2016-02-13 16:55:20', NULL, 0, 0, 0, 'validated', 0, 0),
(123, 128, 88, NULL, 24, '156.50', '168.50', '2016-02-13 16:57:20', NULL, 1, 0, 0, 'validated', 0, 0),
(124, 128, 27, NULL, 24, '212.00', '220.00', '2016-02-13 16:58:34', NULL, 2, 0, 0, 'validated', 0, 0),
(125, 124, 80, NULL, 23, '76.00', '81.50', '2016-02-14 11:20:17', NULL, 0, 0, 0, 'validated', 0, 0),
(126, 129, 89, NULL, 25, '71.50', '88.00', '2016-02-14 11:39:30', NULL, 0, 0, 0, 'validated', 0, 0),
(127, 60, 52, NULL, 4, '44.00', '46.50', '2016-02-14 13:19:45', NULL, 1, 0, 0, 'validated', 0, 0),
(128, 60, 90, NULL, 4, '63.00', '71.00', '2016-02-14 13:21:00', NULL, 0, 0, 0, 'validated', 0, 0),
(129, 60, 91, NULL, 4, '72.00', '80.50', '2016-02-14 13:23:01', NULL, 0, 0, 0, 'validated', 0, 0),
(130, 60, 23, NULL, 4, '82.00', '92.00', '2016-02-14 13:24:33', NULL, 0, 0, 0, 'validated', 0, 0),
(131, 60, 41, NULL, 4, '99.18', '102.18', '2016-02-14 13:26:24', NULL, 0, 0, 0, 'validated', 0, 0),
(132, 60, 92, NULL, 4, '114.00', '116.50', '2016-02-14 13:27:49', NULL, 0, 0, 0, 'validated', 0, 0),
(133, 60, 93, NULL, 4, '122.00', '130.00', '2016-02-14 13:30:07', NULL, 0, 0, 0, 'validated', 0, 0),
(134, 60, 94, NULL, 4, '133.00', '138.50', '2016-02-14 13:31:25', NULL, 1, 0, 0, 'validated', 0, 0),
(135, 60, 95, NULL, 4, '141.00', '147.50', '2016-02-14 13:33:23', NULL, 0, 0, 0, 'validated', 0, 0),
(136, 60, 96, NULL, 4, '14.50', '25.00', '2016-02-14 13:38:34', NULL, 0, 0, 0, 'validated', 0, 0),
(137, 132, 59, NULL, 33, '29.00', '33.50', '2016-02-15 16:50:30', '2016-02-22 22:39:17', 0, 0, 0, 'validated', 1, 1),
(138, 132, 97, NULL, 33, '33.50', '38.00', '2016-02-15 16:55:58', '2016-02-22 22:39:45', 0, 0, 0, 'validated', 1, 1),
(139, 132, 98, NULL, 33, '87.00', '91.50', '2016-02-15 16:59:36', NULL, 0, 0, 0, 'validated', 0, 0),
(140, 132, 99, NULL, 33, '97.50', '104.61', '2016-02-15 17:02:44', NULL, 1, 0, 0, 'validated', 0, 0),
(156, 125, 105, NULL, 3, '24.28', '28.54', '2016-02-17 17:47:48', '2016-02-22 22:38:39', 0, 0, 0, 'validated', 0, 2),
(157, 125, 106, NULL, 3, '30.59', '36.59', '2016-02-17 17:56:31', '2016-02-22 22:38:43', 0, 0, 0, 'validated', 1, 1),
(158, 125, 107, NULL, 3, '36.50', '40.50', '2016-02-17 18:23:02', '2016-02-22 22:38:48', 0, 0, 0, 'validated', 0, 2),
(159, 133, 108, NULL, 41, '18.00', '23.50', '2016-02-17 18:48:02', '2016-02-22 22:39:49', 0, 0, 0, 'validated', 0, 2),
(160, 133, 109, NULL, 41, '34.16', '39.17', '2016-02-17 18:54:59', '2016-02-22 22:39:57', 0, 0, 0, 'validated', 0, 2),
(161, 133, 110, NULL, 41, '47.50', '53.50', '2016-02-17 18:58:20', '2016-02-22 22:40:03', 0, 0, 0, 'validated', 0, 2),
(162, 133, 65, NULL, 41, '40.50', '46.50', '2016-02-17 19:02:23', '2016-02-22 22:40:07', 0, 0, 0, 'validated', 0, 2),
(168, 135, 112, NULL, 42, '43.32', '55.32', '2016-02-18 16:41:44', NULL, 2, 0, 0, 'validated', 0, 0),
(170, 138, 114, NULL, 43, '142.63', '158.12', '2016-02-21 12:30:02', '2016-02-22 22:40:12', 0, 0, 0, 'validated', 0, 2),
(171, 138, 114, NULL, 44, '209.00', '224.00', '2016-02-21 12:37:42', '2016-02-22 22:40:17', 0, 0, 0, 'validated', 0, 2),
(172, 138, 114, NULL, 44, '208.50', '224.00', '2016-02-21 12:38:15', '2016-02-22 22:46:44', 0, 0, 0, 'validated', 0, 2),
(174, 141, 22, NULL, NULL, '888.00', '898.50', '2016-02-21 13:35:08', NULL, 0, 0, 0, 'pending', 0, 1),
(175, 142, 58, NULL, 46, '8.50', '19.17', '2016-02-22 12:09:38', '2016-02-22 22:47:06', 1, 0, 0, 'validated', 0, 2),
(177, 113, 117, NULL, 4, '108.25', '114.01', '2016-02-22 12:39:34', '2016-02-22 22:49:26', 0, 0, 0, 'validated', 0, 2),
(178, 113, 63, NULL, 4, '27.45', '31.33', '2016-02-22 15:39:57', '2016-02-22 22:33:44', 0, 0, 0, 'validated', 0, 2),
(179, 113, 63, NULL, 4, '27.45', '31.83', '2016-02-22 15:41:25', '2016-02-22 22:29:12', 0, 0, 0, 'validated', 0, 2),
(180, 144, 118, NULL, 47, '11.50', '18.73', '2016-02-22 22:03:44', '2016-02-22 22:31:47', 1, 1, 0, 'validated', 0, 2),
(181, 145, 119, NULL, 48, '29.50', '33.60', '2016-02-22 22:09:06', '2016-02-22 22:31:45', 1, 0, 0, 'validated', 0, 2),
(182, 146, 120, NULL, 49, '4.00', '17.50', '2016-02-22 22:15:58', '2016-02-22 22:31:36', 3, 1, 0, 'validated', 0, 2),
(183, 147, 121, NULL, 50, '0.00', '5.00', '2016-02-22 22:27:13', '2016-02-22 22:31:32', 1, 0, 0, 'validated', 0, 2),
(184, 113, 122, NULL, 4, '68.50', '76.50', '2016-02-23 13:39:47', '2016-02-23 14:14:42', 0, 0, 0, 'validated', 0, 2),
(185, 60, 123, NULL, 4, '171.30', '175.40', '2016-02-23 19:28:14', '2016-02-23 19:28:14', 0, 0, 0, 'pending', 1, 0),
(186, 60, 123, NULL, 4, '171.30', '175.40', '2016-02-23 19:28:15', '2016-02-23 19:35:18', 0, 0, 0, 'pending', 1, 0),
(187, 60, 124, NULL, 4, '165.00', '169.66', '2016-02-23 19:40:30', '2016-02-23 19:40:30', 0, 0, 0, 'pending', 1, 1),
(188, 60, 125, NULL, 4, '107.10', '111.00', '2016-02-23 19:57:10', '2016-02-23 19:57:10', 0, 0, 0, 'pending', 2, 0),
(189, 60, 126, NULL, 4, '92.70', '99.00', '2016-02-23 19:58:39', '2016-02-23 19:58:39', 0, 0, 0, 'pending', 0, 2),
(190, 60, 123, NULL, 4, '48.10', '50.10', '2016-02-23 20:08:39', '2016-02-23 20:08:39', 0, 0, 0, 'pending', 2, 0),
(191, 150, 127, NULL, NULL, '5.10', '24.30', '2016-02-27 20:42:58', '2016-02-27 20:42:58', 0, 0, 0, 'pending', 2, 0);

--
-- Déclencheurs `video_tags`
--
DROP TRIGGER IF EXISTS `video_tags_AFTER_DELETE`;
DELIMITER //
CREATE TRIGGER `video_tags_AFTER_DELETE` AFTER DELETE ON `video_tags`
 FOR EACH ROW BEGIN
	
    IF OLD.tag_id IS NOT NULL THEN 
		UPDATE tags SET count_ref = count_ref - 1 WHERE id = OLD.tag_id;
	END IF;
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `video_tags_AFTER_INSERT`;
DELIMITER //
CREATE TRIGGER `video_tags_AFTER_INSERT` AFTER INSERT ON `video_tags`
 FOR EACH ROW BEGIN
	IF NEW.user_id IS NOT NULL THEN
		UPDATE users SET count_tags = count_tags + 1 WHERE id = NEW.user_id;
    END IF;
    IF NEW.tag_id IS NOT NULL THEN 
		UPDATE tags SET count_ref = count_ref + 1 WHERE id = NEW.tag_id;
	END IF;
    IF NEW.video_id IS NOT NULL THEN 
		UPDATE videos SET count_tags = count_tags + 1 WHERE id = NEW.video_id;
	END IF;
    IF NEW.rider_id IS NOT NULL THEN 
		UPDATE riders SET count_tags = count_tags + 1 WHERE id = NEW.rider_id;
	END IF;
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `video_tags_AFTER_UPDATE`;
DELIMITER //
CREATE TRIGGER `video_tags_AFTER_UPDATE` AFTER UPDATE ON `video_tags`
 FOR EACH ROW BEGIN
    IF NEW.rider_id IS NOT NULL THEN 
		UPDATE riders SET count_tags = count_tags + 1 WHERE id = NEW.rider_id;
	END IF;
    IF OLD.rider_id IS NOT NULL THEN 
		UPDATE riders SET count_tags = count_tags - 1 WHERE id = OLD.rider_id;
	END IF;
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `video_tags_BEFORE_DELETE`;
DELIMITER //
CREATE TRIGGER `video_tags_BEFORE_DELETE` BEFORE DELETE ON `video_tags`
 FOR EACH ROW BEGIN
    IF OLD.rider_id IS NOT NULL THEN 
		UPDATE riders SET count_tags = count_tags - 1 WHERE id = OLD.rider_id;
	END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `video_tag_accuracy_rates`
--

CREATE TABLE IF NOT EXISTS `video_tag_accuracy_rates` (
  `user_id` int(11) NOT NULL,
  `video_tag_id` int(11) NOT NULL,
  `value` enum('accurate','fake','skip') COLLATE utf8_polish_ci NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`video_tag_id`),
  KEY `fk_video_tag_accuracy_rates_users1_idx` (`user_id`),
  KEY `fk_video_tag_accuracy_rates_video_tags1_idx` (`video_tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Déclencheurs `video_tag_accuracy_rates`
--
DROP TRIGGER IF EXISTS `video_tag_accuracy_rates_AFTER_INSERT`;
DELIMITER //
CREATE TRIGGER `video_tag_accuracy_rates_AFTER_INSERT` AFTER INSERT ON `video_tag_accuracy_rates`
 FOR EACH ROW BEGIN
	IF NEW.value = "accurate" THEN 
		UPDATE video_tags SET count_accurate = count_accurate + 1 WHERE id = NEW.video_tag_id;
	ELSE
		UPDATE video_tags SET count_fake = count_fake + 1 WHERE id = NEW.video_tag_id;
	END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `video_tag_points`
--

CREATE TABLE IF NOT EXISTS `video_tag_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` tinyint(2) NOT NULL,
  `user_id` int(11) NOT NULL,
  `video_tag_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_video_tag_user` (`user_id`,`video_tag_id`),
  KEY `fk_video_tag_points_video_tags1_idx` (`video_tag_id`),
  KEY `fk_video_tag_points_users1_idx` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=80 ;

--
-- Déclencheurs `video_tag_points`
--
DROP TRIGGER IF EXISTS `video_tag_points_AFTER_INSERT`;
DELIMITER //
CREATE TRIGGER `video_tag_points_AFTER_INSERT` AFTER INSERT ON `video_tag_points`
 FOR EACH ROW BEGIN
	UPDATE video_tags 
		SET count_points = count_points + NEW.`value`,  
				count_up = count_up + GREATEST(NEW.`value`, 0) 
		WHERE id = NEW.video_tag_id; 
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `video_tag_points_AFTER_UPDATE`;
DELIMITER //
CREATE TRIGGER `video_tag_points_AFTER_UPDATE` AFTER UPDATE ON `video_tag_points`
 FOR EACH ROW BEGIN

	IF OLD.`value` IS NOT NULL AND NEW.`value` IS NOT NULL AND NEW.`value` != OLD.`value` THEN
		UPDATE video_tags 
			SET count_points = (count_points + NEW.`value` - OLD.`value`),  
				count_up = count_up + GREATEST(NEW.`value`, 0) 
            WHERE id = NEW.video_tag_id; 
	END IF;
END
//
DELIMITER ;

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `fk_categories_sports1` FOREIGN KEY (`sport_id`) REFERENCES `sports` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `playlists`
--
ALTER TABLE `playlists`
  ADD CONSTRAINT `fk_playlists_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `playlist_points`
--
ALTER TABLE `playlist_points`
  ADD CONSTRAINT `fk_users_has_playlists_playlists1` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_users_has_playlists_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `playlist_video_tags`
--
ALTER TABLE `playlist_video_tags`
  ADD CONSTRAINT `fk_playlists_has_video_tags_playlists1` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_playlists_has_video_tags_video_tags1` FOREIGN KEY (`video_tag_id`) REFERENCES `video_tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `report_errors`
--
ALTER TABLE `report_errors`
  ADD CONSTRAINT `fk_report_errors_error_types1` FOREIGN KEY (`error_type_id`) REFERENCES `error_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_report_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `fk_report_video_tags1` FOREIGN KEY (`video_tag_id`) REFERENCES `video_tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `riders`
--
ALTER TABLE `riders`
  ADD CONSTRAINT `fk_riders_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `social_accounts`
--
ALTER TABLE `social_accounts`
  ADD CONSTRAINT `fk_social_accounts_scoial_providers1` FOREIGN KEY (`social_provider_id`) REFERENCES `social_providers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_social_accounts_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `tags`
--
ALTER TABLE `tags`
  ADD CONSTRAINT `fk_tags_categories1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tags_sports1` FOREIGN KEY (`sport_id`) REFERENCES `sports` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_tags_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Contraintes pour la table `videos`
--
ALTER TABLE `videos`
  ADD CONSTRAINT `fk_videos_sources` FOREIGN KEY (`provider_id`) REFERENCES `video_providers` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_videos_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Contraintes pour la table `video_tags`
--
ALTER TABLE `video_tags`
  ADD CONSTRAINT `fk_users_has_videos_tags1` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_users_has_videos_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `fk_users_has_videos_videos1` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_video_tags_riders1` FOREIGN KEY (`rider_id`) REFERENCES `riders` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Contraintes pour la table `video_tag_accuracy_rates`
--
ALTER TABLE `video_tag_accuracy_rates`
  ADD CONSTRAINT `fk_video_tag_accuracy_rates_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_video_tag_accuracy_rates_video_tags1` FOREIGN KEY (`video_tag_id`) REFERENCES `video_tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `video_tag_points`
--
ALTER TABLE `video_tag_points`
  ADD CONSTRAINT `fk_video_tag_points_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_video_tag_points_video_tags1` FOREIGN KEY (`video_tag_id`) REFERENCES `video_tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
