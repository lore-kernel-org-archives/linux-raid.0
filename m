From: "Gernot A. Weber" <gernot@tux-web.de>
Subject: Failed Raid 5
Date: Thu, 7 Nov 2002 20:56:00 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0211072051220.2926-100000@kopernikus.tux-web.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I just got home from holidays... And when I tried to read my mails I
noticed a drive og my raid 5 was marked as faulty. When reconstructing it
another drive seemed to failed - but I think there was some trouble with
my SCSI controller and another drive was marked as faulty...

How can I try to recover the raid. The first and third disk should be
fine.

Here is my raidtab:

raiddev                 /dev/md3
raid-level              5
nr-raid-disks           3
chunk-size              128
persistent-superblock   1
parity-algorithm        left-symmetric
device                  /dev/sda6
raid-disk               0
device                  /dev/sdb6
raid-disk               1
device                  /dev/sdc6
raid-disk               2


when trying to make a raidstart /dev/md3, I get the following output in
/var/log/messages:

 20:22:29 kopernikus kernel:  [events: 000000eb]
Nov  7 20:22:29 kopernikus kernel:  [events: 000000ec]
Nov  7 20:22:29 kopernikus kernel:  [events: 000000ec]
Nov  7 20:22:29 kopernikus kernel: md: autorun ...
Nov  7 20:22:29 kopernikus kernel: md: considering
scsi/host0/bus0/target1/lun0/part6 ...
Nov  7 20:22:29 kopernikus kernel: md:  adding
scsi/host0/bus0/target1/lun0/part6 ...
Nov  7 20:22:29 kopernikus kernel: md:  adding
scsi/host0/bus0/target2/lun0/part6 ...
Nov  7 20:22:29 kopernikus kernel: md:  adding
scsi/host0/bus0/target0/lun0/part6 ...
Nov  7 20:22:29 kopernikus kernel: md: created md3
Nov  7 20:22:29 kopernikus kernel: md:
bind<scsi/host0/bus0/target0/lun0/part6,1>
Nov  7 20:22:29 kopernikus kernel: md:
bind<scsi/host0/bus0/target2/lun0/part6,2>
Nov  7 20:22:29 kopernikus kernel: md:
bind<scsi/host0/bus0/target1/lun0/part6,3>
Nov  7 20:22:29 kopernikus kernel: md: running:
<scsi/host0/bus0/target1/lun0/part6><scsi/host0/bus0/target2/lun0/part6><scsi/host0/bus0/target0/lun0/part6>
Nov  7 20:22:29 kopernikus kernel: md:
scsi/host0/bus0/target1/lun0/part6's event counter: 000000ec
Nov  7 20:22:29 kopernikus kernel: md:
scsi/host0/bus0/target2/lun0/part6's event counter: 000000ec
Nov  7 20:22:29 kopernikus kernel: md:
scsi/host0/bus0/target0/lun0/part6's event counter: 000000eb
Nov  7 20:22:29 kopernikus kernel: md: freshest:
scsi/host0/bus0/target1/lun0/part6
Nov  7 20:22:29 kopernikus kernel: md3: kicking faulty
scsi/host0/bus0/target0/lun0/part6!
Nov  7 20:22:29 kopernikus kernel: md:
unbind<scsi/host0/bus0/target0/lun0/part6,2>
Nov  7 20:22:29 kopernikus kernel: md:
export_rdev(scsi/host0/bus0/target0/lun0/part6)
Nov  7 20:22:29 kopernikus kernel: md3: max total readahead window set to
1024k
Nov  7 20:22:29 kopernikus kernel: md3: 2 data-disks, max readahead per
data-disk: 512k
Nov  7 20:22:29 kopernikus kernel: raid5: spare disk
scsi/host0/bus0/target1/lun0/part6
Nov  7 20:22:29 kopernikus kernel: raid5: device
scsi/host0/bus0/target2/lun0/part6 operational as raid disk 2
Nov  7 20:22:29 kopernikus kernel: RAID5 conf printout:
Nov  7 20:22:29 kopernikus kernel:  --- rd:3 wd:1 fd:2
Nov  7 20:22:29 kopernikus kernel:  disk 0, s:0, o:0, n:0 rd:0 us:1
dev:[dev 00:00]
Nov  7 20:22:29 kopernikus kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1
dev:[dev 00:00]
Nov  7 20:22:29 kopernikus kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1
dev:scsi/host0/bus0/target2/lun0/part6
Nov  7 20:22:29 kopernikus kernel: md :do_md_run() returned -22
Nov  7 20:22:29 kopernikus kernel: md: md3 stopped.
Nov  7 20:22:29 kopernikus kernel: md:
unbind<scsi/host0/bus0/target1/lun0/part6,1>
Nov  7 20:22:29 kopernikus kernel: md:
export_rdev(scsi/host0/bus0/target1/lun0/part6)
Nov  7 20:22:29 kopernikus kernel: md:
unbind<scsi/host0/bus0/target2/lun0/part6,0>
Nov  7 20:22:29 kopernikus kernel: md:
export_rdev(scsi/host0/bus0/target2/lun0/part6)
Nov  7 20:22:29 kopernikus kernel: md: ... autorun DONE.
Nov  7 20:26:27 kopernikus kernel:  [events: 000000ec]
Nov  7 20:26:27 kopernikus kernel: md:
bind<scsi/host0/bus0/target2/lun0/part6,1>
Nov  7 20:26:27 kopernikus kernel:  [events: 000000eb]
Nov  7 20:26:27 kopernikus kernel: md:
bind<scsi/host0/bus0/target0/lun0/part6,2>


I hope somebody out there is able to help me :))

Thanks,

   Gernot

