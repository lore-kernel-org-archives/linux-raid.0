From: Jan Ceuleers <jan.ceuleers@gmail.com>
Subject: Fwd: [PATCH] md: remove ro check in md_check_recovery()
Date: Sat, 09 Jul 2011 12:00:27 +0200
Message-ID: <4E1826BB.7020903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Namhyung Kim <namhyung@gmail.com>
List-Id: linux-raid.ids

Forwarding to linux-raid

-------- Original Message --------
Subject: 	[PATCH] md: remove ro check in md_check_recovery()
Date: 	Thu, 7 Jul 2011 05:41:06 +0900
From: 	Namhyung Kim <namhyung@gmail.com>
To: 	Neil Brown <neilb@suse.de>
CC: 	linux-raid@vger.kernel.org



Commit c89a8eee6154 ("Allow faulty devices to be removed from a
readonly array.") added some work on ro array in the function,
but it couldn't be done since we didn't allow the ro array to be
handled from the beginning. Fix it.

Signed-off-by: Namhyung Kim<namhyung@gmail.com>
---
  drivers/md/md.c |    3 ---
  1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 53e8d75314c3..a4022e679b63 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7179,9 +7179,6 @@ void md_check_recovery(mddev_t *mddev)
  	if (mddev->bitmap)
  		bitmap_daemon_work(mddev);

-	if (mddev->ro)
-		return;
-
  	if (signal_pending(current)) {
  		if (mddev->pers->sync_request&&  !mddev->external) {
  			printk(KERN_INFO "md: %s in immediate safe mode\n",
-- 
1.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


