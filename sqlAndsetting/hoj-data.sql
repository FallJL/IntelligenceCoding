/*
SQLyog Professional v12.09 (64 bit)
MySQL - 5.7.34 : Database - hoj
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`hoj` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `hoj`;

/*Data for the table `auth` */

insert  into `auth`(`id`,`name`,`permission`,`status`,`gmt_create`,`gmt_modified`) values (1,'problem','problem_admin',0,'2020-10-25 00:17:17','2021-05-15 06:51:23'),(2,'submit','submit',0,'2020-10-25 00:17:22','2021-05-15 06:41:59'),(3,'contest','contest_admin',0,'2020-10-25 00:17:33','2021-05-15 06:51:28'),(4,'rejudge','rejudge',0,'2020-10-25 00:17:49','2021-05-15 06:50:55'),(5,'announcement','announcement_admin',0,'2021-05-15 06:54:28','2021-05-15 06:54:31'),(6,'user','user_admin',0,'2021-05-15 06:54:30','2021-05-15 06:55:04'),(7,'system_info','system_info_admin',0,'2021-05-15 06:57:34','2021-05-15 06:57:41'),(8,'dicussion','discussion_add',0,'2021-05-15 06:57:36','2021-05-15 07:50:45'),(9,'dicussion','discussion_del',0,'2021-05-15 07:01:02','2021-05-15 07:51:31'),(10,'dicussion','discussion_edit',0,'2021-05-15 07:02:15','2021-05-15 07:51:34'),(11,'comment','comment_add',0,'2021-05-15 07:03:48','2021-05-15 07:03:48'),(12,'reply','reply_add',0,'2021-05-15 07:04:55','2021-05-15 07:04:55');

/*Data for the table `category` */

insert  into `category`(`id`,`name`,`gmt_create`,`gmt_modified`) values (1,'闲聊','2021-05-06 11:25:24','2021-05-06 16:43:42'),(2,'题解','2021-05-06 11:25:36','2021-05-06 16:43:47'),(3,'求助','2021-05-06 11:25:40','2021-05-06 11:25:40'),(4,'建议','2021-05-06 11:25:56','2021-05-06 11:25:56'),(5,'记录','2021-05-06 11:26:02','2021-05-06 16:43:51');

/*Data for the table `language` */

