From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: large devices (3ware) - thanx for the info
Date: Wed, 21 Aug 2002 17:16:13 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <CDF05CB9FCA0C845B9778F9E463C476101FC69@cinshrexc01.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Class: urn:content-classes:message
To: Alvin Oga <aoga@Maggie.Linux-Consulting.com>, Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Just as an FYI on the PCI bus, we found out from some testing that a
64-bit, 66MHz PCI bus can be the bottleneck while driving two LTO
Ultrium tape devices, so the PCI bus could definitely be a bottleneck
for fast hard disks (I don't know about ATA100/133 IDE, but with that
many disks, probably).  

The next step up would be PCI-X which (I believe) is currently running
at 133MHz and provides burst transfer rates at up to 1GB/s
(GigaByte/sec) .

Regards,
Andy.

-----Original Message-----
From: Alvin Oga [mailto:aoga@Maggie.Linux-Consulting.com] 
Sent: Wednesday, August 21, 2002 5:07 PM
To: Maurice Hilarius
Cc: linux-raid@vger.kernel.org
Subject: Re: large devices (3ware) - thanx for the info



hi ya maurice

yes... thankx for the benchmark numbers ...

good that the pci buss is the bottle neck for the disk io transfers
( which would than have one  wonder if the 64bit pic buss
( or the so-called 533FSB is any better 

and yes... the file sizes does affect overall transfer speeds etc

thanx
alvin

and nope... we only use 1U chassis... so we're stuck with one pci card
using the normal off-the-shelf atx stuff

On Wed, 21 Aug 2002, Maurice Hilarius wrote:

> With regards to your message at 01:53 PM 8/21/02, Alvin Oga. Where you
stated:
> >3ware has a 8-port ide card ... for 8 master ide disks but its
> >still on one pci buss ( i think thats the bottle neck )
> And a 12 port card too.
> 
> >if you have 12, 26 ide disks... you'd need a 2nd pci slot...but again
> >on the one pci buss...
> We do this all the time. 2 of the cards. One array.
> 
> >i think it'd be better to put one ide controller ( like the 3-ware )
> >into one motherboard... and use a different server for the next 8
disks
> Don't need it.
> Bottleneck is that the card is 64 bit, but only 33MHz.
> It's throughput maxes around 160MB/sec.
> This is a limitation of the PCI at 64/33
> 
> 
> >-- am looking for benchmarks of 8-24-48 hard disks systems
> 
> Here is for 2 x 8 port cards, 16 x Maxtor 160GB.
> RAID5, on a Tyan S2460 AthlonMP board with a single Duron CPU.
> Cards in JBOD mode, using Linux software RAID.
> 
> Version 1.02a       ------Sequential Output------ --Sequential Input-
--Random-
>                      -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--

> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
> raiddawg         4G 17752  89 78709  44 55648  32 20109  98 162752  67

> 224.3   1
>                      ------Sequential Create------ --------Random 
> Create--------
>                      -Create-- --Read--- -Delete-- -Create-- --Read---

> -Delete--
>                files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
> %CP  /sec %CP
>                   16  1240  99 +++++ +++ +++++ +++  1284  99 +++++ 
> +++  3581  99
>
raiddawg,4G,17752,89,78709,44,55648,32,20109,98,162752,67,224.3,1,16,124
0,99,+++++,+++,+++++,+++,1284,99,+++++,+++,3581,99
> 
> With a faster CPU the writes go up higher, typically up to 90MB/sec.
> Reads still max around 160MB/sec.
> With a single card and 8 drives we get the same type of numbers.
> With 2 of the 12 port cards and 24 disks we still get the same
numbers.
> 
> Note these tests use 4GB file size.
> If you use some smaller size you can get higher figures, but is
essentially 
> bullshit, as these are then influenced by Linux cacheing, drive
caches, etc..
> 
> 
> With our best regards,
> 
> Maurice W. Hilarius       Telephone: 01-780-456-9771
> Hard Data Ltd.               FAX:       01-780-456-9772
> 11060 - 166 Avenue        mailto:maurice@harddata.com
> Edmonton, AB, Canada      http://www.harddata.com/
>     T5X 1Y3
> 
> 2.3TB RAID5 NAS server - dual AthlonMP CPU, Linux, $10,995 CAD / $6850
USD
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
