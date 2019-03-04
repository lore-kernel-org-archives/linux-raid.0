From: Aditya Pakki <pakki001@umn.edu>
Subject: [PATCH] md: Fix failed allocation of md_register_thread
Date: Mon,  4 Mar 2019 16:48:54 -0600
Message-ID: <20190304224854.12494-1-pakki001@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

mddev->sync_thread can be set to NULL on kzalloc failure downstream.
The patch checks for such a scenario and frees allocated resources.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index abb5d382f64d..f52b4d9bcd24 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3939,6 +3939,8 @@ static int raid10_run(struct mddev *mddev)
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 		mddev->sync_thread = md_register_thread(md_do_sync, mddev,
 							"reshape");
+		if (!mddev->sync_thread)
+			goto out_free_conf;
 	}
 
 	return 0;
-- 
2.17.1
