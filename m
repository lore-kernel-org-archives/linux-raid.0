From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md updates for 2.6.33 merge window
Date: Fri, 11 Dec 2009 13:37:30 +1100
Message-ID: <19233.45162.919445.731210@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Greetings,

 here is my offering for 2.6.33, to bring more goodness (and less
 badness?) to md/RAID.

 Probably the most significant thing is that we now support barriers
 on all raid levels, so I expect to hear complaints that RAID5 just
 got slower :-(

 There are also some changes to write-intent-bitmap handling so that
 the bitmaps can be inspected and manipulated through sysfs.

 and it is possible to convert a 2-disk RAID5 to RAID1 (so if you
 converted a RAID1 to RAID5 by mistake, you can now convert it back).

 ... as well as the usual mix of minor improvements and little bug
 fixes.

Thanks,
NeilBrown


The following changes since commit 3067e02f8f3ae2f3f02ba76400d03b8bcb4942b0:
  Linus Torvalds (1):
        Merge branch 'acpica' of git://git.kernel.org/.../lenb/linux-acpi-2.6

are available in the git repository at:

  git://neil.brown.name/md for-linus

Arnd Bergmann (1):
      md: move compat_ioctl handling into md.c

NeilBrown (22):
      md/bitmap: protect against bitmap removal while being updated.
      md/raid5: remove some sparse warnings.
      md: remove sparse warning:symbol XXX was not declared.
      md: adjust resync_min usefully when resync aborts.
      md: don't reset curr_resync_completed after an interrupted resync
      md: support barrier requests on all personalities.
      md/raid5: don't complete make_request on barrier until writes are scheduled
      md: add honouring of suspend_{lo,hi} to raid1.
      md/raid1: add takeover support for raid5->raid1
      md: collect bitmap-specific fields into one structure.
      md: move offset, daemon_sleep and chunksize out of bitmap structure
      md: change daemon_sleep to be in 'jiffies' rather than 'seconds'.
      md: remove needless setting of thread->timeout in raid10_quiesce
      md: support bitmap offset appropriate for external-metadata arrays.
      md: factor out parsing of fixed-point numbers
      md: support updating bitmap parameters via sysfs.
      md/bitmap: move setting of daemon_lastrun out of bitmap_read_sb
      md: Support write-intent bitmaps with externally managed metadata.
      md/bitmap: update dirty flag when bitmap bits are explicitly set.
      md: add MODULE_DESCRIPTION for all md related modules.
      md: revise Kconfig help for MD_MULTIPATH
      md: integrate spares into array at earliest opportunity.

Robert Becker (2):
      md/raid10: print more useful messages on device failure.
      raid: improve MD/raid10 handling of correctable read errors.

 Documentation/md.txt    |   45 +++++
 drivers/md/Kconfig      |    9 +-
 drivers/md/bitmap.c     |  449 +++++++++++++++++++++++++++++++++++++++++------
 drivers/md/bitmap.h     |   19 +--
 drivers/md/faulty.c     |    1 +
 drivers/md/linear.c     |    3 +-
 drivers/md/md.c         |  344 ++++++++++++++++++++++++++++--------
 drivers/md/md.h         |   51 ++++--
 drivers/md/multipath.c  |    3 +-
 drivers/md/raid0.c      |    3 +-
 drivers/md/raid1.c      |  217 +++++++++++++++--------
 drivers/md/raid1.h      |    5 +
 drivers/md/raid10.c     |  116 +++++++++++--
 drivers/md/raid5.c      |   63 +++++--
 drivers/md/raid6algos.c |   20 +--
 fs/compat_ioctl.c       |   22 ---
 include/linux/raid/pq.h |   19 ++
 17 files changed, 1077 insertions(+), 312 deletions(-)
