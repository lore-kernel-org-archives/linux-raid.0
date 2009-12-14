From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md updates for 2.6.33 merge window
Date: Mon, 14 Dec 2009 16:34:19 +1100
Message-ID: <19237.52827.142258.858859@notabene.brown>
References: <19233.45162.919445.731210@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19233.45162.919445.731210@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


I think my previous pull request suffered from some conflicts with the
compat_ioctl changes.
Here is a new one with a couple of small additions from Dan Williams.

Thanks,
NeilBrown




The following changes since commit f40542532e96dda5506eb76badea322f2ae4731c:
  Linus Torvalds (1):
        Merge branch 'ixp4xx' of git://git.kernel.org/.../chris/linux-2.6

are available in the git repository at:

  git://neil.brown.name/md for-linus

Arnd Bergmann (1):
      md: move compat_ioctl handling into md.c

Dan Williams (2):
      md: rcu_read_lock() walk of mddev->disks in md_do_sync()
      md: add 'recovery_start' per-device sysfs attribute

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

 Documentation/md.txt    |   72 +++++++-
 drivers/md/Kconfig      |    9 +-
 drivers/md/bitmap.c     |  449 +++++++++++++++++++++++++++++++++++++++++------
 drivers/md/bitmap.h     |   19 +--
 drivers/md/faulty.c     |    1 +
 drivers/md/linear.c     |    3 +-
 drivers/md/md.c         |  393 +++++++++++++++++++++++++++++++++--------
 drivers/md/md.h         |   51 ++++--
 drivers/md/multipath.c  |    3 +-
 drivers/md/raid0.c      |    3 +-
 drivers/md/raid1.c      |  217 +++++++++++++++--------
 drivers/md/raid1.h      |    5 +
 drivers/md/raid10.c     |  116 +++++++++++--
 drivers/md/raid5.c      |   63 +++++--
 drivers/md/raid6algos.c |   20 +--
 fs/compat_ioctl.c       |   18 --
 include/linux/raid/pq.h |   19 ++
 17 files changed, 1146 insertions(+), 315 deletions(-)
