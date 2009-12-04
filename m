From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/22] md: remove needless setting of thread->timeout in
	raid10_quiesce
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.53846.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As bitmap_create and bitmap_destroy already set thread->timeout
as appropriate, there is no need to do it in raid10_quiesce.
There is a possible need to wake the thread after the timeout
has been set low, but it is better to do that where the timeout
is actually set low, in bitmap_create.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |    1 +
 drivers/md/raid10.c |    7 -------
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5e6fd37..4df173a 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1695,6 +1695,7 @@ int bitmap_create(mddev_t *mddev)
 	mddev->bitmap = bitmap;
 
 	mddev->thread->timeout = mddev->bitmap_info.daemon_sleep;
+	md_wakeup_thread(mddev->thread);
 
 	bitmap_update_sb(bitmap);
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 064c2bb..d9e28a6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2275,13 +2275,6 @@ static void raid10_quiesce(mddev_t *mddev, int state)
 		lower_barrier(conf);
 		break;
 	}
-	if (mddev->thread) {
-		if (mddev->bitmap)
-			mddev->thread->timeout = mddev->bitmap_info.daemon_sleep;
-		else
-			mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
-		md_wakeup_thread(mddev->thread);
-	}
 }
 
 static struct mdk_personality raid10_personality =


