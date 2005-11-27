From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 008 of 18] Small cleanups for raid5
Date: Mon, 28 Nov 2005 10:40:17 +1100
Message-ID: <1051127234017.14829@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Resync code:
  A test that isn't needed,
  a 'compute_block' that makes more sense 
    elsewhere (And then doesn't need a test),
  a couple of BUG_ONs to confirm the change makes sense.

Printks:
  A few were missing KERN_*

Also fix a typo in a comment..

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-11-28 10:08:33.000000000 +1100
+++ ./drivers/md/raid5.c	2005-11-28 10:12:30.000000000 +1100
@@ -416,7 +416,7 @@ static int raid5_end_read_request(struct
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 #endif
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
-			printk("R5: read error corrected!!\n");
+			printk(KERN_INFO "raid5: read error corrected!!\n");
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		}
@@ -427,13 +427,14 @@ static int raid5_end_read_request(struct
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&conf->disks[i].rdev->read_errors);
 		if (conf->mddev->degraded)
-			printk("R5: read error not correctable.\n");
+			printk(KERN_WARNING "raid5: read error not correctable.\n");
 		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
 			/* Oh, no!!! */
-			printk("R5: read error NOT corrected!!\n");
+			printk(KERN_WARNING "raid5: read error NOT corrected!!\n");
 		else if (atomic_read(&conf->disks[i].rdev->read_errors)
 			 > conf->max_nr_stripes)
-			printk("raid5: Too many read errors, failing device.\n");
+			printk(KERN_WARNING
+			       "raid5: Too many read errors, failing device.\n");
 		else
 			retry = 1;
 		if (retry)
@@ -603,7 +604,7 @@ static sector_t raid5_compute_sector(sec
 			*dd_idx = (*pd_idx + 1 + *dd_idx) % raid_disks;
 			break;
 		default:
-			printk("raid5: unsupported algorithm %d\n",
+			printk(KERN_ERR "raid5: unsupported algorithm %d\n",
 				conf->algorithm);
 	}
 
@@ -644,7 +645,7 @@ static sector_t compute_blocknr(struct s
 			i -= (sh->pd_idx + 1);
 			break;
 		default:
-			printk("raid5: unsupported algorithm %d\n",
+			printk(KERN_ERR "raid5: unsupported algorithm %d\n",
 				conf->algorithm);
 	}
 
@@ -653,7 +654,7 @@ static sector_t compute_blocknr(struct s
 
 	check = raid5_compute_sector (r_sector, raid_disks, data_disks, &dummy1, &dummy2, conf);
 	if (check != sh->sector || dummy1 != dd_idx || dummy2 != sh->pd_idx) {
-		printk("compute_blocknr: map not correct\n");
+		printk(KERN_ERR "compute_blocknr: map not correct\n");
 		return 0;
 	}
 	return r_sector;
@@ -736,7 +737,7 @@ static void compute_block(struct stripe_
 		if (test_bit(R5_UPTODATE, &sh->dev[i].flags))
 			ptr[count++] = p;
 		else
-			printk("compute_block() %d, stripe %llu, %d"
+			printk(KERN_ERR "compute_block() %d, stripe %llu, %d"
 				" not present\n", dd_idx,
 				(unsigned long long)sh->sector, i);
 
@@ -1004,7 +1005,7 @@ static void handle_stripe(struct stripe_
 		if (dev->written) written++;
 		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
-			/* The ReadError flag wil just be confusing now */
+			/* The ReadError flag will just be confusing now */
 			clear_bit(R5_ReadError, &dev->flags);
 			clear_bit(R5_ReWrite, &dev->flags);
 		}
@@ -1287,7 +1288,7 @@ static void handle_stripe(struct stripe_
 	 * is available
 	 */
 	if (syncing && locked == 0 &&
-	    !test_bit(STRIPE_INSYNC, &sh->state) && failed <= 1) {
+	    !test_bit(STRIPE_INSYNC, &sh->state)) {
 		set_bit(STRIPE_HANDLE, &sh->state);
 		if (failed == 0) {
 			char *pagea;
@@ -1305,21 +1306,20 @@ static void handle_stripe(struct stripe_
 				if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
 					/* don't try to repair!! */
 					set_bit(STRIPE_INSYNC, &sh->state);
+				else {
+					compute_block(sh, sh->pd_idx);
+					uptodate++;
+				}
 			}
 		}
 		if (!test_bit(STRIPE_INSYNC, &sh->state)) {
+			/* either failed parity check, or recovery is happening */
 			if (failed==0)
 				failed_num = sh->pd_idx;
-			/* should be able to compute the missing block and write it to spare */
-			if (!test_bit(R5_UPTODATE, &sh->dev[failed_num].flags)) {
-				if (uptodate+1 != disks)
-					BUG();
-				compute_block(sh, failed_num);
-				uptodate++;
-			}
-			if (uptodate != disks)
-				BUG();
 			dev = &sh->dev[failed_num];
+			BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
+			BUG_ON(uptodate != disks);
+
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantwrite, &dev->flags);
 			clear_bit(STRIPE_DEGRADED, &sh->state);
@@ -1821,7 +1821,8 @@ static int run(mddev_t *mddev)
 	struct list_head *tmp;
 
 	if (mddev->level != 5 && mddev->level != 4) {
-		printk("raid5: %s: raid level not set to 4/5 (%d)\n", mdname(mddev), mddev->level);
+		printk(KERN_ERR "raid5: %s: raid level not set to 4/5 (%d)\n",
+		       mdname(mddev), mddev->level);
 		return -EIO;
 	}
 
