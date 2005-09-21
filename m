From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md ] Better handling of readerrors with raid5.
Date: Wed, 21 Sep 2005 11:14:19 +0200
Message-ID: <17201.9323.915024.189868@cse.unsw.edu.au>
References: <20050916125754.11044.patches@notabene>
	<1050916030157.11071@suse.de>
	<62b0912f050920171550edcab1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="jQDTzwaGrk"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Molle Bestefich on Wednesday September 21
Sender: linux-raid-owner@vger.kernel.org
To: molle.bestefich@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--jQDTzwaGrk
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

On Wednesday September 21, molle.bestefich@gmail.com wrote:
> NeilBrown wrote:
> > TESTERS WANTED!!  SEE BELOW...
> > 
> > This patch changes the behaviour of raid5 when it gets a read error.
> > Instead of just failing the device, it tried to find out what should
> > have been there, and writes it over the bad block.
> 
> Jip-hee!  Beautiful!!
> Neil, a big, warm and fuzzy Thank You for all the hard work you put into MD!
> 

:-)


> I do not have a test system, so I've tried to apply the patch to a
> smallish (6 disk ata) live system instead.  (Am I sane?)

Think "courageous".  However I think there is very little risk.  My
desire for testing is not that I think it might corrupt data or
anything like that, but simply that real failures have fairly
complicated characteristics, in terms of delays so many-happen-at-once
and such, I would really like to see a trace of what happens in
several real-world situations - maybe some refinements can make it
handle failure conditions better.


> 
> Some of the disks have probably developed a couple of bad blocks here
> and there by now.  I imagine doing a 'dd' from the MD device will read
> at least 83% of all sectors (?), so there's a fair chance I'll hit
> something if it's there.

I'm nearly ready to give away a patch which does a background parity
check - it reads all blocks and checks parity, and reports the error
count etc.  Running such a thing every night (or every week) is
probably a good idea in some situations, but really needs the
fix-read-errors patch.

> 
> Applying the patch doesn't quite work for me:
> ==============================================
> linux-2.6.13.2 # patch --dry-run -p0 < md-rewrite-bad-blocks.patch
> patching file ./drivers/md/raid5.c
> Hunk #1 succeeded at 339 (offset -10 lines).
> Hunk #3 succeeded at 963 (offset -20 lines).
> Hunk #4 FAILED at 983.
> Hunk #5 succeeded at 1044 (offset -2 lines).
> Hunk #6 succeeded at 1274 (offset -32 lines).
> 1 out of 6 hunks FAILED -- saving rejects to file ./drivers/md/raid5.c.rej
> patching file ./include/linux/raid/raid5.h
> Hunk #1 succeeded at 153 (offset -1 lines).
> ==============================================
> 
> Hunk #4 succeds if given a fuzz of 3...
> Is it safe to use the patch with 2.6.13.2?

Yes, the changes are quite independent.  I've attached a version of
the patch that applies cleanly against 2.6.13.2.

NeilBrown


--jQDTzwaGrk
Content-Type: text/plain
Content-Disposition: inline;
	filename="patch"
Content-Transfer-Encoding: 7bit

Status: ok

Better handling of readerrors with raid5.


Instead of failing a drive on read-error, we attempt to
re-write the block, and then re-read.  If that all works,
we allow the device to remain in the array.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c         |   61 +++++++++++++++++++++++++++++++++++++++----
 ./include/linux/raid/raid5.h |    2 +
 2 files changed, 58 insertions(+), 5 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-09-21 11:06:49.000000000 +0200
+++ ./drivers/md/raid5.c	2005-09-21 11:07:19.000000000 +0200
@@ -339,7 +339,7 @@ static void shrink_stripes(raid5_conf_t 
 	conf->slab_cache = NULL;
 }
 
