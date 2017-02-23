From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/2] md/raid10: submit bio directly to replacement disk
Date: Thu, 23 Feb 2017 12:34:34 -0800
Message-ID: <bf67a7498d5807e3913762f63402f367a6de401e.1487881989.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

Commit 57c67df(md/raid10: submit IO from originating thread instead of
md thread) submits bio directly for normal disks but not for replacement
disks. There is no point we shouldn't do this for replacement disks.

Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid10.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a1f8e98..4e85a61 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1477,11 +1477,24 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			mbio->bi_bdev = (void*)rdev;
 
 			atomic_inc(&r10_bio->remaining);
+
+			cb = blk_check_plugged(raid10_unplug, mddev,
+					       sizeof(*plug));
+			if (cb)
+				plug = container_of(cb, struct raid10_plug_cb,
+						    cb);
+			else
+				plug = NULL;
 			spin_lock_irqsave(&conf->device_lock, flags);
-			bio_list_add(&conf->pending_bio_list, mbio);
-			conf->pending_count++;
+			if (plug) {
+				bio_list_add(&plug->pending, mbio);
+				plug->pending_cnt++;
+			} else {
+				bio_list_add(&conf->pending_bio_list, mbio);
+				conf->pending_count++;
+			}
 			spin_unlock_irqrestore(&conf->device_lock, flags);
-			if (!mddev_check_plugged(mddev))
+			if (!plug)
 				md_wakeup_thread(mddev->thread);
 		}
 	}
-- 
2.9.3

