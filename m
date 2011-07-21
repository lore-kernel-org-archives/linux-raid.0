From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/36] md patches for 3.1 - part 2: bad block logs
Date: Thu, 21 Jul 2011 12:58:47 +1000
Message-ID: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As promised this is the second of 2 patch-bombs full of patches
that I plan to submit for linux-3.1

While the first set was a varied assortment, these all have a very
strong theme.
This patch set implements a bad-block-log for RAID1, RAID456 and
RAID10.
i.e. the first thing on my "TODO list":
           http://neil.brown.name/blog/20110216044002


On v1.x metadata arrays created with a patched mdadm (which I'll post
a pointer to later) 4K of space is reserved to store a list of
known bad blocks.  When md hits an error, it can now fail just the
block instead of failing the whole device.  This should mean more
graceful failure modes when devices are producing bad blocks.

I have tested these a reasonable amount (and found a few bugs in the
process) but more testing is needed.  One difficulty with testing is
that you need the device to fail occasionally to exercise some of this
code.

One of my tests is below.  It inserts a 'faulty' md device between
the RAID5 and each real device and configures two of them to generate
persistent write errors at different rates.  The first "mkfs" causes
lots of bad blocks to get logged.  The second "mkfs" (after the
'faulty' targets are cleared and flushed) results in all those bad
blocks being successfully repaired and forgotten.
There are obviously lots of other combinations worth testing.

Testing both with the new mdadm and with the old one (or with 0.90
metadata which won't store bad-block lists) would be helpful.

Again, genuine "Reviewed-by" line are very welcome and will be added
if received before I submit this to Linus.

Thanks,
NeilBrown

(from the mdadm man page for "--grow" for faulty arrays:

              When setting the failure mode for level faulty, the options are:
              write-transient, wt, read-transient, rt,  write-persistent,  wp,
              read-persistent,  rp, write-all, read-fixable, rf, clear, flush,
              none.

              Each failure mode can be followed by a number, which is used  as
              a  period between fault generation.  Without a number, the fault
              is generated once on the first relevant request.  With a number,
              the  fault  will be generated after that many requests, and will
              continue to be generated every time the period elapses.

              Multiple failure modes can be current  simultaneously  by  using
              the --grow option to set subsequent failure modes.

              "clear"  or  "none"  will remove any pending or periodic failure
              modes, and "flush" will clear any persistent faults.
)

# test badblock code

mdadm -Ss
mdadm -B /dev/md10 -l faulty -n 1 /dev/sda
mdadm -B /dev/md11 -l faulty -n 1 /dev/sdb
mdadm -B /dev/md12 -l faulty -n 1 /dev/sdc
mdadm -B /dev/md13 -l faulty -n 1 /dev/sdd
./mdadm -CR /dev/md0 -l5 -n4 /dev/md1[0123] --assume-clean

mdadm -G /dev/md10 -l faulty -p wp8000
mdadm -G /dev/md11 -l faulty -p wp7000

mkfs /dev/md0

grep . /sys/block/md0/md/rd?/bad*

mdadm -S /dev/md0
mdadm -G /dev/md10 -l faulty -p clear
mdadm -G /dev/md10 -l faulty -p flush
mdadm -G /dev/md11 -l faulty -p clear
mdadm -G /dev/md11 -l faulty -p flush

mdadm -A /dev/md0 /dev/md1[0123]
mkfs /dev/md0
grep . /sys/block/md0/md/rd?/bad*



---

NeilBrown (36):
      md/raid10: handle further errors during fix_read_error better.
      md/raid10: Handle read errors during recovery better.
      md/raid10: simplify read error handling during recovery.
      md/raid10: record bad blocks due to write errors during resync/recovery.
      md/raid10:  attempt to fix read errors during resync/check
      md/raid10:  Handle write errors by updating badblock log.
      md/raid10: clear bad-block record when write succeeds.
      md/raid10: avoid writing to known bad blocks on known bad drives.
      md/raid10 record bad blocks as needed during recovery.
      md/raid10: avoid reading known bad blocks during resync/recovery.
      md/raid10 - avoid reading from known bad blocks - part 3
      md/raid10: avoid reading from known bad blocks - part 2
      md/raid10: avoid reading from known bad blocks - part 1
      md/raid10: Split handle_read_error out from raid10d.
      md/raid10: simplify/reindent some loops.
      md/raid5: Clear bad blocks on successful write.
      md/raid5.  Don't write to known bad block on doubtful devices.
      md/raid5: write errors should be recorded as bad blocks if possible.
      md/raid5: use bad-block log to improve handling of uncorrectable read errors.
      md/raid5: avoid reading from known bad blocks.
      md/raid1: factor several functions out or raid1d()
      md/raid1: improve handling of read failure during recovery.
      md/raid1: record badblocks found during resync etc.
      md/raid1:  Handle write errors by updating badblock log.
      md/raid1: store behind-write pages in bi_vecs.
      md/raid1: clear bad-block record when write succeeds.
      md/raid1: avoid writing to known-bad blocks on known-bad drives.
      md: make it easier to wait for bad blocks to be acknowledged.
      md: add 'write_error' flag to component devices.
      md/raid1: avoid reading known bad blocks during resync
      md/raid1: avoid reading from known bad blocks.
      md: Disable bad blocks and v0.90 metadata.
      md: load/store badblock list from v1.x metadata
      md: don't allow arrays to contain devices with bad blocks.
      md/bad-block-log: add sysfs interface for accessing bad-block-log.
      md: beginnings of bad block management.


 drivers/md/md.c           |  838 ++++++++++++++++++++++++++++++++++++-
 drivers/md/md.h           |   83 ++++
 drivers/md/raid1.c        |  923 ++++++++++++++++++++++++++++++++---------
 drivers/md/raid1.h        |   20 +
 drivers/md/raid10.c       | 1015 ++++++++++++++++++++++++++++++++++++---------
 drivers/md/raid10.h       |   16 +
 drivers/md/raid5.c        |  183 +++++++-
 drivers/md/raid5.h        |   21 +
 include/linux/raid/md_p.h |   14 -
 9 files changed, 2637 insertions(+), 476 deletions(-)

-- 
Signature

