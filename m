From: David Greaves <david@dgreaves.com>
Subject: md reports: unknown partition table
Date: Tue, 18 Jul 2006 17:43:47 +0100
Message-ID: <44BD0FC3.3010304@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi

After a powercut I'm trying to mount an array and failing :(

teak:~# mdadm --assemble /dev/media --auto=p /dev/sd[bcdef]1
mdadm: /dev/media has been started with 5 drives.

Good

However:
teak:~# mount /media
mount: /dev/media1 is not a valid block device

teak:~# dd if=/dev/media1 of=/dev/null
dd: opening `/dev/media1': No such device or address

teak:~# dd if=/dev/media of=/dev/null
792442+0 records in
792441+0 records out
405729792 bytes transferred in 4.363571 seconds (92981135 bytes/sec)
(after ^C)

dmesg shows:
raid5: device sdb1 operational as raid disk 0
raid5: device sdf1 operational as raid disk 4
raid5: device sde1 operational as raid disk 3
raid5: device sdd1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 1
raid5: allocated 5235kB for md_d127
raid5: raid level 5 set md_d127 active with 5 out of 5 devices, algorithm 2
RAID5 conf printout:
 --- rd:5 wd:5 fd:0
 disk 0, o:1, dev:sdb1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdd1
 disk 3, o:1, dev:sde1
 disk 4, o:1, dev:sdf1
md_d127: bitmap initialized from disk: read 1/1 pages, set 0 bits, status: 0
created bitmap (5 pages) for device md_d127
 md_d127: unknown partition table

That last line looks odd...

It was created like so:

mdadm --create /dev/media --level=5 -n 5 -e1.2 --bitmap=internal
--name=media --auto=p /dev/sd[bcdef]1

and the xfs fstab entry is:
  /dev/media1 /media xfs rw,noatime,logdev=/dev/media2 0 0

fdisk /dev/media
shows:
     Device Boot      Start         End      Blocks   Id  System
/dev/media1               1   312536035  1250144138   83  Linux
/dev/media2       312536036   312560448       97652   da  Non-FS data

cfdisk even gets the filesystem right...

Which is expected.

teak:~# ll /dev/media*
brw-rw----  1 root disk 254, 192 2006-07-18 17:18 /dev/media
brw-rw----  1 root disk 254, 193 2006-07-18 17:18 /dev/media1
brw-rw----  1 root disk 254, 194 2006-07-18 17:18 /dev/media2
brw-rw----  1 root disk 254, 195 2006-07-18 17:18 /dev/media3
brw-rw----  1 root disk 254, 196 2006-07-18 17:18 /dev/media4

teak:~# uname -a
Linux teak 2.6.16.19-teak-060602-01 #3 PREEMPT Sat Jun 3 09:20:24 BST
2006 i686 GNU/Linux
teak:~# mdadm -V
mdadm - v2.5.2 -  27 June 2006


David

-- 
