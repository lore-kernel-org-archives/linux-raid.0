From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 9] md: Fix a comment that is wrong in raid5.h
Date: Mon, 31 Jul 2006 17:31:54 +1000
Message-ID: <1060731073154.24442@suse.de>
References: <20060731172842.24323.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/raid/raid5.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff .prev/include/linux/raid/raid5.h ./include/linux/raid/raid5.h
--- .prev/include/linux/raid/raid5.h	2006-07-31 16:33:02.000000000 +1000
+++ ./include/linux/raid/raid5.h	2006-07-31 16:33:02.000000000 +1000
@@ -195,8 +195,9 @@ struct stripe_head {
  * it to the count of prereading stripes.
  * When write is initiated, or the stripe refcnt == 0 (just in case) we
  * clear the PREREAD_ACTIVE flag and decrement the count
- * Whenever the delayed queue is empty and the device is not plugged, we
- * move any strips from delayed to handle and clear the DELAYED flag and set PREREAD_ACTIVE.
+ * Whenever the 'handle' queue is empty and the device is not plugged, we
+ * move any strips from delayed to handle and clear the DELAYED flag and set
+ * PREREAD_ACTIVE.
  * In stripe_handle, if we find pre-reading is necessary, we do it if
  * PREREAD_ACTIVE is set, else we set DELAYED which will send it to the delayed queue.
  * HANDLE gets cleared if stripe_handle leave nothing locked.
