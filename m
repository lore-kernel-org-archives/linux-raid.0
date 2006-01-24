From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 5] md: Make sure QUEUE_FLAG_CLUSTER is set properly for md.
Date: Tue, 24 Jan 2006 14:58:42 +1100
Message-ID: <1060124035842.28869@suse.de>
References: <20060124145516.28734.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


This flag should be set for a virtual device iff it is set
for all underlying devices.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c |    2 ++
 ./drivers/md/md.c   |    1 +
 2 files changed, 3 insertions(+)

diff ./block/ll_rw_blk.c~current~ ./block/ll_rw_blk.c
--- ./block/ll_rw_blk.c~current~	2006-01-24 14:54:19.000000000 +1100
+++ ./block/ll_rw_blk.c	2006-01-24 14:54:19.000000000 +1100
@@ -778,6 +778,8 @@ void blk_queue_stack_limits(request_queu
 	t->max_hw_segments = min(t->max_hw_segments,b->max_hw_segments);
 	t->max_segment_size = min(t->max_segment_size,b->max_segment_size);
 	t->hardsect_size = max(t->hardsect_size,b->hardsect_size);
+	if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags))
+		clear_bit(QUEUE_FLAG_CLUSTER, &t->queue_flags);
 }
 
 EXPORT_SYMBOL(blk_queue_stack_limits);

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-01-24 14:47:17.000000000 +1100
+++ ./drivers/md/md.c	2006-01-24 14:54:19.000000000 +1100
@@ -264,6 +264,7 @@ static mddev_t * mddev_find(dev_t unit)
 		kfree(new);
 		return NULL;
 	}
+	set_bit(QUEUE_FLAG_CLUSTER, &new->queue->queue_flags);
 
 	blk_queue_make_request(new->queue, md_fail_request);
 
