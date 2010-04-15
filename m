From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/28] md patches destined for -next and the next merge
	window
Date: Thu, 15 Apr 2010 16:21:07 +1000
Message-ID: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
 I thought it was time I posted my patch queue for review to be sure
 it would be ready for the next merge window.

 Apart from sundry bug fixes and minor improvements there are two big
 themes here
 1/ enhancements to level conversion so e.g. we can now convert RAID0
    to RAID5 or RAID10 (near-2 only) and back.
 2/ general refactoring of bits of md code - some functions
    (e.g. do_md_stop) had become really big and were just a mess of
    stuff that all had to be done at much the same time.  It is now
    broken into somewhat meaningful parts.  There is a deeper reason
    for doing this refactoring .... you'll find out soon. :-)

 This is all available at
    git://neil.brown.name/md for-next
 and should be in linux-next in a day or two.


 All review, testing, and comments most welcome.

 Unfortunately it doesn't contain a fix for
   https://bugzilla.kernel.org/show_bug.cgi?id=15464

 I stared at that for some time and haven't made any headway.

NeilBrown

---

H Hartley Sweeten (1):
      drivers/md: Remove unnecessary casts of void *

Maciej Trela (2):
      md: Correctly handle device removal via sysfs
      md: notify level changes through sysfs.

NeilBrown (21):
      md: remove some dead fields from mddev_s
      md: discard StateChanged device flag.
      md: don't use mddev->raid_disks in raid0 or raid10 while array is active.
      md: Relax checks on ->max_disks when external metadata handling is used.
      md: remove unneeded sysfs files more promptly
      md: manage redundancy group in sysfs when changing level.
      md: add support for raid5 to raid4 conversion
      md/raid5: small tidyup in raid5_align_endio
      md: move io accounting out of personalities into md_make_request
      md: don't reference gendisk in getgeo
      md: remove ->changed and related code.
      md: factor do_md_run to separate accesses to ->gendisk
      md: start to refactor do_md_stop
      md: factor md_stop_writes out of do_md_stop.
      md: split md_set_readonly out of do_md_stop
      md: call md_stop_writes from md_stop
      md: pass mddev to make_request functions rather than request_queue
      md: factor out init code for an mddev
      md: don't unregister the thread in mddev_suspend
      md/raid1: fix confusing 'redirect sector' message.
      md/raid1: delay reads that could overtake behind-writes.

Paul Clements (1):
      md: expose max value of behind writes counter

Trela Maciej (1):
      md:Add support for Raid0->Raid5 takeover

Trela, Maciej (2):
      md: Add support for Raid5->Raid0 and Raid10->Raid0 takeover
      md: Add support for Raid0->Raid10 takeover


 drivers/md/bitmap.c    |   41 ++++-
 drivers/md/bitmap.h    |    2 
 drivers/md/faulty.c    |    9 -
 drivers/md/linear.c    |   15 --
 drivers/md/md.c        |  437 +++++++++++++++++++++++++++++-------------------
 drivers/md/md.h        |   10 -
 drivers/md/multipath.c |   13 -
 drivers/md/raid0.c     |  155 ++++++++++++++---
 drivers/md/raid0.h     |    3 
 drivers/md/raid1.c     |   52 +++---
 drivers/md/raid10.c    |  231 +++++++++++++++++--------
 drivers/md/raid10.h    |   12 +
 drivers/md/raid5.c     |   78 ++++++---
 13 files changed, 699 insertions(+), 359 deletions(-)

-- 
Signature

