From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/13] md: Fix single printks with multiple KERN_<level>s
Date: Wed, 12 Jan 2011 09:12:46 +1100
Message-ID: <20110111221246.12732.83999.stgit@notabene.brown>
References: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111221050.12732.31647.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Joe Perches <joe@perches.com>
List-Id: linux-raid.ids

From: Joe Perches <joe@perches.com>

Noticed-by: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c  |    5 +++--
 drivers/md/raid10.c |    5 +++--
 drivers/md/raid5.c  |    1 -
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 845cf95..d50056b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1027,8 +1027,9 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 	} else
 		set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-	printk(KERN_ALERT "md/raid1:%s: Disk failure on %s, disabling device.\n"
-	       KERN_ALERT "md/raid1:%s: Operation continuing on %d devices.\n",
+	printk(KERN_ALERT
+	       "md/raid1:%s: Disk failure on %s, disabling device.\n"
+	       "md/raid1:%s: Operation continuing on %d devices.\n",
 	       mdname(mddev), bdevname(rdev->bdev, b),
 	       mdname(mddev), conf->raid_disks - mddev->degraded);
 }
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0641674..03825cb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1051,8 +1051,9 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 	}
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-	printk(KERN_ALERT "md/raid10:%s: Disk failure on %s, disabling device.\n"
-	       KERN_ALERT "md/raid10:%s: Operation continuing on %d devices.\n",
+	printk(KERN_ALERT
+	       "md/raid10:%s: Disk failure on %s, disabling device.\n"
+	       "md/raid10:%s: Operation continuing on %d devices.\n",
 	       mdname(mddev), bdevname(rdev->bdev, b),
 	       mdname(mddev), conf->raid_disks - mddev->degraded);
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc574f3..316fbe7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1721,7 +1721,6 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 		set_bit(Faulty, &rdev->flags);
 		printk(KERN_ALERT
 		       "md/raid:%s: Disk failure on %s, disabling device.\n"
-		       KERN_ALERT
 		       "md/raid:%s: Operation continuing on %d devices.\n",
 		       mdname(mddev),
 		       bdevname(rdev->bdev, b),


