From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 2 of 4] Fix raid6 problem
Date: Tue, 02 Nov 2004 14:37:45 +1100
Message-ID: <E1COpUP-00038y-Aq@notabene.cse.unsw.edu.au>
References: <20041102143440.12019.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Sometimes it didn't read all (working) drives before
a parity calculation.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid6main.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-11-02 14:20:15.000000000 +1100
+++ ./drivers/md/raid6main.c	2004-11-02 14:20:15.000000000 +1100
@@ -734,7 +734,6 @@ static void compute_parity(struct stripe
 	case READ_MODIFY_WRITE:
 		BUG();		/* READ_MODIFY_WRITE N/A for RAID-6 */
 	case RECONSTRUCT_WRITE:
-	case UPDATE_PARITY:	/* Is this right? */
 		for (i= disks; i-- ;)
 			if ( i != pd_idx && i != qd_idx && sh->dev[i].towrite ) {
 				chosen = sh->dev[i].towrite;
@@ -770,7 +769,8 @@ static void compute_parity(struct stripe
 		i = d0_idx;
 		do {
 			ptrs[count++] = page_address(sh->dev[i].page);
-
+			if (count <= disks-2 && !test_bit(R5_UPTODATE, &sh->dev[i].flags))
+				printk("block %d/%d not uptodate on parity calc\n", i,count);
 			i = raid6_next_disk(i, disks);
 		} while ( i != d0_idx );
 //		break;
@@ -818,7 +818,7 @@ static void compute_block_1(struct strip
 			if (test_bit(R5_UPTODATE, &sh->dev[i].flags))
 				ptr[count++] = p;
 			else
-				PRINTK("compute_block() %d, stripe %llu, %d"
+				printk("compute_block() %d, stripe %llu, %d"
 				       " not present\n", dd_idx,
 				       (unsigned long long)sh->sector, i);
 
@@ -875,6 +875,9 @@ static void compute_block_2(struct strip
 		do {
 			ptrs[count++] = page_address(sh->dev[i].page);
 			i = raid6_next_disk(i, disks);
+			if (i != dd_idx1 && i != dd_idx2 &&
+			    !test_bit(R5_UPTODATE, &sh->dev[i].flags))
+				printk("compute_2 with missing block %d/%d\n", count, i);
 		} while ( i != d0_idx );
 
 		if ( failb == disks-2 ) {
@@ -1157,17 +1160,15 @@ static void handle_stripe(struct stripe_
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
 	 */
-	if (to_read || non_overwrite || (syncing && (uptodate < disks))) {
+	if (to_read || non_overwrite || (to_write && failed) || (syncing && (uptodate < disks))) {
 		for (i=disks; i--;) {
 			dev = &sh->dev[i];
 			if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
 			    (dev->toread ||
 			     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
 			     syncing ||
-			     (failed >= 1 && (sh->dev[failed_num[0]].toread ||
-					 (sh->dev[failed_num[0]].towrite && !test_bit(R5_OVERWRITE, &sh->dev[failed_num[0]].flags)))) ||
-			     (failed >= 2 && (sh->dev[failed_num[1]].toread ||
-					 (sh->dev[failed_num[1]].towrite && !test_bit(R5_OVERWRITE, &sh->dev[failed_num[1]].flags))))
+			     (failed >= 1 && (sh->dev[failed_num[0]].toread || to_write)) ||
+			     (failed >= 2 && (sh->dev[failed_num[1]].toread || to_write))
 				    )
 				) {
 				/* we would like to get this block, possibly
