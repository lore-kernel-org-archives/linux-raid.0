From: Scott Walker <crimson@unspeakable.org>
Subject: Issues with Raid1 on a SS20 running 2.4.20
Date: 09 Jun 2003 21:33:41 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1055208821.22414.3.camel@ninja.crib.unspeakable.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a SS20 with 2 18G disks in it. Both disks are identical Here is
my config setup.


raiddev                 /dev/md2
raid-level              1
nr-raid-disks           2
nr-spare-disks          0
chunk-size              4
persistent-superblock   1

device                  /dev/sda6
raid-disk               0
device                  /dev/sdb6
raid-disk               1

I have Raid and Raid1 compiled into Kernel 2.4.20.

Below is what happens when I fsck a raid device, Either on start or from
cli.

(none):~# fsck /tmp
fsck 1.33 (21-Apr-2003)
e2fsck 1.33 (21-Apr-2003)
The filesystem size (according to the superblock) is 255626 blocks
The physical size of the device is 255600 blocks
Either the superblock or the partition table is likely to be corrupt!
Abort<y>? 

If I mount -a I get it mounted with no issues and the files systesm
works perfectly.

md: raid1 personality registered as nr 3
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.

Above is the line from the kernel boot up


I'm at a loss. Does anyone have some info?

