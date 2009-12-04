From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 21/22] md: move compat_ioctl handling into md.c
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.47435.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-raid.ids

From: Arnd Bergmann <arnd@arndb.de>

The RAID ioctls are only implemented in md.c, so the
handling for them should also be moved there from
fs/compat_ioctl.c.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Neil Brown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c   |   23 +++++++++++++++++++++++
 fs/compat_ioctl.c |   22 ----------------------
 2 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5111587..c4a0e59 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -44,6 +44,7 @@
 #include <linux/random.h>
 #include <linux/reboot.h>
 #include <linux/file.h>
+#include <linux/compat.h>
 #include <linux/delay.h>
 #include <linux/raid/md_p.h>
 #include <linux/raid/md_u.h>
@@ -5681,6 +5682,25 @@ done:
 abort:
 	return err;
 }
+#ifdef CONFIG_COMPAT
+static int md_compat_ioctl(struct block_device *bdev, fmode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case HOT_REMOVE_DISK:
+	case HOT_ADD_DISK:
+	case SET_DISK_FAULTY:
+	case SET_BITMAP_FILE:
+		/* These take in integer arg, do not convert */
+		break;
+	default:
+		arg = (unsigned long)compat_ptr(arg);
+		break;
+	}
+
+	return md_ioctl(bdev, mode, cmd, arg);
+}
+#endif /* CONFIG_COMPAT */
 
 static int md_open(struct block_device *bdev, fmode_t mode)
 {
@@ -5746,6 +5766,9 @@ static const struct block_device_operations md_fops =
 	.open		= md_open,
 	.release	= md_release,
 	.ioctl		= md_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= md_compat_ioctl,
+#endif
 	.getgeo		= md_getgeo,
 	.media_changed	= md_media_changed,
 	.revalidate_disk= md_revalidate,
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index d84e705..ad485ba 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1912,28 +1912,6 @@ COMPATIBLE_IOCTL(FIGETBSZ)
 /* 'X' - originally XFS but some now in the VFS */
 COMPATIBLE_IOCTL(FIFREEZE)
 COMPATIBLE_IOCTL(FITHAW)
-/* RAID */
-COMPATIBLE_IOCTL(RAID_VERSION)
-COMPATIBLE_IOCTL(GET_ARRAY_INFO)
-COMPATIBLE_IOCTL(GET_DISK_INFO)
-COMPATIBLE_IOCTL(PRINT_RAID_DEBUG)
-COMPATIBLE_IOCTL(RAID_AUTORUN)
-COMPATIBLE_IOCTL(CLEAR_ARRAY)
-COMPATIBLE_IOCTL(ADD_NEW_DISK)
-ULONG_IOCTL(HOT_REMOVE_DISK)
-COMPATIBLE_IOCTL(SET_ARRAY_INFO)
-COMPATIBLE_IOCTL(SET_DISK_INFO)
-COMPATIBLE_IOCTL(WRITE_RAID_INFO)
-COMPATIBLE_IOCTL(UNPROTECT_ARRAY)
-COMPATIBLE_IOCTL(PROTECT_ARRAY)
-ULONG_IOCTL(HOT_ADD_DISK)
-ULONG_IOCTL(SET_DISK_FAULTY)
-COMPATIBLE_IOCTL(RUN_ARRAY)
-COMPATIBLE_IOCTL(STOP_ARRAY)
-COMPATIBLE_IOCTL(STOP_ARRAY_RO)
-COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
-COMPATIBLE_IOCTL(GET_BITMAP_FILE)
-ULONG_IOCTL(SET_BITMAP_FILE)
 /* Big K */
 COMPATIBLE_IOCTL(PIO_FONT)
 COMPATIBLE_IOCTL(GIO_FONT)


