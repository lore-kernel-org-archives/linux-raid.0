From: raid@ddx.a2000.nu
Subject: Re: 3ware 7500-12, bad write speed
Date: Thu, 10 Oct 2002 23:18:00 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210102315200.21922-100000@ddx.a2000.nu>
References: <5.1.0.14.2.20020925222027.03eb9710@mail.harddata.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.2.20020925222027.03eb9710@mail.harddata.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok did a benchmark between software raid en hw raid
controller 3ware 7850 (7500-8 now?) with 5 * WDC 120GB 7200RPM (2mb cache)
On xeon dual 2GHZ (controller in 64bits pci)

results :

---raid5 5*120gb sw raid :

Version 1.02c       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
storagenew.a2000 1G 18850  99 78959  77 29982  29 24052  99 81547  22
510.5   2
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
                 16  1933  97 +++++ +++ +++++ +++  1986  98 +++++ +++
5056  98
storagenew.a2000.nu,1G,18850,99,78959,77,29982,29,24052,99,81547,22,510.5,2,16,1933,97,+++++,+++,+++++,+++,1986,98,+++++,+++,5056,98


---raid5 5*120gb hw raid :

Version 1.02c       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
storagenew.a2000 1G 17100  85 32250  23 12053   5 22660  91 49603  10
466.9   1
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
                 16  1872  93 +++++ +++ +++++ +++  1976  98 +++++ +++
5677 100
storagenew.a2000.nu,1G,17100,85,32250,23,12053,5,22660,91,49603,10,466.9,1,16,1872,93,+++++,+++,+++++,+++,1976,98,+++++,+++,5677,100


