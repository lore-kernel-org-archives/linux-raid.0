From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v3 14/14] md: raid10: avoid direct access to bvec table in handle_reshape_read_error
Date: Fri, 17 Mar 2017 00:12:35 +0800
Message-ID: <20170316161235.27110-15-tom.leiming@gmail.com>
References: <20170316161235.27110-1-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170316161235.27110-1-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

All reshape I/O share pages from 1st copy device, so just use that pages
for avoiding direct access to bvec table in handle_reshape_read_error.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid10.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8db3b0869be4..67cf09c0c649 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4681,7 +4681,10 @@ static int handle_reshape_read_error(struct mddev *mddev,
 	struct r10bio *r10b = &on_stack.r10_bio;
 	int slot = 0;
 	int idx = 0;
-	struct bio_vec *bvec = r10_bio->master_bio->bi_io_vec;
+	struct page **pages;
+
+	/* reshape IOs share pages from .devs[0].bio */
+	pages = get_resync_pages(r10_bio->devs[0].bio)->pages;
 
 	r10b->sector = r10_bio->sector;
 	__raid10_find_phys(&conf->prev, r10b);
@@ -4710,7 +4713,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
 			success = sync_page_io(rdev,
 					       addr,
 					       s << 9,
-					       bvec[idx].bv_page,
+					       pages[idx],
 					       REQ_OP_READ, 0, false);
 			rdev_dec_pending(rdev, mddev);
 			rcu_read_lock();
-- 
2.9.3

