From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 3 - md/linear oops fix
Date: Wed, 26 Mar 2003 11:11:01 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18xyVR-0004Tx-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Three patches for md/raid in 2.5.latest....

### Comments for ChangeSet

From: Daniel McNeil <daniel@osdl.org>

This fixes an oops caused by incorrect usage of sector_div()
in which_dev() in md/linear.c.  It was dereferencing an non-existent
hash table entry.

 ----------- Diffstat output ------------
 ./drivers/md/linear.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-03-26 09:44:40.000000000 +1100
+++ ./drivers/md/linear.c	2003-03-26 09:44:40.000000000 +1100
@@ -37,7 +37,11 @@ static inline dev_info_t *which_dev(mdde
 	linear_conf_t *conf = mddev_to_conf(mddev);
 	sector_t block = sector >> 1;
 
-	hash = conf->hash_table + sector_div(block, conf->smallest->size);
+	/*
+	 * sector_div(a,b) returns the remainer and sets a to a/b
+	 */
+	(void)sector_div(block, conf->smallest->size);
+	hash = conf->hash_table + block;
 
 	if ((sector>>1) >= (hash->dev0->size + hash->dev0->offset))
 		return hash->dev1;
