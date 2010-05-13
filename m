From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Wed, 12 May 2010 20:31:47 -0500
Message-ID: <1D.35.20763.7865BEB4@cdptpa-omtalb.mail.rr.com>
References: <07.C9.20538.092F9EB4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <07.C9.20538.092F9EB4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	Hello?  Anyone?  I'm flummoxed, here.  I tried to write in a manual
assembly of the arrays in the initrd, but so far I haven't been able to get
it to work.  One way or another, it just hangs when running
/scripts/local-top/mdadm in the initrd.  Even `ls -1 /dev/sd*` returns an
error.

	It's also really odd that I can assemble and mount the root and boot
arrays, but under Ubuntu I can't even assemble the swap array.  It complains
that the first member of the array is busy and refuses to start /dev/md3.
The results of --examine look identical to those listed below, except of
course for the partition specific entries (size, drive and array UUID,
events, etc).

	I really need to get this machine back on line, and any suggestions
are greatly appreciated.

> > don't want to try to install the OS: that could be a disaster.  BTW, the
> > 2.6.32 kernel is moving the IDE disks all the way from /hda and /hdb to
> > /sdj
> > and /sdk.  I think that's part of why it's breaking: the existing
> > mdadm.conf
> > doesn't scan that high.
> 
> 	OK, maybe not.  I re-arranged things so the boot drives are /dev/sda
> and /dev/sdb, but it still isn't working.  When I boot the Ubuntu live CD
> and install mdadm, it creates the following mdadm.conf:
> 
> ubuntu@ubuntu:~$ cat /etc/mdadm/mdadm.conf
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
> 
> # by default, scan all partitions (/proc/partitions) for MD superblocks.
> # alternatively, specify devices to scan, using wildcards if desired.
> DEVICE partitions
> 
> # auto-create devices with Debian standard permissions
> CREATE owner=root group=disk mode=0660 auto=yes
> 
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
> 
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR root
> 
> # definitions of existing MD arrays
> ARRAY /dev/md/1 level=raid1 metadata=1.0 num-devices=2
> UUID=d6a2c60b:7345e957:05aefe0b:f8d1527f name='Backup':1
> ARRAY /dev/md/2 level=raid1 metadata=1.2 num-devices=2
> UUID=d45ff663:9e53774c:6fcf9968:21692025 name='Backup':2
> ARRAY /dev/md/3 level=raid1 metadata=1.2 num-devices=2
> UUID=3615c4a2:33786b6d:b13863d9:458cd054 name='Backup':3
> ARRAY /dev/md/0 level=raid5 metadata=1.2 num-devices=8
> UUID=940ae4e4:04057ffc:5e92d2fb:63e3efb7 name='Backup':0
> 
> # This file was auto-generated on Tue, 11 May 2010 23:45:16 +0000
> # by mkconf $Id$
> 
> 	If I try to auto-assemble the arrays, it fails:
> 
> ubuntu@ubuntu:~$ sudo mdadm --assemble --scan
> mdadm: no devices found for /dev/md/1
> mdadm: no devices found for /dev/md/2
> mdadm: no devices found for /dev/md/3
> mdadm: no devices found for /dev/md/0
> 
> 	Yet I can manually assemble them with no issues:
> 
> ubuntu@ubuntu:~$ sudo mdadm --assemble /dev/md2 /dev/sda2 /dev/sdb2
> mdadm: /dev/md2 has been started with 2 drives.
> 
> 	I think this failure to auto-assemble lies at the root of the reason
> the arrays are not coming up (and consequently the system is not booting),
> but why is this happening?  Below is the result of the --examine for
> /dev/md2:
> 
> ubuntu@ubuntu:~$ sudo mdadm --examine /dev/sda2
> /dev/sda2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : d45ff663:9e53774c:6fcf9968:21692025
>            Name : 'Backup':2
>   Creation Time : Sun Dec 20 04:59:43 2009
>      Raid Level : raid1
>    Raid Devices : 2
> 
>  Avail Dev Size : 554884828 (264.59 GiB 284.10 GB)
>      Array Size : 554884828 (264.59 GiB 284.10 GB)
>     Data Offset : 272 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : b77a6eb8:c07a50f5:3bff3afb:846652a2
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue May 11 06:27:13 2010
>        Checksum : 96af22ac - correct
>          Events : 14920
> 
> 
>     Array Slot : 2 (failed, 1, 0)
>    Array State : Uu 1 failed
> ubuntu@ubuntu:~$
> ubuntu@ubuntu:~$ sudo mdadm --examine /dev/sdb2
> /dev/sdb2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : d45ff663:9e53774c:6fcf9968:21692025
>            Name : 'Backup':2
>   Creation Time : Sun Dec 20 04:59:43 2009
>      Raid Level : raid1
>    Raid Devices : 2
> 
>  Avail Dev Size : 554884828 (264.59 GiB 284.10 GB)
>      Array Size : 554884828 (264.59 GiB 284.10 GB)
>     Data Offset : 272 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : bc74e25e:14e6562a:f136cf70:a2f6c6ac
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue May 11 06:27:13 2010
>        Checksum : f2324fd6 - correct
>          Events : 14920
> 
> 
>     Array Slot : 1 (failed, 1, 0)
>    Array State : uU 1 failed
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

