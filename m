From: "Duncan, Mike" <Mike.Duncan@Sonopress.com>
Subject: MD/RAID1 Large File Support
Date: Mon, 12 May 2003 16:42:41 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <EC803175C921D411BCE2000000006429081C363F@ash-exch_lg>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I did searches on Google and Yahoo in the archives and could not find
answers to this dilemma, so sorry if this has been discussed before (and it
probably has).

Firstly, lets see my setup...
======================================================
$ uname -a
Linux dionysus 2.5.69 #1 Mon May 12 11:19:38 EDT 2003 i686 unknown
(although I have tried this on 2.4.10-4GB (SuSE 7.3 default), 2.4.18-10GB
(SuSE 8.0 default), and 2.4.20 kernels as well. All with the same results.)

$ cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 hdb2[1] hda2[0]
      38925376 blocks [2/2] [UU]
unused devices: <none>

$ df -Tah
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/md0  reiserfs     37G  5.9G   31G  16% /
proc          proc       0     0     0   -  /proc
devpts      devpts       0     0     0   -  /dev/pts
/dev/hda1     ext3    129M   12M  110M  10% /boot
(/dev/hdb1 = 128M swap)

$ dmesg
Linux version 2.5.69 (root@dionysus) (gcc version 2.95.3 20010315 (SuSE)) #1
Mon May 12 11:19:38 EDT 2003
Video mode to be used for restore is 317
<snip />
md: raid1 personality registered as nr 3
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
<snip />
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hdb2 ...
md:  adding hdb2 ...
md:  adding hda2 ...
md: created md0
md: bind<hda2>
md: bind<hdb2>
md: running: <hdb2><hda2>
md0: setting max_sectors to 8, segment boundary to 2047
blk_queue_segment_boundary: set to minimum fff
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
<snip />
found reiserfs format "3.5" with standard journal
Reiserfs journal params: device md0, size 8192, journal first block 18, max
trans len 1024, max batch 900, max commit age 30, max trans age 30
reiserfs: checking transaction log (md0) for (md0)
Using r5 hash to sort names
reiserfs: using 3.5.x disk format
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 132k freed
<snip />
======================================================

Basically, we are trying to transfer (via FTP and SSH) files larger than 2G.
I have read that SuSE has LFS in all of its distros from 7.1 and up (kernels
2.4.1 and up) and that kernel-wise and glibc-wise everything is ok. So after
re-compiling kernels, textutils, gcc, binutils, and glibc in an effort to
figure out which one is not compiled with LFS support in ... and ...
restarting from scratch once I found out it was not them ... I am left with
md.o or raid1.o as being the culprit. 

So --- is there LFS support in md.o and raid1.o modules? If not, is this
expected in 2.6 kernels? If so, do I need to apply a patch to get this
working or just maybe more kernel parameters?

TIA for any and all help.

------------------------------------ 
Mike Duncan
Web Master/Developer
Sonopress LLC

mike.duncan@sonopress.com
828.658.6082 (desk)
828.423.3310 (cell)
------------------------------------
