From: Jim Paris <jim@jtan.com>
Subject: Zeroing multiple superblocks
Date: Fri, 22 Jan 2010 15:09:24 -0500
Message-ID: <20100122200924.GA29183@psychosis.jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Should --zero-superblock be changed to clear all superblocks,
or at least warn when not all superblocks are cleared?

I ran into a problem a year ago where I had a disk with both 0.90 and
1.0 format metadata.  The wrong one was scanned at boot, causing a
"doesn't match others - assembly aborted" error.  At the time, I
thought I fixed it by doing a --zero-superblock and re-adding the
disk, but it turns out the disk still had two, causing the same
problem (reboots are rare on this machine).

For example:
  # dd if=/dev/zero of=diskimage bs=1M count=8
  # losetup -fv diskimage
  Loop device is /dev/loop0
  # mdadm --create /dev/md0 --level=1 --metadata=0.90 --raid-devices=2 /dev/loop0 missing
  mdadm: array /dev/md0 started.
  # mdadm --stop /dev/md0
  mdadm: stopped /dev/md0
  # mdadm --create /dev/md0 --level=1 --metadata=1.0 --raid-devices=2 /dev/loop0 missing
  mdadm: /dev/loop0 appears to be part of a raid array:
      level=raid1 devices=2 ctime=Fri Jan 22 14:55:26 2010
  Continue creating array? y
  mdadm: array /dev/md0 started.
  # mdadm --stop /dev/md0

Now notice how --zero-superblock has to be run twice before it starts
complaining that no superblock was found:
  # mdadm --zero-superblock /dev/loop0
  # mdadm --zero-superblock /dev/loop0
  # mdadm --zero-superblock /dev/loop0
  mdadm: Unrecognised md component device - /dev/loop0

I guess the only way to be fully safe with the current approach is to
do a zero-superblock over and over until it complains.

-jim
