From: Yuri Tikhonov <yur@emcraft.com>
Subject: [PATCH] Dynamic RAID Stripe Cache Size
Date: Thu, 7 Feb 2008 15:41:01 +0300
Message-ID: <200802071541.01494.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hello,

 On platforms with PAGE_SIZE set to rather big values (e.g. 256KB) the
amount of memory necessary for for the stripe cache may be significant,
so we can't rely on the hard-coded value of initial max_nr_stripes
(this may cause invoking OOM-killer for terminating RAID creation process).

 What this patch does is just checks the size of available memory,
and assigns the appropriate, safe, value to initial max_nr_stripes:
 either the hard-coded NR_STRIPES value if it's safe in the sense that
we'll have some free memory available using stripe cache with such size,
 or the calculated, lesser, value.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
--
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d59e1bc..1d2b064 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4934,10 +4934,11 @@ static struct attribute_group raid5_attrs_group = {
 static int run(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
-	int raid_disk, memory;
+	int raid_disk, memory, avail_stripes;
 	mdk_rdev_t *rdev;
 	struct disk_info *disk;
 	struct list_head *tmp;
+	struct sysinfo val;
 	int working_disks = 0;
 
 	if (mddev->level != 5 && mddev->level != 4 && mddev->level != 6) {
@@ -5074,7 +5075,14 @@ static int run(mddev_t *mddev)
 	else
 		conf->max_degraded = 1;
 	conf->algorithm = mddev->layout;
-	conf->max_nr_stripes = NR_STRIPES;
+
+	/* Set the safe stripe cache size */
+	si_meminfo(&val);
+	avail_stripes = (val.freeram + val.freehigh) * val.mem_unit /
+			(sizeof(struct stripe_head) + conf->raid_disks *
+			((sizeof(struct bio) + PAGE_SIZE))) - 1;
+	conf->max_nr_stripes = (avail_stripes < NR_STRIPES) ? avail_stripes :
+			       NR_STRIPES;
 	conf->expand_progress = mddev->reshape_position;
 
 	/* device size must be a multiple of chunk size */



-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
