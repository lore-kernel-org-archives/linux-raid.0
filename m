From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 6 of 8] MD:  add sync_super to mddev_t struct
Date: Tue, 07 Jun 2011 17:51:30 -0500
Message-ID: <1307487090.31279.15.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Add the 'sync_super' function pointer to MD array structure (struct mddev_s)

If device-mapper (dm-raid.c) is to define its own on-disk superblock and be
able to load it, there must still be a way for MD to initiate superblock
updates.  The simplest way to make this happen is to provide a pointer in
the MD array structure that can be set by device-mapper (or other module)
with a function to do this.  If the function has been set, it will be used;
otherwise, the method with be looked up via 'super_types' as usual.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -1753,6 +1753,18 @@ static struct super_type super_types[] =
 	},
 };
 
+static void sync_super(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	if (mddev->sync_super) {
+		mddev->sync_super(mddev, rdev);
+		return;
+	}
+
+	BUG_ON(mddev->major_version >= ARRAY_SIZE(super_types));
+
+	super_types[mddev->major_version].sync_super(mddev, rdev);
+}
+
 static int match_mddev_units(mddev_t *mddev1, mddev_t *mddev2)
 {
 	mdk_rdev_t *rdev, *rdev2;
@@ -2171,8 +2183,7 @@ static void sync_sbs(mddev_t * mddev, in
 			/* Don't update this superblock */
 			rdev->sb_loaded = 2;
 		} else {
-			super_types[mddev->major_version].
-				sync_super(mddev, rdev);
+			sync_super(mddev, rdev);
 			rdev->sb_loaded = 1;
 		}
 	}
Index: linux-2.6/drivers/md/md.h
===================================================================
--- linux-2.6.orig/drivers/md/md.h
+++ linux-2.6/drivers/md/md.h
@@ -330,6 +330,7 @@ struct mddev_s
 	atomic_t flush_pending;
 	struct work_struct flush_work;
 	struct work_struct event_work;	/* used by dm to report failure event */
+	void (*sync_super)(mddev_t *mddev, mdk_rdev_t *rdev);
 };
 
 


