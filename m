From: Georgios Petasis <petasisg@yahoo.gr>
Subject: Re: raid 1 assembled but inactive - works from a "live"
 distribution...
Date: Thu, 20 Jul 2017 14:52:45 +0300
Message-ID: <8504efd5-dc98-afe6-6d6c-5b1352a9c134@yahoo.gr>
References: <b9a1822b-ab01-2cb3-e417-85aafec9a3d2@yahoo.gr>
Reply-To: petasisg@yahoo.gr, petasisg@yahoo.gr
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b9a1822b-ab01-2cb3-e417-85aafec9a3d2@yahoo.gr>
Content-Language: English & Greek
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Στις 20/7/2017 14:04, ο Georgios Petasis έγραψε:
> Hi all,
>
> I have a fedora 25 (mdadm v3.4 - 28 Jan 2016), where out of blue, it 
> stopped booting. The problem was because it could not mount some 
> filesystems that were software raid1 devices. No disk failures. cat 
> /proc/mdstat shows:
>
> Personalities :
> md0 : inactive sdb1[1] sda1[0]
>       1228797952 blocks super 1.2
>
> md2 : inactive sdb3[2] sda3[0]
>       507344896 blocks super 1.2
>
> md1 : inactive sda2[0] sdb2[2]
>       2047997952 blocks super 1.2
>
> unused devices: <none>
>
> What is strange, is that it does not say it is a raid1 array (all of 
> them are).
>
> mdadm -D /dev/md0 shows:
> /dev/md0:
>         Version : 1.2
>   Creation Time : Sat Feb  4 08:50:18 2012
>      Raid Level : raid1
>   Used Dev Size : 614398840 (585.94 GiB 629.14 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Wed Jul 19 22:46:24 2017
>           State : active, Not Started
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>            Name : server.intellitech.gr:0  (local to host 
> server.intellitech.gr)
>            UUID : 6f903cce:5f6b3df4:c865924f:b05e2cd4
>          Events : 447211
>
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync /dev/sda1
>        1       8       17        1      active sync /dev/sdb1
>
> I booted my pc with a live dvd of fedora 26 (and not 25 as the 
> system), having mdadm v4.0, and everything works as expected. I can 
> see the 3 raid devices, I can mount them and see their contents.
>
> So I am puzzled why mdadm 4 can use the devices, and mdadm 3.4 cannot 
> any more. How can I fix this?
>
> (I have backups of all 3 filesystems, taken with dd from the live dvd, 
> where the raid devices work. The backups can be mounted)
>
> I am thinking like destroying completely the arrays and recreate them, 
> but I feel that there is a much simpler solution, as the raid arrays 
> work with mdadm v4.
>
> Regards,
>
> George
Another puzzling fact, is that booting fedora 25 with the previous 
kernel works.
With the latest kernel does not.
I tried because I saw "md: personality for level 1 is not loaded!" in 
the logs...

George
