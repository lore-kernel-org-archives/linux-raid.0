From: Catalin BOIE <util@deuroconsult.ro>
Subject: Re: Please help with a special RAID 1 setup
Date: Wed, 7 Jan 2004 14:20:40 +0200 (EET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0401071413590.16314@hosting.rdsbv.ro>
References: <3FFBDC7A.8020702@interplus.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FFBDC7A.8020702@interplus.ro>
To: Mircea Ciocan <mirceac@interplus.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>     Here are some relevant data of the test setup that may be usefull:
> [root@test]# cat /etc/raidtab
> raiddev /dev/md0
> raid-level      1
> nr-raid-disks   2
> nr-spare-disks  0
> chunk-size     4
> persistent-superblock 1
> device          /dev/sda2
> raid-disk       0
> device          /dev/sdb2
> raid-disk       1

I think that you must replace:
	nr-raid-disks   2
with
	nr-raid-disks   3
Plus, the correspinding entry:
	device          /dev/sdb3
	raid-disk       2

Else, the third drive isn't recognized as part of the md array.
Probably, you must restart the array (only first time).
You may want to use mdadm instead of raidtools.

> /proc/mdstat BEFORE adding the 3-rd device:
> [root@test]# cat /proc/mdstat
> Personalities : [raid1]
> read_ahead 1024 sectors
> md0 : active raid1 scsi/host3/bus0/target0/lun0/part2[1]
> scsi/host2/bus0/target0/lun0/part2[0]
>       710938560 blocks [2/2] [UU]
>
> unused devices: <none>
>
> Then I add the 3-rd device:
> [root@test]# raidhotadd /dev/md0 /dev/sdb3
>
> /proc/mdstat AFTER adding 3-rd device
>
> [root@nfs10 root]# cat /proc/mdstat
> Personalities : [raid1]
> read_ahead 1024 sectors
> md0 : active raid1 scsi/host3/bus0/target0/lun0/part3[2]
> scsi/host3/bus0/target0/lun0/part2[1] scsi/host2/bus0/target0/lun0/part2[0]
>       710938560 blocks [2/2] [UU]
>
> unused devices: <none>
>
> Piece of the syslog showing the add results:
> .....
> Jan  7 12:09:01 nfs10 kernel: md: updating md0 RAID superblock on device
> Jan  7 12:09:01 nfs10 kernel: md: scsi/host3/bus0/target0/lun0/part3
> [events: 00000012]<6>(write) scsi/host3/bus0/target0/lun0/part3's sb
> offset: 725598144
> Jan  7 12:09:01 nfs10 kernel: md: scsi/host3/bus0/target0/lun0/part2
> [events: 00000012]<6>(write) scsi/host3/bus0/target0/lun0/part2's sb
> offset: 710938560
> Jan  7 12:09:01 nfs10 kernel: md: scsi/host2/bus0/target0/lun0/part2
> [events: 00000012]<6>(write) scsi/host2/bus0/target0/lun0/part2's sb
> offset: 710938560
> ......
>
>     The problem is that no sync is done, as a matter of fact the 3rd
> disk is not even scrached visibly ;(, did I miss someting obvious or
> what I want is impossible ???
>
>     Thank you for reading such a long mail and for any help that will
> lead me solving this,
>
>        Mircea Ciocan
>
>
>
>
>
>
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

---
Catalin(ux) BOIE
catab@deuroconsult.ro
