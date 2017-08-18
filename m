From: Shaohua Li <shli@fb.com>
Subject: [PATCH] md/raid0: attach correct cgroup info in bio
Date: Fri, 18 Aug 2017 10:27:59 -0700
Message-ID: <d76bd8a24c41a69e6b302598383ad1f845683a06.1503077213.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The discard bio doesn't attach the original bio cgroup info. Normal bio
is cloned, so is fine.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 94d9ae9..071a7c5 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -539,6 +539,8 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 		    !discard_bio)
 			continue;
 		bio_chain(discard_bio, bio);
+		if (bio->bi_css)
+			bio_associate_blkcg(discard_bio, bio->bi_css);
 		if (mddev->gendisk)
 			trace_block_bio_remap(bdev_get_queue(rdev->bdev),
 				discard_bio, disk_devt(mddev->gendisk),
-- 
2.9.5