insert  into `language`(`id`,`content_type`,`description`,`name`,`compile_command`,`template`,`code_template`,`is_spj`,`oj`,`gmt_create`,`gmt_modified`) values (1,'text/x-csrc','GCC 7.5.0','C','/usr/bin/gcc -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c11 {src_path} -lm -o {exe_path}','#include <stdio.h>\r\nint add(int a, int b) {\r\n    return a+b;\r\n}\r\nint main() {\r\n    printf(\"%d\", add(1, 2));    \r\n    return 0;\r\n}','//PREPEND BEGIN\r\n#include <stdio.h>\r\n//PREPEND END\r\n\r\n//TEMPLATE BEGIN\r\nint add(int a, int b) {\r\n  // Please fill this blank\r\n  return ___________;\r\n}\r\n//TEMPLATE END\r\n\r\n//APPEND BEGIN\r\nint main() {\r\n  printf(\"%d\", add(1, 2));\r\n  return 0;\r\n}\r\n//APPEND END',1,'ME','2020-12-12 23:11:44','2021-04-24 11:31:33'),(2,'text/x-c++src','G++ 7.5.0','C++','/usr/bin/g++ -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c++14 {src_path} -lm -o {exe_path}','#include <iostream>\r\nint add(int a, int b) {\r\n    return a+b;\r\n}\r\nint main() {\r\n    std::cout << add(1, 2);\r\n    return 0;\r\n}','//PREPEND BEGIN\r\n#include <iostream>\r\nusing namespace std;\r\n//PREPEND END\r\n\r\n//TEMPLATE BEGIN\r\nint add(int a, int b) {\r\n  // Please fill this blank\r\n  return ___________;\r\n}\r\n//TEMPLATE END\r\n\r\n//APPEND BEGIN\r\nint main() {\r\n  cout << add(1, 2);\r\n  return 0;\r\n}\r\n//APPEND END',1,'ME','2020-12-12 23:12:44','2021-04-24 15:11:21'),(3,'text/x-java','OpenJDK 1.8','Java','/usr/bin/javac {src_path} -d {exe_dir} -encoding UTF8','import java.util.Scanner;\r\npublic class Main{\r\n    public static void main(String[] args){\r\n        Scanner in=new Scanner(System.in);\r\n        int a=in.nextInt();\r\n        int b=in.nextInt();\r\n        System.out.println((a+b));\r\n    }\r\n}','//PREPEND BEGIN\r\nimport java.util.Scanner;\r\n//PREPEND END\r\n\r\npublic class Main{\r\n    //TEMPLATE BEGIN\r\n    public static Integer add(int a,int b){\r\n        return _______;\r\n    }\r\n    //TEMPLATE END\r\n\r\n    //APPEND BEGIN\r\n    public static void main(String[] args){\r\n        System.out.println(add(a,b));\r\n    }\r\n    //APPEND END\r\n}\r\n',0,'ME','2020-12-12 23:12:51','2021-04-24 14:42:13'),(4,'text/x-python','Python 3.7.5','Python3','/usr/bin/python3 -m py_compile {src_path}','a, b = map(int, input().split())\r\nprint(a + b)','//PREPEND BEGIN\r\n//PREPEND END\r\n\r\n//TEMPLATE BEGIN\r\ndef add(a, b):\r\n    return a + b\r\n//TEMPLATE END\r\n\r\n\r\nif __name__ == \'__main__\':  \r\n    //APPEND BEGIN\r\n    a, b = 1, 1\r\n    print(add(a, b))\r\n    //APPEND END',0,'ME','2020-12-12 23:14:23','2021-04-24 14:53:53'),(5,'text/x-python','Python 2.7.17','Python2','/usr/bin/python -m py_compile {src_path}','a, b = map(int, raw_input().split())\r\nprint a+b','//PREPEND BEGIN\r\n//PREPEND END\r\n\r\n//TEMPLATE BEGIN\r\ndef add(a, b):\r\n    return a + b\r\n//TEMPLATE END\r\n\r\n\r\nif __name__ == \'__main__\':  \r\n    //APPEND BEGIN\r\n    a, b = 1, 1\r\n    print add(a, b)\r\n    //APPEND END',0,'ME','2021-01-26 11:11:44','2021-04-24 15:04:32'),(6,'text/x-csrc','GCC','GCC',NULL,NULL,NULL,0,'HDU','2021-02-18 21:32:34','2021-02-18 23:42:56'),(7,'text/x-c++src','G++','G++',NULL,NULL,NULL,0,'HDU','2021-02-18 21:32:58','2021-02-18 21:32:58'),(8,'text/x-c++src','C++','C++',NULL,NULL,NULL,0,'HDU','2021-02-18 21:33:11','2021-02-18 21:33:26'),(9,'text/x-csrc','C','C',NULL,NULL,NULL,0,'HDU','2021-02-18 21:33:41','2021-02-18 21:34:11'),(10,'text/x-pascal','Pascal','Pascal',NULL,NULL,NULL,0,'HDU','2021-02-18 21:34:33','2021-02-19 00:16:35'),(12,'text/x-csrc','GNU GCC C11 5.1.0','GNU GCC C11 5.1.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(13,'text/x-c++src','Clang++17 Diagnostics','Clang++17 Diagnostics',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(14,'text/x-c++src','GNU G++11 5.1.0','GNU G++11 5.1.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(15,'text/x-c++src','GNU G++14 6.4.0','GNU G++14 6.4.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(16,'text/x-c++src','GNU G++17 7.3.0','GNU G++17 7.3.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(17,'text/x-c++src','Microsoft Visual C++ 2010','Microsoft Visual C++ 2010',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(18,'text/x-c++src','Microsoft Visual C++ 2017','Microsoft Visual C++ 2017',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(19,'text/x-csharp','C# Mono 6.8','C# Mono 6.8',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:11:24'),(20,'text/x-d','D DMD32 v2.091.0','D DMD32 v2.091.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:11:15'),(21,'text/x-go','Go 1.15.6','Go 1.15.6',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:11:07'),(22,'text/x-haskell','Haskell GHC 8.10.1','Haskell GHC 8.10.1',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:58'),(23,'text/x-java','Java 1.8.0_241','Java 1.8.0_241',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:52'),(24,'text/x-java','Kotlin 1.4.0','Kotlin 1.4.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:45'),(25,'text/x-ocaml','OCaml 4.02.1','OCaml 4.02.1',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(26,'text/x-pascal','Delphi 7','Delphi 7',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(27,'text/x-pascal','Free Pascal 3.0.2','Free Pascal 3.0.2',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(28,'text/x-pascal','PascalABC.NET 3.4.2','PascalABC.NET 3.4.2',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(29,'text/x-perl','Perl 5.20.1','Perl 5.20.1',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(30,'text/x-php','PHP 7.2.13','PHP 7.2.13',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(31,'text/x-python','Python 2.7.18','Python 2.7.18',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:11'),(32,'text/x-python','Python 3.9.1','Python 3.9.1',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:09'),(33,'text/x-python','PyPy 2.7 (7.3.0)','PyPy 2.7 (7.3.0)',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:08'),(34,'text/x-python','PyPy 3.7 (7.3.0)','PyPy 3.7 (7.3.0)',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:06'),(35,'text/x-ruby','Ruby 3.0.0','Ruby 3.0.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:04'),(36,'text/x-rustsrc','Rust 1.49.0','Rust 1.49.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:10:02'),(37,'text/x-scala','Scala 2.12.8','Scala 2.12.8',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(38,'text/javascript','JavaScript V8 4.8.0','JavaScript V8 4.8.0',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-03 19:46:24'),(39,'text/javascript','Node.js 12.6.3','Node.js 12.6.3',NULL,NULL,NULL,0,'CF','2021-03-03 19:46:24','2021-03-25 21:09:56'),(40,'text/x-csharp','C# 8, .NET Core 3.1','C# 8, .NET Core 3.1',NULL,NULL,NULL,0,'CF','2021-03-25 21:17:39','2021-03-25 21:17:50'),(41,'text/x-java','Java 11.0.6','Java 11.0.6',NULL,NULL,NULL,0,'CF','2021-03-25 21:20:03','2021-03-25 21:20:08'),(42,'text/x-go','Golang 1.16','Golang','/usr/bin/go build -o {exe_path} {src_path}','package main\r\nimport \"fmt\"\r\n\r\nfunc main(){\r\n    var x int\r\n    var y int\r\n    fmt.Scanln(&x,&y)\r\n    fmt.Printf(\"%d\",x+y)  \r\n}\r\n','\r\npackage main\r\n\r\n//PREPEND BEGIN\r\nimport \"fmt\"\r\n//PREPEND END\r\n\r\n\r\n//TEMPLATE BEGIN\r\nfunc add(a,b int)int{\r\n    return ______\r\n}\r\n//TEMPLATE END\r\n\r\n//APPEND BEGIN\r\nfunc main(){\r\n    var x int\r\n    var y int\r\n    fmt.Printf(\"%d\",add(x,y))  \r\n}\r\n//APPEND END\r\n',0,'ME','2021-03-28 23:15:54','2021-04-24 15:00:50'),(43,'text/x-csharp','C# Mono 4.6.2','C#','/usr/bin/mcs -optimize+ -out:{exe_path} {src_path}','using System;\r\nusing System.Collections.Generic;\r\nusing System.Text;\r\nclass Solution\r\n{\r\n   static void Main(string[] args)\r\n   {\r\n       int a = int.Parse(Console.ReadLine());\r\n       int b = int.Parse(Console.ReadLine());\r\n       Console.WriteLine(a+b);\r\n   }\r\n}','//PREPEND BEGIN\r\nusing System;\r\nusing System.Collections.Generic;\r\nusing System.Text;\r\n//PREPEND END\r\n\r\nclass Solution\r\n{\r\n    //TEMPLATE BEGIN\r\n    static int add(int a,int b){\r\n        return _______;\r\n    }\r\n    //TEMPLATE END\r\n\r\n    //APPEND BEGIN\r\n    static void Main(string[] args)\r\n    {\r\n        int a ;\r\n        int b ;\r\n        Console.WriteLine(add(a,b));\r\n    }\r\n    //APPEND END\r\n}',0,'ME','2021-04-13 16:10:03','2021-04-24 16:24:02');

/*Data for the table `role` */

insert  into `role`(`id`,`role`,`description`,`status`,`gmt_create`,`gmt_modified`) values (00000000000000001000,'root','超级管理员',0,'2020-10-25 00:16:30','2020-10-25 00:16:30'),(00000000000000001001,'admin','管理员',0,'2020-10-25 00:16:41','2020-10-25 00:16:41'),(00000000000000001002,'default_user','默认用户',0,'2020-10-25 00:16:52','2021-05-15 07:39:05'),(00000000000000001003,'no_subimit_user','禁止提交用户',0,'2021-05-15 07:10:14','2021-05-15 07:39:14'),(00000000000000001004,'no_discuss_user','禁止发贴讨论用户',0,'2021-05-15 07:11:28','2021-05-15 07:39:16'),(00000000000000001005,'mute_user','禁言包括回复讨论发帖用户',0,'2021-05-15 07:12:51','2021-05-15 07:39:19'),(00000000000000001006,'no_submit_no_discuss_user','禁止提交同时禁止发帖用户',0,'2021-05-15 07:38:08','2021-05-15 07:39:34'),(00000000000000001007,'no_submit_mute_user','禁言禁提交用户',0,'2021-05-15 07:39:00','2021-05-15 07:39:26');

/*Data for the table `role_auth` */

insert  into `role_auth`(`id`,`auth_id`,`role_id`,`gmt_create`,`gmt_modified`) values (1,1,1000,'2020-10-25 00:18:17','2020-10-25 00:18:17'),(2,2,1000,'2020-10-25 00:18:38','2021-05-15 07:17:35'),(3,3,1000,'2020-10-25 00:18:48','2021-05-15 07:17:44'),(4,4,1000,'2021-05-15 07:17:56','2021-05-15 07:17:56'),(5,5,1000,'2021-05-15 07:18:20','2021-05-15 07:18:20'),(6,6,1000,'2021-05-15 07:18:29','2021-05-15 07:18:29'),(7,7,1000,'2021-05-15 07:18:42','2021-05-15 07:18:42'),(8,8,1000,'2021-05-15 07:18:59','2021-05-15 07:18:59'),(9,9,1000,'2021-05-15 07:19:07','2021-05-15 07:19:07'),(10,10,1000,'2021-05-15 07:19:10','2021-05-15 07:19:10'),(11,11,1000,'2021-05-15 07:19:13','2021-05-15 07:19:13'),(12,12,1000,'2021-05-15 07:19:18','2021-05-15 07:19:30'),(13,1,1001,'2021-05-15 07:19:29','2021-05-15 07:20:02'),(14,2,1001,'2021-05-15 07:20:25','2021-05-15 07:20:25'),(15,3,1001,'2021-05-15 07:20:33','2021-05-15 07:20:33'),(16,8,1001,'2021-05-15 07:21:56','2021-05-15 07:21:56'),(17,9,1001,'2021-05-15 07:22:03','2021-05-15 07:22:03'),(18,10,1001,'2021-05-15 07:22:10','2021-05-15 07:22:10'),(19,11,1001,'2021-05-15 07:22:17','2021-05-15 07:22:17'),(20,12,1001,'2021-05-15 07:22:21','2021-05-15 07:22:21'),(21,2,1002,'2021-05-15 07:22:40','2021-05-15 07:22:40'),(22,8,1002,'2021-05-15 07:23:49','2021-05-15 07:23:49'),(23,9,1002,'2021-05-15 07:24:10','2021-05-15 07:24:10'),(24,10,1002,'2021-05-15 07:24:14','2021-05-15 07:24:14'),(25,11,1002,'2021-05-15 07:24:19','2021-05-15 07:24:19'),(26,12,1002,'2021-05-15 07:24:23','2021-05-15 07:24:23'),(27,8,1003,'2021-05-15 07:32:56','2021-05-15 07:32:56'),(28,9,1003,'2021-05-15 07:33:01','2021-05-15 07:33:01'),(29,10,1003,'2021-05-15 07:33:05','2021-05-15 07:33:05'),(30,11,1003,'2021-05-15 07:33:09','2021-05-15 07:33:09'),(31,12,1003,'2021-05-15 07:33:22','2021-05-15 07:33:22'),(32,2,1004,'2021-05-15 07:33:38','2021-05-15 07:33:38'),(33,9,1004,'2021-05-15 07:34:27','2021-05-15 07:34:27'),(34,10,1004,'2021-05-15 07:34:31','2021-05-15 07:34:31'),(35,11,1004,'2021-05-15 07:34:42','2021-05-15 07:34:42'),(36,12,1004,'2021-05-15 07:34:47','2021-05-15 07:34:47'),(37,2,1005,'2021-05-15 07:35:11','2021-05-15 07:35:11'),(38,9,1005,'2021-05-15 07:35:46','2021-05-15 07:35:46'),(39,10,1005,'2021-05-15 07:36:01','2021-05-15 07:36:01'),(40,9,1006,'2021-05-15 07:40:09','2021-05-15 07:40:09'),(41,10,1006,'2021-05-15 07:40:16','2021-05-15 07:40:16'),(42,11,1006,'2021-05-15 07:40:30','2021-05-15 07:40:30'),(43,12,1006,'2021-05-15 07:40:37','2021-05-15 07:40:37'),(44,9,1007,'2021-05-15 07:40:54','2021-05-15 07:40:54'),(45,10,1007,'2021-05-15 07:41:04','2021-05-15 07:41:04');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
