From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 4 of 22 - Make raid5 work for big bios
Date: Wed, 19 Jun 2002 10:50:12 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54596.562654.994996@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

--- ./drivers/md/raid5.c	2002/06/18 03:26:36	1.4
+++ ./drivers/md/raid5.c	2002/06/18 03:32:06	1.5
@@ -633,7 +633,6 @@
 		else 
 			page_offset = (signed)(sector - bio->bi_sector) * -512;
 		bio_for_each_segment(bvl, bio, i) {
-			char *ba = __bio_kmap(bio, i);
 			int len = bio_iovec_idx(bio,i)->bv_len;
 			int clen;
 			int b_offset = 0;			
@@ -648,13 +647,16 @@
 				clen = STRIPE_SIZE - page_offset;	
 			else clen = len;
 			
-			if (len > 0) {
+			if (clen > 0) {
+				char *ba = __bio_kmap(bio, i);
 				if (frombio)
 					memcpy(pa+page_offset, ba+b_offset, clen);
 				else
 					memcpy(ba+b_offset, pa+page_offset, clen);
-			}
-			__bio_kunmap(bio, i);
+				__bio_kunmap(bio, i);
+			}	
+			if (clen < len) /* hit end of page */
+				break;
 			page_offset +=  len;
 		}
 	}
