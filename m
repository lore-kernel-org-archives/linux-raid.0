From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Thu, 27 Apr 2017 16:43:56 +0200
Message-ID: <e76a0a07-2306-e63a-a1f7-48d103eefd62@thelounge.net>
References: <590117CD.1000009@tesco.net>
 <22785.65375.947842.648174@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22785.65375.947842.648174@quad.stoffel.home>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>, Ron Leach <ronleach@tesco.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 27.04.2017 um 16:25 schrieb John Stoffel:
> 
> Ron> We run a 2TB fileserver in a raid1 configuration.  Today one of
> Ron> the 2 disks (/dev/sdb) failed and we've just replaced it and set
> Ron> up exactly the same partitions as the working, but degraded, raid
> Ron> has on /dev/sda.
> 
> First off, why are you bothering to do this?  You should just mirror
> the entire disk with MD

because he has partitions in use and more than on mdraid as you can see 
in the /proc/mdstat output? because he just want to replace a disk? 
becaus ehe likjely has also the operating system on one of that many 
RAIDs sharing the same disks?

> then build LVM volumes on top of that 

he is replacing a disk in a already existing RAID and has more than on 
RAID volume

> you can then allocate as you see fit, moving your data around,
> growing, shrinking volumes as you need

he is replacing a disk in a already existing RAID and has more than on 
RAID volume

[root@rh:~]$ df
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/md1       ext4   29G  6.8G   22G  24% /
/dev/md0       ext4  485M   34M  448M   7% /boot
/dev/md2       ext4  3.6T  678G  2.9T  19% /mnt/data

[root@rh:~]$ cat /proc/mdstat
Personalities : [raid10] [raid1]
md0 : active raid1 sda1[0] sdc1[1] sdb1[3] sdd1[2]
       511988 blocks super 1.0 [4/4] [UUUU]

md1 : active raid10 sda2[0] sdc2[1] sdd2[2] sdb2[3]
       30716928 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]

md2 : active raid10 sda3[0] sdc3[1] sdd3[2] sdb3[3]
       3875222528 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]
       [========>............]  check = 44.4% (1721204032/3875222528) 
finish=470.9min speed=76232K/sec



