From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-6: help wanted
Date: Wed, 27 Oct 2004 13:38:00 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16767.6168.695527.234379@cse.unsw.edu.au>
References: <cleqh6$ps4$1@terminus.zytor.com>
	<16764.37392.910080.718564@cse.unsw.edu.au>
	<20041025062026.GA17502@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jim Paris on Monday October 25
To: Jim Paris <jim@jtan.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 25, jim@jtan.com wrote:
> > Does this fix the problem?
> > It is definitely wrong as it is.
> > 
> ..
> >  	case RECONSTRUCT_WRITE:
> > -	case UPDATE_PARITY:	/* Is this right? */
> 
> No, it does not.  Same sort of corruption with that line removed.


Ok, take-2.  I've tested this one myself and it does seem to fix it.

The problem is that it is sometimes using parity to reconstruct a
block, when not all of the blocks have been read in.

In raid5, there are two choices for write - reconstruct-write or
read-modify-write.

If there are any failed drives, it always chooses read-modify-write
and so only has to read data from good drives.

raid6 only allows for reconstruct-write, so if it ever writes to an
array with a failed drive, it must read all blocks and reconstruct the
missing blocks before allowing the write.
As this is something that raid5 didn't have to care about, and as the
raid6 code was based on the raid5 code, it is easy to see how this
case was missed.

The following patch added a bit of tracing to track other cases
(hopefully non-existent) where calculations are done using
non-existent data, and make sure the required blocks are pre-read.
Possible this code (in handle_stripe) needs a substantial clean up...

I'll wait for comments and further testing before I forward it to
Andrew.


NeilBrown

========================================================
Fix raid6 problem

Sometimes it didn't read all (working) drives before
a parity calculation.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid6main.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-10-22 16:14:11.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-10-27 13:11:26.000000000 +1000
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
