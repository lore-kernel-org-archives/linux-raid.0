From: raid@ddx.a2000.nu
Subject: Is Read speed faster when 1 disk is failed on raid5 ?
Date: Thu, 17 Oct 2002 10:19:54 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210171017280.17905-100000@ddx.a2000.nu>
References: <Pine.LNX.4.44.0210102315200.21922-100000@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0210102315200.21922-100000@ddx.a2000.nu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

1 disk is failed (just for test)
then i did an benchmark
write is the same, but read is almost twice the speed
why is this ?

Version 1.02c       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
storagenew.a2000 1G 18671  99 80063  77 31862  38 23361  99 149929  83
372.6   2
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
                 16  1898  94 +++++ +++ +++++ +++  1962  99 +++++ +++
5210  97
storagenew.a2000.nu,1G,18671,99,80063,77,31862,38,23361,99,149929,83,372.6,2,16,1898,94,+++++,+++,+++++,+++,1962,99,+++++,+++,5210,97

On Thu, 10 Oct 2002 raid@ddx.a2000.nu wrote:

> Ok did a benchmark between software raid en hw raid
> controller 3ware 7850 (7500-8 now?) with 5 * WDC 120GB 7200RPM (2mb cache)
> On xeon dual 2GHZ (controller in 64bits pci)
>
> results :
>
> ---raid5 5*120gb sw raid :
>
> Version 1.02c       ------Sequential Output------ --Sequential Input-
> --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
> /sec %CP
> storagenew.a2000 1G 18850  99 78959  77 29982  29 24052  99 81547  22
> 510.5   2
>                     ------Sequential Create------ --------Random
> Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read---
> -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
> /sec %CP
>                  16  1933  97 +++++ +++ +++++ +++  1986  98 +++++ +++
> 5056  98
> storagenew.a2000.nu,1G,18850,99,78959,77,29982,29,24052,99,81547,22,510.5,2,16,1933,97,+++++,+++,+++++,+++,1986,98,+++++,+++,5056,98
>
>

