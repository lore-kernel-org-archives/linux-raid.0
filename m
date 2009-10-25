From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Used Dev Size is wrong
Date: Sun, 25 Oct 2009 11:20:28 -0600
Message-ID: <200910251120.28318.tfjellstrom@shaw.ca>
References: <4AE4832F.7010602@bartk.us>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE4832F.7010602@bartk.us>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Kus <me@bartk.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun October 25 2009, you wrote:
> Hello RAID gurus,
> 
> I recently upgraded my MD 10x1TB RAID6 to a 10x2TB RAID6.  I did this by
> replacing all the 1TB drives in the array with 2TB drives, no more than
> 2 at a time, and letting the array rebuild to assimilate the fresh
> drive(s).  The array finished its last rebuild and showed an Array Size
> of 8000GB, and a Used Dev Size of 2000GB.  Since this isn't the 16TB I
> was looking for, I went through a grow operation:
> 
> # mdadm /dev/md4 -G -z max
> 
> This started a resync @ 50% complete and continued from there.  This had
> the expected effect of increasing the reported Array Size to 16000GB,
> but it also unexpectedly increased the Used Dev Size to 4000GB!  I'm
> worried this incorrect size will lead to errors down the road.  What can
> I do to correct this?  Here are the details of the case:
> 
> jo dev # cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md4 : active raid6 sdl1[13] sdj1[19] sdg1[18] sdd1[17] sdf1[16] sdc1[15]
> sdi1[14] sde1[12] sdk1[11] sdh1[10]
>       15628094464 blocks super 1.2 level 6, 64k chunk, algorithm 2
> [10/10] [UUUUUUUUUU]
>       [===========>.........]  resync = 55.6% (1087519792/1953511808)
> finish=342.1min speed=42184K/sec
> 
> # mdadm --detail /dev/md4
> /dev/md4:
>         Version : 1.02
>   Creation Time : Sun Aug 10 23:41:49 2008
>      Raid Level : raid6
>      Array Size : 15628094464 (14904.11 GiB 16003.17 GB)
>   Used Dev Size : 3907023616 (3726.03 GiB 4000.79 GB)

This looks a little odd though, I can't imagine why it thinks your disks are 
4TB :o

mine: (new array)

     Array Size : 3907049472 (3726.05 GiB 4000.82 GB)
  Used Dev Size : 976762368 (931.51 GiB 1000.20 GB)


>    Raid Devices : 10
>   Total Devices : 10
> Preferred Minor : 4
>     Persistence : Superblock is persistent
> 
>     Update Time : Sun Oct 25 09:07:29 2009
>           State : active, resyncing
>  Active Devices : 10
> Working Devices : 10
>  Failed Devices : 0
>   Spare Devices : 0
> 
>      Chunk Size : 64K
> 
>  Rebuild Status : 55% complete
> 
>            Name : 4
>            UUID : da14eb85:00658f24:80f7a070:b9026515
>          Events : 2901293
> 
>     Number   Major   Minor   RaidDevice State
>       15       8       33        0      active sync   /dev/sdc1
>       14       8      129        1      active sync   /dev/sdi1
>       12       8       65        2      active sync   /dev/sde1
>       16       8       81        3      active sync   /dev/sdf1
>       17       8       49        4      active sync   /dev/sdd1
>       18       8       97        5      active sync   /dev/sdg1
>       10       8      113        6      active sync   /dev/sdh1
>       19       8      145        7      active sync   /dev/sdj1
>       11       8      161        8      active sync   /dev/sdk1
>       13       8      177        9      active sync   /dev/sdl1
> 
> # uname -a
> Linux jo.bartk.us 2.6.29-gentoo-r5 #1 SMP Fri Jun 19 23:04:52 PDT 2009
> x86_64 Intel(R) Pentium(R) D CPU 2.80GHz GenuineIntel GNU/Linux
> 
> # mdadm --examine /dev/sdc1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : da14eb85:00658f24:80f7a070:b9026515
>            Name : 4
>   Creation Time : Sun Aug 10 23:41:49 2008
>      Raid Level : raid6
>    Raid Devices : 10
> 
>  Avail Dev Size : 3907023730 (1863.01 GiB 2000.40 GB)
>      Array Size : 31256188928 (14904.11 GiB 16003.17 GB)
>   Used Dev Size : 3907023616 (1863.01 GiB 2000.40 GB)

I don't see anything particularly wrong about that:

mine shows: (old array)

  Used Dev Size : 625129216 (596.17 GiB 640.13 GB)
     Array Size : 1875387648 (1788.51 GiB 1920.40 GB)

and: (new array)

 Avail Dev Size : 1953524904 (931.51 GiB 1000.20 GB)
     Array Size : 7814098944 (3726.05 GiB 4000.82 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)


which is perfectly correct. It seems like --detail and --examine aren't 
agreeing for some reason. Maybe one of the superblocks on one of the disks is 
not correct?

[snip]
> 
> Thanks in advance for your help!
>
> --Bart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
