From: raid@ddx.a2000.nu
Subject: RE: 3ware 7500-12, bad write speed
Date: Sat, 12 Oct 2002 00:03:26 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210120001500.29225-100000@ddx.a2000.nu>
References: <A1964EDB64C8094DA12D2271C04B812672C771@tabby>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A1964EDB64C8094DA12D2271C04B812672C771@tabby>
To: Adam Radford <aradford@3WARE.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Adam,

results after changing these settings
read is faster, but write is still half sw raid speed


Version 1.02c       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
storagenew.a2000 1G 18240  90 30134  22 12535   6 24634  98 82337  16
468.0   1
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
                 16  1926  95 +++++ +++ +++++ +++  1960  97 +++++ +++
5627  99
storagenew.a2000.nu,1G,18240,90,30134,22,12535,6,24634,98,82337,16,468.0,1,16,1926,95,+++++,+++,+++++,+++,1960,97,+++++,+++,5627,99


On Thu, 10 Oct 2002, Adam Radford wrote:

> Can you run the following commands, then re-run your 3ware benchmark and see
> if the results change?
>
> echo "60" > /proc/sys/vm/bdflush
> echo "512" > /proc/sys/vm/max-readahead
> echo "256" > /proc/sys/vm/min-readahead
>
> -Adam
>
> -----Original Message-----
> From: raid@ddx.a2000.nu [mailto:raid@ddx.a2000.nu]
> Sent: Thursday, October 10, 2002 2:18 PM
> To: linux-raid@vger.kernel.org
> Subject: Re: 3ware 7500-12, bad write speed
>
>
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
> storagenew.a2000.nu,1G,18850,99,78959,77,29982,29,24052,99,81547,22,510.5,2,
> 16,1933,97,+++++,+++,+++++,+++,1986,98,+++++,+++,5056,98
>
>
> ---raid5 5*120gb hw raid :
>
> Version 1.02c       ------Sequential Output------ --Sequential Input-
> --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
> /sec %CP
> storagenew.a2000 1G 17100  85 32250  23 12053   5 22660  91 49603  10
> 466.9   1
>                     ------Sequential Create------ --------Random
> Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read---
> -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
> /sec %CP
>                  16  1872  93 +++++ +++ +++++ +++  1976  98 +++++ +++
> 5677 100
> storagenew.a2000.nu,1G,17100,85,32250,23,12053,5,22660,91,49603,10,466.9,1,1
> 6,1872,93,+++++,+++,+++++,+++,1976,98,+++++,+++,5677,100
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


