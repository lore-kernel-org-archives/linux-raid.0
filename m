From: Paul Downs <paul@positive-internet.com>
Subject: Odd linux raid problems with debian testing.
Date: Tue, 18 Mar 2003 18:18:59 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030318181859.GD18556@u4ia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,
  Sorry if this subject is already done to death on the group but I have
read the archives through google and couldn't find anything similar.  Also
apologies for the rather long winded post, just be thankful I didn't include
all the straces... ;-P

  I have an easily repeatable problem with software raid and kernel
2.4.18/19 + raidtools2 under debian.

  The root device (/dev/md0) has /dev/hda1 and /dev/hdc1. Here is a chunk of
the lilo.conf:

[----- lilo.conf -----]
# Specifies the boot device.  This is where Lilo installs its boot
# block.  It can be either a partition, or the raw device, in which
# case it installs in the MBR, and will overwrite the current MBR.
#
boot=/dev/hda

# Specifies the device that should be mounted as root. (`/')
#
root=/dev/hda1
[---------------------]

  You cannot do the following:

raidhotadd /dev/md0 /dev/hda1

  as it returns this:

/dev/md0: can not hot-add disk: invalid argument.

  an strace indicates:

open("/dev/md0", O_RDWR)                = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 0), ...}) = 0
stat64("/dev/hda1", {st_mode=S_IFBLK|0660, st_rdev=makedev(3, 1), ...}) = 0
ioctl(4, 0x928, 0x301)                  = -1 EINVAL (Invalid argument)
write(2, "/dev/md0: can not hot-add disk: ", 32/dev/md0: can not hot-add
disk: ) = 32
write(2, "invalid argument.\n", 18invalid argument.
)     = 18
exit_group(1)                           = ?

  the ioctl call should succeed.  Similar things occur with other raid
management tools, e.g. lsraid -A -a /dev/md0:

[dev   9,   0] /dev/md0         BC38988B.7A6BC5D2.5084B74A.88CE39EF online
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
[dev  22,   1] /dev/hdc1        BC38988B.7A6BC5D2.5084B74A.88CE39EF good

  and strace indicates that it isn't even attempting to acknowledge the
existence of /dev/hda1!! Which is valid, correctly partitioned and should be
in the raid.

  Attempting other operations on the disk shows that inodes are held open.

  Can anyone elighten me?  It appears to affect whatever root= device is
specified, however I thought i'd change it to /dev/hdc1 and boot but the
machine died and I had to use grub.

  So in summary:

1) am I being stupid?
2) is something wrong?
3) is this perhaps normal behaviour?

Thanks, any replies gratefully received at this point in time as I have
another 3 machines to set up in a similar fashion.

Paul
