From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH]  Disable raid5 handling of read-ahead
Date: Mon, 11 Aug 2003 14:28:37 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19m4IP-0002ez-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch, against 2.6.0-test3, fixes a data corruption bug in raid5
NeilBrown

### Comments for ChangeSet

raid5 trys to honour RWA_MASK, but messes it up and can return bad data.
Just ignore RAW_MASK for now.

 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-08-11 09:01:44.000000000 +1000
+++ ./drivers/md/raid5.c	2003-08-11 09:01:44.000000000 +1000
@@ -1326,7 +1326,7 @@ static int make_request (request_queue_t
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
 
-		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
+		sh = get_active_stripe(conf, new_sector, pd_idx, 0/*(bi->bi_rw&RWA_MASK)*/);
 		if (sh) {
 
 			add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK));
