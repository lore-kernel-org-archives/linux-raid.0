From: Jonathan Brassow <jbrassow@f14.redhat.com>
Subject: [PATCH 4 of 9] MD:  analyze_sbs failure if bad superblocks
Date: Mon, 23 May 2011 22:06:31 -0500
Message-ID: <201105240306.p4O36Vi4029440@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patch name: md-analyze_sbs-failure-if-bad-superblocks.patch

MD's superblock reader function should fail if all superblocks are bad.

analyze_sbs should return -EINVAL if the 'freshest'/best superblock cannot
be validated.  This is especially important to dm-raid.c, as it uses md_run
at creation time to validate array transitions.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -2890,9 +2890,9 @@ static int analyze_sbs(mddev_t *mddev)
 			kick_rdev_from_array(rdev);
 		}
 
-
-	super_types[mddev->major_version].
-		validate_super(mddev, freshest);
+	/* If the freshest superblock available cannot be validated, fail. */
+	if (super_types[mddev->major_version].validate_super(mddev, freshest))
+		return -EINVAL;
 
 	i = 0;
 	rdev_for_each(rdev, tmp, mddev) {
