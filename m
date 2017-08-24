From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] md/raid5: release/flush io in raid5_do_work()
Date: Thu, 24 Aug 2017 09:53:59 -0700
Message-ID: <20170824165359.4065174-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, "4.4+" <stable@vger.kernel.org>
List-Id: linux-raid.ids

In raid5, there are scenarios where some ios are deferred to a later
time, and some IO need a flush to complete. To make sure we make
progress with these IOs, we need to call the following functions:

    flush_deferred_bios(conf);
    r5l_flush_stripe_to_raid(conf->log);

Both of these functions are called in raid5d(), but missing in
raid5_do_work(). As a result, these functions are not called
when multi-threading (group_thread_cnt > 0) is enabled. This patch
adds calls to these function to raid5_do_work().

Note for stable branches:

  r5l_flush_stripe_to_raid(conf->log) is need for 4.4+
  flush_deferred_bios(conf) is only needed for 4.11+

Cc: stable@vger.kernel.org (4.4+)
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f64ff32..6af57c6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6226,6 +6226,10 @@ static void raid5_do_work(struct work_struct *work)
 
 	spin_unlock_irq(&conf->device_lock);
 
+	flush_deferred_bios(conf);
+
+	r5l_flush_stripe_to_raid(conf->log);
+
 	async_tx_issue_pending_all();
 	blk_finish_plug(&plug);
 
-- 
2.9.5

