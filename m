From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/2] allow md_flush_request to take NULL bio
Date: Wed, 10 Feb 2016 16:53:14 -0800
Message-ID: <1455151995-240805-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e55e6cf..2997104 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -406,6 +406,8 @@ static void md_submit_flush_data(struct work_struct *ws)
 	struct mddev *mddev = container_of(ws, struct mddev, flush_work);
 	struct bio *bio = mddev->flush_bio;
 
+	if (!bio)
+		goto out;
 	if (bio->bi_iter.bi_size == 0)
 		/* an empty barrier - all done */
 		bio_endio(bio);
@@ -415,6 +417,7 @@ static void md_submit_flush_data(struct work_struct *ws)
 	}
 
 	mddev->flush_bio = NULL;
+out:
 	wake_up(&mddev->sb_wait);
 }
 
-- 
2.4.6

