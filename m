From: Benjammin2068 <benjammin2068@gmail.com>
Subject: WARNING: mismatch_cnt is not 0 on <array device>
Date: Sun, 25 Sep 2016 21:43:30 -0500
Message-ID: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hey all,


 So the RAID5 which I upgraded to RAID6 was humming along all week just fine (I did the change last weekend) and this weekend I got this:

WARNING: mismatch_cnt is not 0 on /dev/md127

The array seems happy and clean:


> /dev/md127:
>         Version : 1.2
>   Creation Time : Tue Aug 23 03:06:46 2011
>      Raid Level : raid6
>      Array Size : 2930276352 (2794.53 GiB 3000.60 GB)
>   Used Dev Size : 976758784 (931.51 GiB 1000.20 GB)
>    Raid Devices : 5
>   Total Devices : 6
>     Persistence : Superblock is persistent
>
>   Intent Bitmap : Internal
>
>     Update Time : Sun Sep 25 21:42:55 2016
>           State : clean
>  Active Devices : 5
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 1
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>            Name : :BigRAID
>            UUID : 97b17840:3eaff079:d8e384d0:bfdbda42
>          Events : 905701
>
>     Number   Major   Minor   RaidDevice State
>        6       8       81        0      active sync   /dev/sdf1
>        1       8       33        1      active sync   /dev/sdc1
>        5       8       49        2      active sync   /dev/sdd1
>        4       8       65        3      active sync   /dev/sde1
>        8       8       97        4      active sync   /dev/sdg1
>
>        7       8      113        -      spare   /dev/sdh1

I don't think I've ever got a message before about mismatch_cnt

 -Ben

