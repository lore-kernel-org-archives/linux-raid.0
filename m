From: heinzm@redhat.com
Subject: [PATCH] [REGRESSION] md: md.c: fix oops in mddev_suspend for raid0
Date: Mon,  9 May 2016 18:03:02 +0200
Message-ID: <1462809782-4772-1-git-send-email-heinzm@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: linux-raid.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Introduced by upstream commit 70d9798b95562abac005d4ba71d28820f9a201eb

The raid0 personality does not create mddev->thread as oposed to
other personalities leading to its unconditional access in
mddev_suspend() causing an oops.

Patch checks for mddev->thread in order to keep the
intention of aforementioned commit.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>


---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 194580f..d91920d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -305,7 +305,7 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
  */
 void mddev_suspend(struct mddev *mddev)
 {
-	WARN_ON_ONCE(current == mddev->thread->tsk);
+	WARN_ON_ONCE(mddev->thread && current == mddev->thread->tsk);
 	if (mddev->suspended++)
 		return;
 	synchronize_rcu();
-- 
2.5.5

