From: "Andrey ``Bass'' Shcheglov" <andrewbass@gmail.com>
Subject: Repairing a RAID1 with non-zero mismatch_cnt
Date: Mon, 20 Jan 2020 13:02:21 +0300
Message-ID: <CADSg1Jh1i+OPq0_hWOvHxK0xroUbn_w0_ZjxjwcnrbSsBXGY5A@mail.gmail.com>
Reply-To: andrewbass@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I have a question on how to repair a RAID1 array (consisting of 2
physical hard drives, metadata version 1.2) which went split-brain.

One of my md-devices repeatedly shows a non-zero mismatch_cnt:

# cat /sys/block/md4/md/mismatch_cnt
1024

Zeroing out free space (with `zerofree`, as recommended here:
<http://decafbad.net/2017/01/03/mismatch_cnt,-raid1,-and-a-clever-fix/>)
and disabling the swap both retain the mismatch count at the very same
level.
Also, none of the drives is failing (18x and 19x SMART attributes are ok).
Checking file systems (ext4) doesn't show any problem, either, so the
file system metadata is most probably correct, too.

The usual suspects ruled out, I'm starting to think it my data got
corrupted, and at least one out of two replicas is affected.
Of course I can

# echo repair > /sys/block/md0/md/sync_action

but I have a 50% chance of losing information stored on the "right" replica.


So, assuming my /dev/md0 is now assembled from /dev/sda1 and /dev/sdb1,
I feel like assemble and run two separate degraded mirrors from
/dev/sda1 and /dev/sdb1, respectively (`mdadm -A`),
mount the corresponding file systems R/O,
create two backups (one backup per replica)
and then compare them with each other (`diff -urN`).


The question is: is it possible to assemble an array in a read-only mode,
so that the underlying block device is never written to,
the metadata in the superblock remains intact and the event count is
not incremented?

My intention is to avoid the resync when my original /dev/md0 is
reassembled from /dev/sda1 and /dev/sdb1.


If you have any other recommendations on how to interactively repair
the array (I want to be able to peek at the data being synced),
I'd appreciate you sharing them.

Regards,
Andrey.
