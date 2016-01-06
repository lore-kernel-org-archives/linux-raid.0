From: Shaohua Li <shli@fb.com>
Subject: [PATCH 3/3] raid5-cache: handle journal hotadd in quiesce
Date: Wed, 6 Jan 2016 14:37:15 -0800
Message-ID: <56c20f91b45a794aed995640a3e3e9aca2ef7147.1452119479.git.shli@fb.com>
References: <55aef157bf27c1de417577f02b69944a277a0141.1452119479.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55aef157bf27c1de417577f02b69944a277a0141.1452119479.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, neilb@suse.de
List-Id: linux-raid.ids

Handle journal hotadd in quiesce to avoid creating duplicated threads.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 16cf876..4e36eec 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -834,6 +834,13 @@ void r5l_quiesce(struct r5conf *conf, int state)
 		return;
 	if (state == 0) {
 		log->in_teardown = 0;
+		/*
+		 * This is a special case for hotadd. In suspend, the array has
+		 * no journal. In resume, journal is initialized as well as the
+		 * reclaim thread.
+		 */
+		if (log->reclaim_thread)
+			return;
 		log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
 					log->rdev->mddev, "reclaim");
 	} else if (state == 1) {
-- 
2.4.6

