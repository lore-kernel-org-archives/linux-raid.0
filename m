From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/16] hot-replace support for RAID4/5/6
Date: Wed, 26 Oct 2011 12:43:00 +1100
Message-ID: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The following series - on top of my for-linus branch which should appear in
3.2-rc1 eventually - implements hot-replace for RAID4/5/6.  This is almost
certainly the most requested feature over the last few years.
The whole series can be pulled from my md-devel branch:
   git://neil.brown.name/md md-devel
(please don't do a full clone, it is not a very fast link).

There is currently no mdadm support, but you can test it out and
experiment without mdadm.

In order to activate hot-replace you need to mark the device as
'replaceable'.
This happens automatically when a write error is recorded in a
bad-block log (if you happen to have one).
It can be achieved manually by
   echo replaceable > /sys/block/mdXX/md/dev-YYY/state

This makes YYY, in XX, replaceable.

If md notices that there is a replaceable drive and a spare it will
attach the spare to the replaceable drive and mark it as a
'replacement'.
This word appears in the 'state' file and as (R) in /proc/mdstat.

md will then copy data from the replaceable drive to the replacement.
If there is a bad block on the replaceable drive, it will get the data
from elsewhere.  This looks like a "recovery" operation.

When the replacement completes the replaceable device will be marked
as Failed and will be disconnected from the array (i.e. the 'slot'
will be set to 'none') and the replacement drive will take up full
possession of that slot.

It is not possible to assemble an array with replacement with mdadm.
To do this by hand:

  mknod /dev/md27 b 9 27
  < /dev/md27
  cd /sys/block/md27/md
  echo 1.2 > metadata_version
  echo 8:1 > new_dev
  echo 8:17 > new_dev
   ...
  echo active > array_state

Replace '27' by the md number you want.  Replace 1.2 by the metadata
version number (must be 1.x for some x).  Replace 8:1, 8:17 etc
by the major:minor numbers of each device in the array.

Yes: this is clumsy.  But they you aren't doing this on live data -
only on test devices to experiment.

You can still assemble the array without the replacement using mdadm.
Just list all the drives except the replacement in the --assemble
command.
Also once the replacement operation completes you can of course stop
and assemble the new array with old mdadm.

I hope to submit this together with support for RAID10 (and maybe some
minimal support for RAID1) for Linux-3.3. By the time it comes out
mdadm-3.3 should exist will full support for hot-replace.

Review and testing is very welcome, be please do not try it on live
data.

NeilBrown


---

NeilBrown (16):
      md/raid5: Mark device replaceable when we see a write error.
      md/raid5: If there is a spare and a replaceable device, start replacement.
      md/raid5: recognise replacements when assembling array.
      md/raid5: handle activation of replacement device when recovery completes.
      md/raid5:  detect and handle replacements during recovery.
      md/raid5: writes should get directed to replacement as well as original.
      md/raid5: allow removal for failed replacement devices.
      md/raid5: preferentially read from replacement device if possible.
      md/raid5: remove redundant bio initialisations.
      md/raid5: raid5.h cleanup
      md/raid5: allow each slot to have an extra replacement device
      md: create externally visible flags for supporting hot-replace.
      md: change hot_remove_disk to take an rdev rather than a number.
      md: remove test for duplicate device when setting slot number.
      md: take after reference to mddev during sysfs access.
      md: refine interpretation of "hold_active == UNTIL_IOCTL".


 Documentation/md.txt      |   22 ++
 drivers/md/md.c           |  132 ++++++++++---
 drivers/md/md.h           |   82 +++++---
 drivers/md/multipath.c    |    7 -
 drivers/md/raid1.c        |    7 -
 drivers/md/raid10.c       |    7 -
 drivers/md/raid5.c        |  462 +++++++++++++++++++++++++++++++++++----------
 drivers/md/raid5.h        |   98 +++++-----
 include/linux/raid/md_p.h |    7 -
 9 files changed, 599 insertions(+), 225 deletions(-)

-- 
Signature

