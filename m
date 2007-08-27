From: Yuri Tikhonov <yur@emcraft.com>
Subject: md raid acceleration and the async_tx api
Date: Mon, 27 Aug 2007 12:49:48 +0400
Message-ID: <200708271249.48684.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dan.j.williams@intel.com
Cc: linux-raid@vger.kernel.org, Wolfgang Denk <wd@denx.de>, dzu@denx.de
List-Id: linux-raid.ids


 Hello,

 I tested the h/w accelerated RAID-5 using the kernel with PAGE_SIZE set to 
64KB and found the bonnie++ application hangs-up during the "Re-writing" 
test. I made some investigations and discovered that the hang-up occurs 
because one of the mpage_end_io_read() calls is missing (these are the 
callbacks initiated from the ops_complete_biofill() function).

 The fact is that my low-level ADMA driver (the ppc440spe one) successfully 
initiated the ops_complete_biofill() callback but the ops_complete_biofill() 
function itself skipped calling the bi_end_io() handler of the completed bio 
(current dev->read) because during processing of this (current dev->read) bio 
some other request had come to the sh (current dev_q->toread). Thus 
ops_complete_biofill() scheduled another biofill operation which, as a 
result, overwrote the unacknowledged bio (dev->read in ops_run_biofill()), 
and so we lost the previous dev->read bio completely.

 Here is a patch that solves this problem. Perhaps this might be implemented 
in some more elegant and effective way. What are your thoughts regarding 
this?

 Regards, Yuri

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 08b4893..7abc96b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -838,11 +838,24 @@ static void ops_complete_biofill(void *stripe_head_ref)
 		/* acknowledge completion of a biofill operation */
 		/* and check if we need to reply to a read request
 		 */
-		if (test_bit(R5_Wantfill, &dev_q->flags) && !dev_q->toread) {
+		if (test_bit(R5_Wantfill, &dev_q->flags)) {
 			struct bio *rbi, *rbi2;
 			struct r5dev *dev = &sh->dev[i];
 
-			clear_bit(R5_Wantfill, &dev_q->flags);
+			/* There is a chance that another fill operation
+			 * had been scheduled for this dev while we
+			 * processed sh. In this case do one of the following
+			 * alternatives:
+			 * - if there is no active completed biofill for the dev
+			 *   then go to the next dev leaving Wantfill set;
+			 * - if there is active completed biofill for the dev
+			 *   then ack it but leave Wantfill set.
+			 */
+			if (dev_q->toread && !dev->read)
+				continue;
+
+			if (!dev_q->toread)
+				clear_bit(R5_Wantfill, &dev_q->flags);
 
 			/* The access to dev->read is outside of the
 			 * spin_lock_irq(&conf->device_lock), but is protected
