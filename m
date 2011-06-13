From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 3/3] md/raid5: remove unusual use of bio_iovec_idx()
Date: Mon, 13 Jun 2011 23:48:24 +0900
Message-ID: <1307976504-10215-3-git-send-email-namhyung@gmail.com>
References: <1307976504-10215-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1307976504-10215-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

In the bio_for_each_segment loop, bvl always points current
bio_vec, so the same as bio_iovec_idx(, i). Let's get rid of
it.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 026452bbb030..0760716d0e3e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -585,7 +585,7 @@ async_copy_data(int frombio, struct bio *bio, struct page *page,
 	init_async_submit(&submit, flags, tx, NULL, NULL, NULL);
 
 	bio_for_each_segment(bvl, bio, i) {
-		int len = bio_iovec_idx(bio, i)->bv_len;
+		int len = bvl->bv_len;
 		int clen;
 		int b_offset = 0;
 
@@ -601,8 +601,8 @@ async_copy_data(int frombio, struct bio *bio, struct page *page,
 			clen = len;
 
 		if (clen > 0) {
-			b_offset += bio_iovec_idx(bio, i)->bv_offset;
-			bio_page = bio_iovec_idx(bio, i)->bv_page;
+			b_offset += bvl->bv_offset;
+			bio_page = bvl->bv_page;
 			if (frombio)
 				tx = async_memcpy(page, bio_page, page_offset,
 						  b_offset, clen, &submit);
-- 
1.7.5.2
