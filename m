From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Possible Bitmap-bug in raid(1) !
Date: Sat, 22 Apr 2006 10:58:54 +0200
Message-ID: <002f01c665eb$02768700$1600a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, list,

I have one interesting issue

The history in brief:

I have one 200GB raid1 mirror, md10 from sda1,sdb1.

It works great, using bitmap.

1. Once i fail manually the sdb1
2. used the system for a long time with one disk.
3. re-add the sdb1, sync is starts from the beginning, OK
4. the sync is about 50%, the system gets RESET, and reboot.
5, after reboot, this message in the log:

Apr 22 00:50:57 dy-xeon-1 kernel: IP-Config: Complete:
Apr 22 00:50:57 dy-xeon-1 kernel:       device=eth0, addr=192.168.0.50,
mask=255.255.255.0, gw=192.168.0.1,
Apr 22 00:50:57 dy-xeon-1 kernel:      host=xeon, domain=,
nis-domain=(none),
Apr 22 00:50:57 dy-xeon-1 kernel:      bootserver=192.168.0.1,
rootserver=192.168.0.1, rootpath=/NFS/ROOT-XEON1/
Apr 22 00:50:57 dy-xeon-1 kernel: md: Autodetecting RAID arrays.
Apr 22 00:50:57 dy-xeon-1 kernel: md: autorun ...
Apr 22 00:50:57 dy-xeon-1 kernel: md: considering sdb1 ...
Apr 22 00:50:57 dy-xeon-1 kernel: md:  adding sdb1 ...
Apr 22 00:50:57 dy-xeon-1 kernel: md:  adding sda1 ...
Apr 22 00:50:57 dy-xeon-1 kernel: md: created md10
Apr 22 00:50:57 dy-xeon-1 kernel: md: bind<sda1>
Apr 22 00:50:57 dy-xeon-1 kernel: md: bind<sdb1>
Apr 22 00:50:57 dy-xeon-1 kernel: md: running: <sdb1><sda1>
Apr 22 00:50:57 dy-xeon-1 kernel: md10: bitmap initialized from disk: read
12/12 pages, set 1472 bits, status: 0
Apr 22 00:50:57 dy-xeon-1 kernel: created bitmap (187 pages) for device md10
Apr 22 00:50:57 dy-xeon-1 kernel: raid1: raid set md10 active with 1 out of
2 mirrors
Apr 22 00:50:57 dy-xeon-1 kernel: md: ... autorun DONE.
Apr 22 00:50:57 dy-xeon-1 kernel: RAID1 conf printout:
Apr 22 00:50:57 dy-xeon-1 kernel:  --- wd:1 rd:2
Apr 22 00:50:57 dy-xeon-1 kernel:  disk 0, wo:0, o:1, dev:sda1
Apr 22 00:50:57 dy-xeon-1 kernel:  disk 1, wo:1, o:1, dev:sdb1
Apr 22 00:50:57 dy-xeon-1 kernel: Looking up port of RPC 100003/2 on
192.168.0.1
Apr 22 00:50:57 dy-xeon-1 kernel: md: syncing RAID array md10
Apr 22 00:50:57 dy-xeon-1 kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
Apr 22 00:50:57 dy-xeon-1 kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Apr 22 00:50:57 dy-xeon-1 kernel: md: using 128k window, over a total of
195358336 blocks.
Apr 22 00:50:57 dy-xeon-1 kernel: Looking up port of RPC 100005/1 on
192.168.0.1
Apr 22 00:50:57 dy-xeon-1 kernel: md: md10: sync done.
Apr 22 00:50:57 dy-xeon-1 kernel: RAID1 conf printout:
Apr 22 00:50:57 dy-xeon-1 kernel:  --- wd:2 rd:2
Apr 22 00:50:57 dy-xeon-1 kernel:  disk 0, wo:0, o:1, dev:sda1
Apr 22 00:50:57 dy-xeon-1 kernel:  disk 1, wo:0, o:1, dev:sdb1
Apr 22 00:50:57 dy-xeon-1 kernel: VFS: Mounted root (nfs filesystem)
readonly.
...
This looks good, for a first time, but really can resync ~100GB in one
second? :-)

...
Apr 22 00:51:41 dy-xeon-1 kernel: XFS mounting filesystem md10
Apr 22 00:51:41 dy-xeon-1 kernel: XFS: Log inconsistent (didn't find
previous header)
Apr 22 00:51:41 dy-xeon-1 kernel: XFS: failed to find log head
Apr 22 00:51:41 dy-xeon-1 kernel: XFS: log mount/recovery failed: error 5
Apr 22 00:51:41 dy-xeon-1 kernel: XFS: log mount failed
Apr 22 00:51:45 dy-xeon-1 kernel: XFS: osyncisdsync is now the default,
option is deprecated.
Apr 22 00:51:45 dy-xeon-1 kernel: XFS mounting filesystem md10
Apr 22 00:51:45 dy-xeon-1 kernel: XFS: Log inconsistent (didn't find
previous header)
Apr 22 00:51:45 dy-xeon-1 kernel: XFS: failed to find log head
Apr 22 00:51:45 dy-xeon-1 kernel: XFS: log mount/recovery failed: error 5
Apr 22 00:51:45 dy-xeon-1 kernel: XFS: log mount failed

6. the XFS cannot see te superblock, mount failed.
7. cat /proc/mdstat the array looks good, and clean, bitmap 0/187
8. mdadm -f  /dev/md10 /dev/sdb1
9. mounting the md10, and mount can made it! :-) No data lost.

But if i start the xfs_repair (or the mount founds the xfs internal log, and
superblock), i will have a lot of data corruption!

One question:

After mdadm -a /dev/md10 /dev/sdb1 (point #3), the raid NEEDS to clean (or r
emove) the bitmap from sdb1, am i right? :-)

Kernel 2.6.15.7

Cheers,
Janos



