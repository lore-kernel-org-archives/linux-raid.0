From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Sat, 29 May 2010 14:34:02 -0500
Message-ID: <E9.95.03062.62C610C4@cdptpa-omtalb.mail.rr.com>
References: <98.D5.03062.322610C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <98.D5.03062.322610C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	OK, I figured it out, I think.  Apparently mdadm does not like the
single quotes around the hostname.  The odd thing is, mdadm *CREATED* those
hostnames automatically.  It looks like I can get this to work (I hope) by
updating the homehost name in each array member's superblock.  'Fingers
crossed.

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Leslie Rhorer
> Sent: Saturday, May 29, 2010 1:51 PM
> To: linux-raid@vger.kernel.org
> Subject: RE: Broken RAID1 boot arrays
> 
> 
> 	I've found a little time to look into this a bit further.  The
> reports are different from "Lenny" and "Squeeze", but the end result is
> the
> same (except of course "Squeeze" won't boot, at all from a RAID array).
> Nothng I try will get mdadm to auto-assemble the arrays.  First of all,
> shouldn't the UUIDs of all the partitions appear in /dev/disk/by-uuid?
> None
> of them are there for any unassembled partitions under "Squeeze" and none
> of
> them are there at all under "Lenny".  Why is "Lenny" reporting a wrong
> name
> and saying the partitions are not built for the host?  The hostname is
> correct.  Why is "Squeeze" reporting incorrect device UUIDs?  Is it
> because
> they do not exist in /dev/disk/by-uuid?
> 
> >From "Squeeze":
> 
> root@Backup: /# mdadm --assemble -v --scan
> <snip>
> mdadm: no RAID superblock on /dev/hdb1
> mdadm: /dev/hdb1 has wrong uuid.
> <snip>
> 
> root@Backup:/dev/disk/by-uuid# ls -l
> total 0
> lrwxrwxrwx 1 root root 10 May 28 21:27 405a6da1-8040-49bc-8a6a-
> b5aa4faf79d3
> -> ../../sda2
> lrwxrwxrwx 1 root root  9 May 29 12:02 bba2eeda-2c8b-45ad-86d1-
> 82b6cef84ee3
> -> ../../md0
> lrwxrwxrwx 1 root root 10 May 28 21:27 ea01cadd-1e17-49b4-a1c4-
> 3ae2898eee01
> -> ../../sda5
> lrwxrwxrwx 1 root root 10 May 28 21:27 f8f1c3d3-0ea3-495d-9be8-
> 9e4038aebb96
> -> ../../sda1
> root@Backup:/dev/disk/by-uuid# mdadm --examine /dev/hdb1
> /dev/hdb1:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : d6a2c60b:7345e957:05aefe0b:f8d1527f
>            Name : 'Backup':1
>   Creation Time : Sun Dec 20 01:13:59 2009
>      Raid Level : raid1
>    Raid Devices : 2
> 
>  Avail Dev Size : 12289632 (5.86 GiB 6.29 GB)
>      Array Size : 12289632 (5.86 GiB 6.29 GB)
>    Super Offset : 12289640 sectors
>           State : clean
>     Device UUID : f32fd8b1:95b548af:13b79684:51213590
> 
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Thu May 20 20:14:16 2010
>        Checksum : 3242a0f1 - correct
>          Events : 292
> 
> 
>    Device Role : Active device 1
>    Array State : AA ('A' == active, '.' == missing)
> root@Backup:/dev/disk/by-uuid# hostname
> Backup
> 
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
> MAILADDR lrhorer@satx.rr.com
> 
> PROGRAM /usr/bin/mdadm_notify
> 
> # definitions of existing MD arrays
> ARRAY /dev/md0 metadata=1.2 UUID=940ae4e4:04057ffc:5e92d2fb:63e3efb7
> name='Backup':0
> ARRAY /dev/md1 metadata=1.0 UUID=d6a2c60b:7345e957:05aefe0b:f8d1527f
> name='Backup':1
> ARRAY /dev/md2 metadata=1.2 UUID=d45ff663:9e53774c:6fcf9968:21692025
> name='Backup':2
> ARRAY /dev/md3 metadata=1.2 UUID=3615c4a2:33786b6d:b13863d9:458cd054
> name='Backup':3
> 
> # This file was auto-generated on Thu, 20 May 2010 06:52:13 -0500
> # by mkconf 3.0.3-2
> 
> 
> 
> 
> >From "Lenny":
> 
> RAID-Server:/RAID/Server-Main# mdadm --assemble --scan -v
> <snip>
> mdadm: /dev/hda1 has wrong name.
> <snip>
> mdadm: /dev/sda1 has wrong name.
> <snip>
> mdadm: /dev/hda1 is not built for host RAID-Server.
> <snip>
> mdadm: /dev/sda1 is not built for host RAID-Server.
> <snip>
> 
> RAID-Server:/RAID/Server-Main# mdadm --examine /dev/hda1
> /dev/hda1:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : 76e8e11d:e0183c3c:404cb86a:19a7cb3d
>            Name : 'RAID-Server':1
>   Creation Time : Wed Dec 23 23:46:28 2009
>      Raid Level : raid1
>    Raid Devices : 2
> 
>  Avail Dev Size : 803160 (392.23 MiB 411.22 MB)
>      Array Size : 803160 (392.23 MiB 411.22 MB)
>    Super Offset : 803168 sectors
>           State : clean
>     Device UUID : 28fa09ed:07bf99e2:e3a3b396:9fe389d3
> 
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Sat May 29 12:52:54 2010
>        Checksum : 9e33cfa4 - correct
>          Events : 252
> 
> 
>     Array Slot : 2 (failed, 1, 0)
>    Array State : Uu 1 failed
> RAID-Server:/RAID/Server-Main# mdadm --examine /dev/sda1
> /dev/sda1:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : 76e8e11d:e0183c3c:404cb86a:19a7cb3d
>            Name : 'RAID-Server':1
>   Creation Time : Wed Dec 23 23:46:28 2009
>      Raid Level : raid1
>    Raid Devices : 2
> 
>  Avail Dev Size : 803160 (392.23 MiB 411.22 MB)
>      Array Size : 803160 (392.23 MiB 411.22 MB)
>    Super Offset : 803168 sectors
>           State : clean
>     Device UUID : 28212297:1d982d5d:ce41b6fe:03720159
> 
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Sat May 29 12:52:54 2010
>        Checksum : b059fc07 - correct
>          Events : 252
> 
> 
>     Array Slot : 1 (failed, 1, 0)
>    Array State : uU 1 failed
> RAID-Server:/dev/disk/by-uuid# ll
> total 0
> drwxr-xr-x 2 root root 120 2010-05-10 16:26 .
> drwxr-xr-x 6 root root 120 2010-05-10 16:26 ..
> lrwxrwxrwx 1 root root   9 2010-05-10 16:26
> 5cbe8269-fec8-42db-889d-a1d57b0a797e -> ../../md2
> lrwxrwxrwx 1 root root   9 2010-05-10 16:26
> 5f41f190-d280-4f55-8b61-44f4abe981c1 -> ../../md0
> lrwxrwxrwx 1 root root   9 2010-05-10 16:26
> 904e95cb-d0ad-4167-9dbf-51baf1867c00 -> ../../md3
> 
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
> MAILADDR lrhorer@satx.rr.com
> 
> # This file was auto-generated on Fri, 21 Nov 2008 22:35:30 -0600
> # by mkconf $Id$
> PROGRAM /usr/bin/mdadm_notify
> 
> ARRAY /dev/md0 level=raid6 metadata=1.2 num-devices=11
> UUID=5ff10d73:a096195f:7a646bba:a68986ca name=RAID-Server:0
> ARRAY /dev/md1 level=raid1 metadata=1.0 num-devices=2
> UUID=76e8e11d:e0183c3c:404cb86a:19a7cb3d name=RAID-Server:1
> ARRAY /dev/md2 level=raid1 metadata=1.2 num-devices=2
> UUID=4b466602:fb81286c:4ad8dc5c:ad0bd065 name=RAID-Server:2
> ARRAY /dev/md3 level=raid1 metadata=1.2 num-devices=2
> UUID=5bc11cda:e1b4065f:fbf2fca5:8b12e0ba name=RAID-Server:3
> 
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

