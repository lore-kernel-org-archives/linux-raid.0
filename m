From: Janek Kozicki <janek_listy@wp.pl>
Subject: mismatch_cnt of 128 and 1408.
Date: Mon, 24 Mar 2008 08:36:51 +0100
Message-ID: <20080324083651.444cbab3@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

My backup box with raid5 recently suffered a series of power
failures. Now I'm doing some recovery hoping that power surges did
not damage HDDs.

I have here
- md0 a raid1 of 3*1GB=1GB (root partition) and
- md1 a raid5 of 3*500GB=1000GB (backup partition) and
- md2 a raid1 of 3*4GB=4GB (swap).

I did following things:

1. power on the server, and incidentally mount count for md1 enforced
   an fsck which found two errors.

2. /usr/share/mdadm/checkarray -a
   which does a resync of all raid partitions. It takes 5 hours for
   the 1TB backup partition.

3. afterwards the command: cat /sys/block/md?/md/mismatch_cnt gave answer:
   md0: 128
   md1: 0
   md2: 1408

4. touch /forcefsck ; shutdown -r now

5. then after reboot: /usr/share/mdadm/checkarray -a ; cat /sys/block/md?/md/mismatch_cnt
   md0: 128
   md1: 0
   md2: 1408

Now I am alarmed that something might be wrong with the root
partition. From other posts I remember that mismatch count for swap
partitions is allowed to be nonzero.

I checked smart health status of HDDs with smartctl -H and the drives
are healthy.


Is mismatch count = 128 an indication of bad HDD? How to discover
which one is bad?

-- 
Janek Kozicki                                                         |
