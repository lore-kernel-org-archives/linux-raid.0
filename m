From: qiyong <qiyong@fc-cn.com>
Subject: [patch] raid5_unplug_device() fix
Date: Thu, 20 Apr 2006 18:01:03 +0800
Message-ID: <20060420100103.GA16687@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: akpm@osdl.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Hello,

Fix raid5_unplug_device() to not disturb raid5d unnecessarily.

Signed-off-by: Coywolf Qi Hunt <qiyong@fc-cn.com>
---

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3184360..eff1d9c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1680,8 +1680,8 @@ static void raid5_unplug_device(request_
 	if (blk_remove_plug(q)) {
 		conf->seq_flush++;
 		raid5_activate_delayed(conf);
+		md_wakeup_thread(mddev->thread);
 	}
-	md_wakeup_thread(mddev->thread);
 
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 

-- 
Coywolf Qi Hunt
