From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm/mdmon:deleted the abort_reshape never invoked
Date: Mon, 20 Mar 2017 13:21:24 +0800
Message-ID: <1489987284-22786-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

mdmon.c: abort_reshape() has implemented in Grow.c,
this function doesn't make a lot of sense here.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdmon.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index e4b73d9..95e9bba 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -580,11 +580,6 @@ int restore_stripes(int *dest, unsigned long long *offsets,
 	return 1;
 }
 
-void abort_reshape(struct mdinfo *sra)
-{
-	return;
-}
-
 int save_stripes(int *source, unsigned long long *offsets,
 		 int raid_disks, int chunk_size, int level, int layout,
 		 int nwrites, int *dest,
-- 
2.6.6

