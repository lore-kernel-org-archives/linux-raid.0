From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 5/7] bcache: move to drivers/md/
Date: Fri, 11 May 2012 12:46:36 -0700
Message-ID: <20120511194636.25770.86090.stgit@dwillia2-linux.jf.intel.com>
References: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120511194327.25770.79292.stgit-p8uTFz9XbKgaePuBGzJMJzMJUdESFZ8XQQ4Iyu8u01E@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

This is in preparation for being exposed as a md or dm device.  The
rationale is that userspace tooling already knows how to generically
manipulate these composite block devices, so there is not much
motivation to add new bcache-specific tooling.

As seen with raid there is precedent for md and dm to share a common
personality backend and separate the frontend virtual block device
presentation.

Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/block/Kconfig            |    2 --
 drivers/block/Makefile           |    1 -
 drivers/md/Kconfig               |    2 ++
 drivers/md/Makefile              |    1 +
 drivers/md/bcache/Kconfig        |    0 
 drivers/md/bcache/Makefile       |    0 
 drivers/md/bcache/alloc.c        |    0 
 drivers/md/bcache/bcache.h       |    0 
 drivers/md/bcache/bset.c         |    0 
 drivers/md/bcache/bset.h         |    0 
 drivers/md/bcache/btree.c        |    0 
 drivers/md/bcache/btree.h        |    0 
 drivers/md/bcache/debug.c        |    0 
 drivers/md/bcache/debug.h        |    0 
 drivers/md/bcache/io.c           |    0 
 drivers/md/bcache/journal.c      |    0 
 drivers/md/bcache/journal.h      |    0 
 drivers/md/bcache/request.c      |    0 
 drivers/md/bcache/request.h      |    0 
 drivers/md/bcache/stats.c        |    0 
 drivers/md/bcache/stats.h        |    0 
 drivers/md/bcache/super.c        |    0 
 drivers/md/bcache/sysfs.c        |    0 
 drivers/md/bcache/sysfs.h        |    0 
 drivers/md/bcache/trace.c        |    0 
 drivers/md/bcache/util.c         |    0 
 drivers/md/bcache/util.h         |    0 
 drivers/md/bcache/writeback.c    |    0 
 28 files changed, 3 insertions(+), 3 deletions(-)
 rename drivers/{block/bcache/Kconfig => md/bcache/Kconfig} (100%)
 rename drivers/{block/bcache/Makefile => md/bcache/Makefile} (100%)
 rename drivers/{block/bcache/alloc.c => md/bcache/alloc.c} (100%)
 rename drivers/{block/bcache/bcache.h => md/bcache/bcache.h} (100%)
 rename drivers/{block/bcache/bset.c => md/bcache/bset.c} (100%)
 rename drivers/{block/bcache/bset.h => md/bcache/bset.h} (100%)
 rename drivers/{block/bcache/btree.c => md/bcache/btree.c} (100%)
 rename drivers/{block/bcache/btree.h => md/bcache/btree.h} (100%)
 rename drivers/{block/bcache/debug.c => md/bcache/debug.c} (100%)
 rename drivers/{block/bcache/debug.h => md/bcache/debug.h} (100%)
 rename drivers/{block/bcache/io.c => md/bcache/io.c} (100%)
 rename drivers/{block/bcache/journal.c => md/bcache/journal.c} (100%)
 rename drivers/{block/bcache/journal.h => md/bcache/journal.h} (100%)
 rename drivers/{block/bcache/request.c => md/bcache/request.c} (100%)
 rename drivers/{block/bcache/request.h => md/bcache/request.h} (100%)
 rename drivers/{block/bcache/stats.c => md/bcache/stats.c} (100%)
 rename drivers/{block/bcache/stats.h => md/bcache/stats.h} (100%)
 rename drivers/{block/bcache/super.c => md/bcache/super.c} (100%)
 rename drivers/{block/bcache/sysfs.c => md/bcache/sysfs.c} (100%)
 rename drivers/{block/bcache/sysfs.h => md/bcache/sysfs.h} (100%)
 rename drivers/{block/bcache/trace.c => md/bcache/trace.c} (100%)
 rename drivers/{block/bcache/util.c => md/bcache/util.c} (100%)
 rename drivers/{block/bcache/util.h => md/bcache/util.h} (100%)
 rename drivers/{block/bcache/writeback.c => md/bcache/writeback.c} (100%)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index d872600..4e4c8a4 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -526,8 +526,6 @@ config VIRTIO_BLK
 	  This is the virtual block driver for virtio.  It can be used with
           lguest or QEMU based VMMs (like KVM or Xen).  Say Y or M.
 
-source "drivers/block/bcache/Kconfig"
-
 config BLK_DEV_HD
 	bool "Very old hard disk (MFM/RLL/IDE) driver"
 	depends on HAVE_IDE
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 19520e1..5b79505 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -41,6 +41,5 @@ obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/
-obj-$(CONFIG_BCACHE)           += bcache/
 
 swim_mod-y	:= swim.o swim_asm.o
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index faa4741..110c1b7 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -185,6 +185,8 @@ config MD_FAULTY
 
 	  In unsure, say N.
 
