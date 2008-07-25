From: Arthur Jones <ajones@riverbed.com>
Subject: [PATCH] md: raid10: wake up frozen array
Date: Fri, 25 Jul 2008 12:03:38 -0700
Message-ID: <20080725190338.GA27484@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When rescheduling a bio in raid10, we wake up
the md thread, but if the array is frozen, this
will have no effect.  This causes the array to
remain frozen for eternity.  We add a wake_up
to allow the array to de-freeze.  This code is
nearly identical to the raid1 code, which has
this fix already.

Signed-off-by: Arthur Jones <ajones@riverbed.com>
---
 drivers/md/raid10.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 159535d..d41bebb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -215,6 +215,9 @@ static void reschedule_retry(r10bio_t *r10_bio)
 	conf->nr_queued ++;
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
+	/* wake up frozen array... */
+	wake_up(&conf->wait_barrier);
+
 	md_wakeup_thread(mddev->thread);
 }
 
-- 
1.5.4.3
