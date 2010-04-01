From: Mark Knecht <markknecht@gmail.com>
Subject: RAID1 on logical partitions?
Date: Thu, 1 Apr 2010 07:31:53 -0700
Message-ID: <y2h5bdc1c8b1004010731g6c696517s28d184d1a8cfdf93@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   On this new machine that I've been playing with I'm interested in
doing a chroot install of Gentoo onto RAID1. As partitions 1, 2 & 3
are taken with the first install I created an extended partition and
then a new logical partition intending /dev/sdX5 to be the new
install. I do intend to boot this install later, but for now it's just
chroot.

   When I attempt to create the RAID I get the message shown below
about "mdadm: Note: this array has metadata at the start..."

QUESTIONS:

1) Is there anything special about RAID on logical partitions that I
should be careful about? Do I need to move the partition start away
from the beginning of the logical partition?

2) As I do intend to put / for the new install on this RAID does grub
as a boot-loader understand md/v1.x metadata?

3) My (multiple) boot partitions are not RAID so they will start and
provide the grub menu choices, but do I need to do anything other than
include RAID1 in the kernel to then boot /dev/md5 - the RAID built
using /dev/sdX5?

Thanks,
Mark

keeper ~ # fdisk -l /dev/sda /dev/sdb /dev/sdc

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x1d23ae47

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          14      112423+  83  Linux
/dev/sda2              16         538     4200997+  83  Linux
/dev/sda3            2048        5964    31463302+  83  Linux
/dev/sda4            6000      121601   928573065    5  Extended
/dev/sda5            6000       19054   104864256   83  Linux

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x85959094

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1          14      112423+  83  Linux
/dev/sdb2              16         538     4200997+  83  Linux
/dev/sdb4            6000      121601   928573065    5  Extended
/dev/sdb5            6000       19054   104864256   83  Linux

Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x70d12429

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1          14      112423+  83  Linux
/dev/sdc2              16         538     4200997+  83  Linux
/dev/sdc4            6000      121601   928573065    5  Extended
/dev/sdc5            6000       19054   104864256   83  Linux
keeper ~ #

keeper ~ # mdadm --create /dev/md5 --level=1 --raid-devices=3
/dev/sda5 /dev/sdb5 /dev/sdc5
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/' or '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=1.0
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/' or '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=1.0
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/' or '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=1.0
Continue creating array? n
mdadm: create aborted.
keeper ~ #
