From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 5 of 6] Remove extra loop from copy_data
Date: Mon, 07 Feb 2005 13:44:19 +1100
Message-ID: <E1Cxyst-0004fq-N8@notabene.cse.unsw.edu.au>
References: <20050207133555.17870.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


copy_data currently loops over bio's in a list, but the 
caller also does the same looping, sometimes with extra work.
So remove the loop from copy_data.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid5.c     |   72 ++++++++++++++++++++++-------------------------
 ./drivers/md/raid6main.c |   65 ++++++++++++++++++++----------------------
 2 files changed, 65 insertions(+), 72 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-02-07 13:31:05.000000000 +1100
+++ ./drivers/md/raid5.c	2005-02-07 13:34:09.000000000 +1100
@@ -613,11 +613,10 @@ static sector_t compute_blocknr(struct s
 
 
 /*
- * Copy data between a page in the stripe cache, and one or more bion
- * The page could align with the middle of the bio, or there could be 
- * several bion, each with several bio_vecs, which cover part of the page
- * Multiple bion are linked together on bi_next.  There may be extras
- * at the end of this list.  We ignore them.
+ * Copy data between a page in the stripe cache, and a bio.
+ * There are no alignment or size guarantees between the page or the
+ * bio except that there is some overlap.
+ * All iovecs in the bio must be considered. 
  */
 static void copy_data(int frombio, struct bio *bio,
 		     struct page *page,
@@ -626,41 +625,38 @@ static void copy_data(int frombio, struc
 	char *pa = page_address(page);
 	struct bio_vec *bvl;
 	int i;
+	int page_offset;
 
-	for (;bio && bio->bi_sector < sector+STRIPE_SECTORS;
-	      bio = r5_next_bio(bio, sector) ) {
-		int page_offset;
-		if (bio->bi_sector >= sector)
-			page_offset = (signed)(bio->bi_sector - sector) * 512;
-		else 
-			page_offset = (signed)(sector - bio->bi_sector) * -512;
-		bio_for_each_segment(bvl, bio, i) {
-			int len = bio_iovec_idx(bio,i)->bv_len;
-			int clen;
-			int b_offset = 0;			
-
-			if (page_offset < 0) {
-				b_offset = -page_offset;
-				page_offset += b_offset;
-				len -= b_offset;
-			}
-
-			if (len > 0 && page_offset + len > STRIPE_SIZE)
-				clen = STRIPE_SIZE - page_offset;	
-			else clen = len;
+	if (bio->bi_sector >= sector)
+		page_offset = (signed)(bio->bi_sector - sector) * 512;
+	else 
+		page_offset = (signed)(sector - bio->bi_sector) * -512;
+	bio_for_each_segment(bvl, bio, i) {
+		int len = bio_iovec_idx(bio,i)->bv_len;
+		int clen;
+		int b_offset = 0;			
+
+		if (page_offset < 0) {
+			b_offset = -page_offset;
+			page_offset += b_offset;
+			len -= b_offset;
+		}
+
+		if (len > 0 && page_offset + len > STRIPE_SIZE)
+			clen = STRIPE_SIZE - page_offset;	
+		else clen = len;
 			
-			if (clen > 0) {
-				char *ba = __bio_kmap_atomic(bio, i, KM_USER0);
-				if (frombio)
-					memcpy(pa+page_offset, ba+b_offset, clen);
-				else
-					memcpy(ba+b_offset, pa+page_offset, clen);
-				__bio_kunmap_atomic(ba, KM_USER0);
-			}	
-			if (clen < len) /* hit end of page */
-				break;
-			page_offset +=  len;
-		}
+		if (clen > 0) {
+			char *ba = __bio_kmap_atomic(bio, i, KM_USER0);
+			if (frombio)
+				memcpy(pa+page_offset, ba+b_offset, clen);
+			else
+				memcpy(ba+b_offset, pa+page_offset, clen);
+			__bio_kunmap_atomic(ba, KM_USER0);
+		}	
+		if (clen < len) /* hit end of page */
+			break;
+		page_offset +=  len;
 	}
 }
 

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-02-07 13:31:05.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-02-07 13:34:09.000000000 +1100
@@ -670,41 +670,38 @@ static void copy_data(int frombio, struc
 	char *pa = page_address(page);
 	struct bio_vec *bvl;
 	int i;
+	int page_offset;
 
-	for (;bio && bio->bi_sector < sector+STRIPE_SECTORS;
-	      bio = r5_next_bio(bio, sector) ) {
-		int page_offset;
-		if (bio->bi_sector >= sector)
-			page_offset = (signed)(bio->bi_sector - sector) * 512;
-		else
-			page_offset = (signed)(sector - bio->bi_sector) * -512;
-		bio_for_each_segment(bvl, bio, i) {
-			int len = bio_iovec_idx(bio,i)->bv_len;
-			int clen;
-			int b_offset = 0;
-
-			if (page_offset < 0) {
-				b_offset = -page_offset;
-				page_offset += b_offset;
-				len -= b_offset;
-			}
-
-			if (len > 0 && page_offset + len > STRIPE_SIZE)
-				clen = STRIPE_SIZE - page_offset;
-			else clen = len;
-
-			if (clen > 0) {
-				char *ba = __bio_kmap_atomic(bio, i, KM_USER0);
-				if (frombio)
-					memcpy(pa+page_offset, ba+b_offset, clen);
-				else
-					memcpy(ba+b_offset, pa+page_offset, clen);
-				__bio_kunmap_atomic(ba, KM_USER0);
-			}
-			if (clen < len) /* hit end of page */
-				break;
-			page_offset +=  len;
-		}
+	if (bio->bi_sector >= sector)
+		page_offset = (signed)(bio->bi_sector - sector) * 512;
+	else 
+		page_offset = (signed)(sector - bio->bi_sector) * -512;
+	bio_for_each_segment(bvl, bio, i) {
+		int len = bio_iovec_idx(bio,i)->bv_len;
+		int clen;
+		int b_offset = 0;			
+
+		if (page_offset < 0) {
+			b_offset = -page_offset;
+			page_offset += b_offset;
+			len -= b_offset;
+		}
+
+		if (len > 0 && page_offset + len > STRIPE_SIZE)
+			clen = STRIPE_SIZE - page_offset;	
+		else clen = len;
+			
+		if (clen > 0) {
+			char *ba = __bio_kmap_atomic(bio, i, KM_USER0);
+			if (frombio)
+				memcpy(pa+page_offset, ba+b_offset, clen);
+			else
+				memcpy(ba+b_offset, pa+page_offset, clen);
+			__bio_kunmap_atomic(ba, KM_USER0);
+		}	
+		if (clen < len) /* hit end of page */
+			break;
+		page_offset +=  len;
 	}
 }
 
