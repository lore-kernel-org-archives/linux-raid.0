From: raid@ddx.a2000.nu
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?
Date: Thu, 17 Oct 2002 13:52:44 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210171349420.18584-100000@ddx.a2000.nu>
References: <Pine.LNX.4.44.0210171017280.17905-100000@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0210171017280.17905-100000@ddx.a2000.nu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

did the same test with 4 disks in raid5

4 disks raid5 synced :

Version 1.02c       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
storagenew.a2000 1G 18654  99 64992  63 24127  25 23504  97 57140  17
480.7   2
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
                 16  1915  96 +++++ +++ +++++ +++  2002  98 +++++ +++
5422  98
storagenew.a2000.nu,1G,18654,99,64992,63,24127,25,23504,97,57140,17,480.7,2,16,1915,96,+++++,+++,+++++,+++,2002,98,+++++,+++,5422,98


raid5 4disks, 1 failed :

Version 1.02c       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
storagenew.a2000 1G 18566  99 58434  57 27743  35 23089  98 119752  56
332.1   1
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
                 16  1942  97 +++++ +++ +++++ +++  1978  99 +++++ +++
5585  99
storagenew.a2000.nu,1G,18566,99,58434,57,27743,35,23089,98,119752,56,332.1,1,16,1942,97,+++++,+++,+++++,+++,1978,99,+++++,+++,5585,99