+source "drivers/md/bcache/Kconfig"
+
 config BLK_DEV_DM
 	tristate "Device mapper support"
 	---help---
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 046860c..b717f51 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_MD_RAID10)		+= raid10.o
 obj-$(CONFIG_MD_RAID456)	+= raid456.o
 obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
 obj-$(CONFIG_MD_FAULTY)		+= faulty.o
+obj-$(CONFIG_BCACHE)		+= bcache/
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
diff --git a/drivers/block/bcache/Kconfig b/drivers/md/bcache/Kconfig
similarity index 100%
rename from drivers/block/bcache/Kconfig
rename to drivers/md/bcache/Kconfig
diff --git a/drivers/block/bcache/Makefile b/drivers/md/bcache/Makefile
similarity index 100%
rename from drivers/block/bcache/Makefile
rename to drivers/md/bcache/Makefile
diff --git a/drivers/block/bcache/alloc.c b/drivers/md/bcache/alloc.c
similarity index 100%
rename from drivers/block/bcache/alloc.c
rename to drivers/md/bcache/alloc.c
diff --git a/drivers/block/bcache/bcache.h b/drivers/md/bcache/bcache.h
similarity index 100%
rename from drivers/block/bcache/bcache.h
rename to drivers/md/bcache/bcache.h
diff --git a/drivers/block/bcache/bset.c b/drivers/md/bcache/bset.c
similarity index 100%
rename from drivers/block/bcache/bset.c
rename to drivers/md/bcache/bset.c
diff --git a/drivers/block/bcache/bset.h b/drivers/md/bcache/bset.h
similarity index 100%
rename from drivers/block/bcache/bset.h
rename to drivers/md/bcache/bset.h
diff --git a/drivers/block/bcache/btree.c b/drivers/md/bcache/btree.c
similarity index 100%
rename from drivers/block/bcache/btree.c
rename to drivers/md/bcache/btree.c
diff --git a/drivers/block/bcache/btree.h b/drivers/md/bcache/btree.h
similarity index 100%
rename from drivers/block/bcache/btree.h
rename to drivers/md/bcache/btree.h
diff --git a/drivers/block/bcache/debug.c b/drivers/md/bcache/debug.c
similarity index 100%
rename from drivers/block/bcache/debug.c
rename to drivers/md/bcache/debug.c
diff --git a/drivers/block/bcache/debug.h b/drivers/md/bcache/debug.h
similarity index 100%
rename from drivers/block/bcache/debug.h
rename to drivers/md/bcache/debug.h
diff --git a/drivers/block/bcache/io.c b/drivers/md/bcache/io.c
similarity index 100%
rename from drivers/block/bcache/io.c
rename to drivers/md/bcache/io.c
diff --git a/drivers/block/bcache/journal.c b/drivers/md/bcache/journal.c
similarity index 100%
rename from drivers/block/bcache/journal.c
rename to drivers/md/bcache/journal.c
diff --git a/drivers/block/bcache/journal.h b/drivers/md/bcache/journal.h
similarity index 100%
rename from drivers/block/bcache/journal.h
rename to drivers/md/bcache/journal.h
diff --git a/drivers/block/bcache/request.c b/drivers/md/bcache/request.c
similarity index 100%
rename from drivers/block/bcache/request.c
rename to drivers/md/bcache/request.c
diff --git a/drivers/block/bcache/request.h b/drivers/md/bcache/request.h
similarity index 100%
rename from drivers/block/bcache/request.h
rename to drivers/md/bcache/request.h
diff --git a/drivers/block/bcache/stats.c b/drivers/md/bcache/stats.c
similarity index 100%
rename from drivers/block/bcache/stats.c
rename to drivers/md/bcache/stats.c
diff --git a/drivers/block/bcache/stats.h b/drivers/md/bcache/stats.h
similarity index 100%
rename from drivers/block/bcache/stats.h
rename to drivers/md/bcache/stats.h
diff --git a/drivers/block/bcache/super.c b/drivers/md/bcache/super.c
similarity index 100%
rename from drivers/block/bcache/super.c
rename to drivers/md/bcache/super.c
diff --git a/drivers/block/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
similarity index 100%
rename from drivers/block/bcache/sysfs.c
rename to drivers/md/bcache/sysfs.c
diff --git a/drivers/block/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
similarity index 100%
rename from drivers/block/bcache/sysfs.h
rename to drivers/md/bcache/sysfs.h
diff --git a/drivers/block/bcache/trace.c b/drivers/md/bcache/trace.c
similarity index 100%
rename from drivers/block/bcache/trace.c
rename to drivers/md/bcache/trace.c
diff --git a/drivers/block/bcache/util.c b/drivers/md/bcache/util.c
similarity index 100%
rename from drivers/block/bcache/util.c
rename to drivers/md/bcache/util.c
diff --git a/drivers/block/bcache/util.h b/drivers/md/bcache/util.h
similarity index 100%
rename from drivers/block/bcache/util.h
rename to drivers/md/bcache/util.h
diff --git a/drivers/block/bcache/writeback.c b/drivers/md/bcache/writeback.c
similarity index 100%
rename from drivers/block/bcache/writeback.c
rename to drivers/md/bcache/writeback.c
