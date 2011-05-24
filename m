From: Jonathan Brassow <jbrassow@f14.redhat.com>
Subject: [PATCH 3 of 9] MD:  allow analyze_sbs to fail
Date: Mon, 23 May 2011 22:06:20 -0500
Message-ID: <201105240306.p4O36Kvt029366@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patch name: md-allow-analyze_sbs-to-fail.patch

Catch the case that md_run is called requiring non-existant super_types fns.

Other modules may call md_run (like device-mapper's, dm-raid.c), we mustn't
assume they will always set a valid MD major_version.  This is especially true
in the case of device-mapper, which will use a new superblock type.  If patches
don't land in the kernel in the proper order, access will be attempted beyond
the end of the super_types array.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -2864,12 +2864,15 @@ abort_free:
  */
 
 
-static void analyze_sbs(mddev_t * mddev)
+static int analyze_sbs(mddev_t *mddev)
 {
 	int i;
 	mdk_rdev_t *rdev, *freshest, *tmp;
 	char b[BDEVNAME_SIZE];
 
+	if (mddev->major_version >= ARRAY_SIZE(super_types))
+		return -EINVAL;
+
 	freshest = NULL;
 	rdev_for_each(rdev, tmp, mddev)
 		switch (super_types[mddev->major_version].
@@ -2921,6 +2924,7 @@ static void analyze_sbs(mddev_t * mddev)
 			clear_bit(In_sync, &rdev->flags);
 		}
 	}
+	return 0;
 }
 
 /* Read a fixed-point number.
@@ -4459,7 +4463,8 @@ int md_run(mddev_t *mddev)
 	if (should_read_super(mddev)) {
 		if (!mddev->persistent)
 			return -EINVAL;
-		analyze_sbs(mddev);
+		if (analyze_sbs(mddev))
+			return -EINVAL;
 	}
 
 	if (mddev->level != LEVEL_NONE)
