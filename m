From: Stephan van Hienen <raid@a2000.nu>
Subject: raid5 slow
Date: Mon, 29 Nov 2004 09:51:58 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411290948230.13437@adsl.a2000.nu>
References: <200411290449.iAT4nsN02715@www.watkins-home.com>
 <Pine.LNX.4.61.0411290928430.13437@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0411290928430.13437@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> it's only a bit slow :
>
> Version  1.03       ------Sequential Output------ --Sequential Input- 
> --Random-
>                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP /sec 
> %CP
> storage.a2000.nu 2G 26828  99 123983  73 58525  57 27336  99 171371  96 583.9 
> 4
>                    ------Sequential Create------ --------Random 
> Create--------
>                    -Create-- --Read--- -Delete-- -Create-- --Read--- 
> -Delete--
>              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP /sec 
> %CP
>                 16  1023  12 +++++ +++   920  11  1004  14 +++++ +++ 722   9
> storage.a2000.nu,2G,26828,99,123983,73,58525,57,27336,99,171371,96,583.9,4,16,1023,12,+++++,+++,920,11,1004,14,+++++,+++,722,9

created a raid0 with the same disks :

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
storage.a2000.nu 2G 28435  99 219329  73 102949  51 29704  99 275323  62 
639.5   2
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16 10108  84 +++++ +++  8825  69  9877  88 +++++ +++ 
7546  66
storage.a2000.nu,2G,28435,99,219329,73,102949,51,29704,99,275323,62,639.5,2,16,10108,84,+++++,+++,8825,69,9877,88,+++++,+++,7546,66


shouldn't the raid be about the same ?

now i get 275MB/sec with raid0 (14 disks)
171MB/sec with raid5 (14 disks)

while the old raid5 situation was 257MB/sec with raid5 (13 disks)
