From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 01/13] block: introduce bio_segments_all()
Date: Tue, 28 Feb 2017 23:41:31 +0800
Message-ID: <1488296503-4987-2-git-send-email-tom.leiming@gmail.com>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

So that we can replace the direct access to .bi_vcnt.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 include/linux/bio.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8e521194f6fc..3364b3ed90e7 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -293,6 +293,13 @@ static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv)
 		bv->bv_len = iter.bi_bvec_done;
 }
 
+static inline unsigned bio_segments_all(struct bio *bio)
+{
+	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
+
+	return bio->bi_vcnt;
+}
+
 enum bip_flags {
 	BIP_BLOCK_INTEGRITY	= 1 << 0, /* block layer owns integrity data */
 	BIP_MAPPED_INTEGRITY	= 1 << 1, /* ref tag has been remapped */
-- 
2.7.4

