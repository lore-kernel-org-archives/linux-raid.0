From: raid+news@reguly.net
Subject: raidtools -> mdadm migration
Date: Tue, 14 May 2002 22:19:08 -0300 (BRT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0205142154470.23293-100000@plazarus.plazahoteis.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello, I am running Debian and RAID1 with XFS on top of it,
how do I migrate to the mdadm ?

In this migration process, I would like to try ext3 too
(already have that in my kernel).

this is my raidtab (both partitions are raid autodetect):

raiddev /dev/md0
 raid-level      1
 nr-raid-disks   2
 nr-spare-disks  0
# chunk-size      32
 persistent-superblock 1

 device          /dev/sda2
 raid-disk       0

 device          /dev/sdb2
 raid-disk       1
# failed-disk	 1


All this need to be done via ssh (well if I screw up I can have fisical
access to the box, but it is on the other side of the city). Backup is
already done (will do again of course).

If anyone has written some sort of howto do this migration, please let me
know.

Thanks.

-- 
Alvaro





