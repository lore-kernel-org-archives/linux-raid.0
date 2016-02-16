From: Jes.Sorensen@redhat.com
Subject: [PATCH] md/raid5: Compare apples to apples (or sectors to sectors)
Date: Tue, 16 Feb 2016 16:44:24 -0500
Message-ID: <1455659064-15940-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

'max_discard_sectors' is in sectors, while 'stripe' is in bytes.

This fixes the problem where DISCARD would get disabled on some larger
RAID5 configurations (6 or more drives in my testing), while it worked
as expected with smaller configurations.

Fixes: 620125f2bf8 ("MD: raid5 trim support")
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
This bug has been present since RAID5 DISCARD was introduced, so it applies
to stable as well.

 drivers/md/raid5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b4f02c9..7f770b0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7014,8 +7014,8 @@ static int raid5_run(struct mddev *mddev)
 		}
 
 		if (discard_supported &&
-		   mddev->queue->limits.max_discard_sectors >= stripe &&
-		   mddev->queue->limits.discard_granularity >= stripe)
+		    mddev->queue->limits.max_discard_sectors >= (stripe >> 9) &&
+		    mddev->queue->limits.discard_granularity >= stripe)
 			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
 						mddev->queue);
 		else
-- 
1.8.3.1

