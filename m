From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: raid5 slow
Date: Wed, 1 Dec 2004 00:39:11 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412010029020.31657@adsl.a2000.nu>
References: <200411290449.iAT4nsN02715@www.watkins-home.com>
 <Pine.LNX.4.61.0411290928430.13437@adsl.a2000.nu>
 <Pine.LNX.4.61.0411290948230.13437@adsl.a2000.nu> <16811.48945.141392.294625@cse.unsw.edu.au>
 <Pine.LNX.4.61.0411300146360.32052@adsl.a2000.nu>
 <Pine.LNX.4.61.0411302034160.24563@adsl.a2000.nu> <16813.418.770001.453039@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16813.418.770001.453039@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I haven't managed to duplicate the degree of slowdown that you report
> - I only get about 10%.
>
> However I found an old Email which also reported slow raid5 in 2.6 and
> it noted that when the array is degraded, it goes faster ....
>
> I just tried it and got most of the speed back when the array is
> degraded!!!
> Would you be able to test that option?

2 tests :
(kernel 2.6.10-rc2 13d r5 ext2)

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
storage.a2000.nu 2G 25238  99 116958  98 67987  73 25702  91 142010  70 
608.2   3
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16  1354  78 +++++ +++ +++++ +++  1262  74 +++++ +++ 
4895  95
storage.a2000.nu,2G,25238,99,116958,98,67987,73,25702,91,142010,70,608.2,3,16,1354,78,+++++,+++,+++++,+++,1262,74,+++++,+++,4895,95

]# mdadm --manage --fail /dev/md0 /dev/sdn1
mdadm: set /dev/sdn1 faulty in /dev/md0
]# mdadm --manage --remove /dev/md0 /dev/sdn1
mdadm: hot removed /dev/sdn1

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
storage.a2000.nu 2G 25458  99 107295  83 59079  60 26079  93 145775  77 
490.2   3
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16  1423  83 +++++ +++ +++++ +++  1453  82 +++++ +++ 
4872 100
storage.a2000.nu,2G,25458,99,107295,83,59079,60,26079,93,145775,77,490.2,3,16,1423,83,+++++,+++,+++++,+++,1453,82,+++++,+++,4872,100

