From: David Greaves <david@dgreaves.com>
Subject: Can't mount after mkfs -b 8192
Date: Thu, 03 Jun 2004 23:31:57 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40BFA6DD.6000904@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

First - thanks Guy - I've setup using 1 big partitions and I'll deal 
with monitoring as you suggest.

(BTW, are patches to mdadm recvd well? If so I'll take a look - 
especially at the state=spare message when rebuilding.)

Anyway, I now have an lvm2 on top and wanted a reiserfs (actually, since 
I'm ex-sgi I wanted xfs - but it doesn't shrink :( ) and I'm having odd 
behaviour. (Also, I posted to the reiser list but thinking about it, 
raid makes as much sense...)

So, environment:
Kernel 2.6.6
progsreiserfs 0.3.0.4-3

Summary:
I have a raid5 array in an LVM2 VG with a 600Gb LV defined.
If I make a reiserfs with a block size of 8192 it won't mount.

The following commands were issued consecutively:

cu:~# mkfs -treiserfs /dev/video_vg/video_lv
All data on /dev/video_vg/video_lv will be lost. Do you really want to
create reiser filesystem (v3.6) (y/n) y
Creating reiser filesystem (v3.6) with standard journal on
/dev/video_vg/video_lv
initializing skiped area: done
initializing journal: done
syncing...done

cu:~# mount /dev/video_vg/video_lv /huge

cu:~# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/hda2             19283776    697988  18585788   4% /
/dev/hda1                97826     13003     79604  15% /boot
/dev/mapper/video_vg-video_lv
                     629126396     32840 629093556   1% /huge

cu:~# umount /huge

cu:~# mkfs -treiserfs -b 8192 /dev/video_vg/video_lv
All data on /dev/video_vg/video_lv will be lost. Do you really want to
create reiser filesystem (v3.6) (y/n) y
Creating reiser filesystem (v3.6) with standard journal on
/dev/video_vg/video_lv
initializing skiped area: done
initializing journal: done
syncing...done

cu:~# mount /dev/video_vg/video_lv /huge
mount: wrong fs type, bad option, bad superblock on /dev/video_vg/video_lv,
       or too many mounted file systems

dmesg now shows:
sh-2011: read_super_block: can't find a reiserfs filesystem on (dev
dm-0, block 16, size 4096)
sh-2021: reiserfs_fill_super: can not find reiserfs on dm-0

any suggestions.

Nb I'll be storing 2-5Gb video files - hence the large blocksize.

David


