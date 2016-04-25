From: Shaohua Li <shli@fb.com>
Subject: [PATCH] MD: make bio mergeable
Date: Mon, 25 Apr 2016 16:52:38 -0700
Message-ID: <384a0e0c7d6f2700aadbcbdef003cece88fa7dd7.1461626533.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: qkrwngud825@gmail.com, Kernel-team@fb.com, "v4.3+" <stable@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@fb.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

blk_queue_split marks bio unmergeable, which makes sense for normal bio.
But if dispatching the bio to underlayer disk, the blk_queue_split
checks are invalid, hence it's possible the bio becomes mergeable.

In the reported bug, this bug causes trim against raid0 performance slash
https://bugzilla.kernel.org/show_bug.cgi?id=117051

Reported-by: Park Ju Hyung <qkrwngud825@gmail.com>
Fixes: 6ac45aeb6bca(block: avoid to merge splitted bio)
Cc: stable@vger.kernel.org (v4.3+)
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 194580f..14d3b37 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -284,6 +284,8 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 	 * go away inside make_request
 	 */
 	sectors = bio_sectors(bio);
+	/* bio could be mergeable after passing to underlayer */
+	bio->bi_rw &= ~REQ_NOMERGE;
 	mddev->pers->make_request(mddev, bio);
 
 	cpu = part_stat_lock();
-- 
2.8.0.rc2
