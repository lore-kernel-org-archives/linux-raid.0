From: Xiao Ni <xni@redhat.com>
Subject: [MD PATCH 1/1] Don't add nr_pending for resync requests
Date: Mon, 24 Apr 2017 16:47:15 +0800
Message-ID: <1493023635-5652-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, ncroxon@redhat.com
List-Id: linux-raid.ids

In newer barrier codes, raise_barrier waits if conf->nr_pending[idx] is not zero.
After all the conditions are true, the resync request can go on be handling. But
it adds conf->nr_pending[idx] again. The next resync request hit the same bucket
idx need to wait the resync request which is submitted before. The performance
of resync/recovery is degraded.

I did some tests:
1. Before removing the codes, the resync performance is:
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdc               0.00     0.00    0.00  164.00     0.00    10.13   126.46     0.95    5.80    0.00    5.80   5.82  95.40
sdb               0.00     0.00  163.00    2.00    10.19     0.00   126.47     0.04    0.25    0.18    5.50   0.25   4.10
2. After removing the codes, the resync performance is:
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdc               0.00  2164.00    0.00  751.00     0.00   182.06   496.49     7.49    9.95    0.00    9.95   1.33 100.00
sdb            2162.00     0.00  752.00    0.00   182.25     0.00   496.34     0.56    0.74    0.74    0.00   0.65  48.80

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a34f587..48567ea 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -869,7 +869,6 @@ static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
 			     atomic_read(&conf->barrier[idx]) < RESYNC_DEPTH,
 			    conf->resync_lock);
 
-	atomic_inc(&conf->nr_pending[idx]);
 	spin_unlock_irq(&conf->resync_lock);
 }
 
@@ -880,7 +879,6 @@ static void lower_barrier(struct r1conf *conf, sector_t sector_nr)
 	BUG_ON(atomic_read(&conf->barrier[idx]) <= 0);
 
 	atomic_dec(&conf->barrier[idx]);
-	atomic_dec(&conf->nr_pending[idx]);
 	wake_up(&conf->wait_barrier);
 }
 
-- 
2.7.4

