From: <oferh@marvell.com>
Subject: [PATCH] md/raid5: add thread_group worker async_tx_issue_pending_all
Date: Mon, 24 Jul 2017 09:17:40 +0300
Message-ID: <1500877060-12256-1-git-send-email-oferh@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: shli@kernel.org
Cc: nadavh@marvell.com, linux-raid@vger.kernel.org, Ofer Heifetz <oferh@marvell.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

From: Ofer Heifetz <oferh@marvell.com>

Since thread_group worker and raid5d kthread are not in sync, if
worker writes stripe before raid5d then requests will be waiting
for issue_pendig.

Issue observed when building raid5 with ext4, in some build runs
jbd2 would get hung and requests were waiting in the HW engine
waiting to be issued.

Fix this by adding a call to async_tx_issue_pending_all in the
raid5_do_work.

Signed-off-by: Ofer Heifetz <oferh@marvell.com>
Cc: stable@vger.kernel.org
---
 drivers/md/raid5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index aeeb8d6..3c0b924 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6237,6 +6237,8 @@ static void raid5_do_work(struct work_struct *work)
 	pr_debug("%d stripes handled\n", handled);
 
 	spin_unlock_irq(&conf->device_lock);
+
+	async_tx_issue_pending_all();
 	blk_finish_plug(&plug);
 
 	pr_debug("--- raid5worker inactive\n");
-- 
1.9.1
