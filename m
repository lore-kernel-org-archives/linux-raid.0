From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/15] lightnvm: stop using ->queuedata
Date: Fri,  8 May 2020 18:15:11 +0200
Message-ID: <20200508161517.252308-10-hch@lst.de>
References: <20200508161517.252308-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200508161517.252308-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org
List-Id: linux-raid.ids

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/lightnvm/core.c      | 1 -
 drivers/lightnvm/pblk-init.c | 2 +-
 drivers/lightnvm/pblk.h      | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
index db38a68abb6c0..85c5490cdfd2e 100644
--- a/drivers/lightnvm/core.c
+++ b/drivers/lightnvm/core.c
@@ -400,7 +400,6 @@ static int nvm_create_tgt(struct nvm_dev *dev, struct nvm_ioctl_create *create)
 	}
 
 	tdisk->private_data = targetdata;
-	tqueue->queuedata = targetdata;
 
 	mdts = (dev->geo.csecs >> 9) * NVM_MAX_VLBA;
 	if (dev->geo.mdts) {
diff --git a/drivers/lightnvm/pblk-init.c b/drivers/lightnvm/pblk-init.c
index 9a967a2e83dd7..bec904ec0f7c0 100644
--- a/drivers/lightnvm/pblk-init.c
+++ b/drivers/lightnvm/pblk-init.c
@@ -49,7 +49,7 @@ struct bio_set pblk_bio_set;
 
 static blk_qc_t pblk_make_rq(struct request_queue *q, struct bio *bio)
 {
-	struct pblk *pblk = q->queuedata;
+	struct pblk *pblk = bio->bi_disk->private_data;
 
 	if (bio_op(bio) == REQ_OP_DISCARD) {
 		pblk_discard(pblk, bio);
diff --git a/drivers/lightnvm/pblk.h b/drivers/lightnvm/pblk.h
index 86ffa875bfe16..ed364afaed0d8 100644
--- a/drivers/lightnvm/pblk.h
+++ b/drivers/lightnvm/pblk.h
@@ -1255,7 +1255,7 @@ static inline int pblk_boundary_ppa_checks(struct nvm_tgt_dev *tgt_dev,
 				continue;
 		}
 
-		print_ppa(tgt_dev->q->queuedata, ppa, "boundary", i);
+		print_ppa(tgt_dev->disk->private_data, ppa, "boundary", i);
 
 		return 1;
 	}
-- 
2.26.2
