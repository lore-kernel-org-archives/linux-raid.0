From: Shaohua Li <shli@kernel.org>
Subject: [patch]raid5: support sync request
Date: Tue, 17 Apr 2012 13:09:38 +0800
Message-ID: <4F8CFB12.306@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids


REQ_SYNC is ignored in current raid5 code. Block layer does use it to do 
policy,
for example ioscheduler. This patch adds it.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
  drivers/md/raid5.c |   12 ++++++++++--
  drivers/md/raid5.h |    1 +
  2 files changed, 11 insertions(+), 2 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-04-17 11:59:24.556008869 +0800
+++ linux/drivers/md/raid5.c	2012-04-17 12:06:06.306007114 +0800
@@ -518,6 +518,8 @@ static void ops_run_io(struct stripe_hea
  			replace_only = 1;
  		} else
  			continue;
+		if (test_and_clear_bit(R5_SyncIO, &sh->dev[i].flags))
+			rw |= REQ_SYNC;

  		bi = &sh->dev[i].req;
  		rbi = &sh->dev[i].rreq; /* For writing to replacement */
@@ -1114,6 +1116,8 @@ ops_run_biodrain(struct stripe_head *sh,
  				dev->sector + STRIPE_SECTORS) {
  				if (wbi->bi_rw & REQ_FUA)
  					set_bit(R5_WantFUA, &dev->flags);
+				if (wbi->bi_rw & REQ_SYNC)
+					set_bit(R5_SyncIO, &dev->flags);
  				tx = async_copy_data(1, wbi, dev->page,
  					dev->sector, tx);
  				wbi = r5_next_bio(wbi, dev->sector);
@@ -1131,13 +1135,15 @@ static void ops_complete_reconstruct(voi
  	int pd_idx = sh->pd_idx;
  	int qd_idx = sh->qd_idx;
  	int i;
-	bool fua = false;
+	bool fua = false, sync = false;

  	pr_debug("%s: stripe %llu\n", __func__,
  		(unsigned long long)sh->sector);

-	for (i = disks; i--; )
+	for (i = disks; i--; ) {
  		fua |= test_bit(R5_WantFUA, &sh->dev[i].flags);
+		sync |= test_bit(R5_SyncIO, &sh->dev[i].flags);
+	}

  	for (i = disks; i--; ) {
  		struct r5dev *dev = &sh->dev[i];
@@ -1146,6 +1152,8 @@ static void ops_complete_reconstruct(voi
  			set_bit(R5_UPTODATE, &dev->flags);
  			if (fua)
  				set_bit(R5_WantFUA, &dev->flags);
+			if (sync)
+				set_bit(R5_SyncIO, &dev->flags);
  		}
  	}

Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2012-04-17 11:59:26.866008859 +0800
+++ linux/drivers/md/raid5.h	2012-04-17 12:00:29.196008586 +0800
@@ -285,6 +285,7 @@ enum r5dev_flags {
  			 */
  	R5_Wantdrain,	/* dev->towrite needs to be drained */
  	R5_WantFUA,	/* Write should be FUA */
+	R5_SyncIO,	/* The IO is sync */
  	R5_WriteError,	/* got a write error - need to record it */
  	R5_MadeGood,	/* A bad block has been fixed by writing to it */
  	R5_ReadRepl,	/* Will/did read from replacement rather than orig */
