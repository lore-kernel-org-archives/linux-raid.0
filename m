From: Coywolf Qi Hunt <qiyong@fc-cn.com>
Subject: [patch 2/2] raid6_unplug_device() fix
Date: Tue, 25 Apr 2006 11:36:16 +0800
Message-ID: <20060425033616.GA27664@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: akpm@osdl.org
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Fix raid6_unplug_device() to not disturb raid6d unnecessarily.

Signed-off-by: Coywolf Qi Hunt <qiyong@fc-cn.com>
---

diff --git a/drivers/md/raid6main.c b/drivers/md/raid6main.c
index 820536e..d3deedb 100644
--- a/drivers/md/raid6main.c
+++ b/drivers/md/raid6main.c
@@ -1644,8 +1644,8 @@ static void raid6_unplug_device(request_
 	if (blk_remove_plug(q)) {
 		conf->seq_flush++;
 		raid6_activate_delayed(conf);
+		md_wakeup_thread(mddev->thread);
 	}
-	md_wakeup_thread(mddev->thread);
 
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 

-- 
Coywolf Qi Hunt
