From: Shaohua Li <shli@kernel.org>
Subject: [patch]raid5: delete another BUG_ON
Date: Mon, 14 Apr 2014 14:14:17 +0800
Message-ID: <20140414061417.GA26258@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


I hit another BUG_ON with e240c1839d11152b0355442. In __get_priority_stripe(),
stripe count equals to 0 initially. Between atomic_inc and BUG_ON,
get_active_stripe() finds the stripe. So the stripe count isn't 1 any more.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-04-14 11:44:11.448492119 +0800
+++ linux/drivers/md/raid5.c	2014-04-14 11:52:19.158359774 +0800
@@ -4371,7 +4371,6 @@ static struct stripe_head *__get_priorit
 	}
 	list_del_init(&sh->lru);
 	atomic_inc(&sh->count);
-	BUG_ON(atomic_read(&sh->count) != 1);
 	return sh;
 }
 
