From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] Revert "md: raid1: use bio helper in process_checks()"
Date: Tue, 28 Mar 2017 11:49:57 +0200
Message-ID: <20170328095029.3500369-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, NeilBrown <neilb@suse.com>, Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, "colyli@suse.de" <colyli@suse.de>, Guoqing Jiang <gqjiang@suse.com>, Mike Christie <mchristi@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Commit 60928a91b0b3 ("md: raid1: use bio helper in process_checks()")
is probably correct, but I get a new compile-time warning after
it, and have trouble understanding what it fixes:

drivers/md/raid1.c: In function 'sync_request_write':
drivers/md/raid1.c:2172:9: error: 'page_len$' may be used uninitialized in this function [-Werror=maybe-uninitialized]
     if (memcmp(page_address(ppages[j]),
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         page_address(spages[j]),
         ~~~~~~~~~~~~~~~~~~~~~~~~
         page_len[j]))
         ~~~~~~~~~~~~
drivers/md/raid1.c:2160:7: note: 'page_len$' was declared here
   int page_len[RESYNC_PAGES];
       ^~~~~~~~

This reverts it to resolve the warning.

Fixes: 60928a91b0b3 ("md: raid1: use bio helper in process_checks()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/md/raid1.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b7d9651286d4..4d176c8abc33 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2113,7 +2113,6 @@ static void process_checks(struct r1bio *r1_bio)
 		int j;
 		int size;
 		int error;
-		struct bio_vec *bi;
 		struct bio *b = r1_bio->bios[i];
 		struct resync_pages *rp = get_resync_pages(b);
 		if (b->bi_end_io != end_sync_read)
@@ -2132,7 +2131,9 @@ static void process_checks(struct r1bio *r1_bio)
 		b->bi_private = rp;
 
 		size = b->bi_iter.bi_size;
-		bio_for_each_segment_all(bi, b, j) {
+		for (j = 0; j < vcnt ; j++) {
+			struct bio_vec *bi;
+			bi = &b->bi_io_vec[j];
 			bi->bv_offset = 0;
 			if (size > PAGE_SIZE)
 				bi->bv_len = PAGE_SIZE;
@@ -2156,22 +2157,17 @@ static void process_checks(struct r1bio *r1_bio)
 		int error = sbio->bi_error;
 		struct page **ppages = get_resync_pages(pbio)->pages;
 		struct page **spages = get_resync_pages(sbio)->pages;
-		struct bio_vec *bi;
-		int page_len[RESYNC_PAGES];
 
 		if (sbio->bi_end_io != end_sync_read)
 			continue;
 		/* Now we can 'fixup' the error value */
 		sbio->bi_error = 0;
 
-		bio_for_each_segment_all(bi, sbio, j)
-			page_len[j] = bi->bv_len;
-
 		if (!error) {
 			for (j = vcnt; j-- ; ) {
 				if (memcmp(page_address(ppages[j]),
 					   page_address(spages[j]),
-					   page_len[j]))
+					   sbio->bi_io_vec[j].bv_len))
 					break;
 			}
 		} else
-- 
2.9.0
