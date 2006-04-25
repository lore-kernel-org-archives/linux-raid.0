From: Coywolf Qi Hunt <qiyong@fc-cn.com>
Subject: [patch 1/2] raid6_end_write_request() spinlock fix
Date: Tue, 25 Apr 2006 11:35:42 +0800
Message-ID: <20060425033542.GA4087@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751271AbWDYDdj@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@osdl.org
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Reduce the raid6_end_write_request() spinlock window.

Signed-off-by: Coywolf Qi Hunt <qiyong@fc-cn.com>
---

diff --git a/drivers/md/raid6main.c b/drivers/md/raid6main.c
index bc69355..820536e 100644
--- a/drivers/md/raid6main.c
+++ b/drivers/md/raid6main.c
@@ -468,7 +468,6 @@ static int raid6_end_write_request (stru
  	struct stripe_head *sh = bi->bi_private;
 	raid6_conf_t *conf = sh->raid_conf;
 	int disks = conf->raid_disks, i;
-	unsigned long flags;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
 	if (bi->bi_size)
@@ -486,16 +485,14 @@ static int raid6_end_write_request (stru
 		return 0;
 	}
 
-	spin_lock_irqsave(&conf->device_lock, flags);
 	if (!uptodate)
 		md_error(conf->mddev, conf->disks[i].rdev);
 
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
-
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
-	__release_stripe(conf, sh);
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	release_stripe(sh);
+
 	return 0;
 }
 

-- 
Coywolf Qi Hunt
