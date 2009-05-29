From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 1/2] md: Push down reconstruction log message to personality code.
Date: Fri, 29 May 2009 15:18:41 +0200
Message-ID: <1243603122-11116-2-git-send-email-maan@systemlinux.org>
References: <1243603122-11116-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243603122-11116-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Currently, the md layer checks in analyze_sbs() if the raid level
supports reconstruction (mddev->level >= 1) and if reconstruction is
in progress (mddev->recovery_cp != MaxSector).

Move that printk into the personality code of those raid levels that
care (levels 1, 4, 5, 6, 10).

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c     |    9 ---------
 drivers/md/raid1.c  |    4 ++++
 drivers/md/raid10.c |    4 ++++
 drivers/md/raid5.c  |    4 ++++
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a54ec91..1d71cc2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2597,15 +2597,6 @@ static void analyze_sbs(mddev_t * mddev)
 			clear_bit(In_sync, &rdev->flags);
 		}
 	}
-
-
-
-	if (mddev->recovery_cp != MaxSector &&
-	    mddev->level >= 1)
-		printk(KERN_ERR "md: %s: raid array is not clean"
-		       " -- starting background reconstruction\n",
-		       mdname(mddev));
-
 }
 
 static void md_safemode_timeout(unsigned long data);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4692a8a..d29842f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2052,6 +2052,10 @@ static int run(mddev_t *mddev)
 		goto out_free_conf;
 	}
 
+	if (mddev->recovery_cp != MaxSector)
+		printk(KERN_NOTICE "raid1: %s is not clean"
+		       " -- starting background reconstruction\n",
+		       mdname(mddev));
 	printk(KERN_INFO 
 		"raid1: raid set %s active with %d out of %d mirrors\n",
 		mdname(mddev), mddev->raid_disks - mddev->degraded, 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d75cb96..c317543 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2186,6 +2186,10 @@ static int run(mddev_t *mddev)
 		goto out_free_conf;
 	}
 
+	if (mddev->recovery_cp != MaxSector)
+		printk(KERN_NOTICE "raid10: %s is not clean"
+		       " -- starting background reconstruction\n",
+		       mdname(mddev));
 	printk(KERN_INFO
 		"raid10: raid set %s active with %d out of %d devices\n",
 		mdname(mddev), mddev->raid_disks - mddev->degraded,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9ec505b..cdd5b49 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4454,6 +4454,10 @@ static int run(mddev_t *mddev)
 	int working_disks = 0;
 	mdk_rdev_t *rdev;
 
+	if (mddev->recovery_cp != MaxSector)
+		printk(KERN_NOTICE "raid5: %s is not clean"
+		       " -- starting background reconstruction\n",
+		       mdname(mddev));
 	if (mddev->reshape_position != MaxSector) {
 		/* Check that we can continue the reshape.
 		 * Currently only disks can change, it must
-- 
1.5.4.3

