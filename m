From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: =?utf-8?b?W1BBVENIIDA5LzE1LCBm0ZZ4ZWRdIGxpZ2h0bnZtOiBz?=
 =?utf-8?q?top_using_-=3Equeuedata?=
Date: Sat, 9 May 2020 10:38:49 +0200
Message-ID: <20200509083849.GA22173@lst.de>
References: <20200508161517.252308-1-hch@lst.de>
	<20200508161517.252308-10-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200508161517.252308-10-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-m68k-cunTk1MwBs8S/qaLPR03pWD2FQJk+8+b@public.gmane.org, Philip Kelleher <pjk1939-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-raid.ids

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---

fixed the compilation in the print_ppa arguments

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
index 86ffa875bfe16..49718105bc0dc 100644
--- a/drivers/lightnvm/pblk.h
+++ b/drivers/lightnvm/pblk.h
@@ -1255,7 +1255,7 @@ static inline int pblk_boundary_ppa_checks(struct nvm_tgt_dev *tgt_dev,
 				continue;
 		}
 
-		print_ppa(tgt_dev->q->queuedata, ppa, "boundary", i);
+		print_ppa(tgt_dev->disk->q->private_data, ppa, "boundary", i);
 
 		return 1;
 	}
-- 
2.26.2
