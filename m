From: Stephan van Hienen <raid@a2000.nu>
Subject: RE: raid5 code ok with 2TB + ?
Date: Mon, 29 Nov 2004 09:33:00 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411290928430.13437@adsl.a2000.nu>
References: <200411290449.iAT4nsN02715@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411290449.iAT4nsN02715@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 28 Nov 2004, Guy wrote:

> I use dd to test disks, and arrays.  Give this a test.  It may stop at the
> 2TB limit, not sure.  My monster 14 disk array is only about 240G.
>
> time dd if=/dev/md0 of=/dev/null bs=1024k
>

]# dd if=/dev/zero of=testfile bs=8192
dd: writing `testfile': No space left on device
285696059+0 records in
285696058+0 records out

du doesn't undestand the size :

]# du -h
132G    .

ls understands a bit (total is incorrect, but filesize is ok) :

]# ls -la
total 138084832
drwxr-xr-x   21 root     root         4096 Nov 29 01:40 ..
drwxr-xr-x    2 root     root           21 Nov 29 02:07 .
-rw-r--r--    1 root     root     2340422111232 Nov 29 07:39 testfile

]# ls -al -h
total 132G
drwxr-xr-x    2 root     root           21 Nov 29 02:07 .
drwxr-xr-x   21 root     root         4.0K Nov 29 01:40 ..
-rw-r--r--    1 root     root         2.1T Nov 29 07:39 testfile

no errors in dmesg so looks like it's ok
it's only a bit slow :

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
storage.a2000.nu 2G 26828  99 123983  73 58525  57 27336  99 171371  96 
583.9   4
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16  1023  12 +++++ +++   920  11  1004  14 +++++ +++ 
722   9
storage.a2000.nu,2G,26828,99,123983,73,58525,57,27336,99,171371,96,583.9,4,16,1023,12,+++++,+++,920,11,1004,14,+++++,+++,722,9


compared to the old raid5 with 13 disk (with redhat 8 and kernel 2.4) :

met 13 disken : (rh 8 ext3)

Version 1.02c       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
storage.a2000.nu 1G 17775 100 100912  99 70290  66 23648  99 257029  81 
624.1   3
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16  1944  99 +++++ +++ +++++ +++  2042  98 +++++ +++ 
5689  97
storage.a2000.nu,1G,17775,100,100912,99,70290,66,23648,99,257029,81,
624.1,3,16,1944,99,+++++,+++,+++++,+++,2042,98,+++++,+++,5689,97


