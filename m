From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Fri, 22 Feb 2013 13:30:47 -0500
Message-ID: <5127B957.1090300@turmel.org>
References: <5123A1CC.2000003@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heis
 l.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.org> <5127B0AB.5040108@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5127B0AB.5040108@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

You forgot linux-raid again.

On 02/22/2013 12:53 PM, Stone wrote:

> a littel question.
> i have now created my new raid on my new devices with:
> mdadm --create --verbose /dev/md0 --level=5 --raid-devices=4 /dev/sdb1
> /dev/sdc1 /dev/sdd1 /dev/sde1
> mdadm --detail --scan --verbose > /etc/mdadm/mdadm.conf
> cat /etc/mdadm/mdadm.conf
> ARRAY /dev/md0 level=raid5 num-devices=4 metadata=1.2 spares=1
> name=bender:0 UUID=a3ff1ec9:83c2cc4b:7c5e0550:5655e4d0
>    devices=/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1
> 
> md0 is now synced
> after a reboot my md0 is now a md127

You forgot to update your initramfs after you changed mdadm.conf.

> cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md127 : active (auto-read-only) raid5 sde1[4] sdb1[0] sdd1[2] sdc1[1]
>       8788597248 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4]
> [UUUU]
> 
> unused devices: <none>
> 
>  mdadm -D /dev/md127
> /dev/md127:
>         Version : 1.2
>   Creation Time : Fri Feb 22 10:42:16 2013
>      Raid Level : raid5
>      Array Size : 8788597248 (8381.46 GiB 8999.52 GB)
>   Used Dev Size : 2929532416 (2793.82 GiB 2999.84 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
> 
>     Update Time : Fri Feb 22 18:09:13 2013
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>            Name : bender:0  (local to host bender)
>            UUID : a3ff1ec9:83c2cc4b:7c5e0550:5655e4d0
>          Events : 28
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       17        0      active sync   /dev/sdb1
>        1       8       33        1      active sync   /dev/sdc1
>        2       8       49        2      active sync   /dev/sdd1
>        4       8       65        3      active sync   /dev/sde1
> 
> WTF is going on here?
> i had never this problem :)

Not a problem.  User error.  How raids are put together during boot
happens inside the initramfs.  Your root filesystem isn't even mounted
yet at that point, so mdadm.conf can't be read from it.

If you don't want the array assembled by the initramfs, you need two
mdadm.conf.  One inside the initramfs to disable assembly, and another
in /etc/...  to control later assembly.

Phil