-static int raid5_end_read_request (struct bio * bi, unsigned int bytes_done,
+static int raid5_end_read_request(struct bio * bi, unsigned int bytes_done,
 				   int error)
 {
  	struct stripe_head *sh = bi->bi_private;
@@ -391,10 +391,27 @@ static int raid5_end_read_request (struc
 		}
 #else
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
-#endif		
+#endif
+		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
+			printk("R5: read error corrected!!\n");
+			clear_bit(R5_ReadError, &sh->dev[i].flags);
+			clear_bit(R5_ReWrite, &sh->dev[i].flags);
+		}
 	} else {
-		md_error(conf->mddev, conf->disks[i].rdev);
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
+		if (conf->mddev->degraded) {
+			printk("R5: read error not correctable.\n");
+			clear_bit(R5_ReadError, &sh->dev[i].flags);
+			clear_bit(R5_ReWrite, &sh->dev[i].flags);
+			md_error(conf->mddev, conf->disks[i].rdev);
+		} else if (test_bit(R5_ReWrite, &sh->dev[i].flags)) {
+			/* Oh, no!!! */
+			printk("R5: read error NOT corrected!!\n");
+			clear_bit(R5_ReadError, &sh->dev[i].flags);
+			clear_bit(R5_ReWrite, &sh->dev[i].flags);
+			md_error(conf->mddev, conf->disks[i].rdev);
+		} else
+			set_bit(R5_ReadError, &sh->dev[i].flags);
 	}
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 #if 0
@@ -946,6 +963,12 @@ static void handle_stripe(struct stripe_
 		if (dev->written) written++;
 		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
 		if (!rdev || !rdev->in_sync) {
+			/* The ReadError flag wil just be confusing now */
+			clear_bit(R5_ReadError, &dev->flags);
+			clear_bit(R5_ReWrite, &dev->flags);
+		}
+		if (!rdev || !rdev->in_sync
+		    || test_bit(R5_ReadError, &dev->flags)) {
 			failed++;
 			failed_num = i;
 		} else
@@ -960,6 +983,14 @@ static void handle_stripe(struct stripe_
 	if (failed > 1 && to_read+to_write+written) {
 		spin_lock_irq(&conf->device_lock);
 		for (i=disks; i--; ) {
+
+			if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
+				mdk_rdev_t *rdev = conf->disks[i].rdev;
+				if (rdev && rdev->in_sync)
+					/* multiple read failures in one stripe */
+					md_error(conf->mddev, rdev);
+			}
+
 			/* fail all writes first */
 			bi = sh->dev[i].towrite;
 			sh->dev[i].towrite = NULL;
@@ -993,7 +1024,8 @@ static void handle_stripe(struct stripe_
 			}
 
 			/* fail any reads if this device is non-operational */
-			if (!test_bit(R5_Insync, &sh->dev[i].flags)) {
+			if (!test_bit(R5_Insync, &sh->dev[i].flags) ||
+			    test_bit(R5_ReadError, &sh->dev[i].flags)) {
 				bi = sh->dev[i].toread;
 				sh->dev[i].toread = NULL;
 				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
@@ -1240,7 +1272,26 @@ static void handle_stripe(struct stripe_
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
-	
+
+	/* If the failed drive is just a ReadError, then we might need to progress
+	 * the repair/check process
+	 */
+	if (failed == 1 && test_bit(R5_ReadError, &sh->dev[failed_num].flags)
+	    && !test_bit(R5_LOCKED, &sh->dev[failed_num].flags)
+	    && test_bit(R5_UPTODATE, &sh->dev[failed_num].flags)
+		) {
+		dev = &sh->dev[failed_num];
+		if (!test_bit(R5_ReWrite, &dev->flags)) {
+			set_bit(R5_Wantwrite, &dev->flags);
+			set_bit(R5_ReWrite, &dev->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+		} else {
+			/* let's read it back */
+			set_bit(R5_Wantread, &dev->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+		}
+	}
+
 	spin_unlock(&sh->lock);
 
 	while ((bi=return_bi)) {

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2005-09-21 11:06:49.000000000 +0200
+++ ./include/linux/raid/raid5.h	2005-09-21 11:06:52.000000000 +0200
@@ -153,6 +153,8 @@ struct stripe_head {
 #define	R5_Wantwrite	5
 #define	R5_Syncio	6	/* this io need to be accounted as resync io */
 #define	R5_Overlap	7	/* There is a pending overlapping request on this block */
+#define	R5_ReadError	8	/* seen a read error here recently */
+#define	R5_ReWrite	9	/* have tried to over-write the readerror */
 
 /*
  * Write method

--jQDTzwaGrk--
