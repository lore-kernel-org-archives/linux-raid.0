From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 02/17] block: introduce bio_remove_last_page()
Date: Thu, 16 Feb 2017 19:45:32 +0800
Message-ID: <1487245547-24384-3-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

MD need this helper to remove the last added page, so introduce
it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/bio.c         | 23 +++++++++++++++++++++++
 include/linux/bio.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 5eec5e08417f..0ce7ffcd7939 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -837,6 +837,29 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
 EXPORT_SYMBOL(bio_add_pc_page);
 
 /**
+ *	bio_remove_last_page	-	remove the last added page
+ *	@bio: destination bio
+ *
+ *	Attempt to remove the last added page from the bio_vec maplist.
+ */
+void bio_remove_last_page(struct bio *bio)
+{
+	/*
+	 * cloned bio must not modify vec list
+	 */
+	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
+		return;
+
+	if (bio->bi_vcnt > 0) {
+		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+
+		bio->bi_iter.bi_size -= bv->bv_len;
+		bio->bi_vcnt--;
+	}
+}
+EXPORT_SYMBOL(bio_remove_last_page);
+
+/**
  *	bio_add_page	-	attempt to add page to bio
  *	@bio: destination bio
  *	@page: page to add
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 3364b3ed90e7..32aeb493d1fe 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -443,6 +443,7 @@ extern void bio_init(struct bio *bio, struct bio_vec *table,
 extern void bio_reset(struct bio *);
 void bio_chain(struct bio *, struct bio *);
 
+extern void bio_remove_last_page(struct bio *bio);
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
-- 
2.7.4
