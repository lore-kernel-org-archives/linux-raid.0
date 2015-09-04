From: Shaohua Li <shli@fb.com>
Subject: [PATCH] raid5-cache: check stripe finish out of order
Date: Fri, 4 Sep 2015 14:14:05 -0700
Message-ID: <3a9623e22383f0fb2c22d71298ad7c6b5aff07a0.1441390514.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

stripes could finish out of order. Hence r5l_move_io_unit_list() of
__r5l_stripe_write_finished might not move any entry and leave
stripe_end_ios list empty.

This applies on top of http://marc.info/?l=linux-raid&m=144122700510667

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 410b85b..2dea05f 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -545,8 +545,13 @@ static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
+	/* might move 0 entry */
 	r5l_move_io_unit_list(&log->flushed_ios, &log->stripe_end_ios,
 		IO_UNIT_STRIPE_END);
+	if (list_empty(&log->stripe_end_ios)) {
+		spin_unlock_irqrestore(&log->io_list_lock, flags);
+		return;
+	}
 
 	last = list_last_entry(&log->stripe_end_ios,
 			struct r5l_io_unit, log_sibling);
-- 
1.8.1

