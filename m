From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 04/17] md: introduce helpers for dealing with fetch/store preallocated pages in bio
Date: Thu, 16 Feb 2017 19:45:34 +0800
Message-ID: <1487245547-24384-5-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Both raid1 and raid10 uses bio's bvec table to store pre-allocated
pages, then fetch and add it to bio.

This patch introduces two helpers for dealing with the special case,
like what bio_iov_iter_get_pages() does.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/md.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index a86ad62079de..21897cb514af 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -708,4 +708,25 @@ static inline void mddev_clear_unsupported_flags(struct mddev *mddev,
 {
 	mddev->flags &= ~unsupported_flags;
 }
+
+/*
+ * Both raid1 and raid10 use bio's bvec table to store the preallocated
+ * pages, so we introduces the following helpers for this kind of usage.
+ *
+ * Actually the usage is a bit similar with bio_iov_iter_get_pages().
+ *
+ * Please make sure .bi_io_vec[idx] points to one unused vector by the
+ * bio.
+ */
+static inline struct page *mdev_get_page_from_bio(struct bio *bio, unsigned idx)
+{
+	return bio->bi_io_vec[idx].bv_page;
+}
+
+static inline void mdev_put_page_to_bio(struct bio *bio, unsigned idx,
+					struct page *page)
+{
+	bio->bi_io_vec[idx].bv_page = page;
+}
+
 #endif /* _MD_MD_H */
-- 
2.7.4
