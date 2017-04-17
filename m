From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] md/raid10: wait up frozen array in handle_write_completed
Date: Mon, 17 Apr 2017 17:11:05 +0800
Message-ID: <20170417091105.27180-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, neilb@suse.com
List-Id: linux-raid.ids

Since nr_queued is changed, we need to call wake_up here
if the array is already frozen and waiting for condition
"nr_pending == nr_queued + extra" to be true.

And commit 824e47daddbf ("RAID1: avoid unnecessary spin
locks in I/O barrier code") which has already added the
wake_up for raid1.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/raid10.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4167091..acb3f46 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2704,6 +2704,11 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 			list_add(&r10_bio->retry_list, &conf->bio_end_io_list);
 			conf->nr_queued++;
 			spin_unlock_irq(&conf->device_lock);
+			/*
+			 * In case freeze_array() is waiting for condition
+			 * nr_pending == nr_queued + extra to be true.
+			 */
+			wake_up(&conf->wait_barrier);
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
 			if (test_bit(R10BIO_WriteError,
-- 
2.10.0

