From: Robert Steinmetz AIA <rob@steinmetznet.com>
Subject: Degraded Array event on /dev/md1:thelma
Date: Thu, 23 Apr 2015 12:38:45 -0500
Message-ID: <55392E25.7080604@steinmetznet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a small Ubuntu 14.04 LTS server with two Type 1 arrays, primarily 
for redundancy. Recently I started getting email with the above title.

I checked the array and one drive had failed. I replaced the drive, ran 
fdisk to create a new Linux Raid Array partition (type fd) of exactly 
the same size as the existing disk.
Then using gnome-disk-utility added the new drive to the array. 
Apparently that added the entire disk, not the partition I created 
however, everything seems to be working properly.

BUT I am still regularly getting the email below indicating a problem 
with /dev/md1, even though I think I fixed the problem.
> This is an automatically generated mail message from mdadm
> running on thelma
>
> A DegradedArray event had been detected on md device /dev/md1.
>
> Faithfully yours, etc.
>
> P.S. The /proc/mdstat file currently contains the following:
>
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> md1 : active raid1 sdc1[0]
>        312567552 blocks [2/1] [U_]
>        
> md0 : active raid1 sda1[0] sdb1[1]
>        78148096 blocks [2/2] [UU]
>        
> unused devices: <none>

However mdadm reports:
> root@thelma:~# mdadm --detail /dev/md1
> /dev/md1:
>         Version : 0.90
>   Creation Time : Sun Mar 11 19:06:41 2007
>      Raid Level : raid1
>      Array Size : 312567552 (298.09 GiB 320.07 GB)
>   Used Dev Size : 312567552 (298.09 GiB 320.07 GB)
>   Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 1
>     Persistence : Superblock is persistent
>
>     Update Time : Thu Apr 23 12:36:16 2015
>           State : clean
>  Active Devices : 2
>  Working Devices : 2
>  Failed Devices : 0
>  Spare Devices : 0
>
>            UUID : a5865e80:27a899df:bfaac05b:eff3fc62
>          Events : 0.16313034
>
>     Number   Major   Minor   RaidDevice State
>        0       8       33        0      active sync   /dev/sdc1
>        1       8       48        1      active sync   /dev/sdd

mdadm.conf contains the following:
> root@thelma:/etc/mdadm# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
> [raid4] [raid10]
> md1 : active raid1 sdc1[0] sdd[1]
>       312567552 blocks [2/2] [UU]
>
> md0 : active raid1 sda1[0] sdb1[1]
>       78148096 blocks [2/2] [UU]
cat /proc/mdstat produces.
> root@thelma:/etc/mdadm# cat /proc/mdstat
>
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
> [raid4] [raid10]
> md1 : active raid1 sdc1[0] sdd[1]
>       312567552 blocks [2/2] [UU]
>
> md0 : active raid1 sda1[0] sdb1[1]
>       78148096 blocks [2/2] [UU]
>
> unused devices: <none>
I'm not sure whether there is a real problem or how to fix it. It seems 
some inaccurate configuration information is stored somewhere.

