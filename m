From: Stefan Myankov <kotak@poco-loco.org>
Subject: Software RAID-5 attempt to access beyond end of device...
Date: Sat, 8 Feb 2003 01:03:04 +0200 (EET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0302080102440.8110@poco-loco.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



	Hello everyone,

Recently I had to set up a large file archive on-a x86 system. The setup
included two HPT374 ATA-RAID controllers which after testing prooved to be
inapropriate (poor performance, buggy drivers provided by the
manufacturer). So I decided to use the controllers only for their IDE
funcionality. After setting up the hard drives (10 Seagate Barracuda.7
7200/2048k cache) and cfdisking them to partition type
Linux-Raid-Autodetect I set-up a raidtab file containing the following:
 raiddev /dev/md0
        raid-level 5
                nr-raid-disks 5
                nr-spare-disks 0
                persistent-superblock 1
                chunk-size 256k
                parity-algorithm left-symmetric
                        device /dev/hdm1
                        raid-disk 0
                        device /dev/hdp1
                        raid-disk 1
                        device /dev/hdq1
                        raid-disk 2
                        device /dev/hds1
                        raid-disk 3
                        device /dev/hdt1
                        raid-disk 4

raiddev /dev/md1
        raid-level 5
                nr-raid-disks 5
                nr-spare-disks 0
                persistent-superblock 1
                chunk-size 256k
                parity-algorithm left-symmetric
                        device /dev/hde1
                        raid-disk 0
                        device /dev/hdf1
                        raid-disk 1
                        device /dev/hdg1
                        raid-disk 2
                        device /dev/hdi1
                        raid-disk 3
                        device /dev/hdk1
                        raid-disk 4
--
and created the arrays.
After several days of usage of the archive and when one of the arrays
reached 35% of its' capacity I noticed this error:

attempt to access beyond end of device
09:00: rw=0, want=1017335020, limit=625153024

This keeps showing up and I'm worried about data consistency. The
filesystem I use is reiserfs.

Please advise me where could be the problem.
Thanks in advance,
	Stefan Myankov
	PocoLoco Networks
