From: Jim Paris <jim@jtan.com>
Subject: Re: Call for RAID-6 users
Date: Tue, 27 Jul 2004 14:19:38 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040727181938.GA28181@jim.sh>
References: <20040727021209.GA19205@jim.sh> <Pine.GSO.4.33.0407271238490.25702-100000@sweetums.bluetronic.net> <20040727172028.GA27240@jim.sh>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040727172028.GA27240@jim.sh>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> > >tar handles special files in /dev properly.
> > 
> > Don't bet your life on it.  GNU Tar (tm) will work most of the time on
> > most systems (read: non-linux), but NEVER assume tar will read device
> > entries correctly. (cpio is the "correct" tool.  dump is the Correct
> > Tool (tm).)

Attached is another trace that shows this corruption on a single
regular file copied with "cp" onto a fresh filesystem.

-jim


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=typescript

Script started on Tue Jul 27 14:11:19 2004
bucket:/# mdadm --stop /dev/md1
bucket:/# mdadm --zero-superblock /dev/hd[gikmo]2
mdadm: /dev/hdg2 does not appear to have an MD superblock.
mdadm: /dev/hdi2 does not appear to have an MD superblock.
mdadm: /dev/hdk2 does not appear to have an MD superblock.
mdadm: /dev/hdm2 does not appear to have an MD superblock.
mdadm: /dev/hdo2 does not appear to have an MD superblock.
bucket:/# for i in /dev/hd[gikmo]2; do dd if=/dev/zero of=$i bs=1M count=100 ; done
100+0 records in
100+0 records out
104857600 bytes transferred in 2.967763 seconds (35332202 bytes/sec)
100+0 records in
100+0 records out
104857600 bytes transferred in 2.969712 seconds (35309012 bytes/sec)
100+0 records in
100+0 records out
104857600 bytes transferred in 2.973760 seconds (35260950 bytes/sec)
100+0 records in
100+0 records out
104857600 bytes transferred in 2.965225 seconds (35362443 bytes/sec)
100+0 records in
100+0 records out
104857600 bytes transferred in 2.976899 seconds (35223769 bytes/sec)
bucket:/# mdadm --create /dev/md1 --level=6 --chunk=128 --raid-devices=6 missing  /dev/hd[gikmo]2
mdadm: array /dev/md1 started.
bucket:/# mkreiserfs /dev/md1
mkreiserfs 3.6.17 (2003 www.namesys.com)

A pair of credits:
Continuing core development of ReiserFS is  mostly paid for by Hans Reiser from
money made selling licenses  in addition to the GPL to companies who don't want
it known that they use ReiserFS  as a foundation for their proprietary product.
And my lawyer asked 'People pay you money for this?'. Yup. Life is good. If you
buy ReiserFS, you can focus on your value add rather than reinventing an entire
FS.

Vitaly Fertman wrote  fsck for V3 and  maintains the reiserfsprogs package now.
He wrote librepair,  userspace plugins repair code, fsck for V4,  and worked on
developing libreiser4 and userspace plugins with Umka.


Guessing about desired format.. Kernel 2.6.7 is running.
Format 3.6 with standard journal
Count of blocks on the device: 244067328
Number of blocks consumed by mkreiserfs formatting process: 15660
Blocksize: 4096
Hash function used to sort names: "r5"
Journal Size 8193 blocks (first block 18)
Journal Max transaction length 1024
inode generation number: 0
UUID: 7fbea519-7d20-40dd-916c-d99136e6e347
ATTENTION: YOU SHOULD REBOOT AFTER FDISK!
	ALL DATA WILL BE LOST ON '/dev/md1'!
Continue (y/n):y
Initializing journal - 0%....20%....40%....60%....80%....100%
Syncing..ok

Tell your friends to use a kernel based on 2.4.18 or later, and especially not a
kernel based on 2.4.9, when you use reiserFS. Have fun.

ReiserFS is successfully created on /dev/md1.
bucket:/# dd if=/dev/urandom of=testfile bs=1M count=100
100+0 records in
100+0 records out
104857600 bytes transferred in 17.675100 seconds (5932504 bytes/sec)
bucket:/# mount /dev/md1 /mnt/root
bucket:/# cp testfile /mnt/root
bucket:/# umount /mnt/root
bucket:/# mount /dev/md1 /mnt/root
bucket:/# md5sum testfile /mnt/root/testfile
95454f5f81b58f89cdd2f6954d721302  testfile
3b9c4173f3c1c0b315938b5a864f411b  /mnt/root/testfile
bucket:/# exit

Script done on Tue Jul 27 14:15:21 2004

--VbJkn9YxBvnuCH5J--
