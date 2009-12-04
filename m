From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/22] MD patches queued for 2.6.33
Date: Fri, 04 Dec 2009 17:48:01 +1100
Message-ID: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

 As 2.6.32 is now out I thought it was well past time to publish my
 current queue of patched for the 2.6.33 merge window.

 Many of these have been sitting in my queue for a while but some are
 newly written or re-written (I found more problems with the 'barrier'
 handling).
 So I will need to do some testing before I ask Linus to pull them.

 Any review that anyone cares to do will be greatly appreciated.

Thanks,
NeilBrown


---

Arnd Bergmann (1):
      md: move compat_ioctl handling into md.c

NeilBrown (19):
      md/bitmap: protect against bitmap removal while being updated.
      md: adjust resync_min usefully when resync aborts.
      md: don't reset curr_resync_completed after an interrupted resync
      md: support barrier requests on all personalities.
      md/raid5: don't complete make_request on barrier until writes are scheduled
      md: add honouring of suspend_{lo,hi} to raid1.
      md/raid1: add takeover support for raid5->raid1
      md: remove sparse warning:symbol XXX was not declared.
      md: collect bitmap-specific fields into one structure.
      md: move offset, daemon_sleep and chunksize out of bitmap structure
      md: change daemon_sleep to be in 'jiffies' rather than 'seconds'.
      md: remove needless setting of thread->timeout in raid10_quiesce
      md: support bitmap offset appropriate for external-metadata arrays.
      md: support updating bitmap parameters via sysfs.
      md: Support write-intent bitmaps with externally managed metadata.
      md/bitmap: update dirty flag when bitmap bits are explicitly set.
      md: add MODULE_DESCRIPTION for all md related modules.
      md: revise Kconfig help for MD_MULTIPATH
      md: integrate spares into array at earliest opportunity.

Robert Becker (2):
      md/raid10: print more useful messages on device failure.
      raid: improve MD/raid10 handling of correctable read errors.


 drivers/md/Kconfig      |    9 -
 drivers/md/bitmap.c     |  450 +++++++++++++++++++++++++++++++++++++++++------
 drivers/md/bitmap.h     |   19 --
 drivers/md/faulty.c     |    1 
 drivers/md/linear.c     |    3 
 drivers/md/md.c         |  289 +++++++++++++++++++++++++-----
 drivers/md/md.h         |   48 ++++-
 drivers/md/multipath.c  |    3 
 drivers/md/raid0.c      |    3 
 drivers/md/raid1.c      |  219 +++++++++++++++--------
 drivers/md/raid1.h      |    5 +
 drivers/md/raid10.c     |  116 +++++++++++-
 drivers/md/raid5.c      |   60 +++++-
 drivers/md/raid6algos.c |   20 --
 fs/compat_ioctl.c       |   22 --
 include/linux/raid/pq.h |   19 ++
 16 files changed, 997 insertions(+), 289 deletions(-)

-- 
Signature

