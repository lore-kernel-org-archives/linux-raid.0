From: Dan Carpenter <error27@gmail.com>
Subject: [patch] md/raid10: double lock typo in handle_read_error()
Date: Wed, 27 Jul 2011 12:52:02 +0300
Message-ID: <20110727095202.GJ3824@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This should be a spin_unlock_irq() instead of spin_lock_irq()

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9214e08..8b29cd4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2117,7 +2117,7 @@ read_more:
 			mbio->bi_phys_segments = 2;
 		else
 			mbio->bi_phys_segments++;
-		spin_lock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->device_lock);
 		generic_make_request(bio);
 		bio = NULL;
 
