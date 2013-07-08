From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 1/2] block: add bio_rewind() to reset bio_vec
Date: Mon,  8 Jul 2013 16:25:13 -0400
Message-ID: <1373315114-16625-1-git-send-email-joe.lawrence@stratus.com>
References: <20130708160656.6cb8e74b@jlaw-desktop.mno.stratus.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130708160656.6cb8e74b@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, kmo@daterainc.com, Joe Lawrence <joe.lawrence@stratus.com>
List-Id: linux-raid.ids

Provide a mechanism for drivers to "rewind" a bio, essentially undoing
all bio_advance() calls on the bio. After the rewind, the bio idx will
be 0, size and sector reset, and each bio_vec len and offset restored to
their initial values.

Suggested-by: NeilBrown <neilb@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 fs/bio.c            | 27 +++++++++++++++++++++++++++
 include/linux/bio.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/fs/bio.c b/fs/bio.c
index 94bbc04..04309df 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -833,6 +833,33 @@ void bio_advance(struct bio *bio, unsigned bytes)
 EXPORT_SYMBOL(bio_advance);
 
 /**
+ * bio_rewind - reset a bio to its start
+ * @bio:        bio to rewind
+ *
+ * This resets bi_sector, bi_size and bi_idx; completely undoing all
+ * bio_advances on the @bio.
+ */
+void bio_rewind(struct bio *bio)
+{
+	int bytes = 0;
+
+	if (bio->bi_idx < bio->bi_vcnt && bio_iovec(bio)->bv_offset > 0) {
+		bytes = bio_iovec(bio)->bv_offset;
+		bio_iovec(bio)->bv_offset -= bytes;
+		bio_iovec(bio)->bv_len += bytes;
+	}
+	while (bio->bi_idx) {
+		bio->bi_idx -= 1;
+		bio_iovec(bio)->bv_len += bio_iovec(bio)->bv_offset;
+		bio_iovec(bio)->bv_offset = 0;
+		bytes += bio_iovec(bio)->bv_len;
+	}
+	bio->bi_size += bytes;
+	bio->bi_sector -= bytes >> 9;
+}
+EXPORT_SYMBOL(bio_rewind);
+
+/**
  * bio_alloc_pages - allocates a single page for each bvec in a bio
  * @bio: bio to allocate pages for
  * @gfp_mask: flags for allocation
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ef24466..e2082fb 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -258,6 +258,7 @@ extern int bio_phys_segments(struct request_queue *, struct bio *);
 
 extern int submit_bio_wait(int rw, struct bio *bio);
 extern void bio_advance(struct bio *, unsigned);
+extern void bio_rewind(struct bio *);
 
 extern void bio_init(struct bio *);
 extern void bio_reset(struct bio *);
-- 
1.8.1.4

