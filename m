From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] Grow: fix version number in error message
Date: Tue, 19 Jul 2011 13:34:13 +0900
Message-ID: <1311050053-2831-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As the conditional checks, reshape to fewer devices is supported
since Linux kernel 2.6.30 not 2.6.32.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index a4092b5..e4fc222 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1268,7 +1268,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 
 	if (re->after.data_disks < re->before.data_disks &&
 	    get_linux_version() < 2006030)
-		return "reshape to fewer devices is not supported before 2.6.32 - sorry.";
+		return "reshape to fewer devices is not supported before 2.6.30 - sorry.";
 
 	re->backup_blocks = compute_backup_blocks(
 		info->new_chunk, info->array.chunk_size,
-- 
1.7.6

