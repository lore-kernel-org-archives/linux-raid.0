From: Gerald Hochegger <gerald.hochegger@uni-klu.ac.at>
Subject: Major incompatibility mdadm-2.5.6 mdadm-2.6.2
Date: Wed, 08 Aug 2007 17:53:59 +0200
Message-ID: <1186588439.13023.48.camel@linux0-zid>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

while manually failing devices and watching the
resync of raid1 md devices on our SAN (IBM DS4700)
I've encountered a weird problem:

I'm running Debian Etch
(kernel 2.6.18-4-xen-amd64, mdadm-2.5.6)

I've created a md raid1 device with (mdadm-2.5.6):

 mdadm --create /dev/md0 --level 1 --name=test-xm36 \
 --metadata=1.2 \  --raid-devices=2 \
 /dev/disk/by-id/scsi-3600a0b800026c162000006be46b81a74 \
 /dev/disk/by-id/scsi-3600a0b80002904d80000197946b818f0

assembling, failing, resyncing works like a charm

 mdadm --stop /dev/md0

 mdadm --assemble --auto=md /dev/md/test-xm36 \
 /dev/disk/by-id/scsi-3600a0b800026c162000006be46b81a74 \
 /dev/disk/by-id/scsi-3600a0b80002904d80000197946b818f0

 mdadm --fail /dev/md/test-xm36 \
 /dev/disk/by-id/scsi-3600a0b80002904d80000197946b818f0

 mdadm --stop /dev/md/test-xm36

 mdadm --assemble --auto=md /dev/md/test-xm36 ...

 mdadm --add /dev/md/test-xm36 \
 /dev/disk/by-id/scsi-3600a0b80002904d80000197946b818f0

/dev/md/test-xm36 gets resynced now without any problems

After installing a backported mdadm-2.6.2 (from Debian unstable)
and running the same --fail --stop --assemble and --add commands
on this md raid1 device (but no --create)
the re-adding of the device:

 mdadm --add /dev/md/test-xm36 \
 /dev/disk/by-id/scsi-3600a0b80002904d80000197946b818f0

fails with:
 mdadm: add new device failed for
  /dev/disk/by-id/scsi-3600a0b80002904d80000197946b818f0
  as 2: Invalid argument

and dmesg says:

 md: sdv has invalid sb, not importing!
 md: md_import_device returned -22

(/dev/sdv is
 /dev/disk/by-id/scsi-3600a0b80002904d80000197946b818f0)

Even a
 mdadm --zero-superblock \
 /dev/disk/by-id/scsi-3600a0b80002904d80000197946b818f0

or
 dd bs=1k if=/dev/zero \
 of=/dev/disk/by-id/scsi-3600a0b80002904d80000197946b818f0

or
 rebooting

does help ??

I'm not able to re-add the failed device with mdadm-2.6.2 !
Adding always fails with the above message.

Downgrading to mdadm-2.5.6 cures the problem.
After recreating the raid1 device with mdadm-2.6.2
the problem also vanishes.

It seems mdadm-2.6.2 has problems re-adding failed devices, when
the array was created with mdadm-2.5.6

This could be a major problem when people are upgrading
to Debian Etch+1 and can not resync failed raid1 devices
they have created with Etch mdadm-2.5.6

Please help,
Gerald


