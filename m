From: Piotr Legiecki <piotrlg@pum.edu.pl>
Subject: Changed the SATA ports of two disks in RAID10 and raid disappeared
Date: Mon, 19 Sep 2011 15:32:08 +0200
Message-ID: <4E774458.3070107@pum.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I have RAID10 with 4 disks. Two of them are connected to 3ware PCIe 4 
ports SATA controler and the other two on the motherboard SATA ports. I 
wanted to reconnect those two disks connected to motherboard to 3ware card.

So I have turned of the computer, changed the ports, started the 
computer and... something went wrong. The system (is located on other 
set of disks) started to boot but stopped at some point with
(initramfs) prompt.

So i have changed back the cables to their original position booted once 
again and the system booted ok, but that RAID10 raid is no longer visible.
cat /proc/mdstat shows no sing of md4 (that is my RAID10).

> bez:~# mdadm --examine /dev/sde1
> mdadm: metadata format 00.90 unknown, ignored.
> mdadm: metadata format 00.90 unknown, ignored.
> mdadm: metadata format 00.90 unknown, ignored.
> mdadm: metadata format 00.90 unknown, ignored.
> mdadm: metadata format 00.90 unknown, ignored.
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 68ba9941:99b06d2b:a6d85817:73d86525
>   Creation Time : Mon Aug 22 14:08:36 2011
>      Raid Level : raid10
>   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>      Array Size : 1953519872 (1863.02 GiB 2000.40 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 4
> 
>     Update Time : Mon Sep 19 14:41:24 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 9d49c129 - correct
>          Events : 10
> 
>          Layout : near=2, far=1
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     2       8       65        2      active sync   /dev/sde1
> 
>    0     0       8        1        0      active sync   /dev/sda1
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       8       65        2      active sync   /dev/sde1
>    3     3       8       81        3      active sync   /dev/sdf1

Well, it looks OK. So why there is no md4?

> bez:~# mdadm --detail --scan
> mdadm: metadata format 00.90 unknown, ignored.
> mdadm: metadata format 00.90 unknown, ignored.
> mdadm: metadata format 00.90 unknown, ignored.
> mdadm: metadata format 00.90 unknown, ignored.
> mdadm: metadata format 00.90 unknown, ignored.
> ARRAY /dev/md1 level=raid1 num-devices=2 metadata=00.90 UUID=8217ec09:15447b4d:65b570e2:d0c384e4
> ARRAY /dev/md0 level=raid1 num-devices=2 metadata=00.90 UUID=6cc5fe40:770f86cb:65b570e2:d0c384e4
> ARRAY /dev/md2 level=raid1 num-devices=2 metadata=00.90 UUID=925a0a99:c6f209cb:f9cbbe93:e229c843
> ARRAY /dev/md3 level=raid1 num-devices=2 metadata=00.90 UUID=f2108b92:c3e6b4ae:f9cbbe93:e229c843

So two questions are important now.
1. How to run this array (safely) again on old ports
2. How to change the ports to new ones? In a proper way.

The other thing bothers me o bit. Why there is
mdadm: metadata format 00.90 unknown, ignored. warnig? AFAIR it was 
almost from the beggining of my md arrays on this computer.

> bez:~# uname -a
> Linux bez 2.6.26-2-686-bigmem #1 SMP Thu Nov 25 01:59:22 UTC 2010 i686 GNU/Linux

Regards
Piotr
