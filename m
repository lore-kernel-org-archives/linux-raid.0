From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/3] md: takeover should clear unrelated bits
Date: Thu, 8 Dec 2016 15:48:17 -0800
Message-ID: <8ba65915901de01043eb08cfadd07d65767776fb.1481240632.git.shli@fb.com>
References: <cover.1481240632.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1481240632.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

When we change level from raid1 to raid5, the MD_FAILFAST_SUPPORTED bit
will be accidentally set, but raid5 doesn't support it. The same is true
for the MD_HAS_JOURNAL bit.

Fix: 46533ff (md: Use REQ_FAILFAST_* on metadata writes where appropriate)
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid0.c | 5 +++++
 drivers/md/raid1.c | 5 ++++-
 drivers/md/raid5.c | 6 +++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e628f18..a162fed 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -539,8 +539,11 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
 	mddev->delta_disks = -1;
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp = MaxSector;
+	clear_bit(MD_HAS_JOURNAL, &mddev->flags);
+	clear_bit(MD_JOURNAL_CLEAN, &mddev->flags);
 
 	create_strip_zones(mddev, &priv_conf);
+
 	return priv_conf;
 }
 
@@ -580,6 +583,7 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
 	mddev->degraded = 0;
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp = MaxSector;
+	clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
 
 	create_strip_zones(mddev, &priv_conf);
 	return priv_conf;
@@ -622,6 +626,7 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
 	mddev->raid_disks = 1;
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp = MaxSector;
+	clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
 
 	create_strip_zones(mddev, &priv_conf);
 	return priv_conf;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 94e0afc..efc2e74 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3243,9 +3243,12 @@ static void *raid1_takeover(struct mddev *mddev)
 		mddev->new_layout = 0;
 		mddev->new_chunk_sectors = 0;
 		conf = setup_conf(mddev);
-		if (!IS_ERR(conf))
+		if (!IS_ERR(conf)) {
 			/* Array must appear to be quiesced */
 			conf->array_frozen = 1;
+			clear_bit(MD_HAS_JOURNAL, &mddev->flags);
+			clear_bit(MD_JOURNAL_CLEAN, &mddev->flags);
+		}
 		return conf;
 	}
 	return ERR_PTR(-EINVAL);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6bf3c26..3e6a2a0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7811,6 +7811,7 @@ static void *raid45_takeover_raid0(struct mddev *mddev, int level)
 static void *raid5_takeover_raid1(struct mddev *mddev)
 {
 	int chunksect;
+	void *ret;
 
 	if (mddev->raid_disks != 2 ||
 	    mddev->degraded > 1)
@@ -7832,7 +7833,10 @@ static void *raid5_takeover_raid1(struct mddev *mddev)
 	mddev->new_layout = ALGORITHM_LEFT_SYMMETRIC;
 	mddev->new_chunk_sectors = chunksect;
 
-	return setup_conf(mddev);
+	ret = setup_conf(mddev);
+	if (!IS_ERR_VALUE(ret))
+		clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
+	return ret;
 }
 
 static void *raid5_takeover_raid6(struct mddev *mddev)
-- 
2.9.3

