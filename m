From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Successful RAID 6 setup
Date: Fri, 6 Nov 2009 14:22:54 -0700
Message-ID: <200911061422.54454.tfjellstrom@shaw.ca>
References: <4AF1C20C.4090902@gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF1C20C.4090902@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed November 4 2009, Andrew Dunn wrote:
> I sent this a couple days ago, wondering if it fell through the cracks or
>  if I am asking the wrong questions.
> 
> ------
> 
> I will preface this by saying I only need about 100MB/s out of my array
> because I access it via a gigabit crossover cable.
> 
> I am backing up all of my information right now (~4TB) with the
> intention of re-creating this array with a larger chunk size and
> possibly tweaking the file system a little bit.
> 
> My original array was a raid6 of 9 WD caviar black drives, the chunk
> size was 64k. I use USAS-AOC-L8i controllers to address all of my drives
> and the TLER setting on the drives is enabled for 7 seconds.
> 
> storrgie@ALEXANDRIA:~$ sudo mdadm -D /dev/md0
> /dev/md0:
>         Version : 00.90
>   Creation Time : Wed Oct 14 19:59:46 2009
>      Raid Level : raid6
>      Array Size : 6837319552 (6520.58 GiB 7001.42 GB)
>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>    Raid Devices : 9
>   Total Devices : 9
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Mon Nov  2 16:58:43 2009
>           State : active
>  Active Devices : 9
> Working Devices : 9
>  Failed Devices : 0
>   Spare Devices : 0
> 
>      Chunk Size : 64K
> 
>            UUID : 53dadda1:c58785d5:613e2239:070da8c8 (local to host
> ALEXANDRIA)
>          Events : 0.649527
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       65        0      active sync   /dev/sde1
>        1       8       81        1      active sync   /dev/sdf1
>        2       8       97        2      active sync   /dev/sdg1
>        3       8      113        3      active sync   /dev/sdh1
>        4       8      129        4      active sync   /dev/sdi1
>        5       8      145        5      active sync   /dev/sdj1
>        6       8      161        6      active sync   /dev/sdk1
>        7       8      177        7      active sync   /dev/sdl1
>        8       8      193        8      active sync   /dev/sdm1
> 
> I have noticed slow rebuilding time when I first created the array and
> intermittent lockups while writing large data sets.
> 
> Per some reading I was thinking of adjusting my chunk size to 1024k, and
> trying to figure out the weird stuff required when creating a file
>  system.
> 
> Questions:
> 
> Should I have the TLER on my drives enabled? (WDTLER, seven seconds)

I've heard people claim that TLER is really only useful for a hardware raid 
card. The card itself can manage the failing sector a lot faster than the 
drives. With Software raid, you might as well let the drive try its best, or 
md will want to fail the drive (I'm not sure how hard it tries to recover a 
sector that has previously returned an error).

> Is 1024k chunk size going to be a good choice for my purposes? (I store
> use this for storage of files that are 4MiB to 16GiB)
> 
> Is ext4 the ideal file system for my purposes?
> 
> Should I be investigating into the file system stripe size and chunk
> size or let mkfs choose these for me? If I need to, please be kind to
> point me in a good direction as I am new to this lower level file system
> stuff.
> 
> Can I change the properties of my file system in place (ext4 or other)
> so that I can tweak the stripe size when I add more drives and grow the
> array?
> 
> Should I be asking any other questions?
> 
> Thanks a ton, this is the first mailing list I have ever subscribed, I
> am really excited to see what you all say.
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
