From: Eddie Johnson <ejohnson@milleraa.com>
Subject: (no subject)
Date: Wed, 11 Sep 2002 14:27:58 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D7F8B2E.14D49808@milleraa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: ejohnson@milleraa.com
List-Id: linux-raid.ids

I installed Suse Linux Professional 8 on a HP Netserver LC3 PII/450.  An
AHA-2940 UW Scsi host adapter with a AIC-78XX Scsi Protocol Chip/50 pin
high density scsi-2 control.  I have a raid (3 drives) off the host
adapter and a 80 gig scsi drive off the mother board. After launching
yast2 the first raid has the following device: LD0 raid 5 34730R:
device_name /dev/sda, vendor megaraid.  Disk two (80 gig drive) has LD1
raid 0 70006R: device name /dev/sdb vendor the same as above.  There was
no raidtab file so I created one with the following:

raiddev /dev/md0
raid-level 5
nr-raid-disks 1(little sketchy on this because it is three drives that
make up the raid)
nr-spare-disks 0
persistent superblock 1
parity-algorithm left-symmetric
chunk-size 2048
device /dev/sda
raid-disk 0 (sketchy here as well)

#Second drive
raiddev /dev/md1
raid-level 5
nr-raid-disks 1
nr-spare-disks 0
persistent-superblock 1
chunk-size 2048
device /dev/sdb
raid-disks 1 (sketchy as well)

Trying to follow the procedures and I type:
mkraid /dev/md0 and I get:

Handling md device /dev/md0
analyzing super-block
disk 0: /dev/sda, 35563520kb, raid superblock at 35563456kb

Second drive I get:

Handling md deviice /dev/md1
analyzing super-block
disk 0: /dev/sdb, 71686144kb, raid superblock at 71686080kb

I then type cat /proc/mdstat and get the following:

Personalities [RAID5]
read_ahead not set
md1: inactive sdb [0]
     71684096 blocks
md0: inactive sda [0]
     35561472 blocks
unused devices: <none>

If I read this correctly both are inactive when it should be stating
that they are active.  At this point I am baffled any suggestions or
possible directions would greatly be appreciated.


Thanks in advance,
Ed

