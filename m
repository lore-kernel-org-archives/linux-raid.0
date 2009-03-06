From: PGNet <pgnet.trash+raid@gmail.com>
Subject: /boot & non-"/" LVs on RAID-1 fail to mount in SingleUser mode; ok in
	'normal' boot
Date: Fri, 6 Mar 2009 13:22:03 -0800
Message-ID: <dbd51810903061322u1fc299el4e45dfee513d9294@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(trying to convince myself whether this is a config prob, or a bug ...)

my openSUSE 11.1 has all its partitions on RAID-1

"/boot" is on an ext3 formatted partition,

    grep boot /etc/fstab
        /dev/md0   /boot   ext3   acl,user_xattr   1 2

other partitions are on LVs

 pvs
  PV         VG    Fmt  Attr PSize    PFree
  /dev/md1   VGS   lvm2 a-   508.00M        0
  /dev/md2   VG0   lvm2 a-    11.97G        0
  /dev/md3   VG1   lvm2 a-   220.23G  178.23G

 grep VG /etc/fstab
  /dev/VG0/LV_ROOT        /           ext3  acl,user_xattr 1 1
  /dev/mapper/VGS-LV_SWAP swap        swap  defaults       0 0
  /dev/VG1/stor           /home/stor  ext3  defaults       0 2
  /dev/VG1/work           /home/work  ext3  defaults       0 2

unders 'normal' boot, it works fine.

booting into single user mode, however, only "/" mounts/appears,

 df -H
  Filesystem              Size   Used  Avail Use% Mounted on
  /dev/mapper/VG0-LV_ROOT  13G   4.5G   7.6G  37% /
  sysfs                    13G   4.5G   7.6G  37% /sys
  debugfs                  13G   4.5G   7.6G  37% /sys/kernel/debug
  udev                    4.2G    95k   4.2G   1% /dev
  devpts                  4.2G    95k   4.2G   1% /dev/pts
  none                    135M      0   135M   0% /tmp

 -- /boot and the other VG1 LVs are missing :-/

attempting to mount returns,

    mount -a
        mount: special device /dev/md0 does not exist
        mount: special device /dev/VG1/stor does not exist
        mount: special device /dev/VG1/work does not exist

and, checking,

    ls -al /boot

it's, not suprisingly, (empty)

how do i correctly set up so that "/boot" (and other, non-"/" parts, as above)
is correctly mounted in single-user mode?

is this a config problem on my part, a bug in md, or something else?

thanks.
