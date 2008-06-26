From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Slowww raid check (raid10, f2)
Date: Thu, 26 Jun 2008 09:24:33 -0500
Message-ID: <4863A6A1.3010408@gmail.com>
References: <cccedfc60806260621ud3af517j959f5ce3c2e521ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60806260621ud3af517j959f5ce3c2e521ef@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jon Nelson wrote:
> A few months back, I converted my raid setup from raid5 to raid10,f2,
> using the same disks and setup as before.
> The setup is an AMD x86-64, 3600+ dual, making use of three 300 GB SATA disks:
> 
> The current raid looks like this:
> 
> md0 : active raid10 sdb4[0] sdc4[2] sdd4[1]
>       460057152 blocks 64K chunks 2 far-copies [3/3] [UUU]
>       bitmap: 1/439 pages [4KB], 512KB chunk, file: /md0.bitmap
> 
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Fri May 23 23:24:20 2008
>      Raid Level : raid10
>      Array Size : 460057152 (438.74 GiB 471.10 GB)
>   Used Dev Size : 306704768 (292.50 GiB 314.07 GB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>   Intent Bitmap : /md0.bitmap
> 
>     Update Time : Thu Jun 26 08:16:52 2008
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : near=1, far=2
>      Chunk Size : 64K
> 
>            UUID : ff4e969d:2f07be4e:8c61e068:8406cdc0
>          Events : 0.1670
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       20        0      active sync   /dev/sdb4
>        1       8       52        1      active sync   /dev/sdd4
>        2       8       36        2      active sync   /dev/sdc4
> 
> As you can see, it's comprised of 3x 292 MiB partitions (the other
> partitions are unused or used for /boot, so no run-time I/O).
> 
> Individually, the disks are capable of some 70 MB/s (give or take).
> The raid5 would take 2.5 hours to run a "check".
> The raid10,f2 takes substantially longer:
> 
> Jun 23 02:30:01 turnip kernel: md: data-check of RAID array md0
> Jun 23 07:17:46 turnip kernel: md: md0: data-check done.
> 
> Whaaa? 4.75 hours? That's 28MB/s end-to-end. That's about 40% of
> actual disk speed. I expected it to be slower but not /that/ much
> slower. What might be going on here?
> 

What kind of controller are you using, and how is it connected to the MB?

If it is a PCI (non-e, non-X) those numbers are about right.

If it is on the MB but still wired in with a PCI 32-bit/33mhz slot that is also 
about right.

If it is either PCI-X, PCI-e, or wired into the MB with a proper connection then 
this would be low.

The ones on the MB can be connected almost any way, I have seen nice fast 
connections and I have seen ones connected with standard PCI on the MB.

Do a test of "dd if=/dev/sdb4 of=/dev/null bs=64k" on 1 then 2 and the 3 disks 
while watching "vmstat 1" and see how it scales.

                            Roger
