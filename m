From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 002 of 18] Fix locking problem in r5/r6
Date: Mon, 28 Nov 2005 10:39:45 +1100
Message-ID: <1051127233945.14757@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


bitmap_unplug actually writes data (bits) to storage, so we
shouldn't be holding a spinlock...

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c     |    2 ++
 ./drivers/md/raid6main.c |    2 ++
 2 files changed, 4 insertions(+)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-11-28 10:08:19.000000000 +1100
+++ ./drivers/md/raid5.c	2005-11-28 10:08:33.000000000 +1100
@@ -1704,7 +1704,9 @@ static void raid5d (mddev_t *mddev)
 
 		if (conf->seq_flush - conf->seq_write > 0) {
 			int seq = conf->seq_flush;
+			spin_unlock_irq(&conf->device_lock);
 			bitmap_unplug(mddev->bitmap);
+			spin_lock_irq(&conf->device_lock);
 			conf->seq_write = seq;
 			activate_bit_delay(conf);
 		}

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-11-28 10:08:19.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-11-28 10:08:33.000000000 +1100
@@ -1784,7 +1784,9 @@ static void raid6d (mddev_t *mddev)
 
 		if (conf->seq_flush - conf->seq_write > 0) {
 			int seq = conf->seq_flush;
+			spin_unlock_irq(&conf->device_lock);
 			bitmap_unplug(mddev->bitmap);
+			spin_lock_irq(&conf->device_lock);
 			conf->seq_write = seq;
 			activate_bit_delay(conf);
 		}
