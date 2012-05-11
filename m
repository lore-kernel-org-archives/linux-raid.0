From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 0/7] bcache: md conversion
Date: Fri, 11 May 2012 12:46:11 -0700
Message-ID: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

The consensus from LSF was that bcache need not invent a new interface
when md and dm can both do the job.  As mentioned in patch 7 this series
aims to be a minimal conversion.  Other refactoring items like
deprecating register_lock for mddev->reconfig_mutex are deferred.

This supports assembly of an already established cache array:

	mdadm -A /dev/md/bcache /dev/sd[ab]

...will create the /dev/md/bcache container and a subarray representing
the cache volume.  "Flash-only", or backing-device only volumes were not
tested.  "Create" support and hot-add/hot-remove come later.

Note:
* When attempting to test with small loopback devices (100MB), assembly
  soft locks in bcache_journal_read().  That hang went away with larger
  devices, so there seems to be minimum component device size that needs
  to be considered in the tooling.

---

Dan Williams (7):
      bcache: compile fix
      bcache: disable lockdep, enable CONFIG_BCACHE=m
      bcache: drop select COMPACTION
      bcache: fix symlink removal
      bcache: move to drivers/md/
      bcache: uplevel allocation of 'cached_dev' and 'cache'
      md: add bcache personality


 drivers/block/Kconfig            |    2 
 drivers/block/Makefile           |    1 
 drivers/md/Kconfig               |   14 +
 drivers/md/Makefile              |    1 
 drivers/md/bcache/Kconfig        |    3 
 drivers/md/bcache/Makefile       |    2 
 drivers/md/bcache/alloc.c        |    0 
 drivers/md/bcache/bcache.h       |   39 ++++
 drivers/md/bcache/bset.c         |    0 
 drivers/md/bcache/bset.h         |    0 
 drivers/md/bcache/btree.c        |   18 --
 drivers/md/bcache/btree.h        |    0 
 drivers/md/bcache/debug.c        |    0 
 drivers/md/bcache/debug.h        |    0 
 drivers/md/bcache/io.c           |    0 
 drivers/md/bcache/journal.c      |    0 
 drivers/md/bcache/journal.h      |    0 
 drivers/md/bcache/md.c           |  374 ++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/request.c      |   24 +-
 drivers/md/bcache/request.h      |    0 
 drivers/md/bcache/stats.c        |    0 
 drivers/md/bcache/stats.h        |    0 
 drivers/md/bcache/super.c        |  394 +++++++++-----------------------------
 drivers/md/bcache/sysfs.c        |   49 -----
 drivers/md/bcache/sysfs.h        |    0 
 drivers/md/bcache/trace.c        |    0 
 drivers/md/bcache/util.c         |    2 
 drivers/md/bcache/util.h         |    3 
 drivers/md/bcache/writeback.c    |    0 
 kernel/lockdep.c                 |    1 
 30 files changed, 539 insertions(+), 388 deletions(-)
 rename drivers/{block/bcache/Kconfig => md/bcache/Kconfig} (95%)
 rename drivers/{block/bcache/Makefile => md/bcache/Makefile} (77%)
 rename drivers/{block/bcache/alloc.c => md/bcache/alloc.c} (100%)
 rename drivers/{block/bcache/bcache.h => md/bcache/bcache.h} (94%)
 rename drivers/{block/bcache/bset.c => md/bcache/bset.c} (100%)
 rename drivers/{block/bcache/bset.h => md/bcache/bset.h} (100%)
 rename drivers/{block/bcache/btree.c => md/bcache/btree.c} (99%)
 rename drivers/{block/bcache/btree.h => md/bcache/btree.h} (100%)
 rename drivers/{block/bcache/debug.c => md/bcache/debug.c} (100%)
 rename drivers/{block/bcache/debug.h => md/bcache/debug.h} (100%)
 rename drivers/{block/bcache/io.c => md/bcache/io.c} (100%)
 rename drivers/{block/bcache/journal.c => md/bcache/journal.c} (100%)
 rename drivers/{block/bcache/journal.h => md/bcache/journal.h} (100%)
 create mode 100644 drivers/md/bcache/md.c
 rename drivers/{block/bcache/request.c => md/bcache/request.c} (98%)
 rename drivers/{block/bcache/request.h => md/bcache/request.h} (100%)
 rename drivers/{block/bcache/stats.c => md/bcache/stats.c} (100%)
 rename drivers/{block/bcache/stats.h => md/bcache/stats.h} (100%)
 rename drivers/{block/bcache/super.c => md/bcache/super.c} (83%)
 rename drivers/{block/bcache/sysfs.c => md/bcache/sysfs.c} (95%)
 rename drivers/{block/bcache/sysfs.h => md/bcache/sysfs.h} (100%)
 rename drivers/{block/bcache/trace.c => md/bcache/trace.c} (100%)
 rename drivers/{block/bcache/util.c => md/bcache/util.c} (99%)
 rename drivers/{block/bcache/util.h => md/bcache/util.h} (99%)
 rename drivers/{block/bcache/writeback.c => md/bcache/writeback.c} (100%)
