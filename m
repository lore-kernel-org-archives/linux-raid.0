From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] md/raid1: use local list for pending write-bio in make_request()
Date: Thu,  2 Jun 2011 21:46:27 +0900
Message-ID: <1307018787-5749-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Use local bio_list for gathering mirrored bios to reduce locking overhead.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid1.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5d096096f958..39e9f54038a8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -707,6 +707,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 	mdk_rdev_t *blocked_rdev;
 	int plugged;
+	struct bio_list write_list;
 
 	/*
 	 * Register the new request and wait if the reconstruction
@@ -801,6 +802,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	plugged = mddev_check_plugged(mddev);
 
 	disks = conf->raid_disks;
+	bio_list_init(&write_list);
  retry_write:
 	blocked_rdev = NULL;
 	rcu_read_lock();
@@ -894,10 +896,12 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		}
 
 		atomic_inc(&r1_bio->remaining);
-		spin_lock_irqsave(&conf->device_lock, flags);
-		bio_list_add(&conf->pending_bio_list, mbio);
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		bio_list_add(&write_list, mbio);
 	}
+	spin_lock_irqsave(&conf->device_lock, flags);
+	bio_list_merge(&conf->pending_bio_list, &write_list);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+
 	r1_bio_write_done(r1_bio);
 
 	/* In case raid1d snuck in to freeze_array */
-- 
1.7.5.2

