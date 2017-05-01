From: Shaohua Li <shli@fb.com>
Subject: [PATCH] md/raid10: skip spare disk as 'first' disk
Date: Mon, 1 May 2017 12:22:01 -0700
Message-ID: <7adb3f88bd6d611511ad14dcf8da6898e5f8168d.1493666464.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Guoqing Jiang <gqjiang@suse.com>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

Commit 6f287ca(md/raid10: reset the 'first' at the end of loop) ignores
a case in reshape, the first rdev could be a spare disk, which shouldn't
be accounted as the first disk since it doesn't include the offset info.

Fix: 6f287ca(md/raid10: reset the 'first' at the end of loop)
Cc: Guoqing Jiang <gqjiang@suse.com>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2883b72..cce23be 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4079,8 +4079,8 @@ static int raid10_start_reshape(struct mddev *mddev)
 				diff = 0;
 			if (first || diff < min_offset_diff)
 				min_offset_diff = diff;
+			first = 0;
 		}
-		first = 0;
 	}
 
 	if (max(before_length, after_length) > min_offset_diff)
-- 
2.9.3

