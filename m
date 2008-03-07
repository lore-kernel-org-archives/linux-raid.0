From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 2] md: Reduce CPU wastage on idle md array with a write-intent bitmap. fix
Date: Fri, 7 Mar 2008 16:00:53 +1100
Message-ID: <1080307050053.26127@suse.de>
References: <20080307155754.25976.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Recent patch titled
  Reduce CPU wastage on idle md array with a write-intent bitmap.

would sometimes leave the array with dirty bitmap bits that stay
dirty.  A subsequent write would sort things out so it isn't a big
problem, but should be fixed nonetheless.

We need to make sure that when the bitmap becomes not "allclean", the
daemon_sleep really does get set to a sensible value.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-03-07 15:51:23.000000000 +1100
+++ ./drivers/md/bitmap.c	2008-03-07 15:56:57.000000000 +1100
@@ -1045,7 +1045,8 @@ void bitmap_daemon_work(struct bitmap *b
 	if (bitmap == NULL)
 		return;
 	if (time_before(jiffies, bitmap->daemon_lastrun + bitmap->daemon_sleep*HZ))
-		return;
+		goto done;
+
 	bitmap->daemon_lastrun = jiffies;
 	if (bitmap->allclean) {
 		bitmap->mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
@@ -1142,6 +1143,7 @@ void bitmap_daemon_work(struct bitmap *b
 		}
 	}
 
+ done:
 	if (bitmap->allclean == 0)
 		bitmap->mddev->thread->timeout = bitmap->daemon_sleep * HZ;
 }
