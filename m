From: shli@kernel.org
Subject: [PATCH] md:raid1/10: avoid unnecessary locking
Date: Wed, 10 May 2017 08:52:28 -0700
Message-ID: <1946dca4cbeb08911e4fcc155d1b2ffa8bc6c0a2.1494431492.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

If we add bios to block plugging list, locking is unnecessry, since the block
unplug is guaranteed not to run at that time.

Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid1.c  | 7 +++----
 drivers/md/raid10.c | 7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7c1f73398800..a17ed6218d51 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1529,17 +1529,16 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			plug = container_of(cb, struct raid1_plug_cb, cb);
 		else
 			plug = NULL;
-		spin_lock_irqsave(&conf->device_lock, flags);
 		if (plug) {
 			bio_list_add(&plug->pending, mbio);
 			plug->pending_cnt++;
 		} else {
+			spin_lock_irqsave(&conf->device_lock, flags);
 			bio_list_add(&conf->pending_bio_list, mbio);
 			conf->pending_count++;
-		}
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-		if (!plug)
+			spin_unlock_irqrestore(&conf->device_lock, flags);
 			md_wakeup_thread(mddev->thread);
+		}
 	}
 
 	r1_bio_write_done(r1_bio);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6b86a0032cf8..4343d7ff9916 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1282,17 +1282,16 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 		plug = container_of(cb, struct raid10_plug_cb, cb);
 	else
 		plug = NULL;
-	spin_lock_irqsave(&conf->device_lock, flags);
 	if (plug) {
 		bio_list_add(&plug->pending, mbio);
 		plug->pending_cnt++;
 	} else {
+		spin_lock_irqsave(&conf->device_lock, flags);
 		bio_list_add(&conf->pending_bio_list, mbio);
 		conf->pending_count++;
-	}
-	spin_unlock_irqrestore(&conf->device_lock, flags);
-	if (!plug)
+		spin_unlock_irqrestore(&conf->device_lock, flags);
 		md_wakeup_thread(mddev->thread);
+	}
 }
 
 static void raid10_write_request(struct mddev *mddev, struct bio *bio,
-- 
2.11.0

