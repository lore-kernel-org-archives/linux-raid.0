From: Ryan_MichaelS@emc.com
Subject: md looping on recovery of raid1 array
Date: Sat, 7 Jul 2007 19:21:42 -0400
Message-ID: <D09BBFE8953B884BBAB9F6A5198837B70CA9FD6B@CORPUSMX50A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Md loops forever when attempting to recover a 2 disk raid 1 array:

Jul  7 16:32:35 soho user.info kernel: md: recovery of RAID array md0
Jul  7 16:32:35 soho user.info kernel: md: minimum _guaranteed_  speed:
1000 B/sec/disk.
Jul  7 16:32:35 soho user.info kernel: md: using maximum available idle
IO bandwidth (but not more than 200000 KB/sec) for recovery.
Jul  7 16:32:35 soho user.info kernel: md: using 128k window, over a
total of 2096384 blocks.
Jul  7 16:32:35 soho user.err kernel: scsi 1:0:0:0: rejecting I/O to
dead device
Jul  7 16:32:35 soho user.err kernel: scsi 1:0:0:0: rejecting I/O to
dead device
Jul  7 16:32:35 soho user.alert kernel: raid1: dm-1: unrecoverable I/O
read error for block 0
Jul  7 16:32:35 soho user.err kernel: scsi 1:0:0:0: rejecting I/O to
dead device
Jul  7 16:32:35 soho user.alert kernel: raid1: dm-1: unrecoverable I/O
read error for block 128
Jul  7 16:32:35 soho user.info kernel: md: md0: recovery done.
Jul  7 16:32:35 soho user.err kernel: scsi 1:0:0:0: rejecting I/O to
dead device
Jul  7 16:32:35 soho user.err kernel: scsi 1:0:0:0: rejecting I/O to
dead device
Jul  7 16:32:35 soho user.alert kernel: raid1: dm-1: unrecoverable I/O
read error for block 256
Jul  7 16:32:35 soho user.err kernel: scsi 1:0:0:0: rejecting I/O to
dead device
Jul  7 16:32:35 soho user.alert kernel: raid1: dm-1: unrecoverable I/O
read error for block 384
Jul  7 16:32:35 soho user.err kernel: scsi 1:0:0:0: rejecting I/O to
dead device
Jul  7 16:32:35 soho user.warn kernel: md: super_written gets error=-5,
uptodate=0
Jul  7 16:32:35 soho user.warn kernel: RAID1 conf printout:
Jul  7 16:32:35 soho user.warn kernel:  --- wd:1 rd:2
Jul  7 16:32:35 soho user.warn kernel:  disk 0, wo:1, o:1, dev:dm-7 Jul
7 16:32:35 soho user.warn kernel:  disk 1, wo:0, o:1, dev:dm-1
Jul  7 16:32:35 soho user.warn kernel: RAID1 conf printout:
Jul  7 16:32:35 soho user.warn kernel:  --- wd:1 rd:2
Jul  7 16:32:35 soho user.warn kernel:  disk 1, wo:0, o:1, dev:dm-1
Jul  7 16:32:35 soho user.warn kernel: RAID1 conf printout:
Jul  7 16:32:35 soho user.warn kernel:  --- wd:1 rd:2
Jul  7 16:32:35 soho user.warn kernel:  disk 0, wo:1, o:1, dev:dm-7
Jul  7 16:32:35 soho user.warn kernel:  disk 1, wo:0, o:1, dev:dm-1
Jul  7 16:32:35 soho user.info kernel: md: recovery of RAID array md0
...

This occurs after hotswap removing both drives of the raid1 array and
reinserting them.  The kernel version is 2.6.19.  Is anyone familiar
with this scenario?  Can anyone shed any light on what's happening here?

Thanks.
- Michael
