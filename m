From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] mdadm: fix a buffer overflow
Date: Wed, 7 Sep 2016 17:28:29 -0700
Message-ID: <1473294509-1828100-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, shli@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

struct mdp_superblock_1.set_name is 32B long, but struct mdinfo.name
is 33B long. So we need strncpy instead strcpy to avoid buffer
overflow.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 super1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/super1.c b/super1.c
index f3e4023..942f0d2 100644
--- a/super1.c
+++ b/super1.c
@@ -1294,7 +1294,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 			strcat(sb->set_name, ":");
 			strcat(sb->set_name, info->name);
 		} else
-			strcpy(sb->set_name, info->name);
+			strncpy(sb->set_name, info->name, 32);
 	} else if (strcmp(update, "devicesize") == 0 &&
 	    __le64_to_cpu(sb->super_offset) <
 	    __le64_to_cpu(sb->data_offset)) {
-- 
2.8.0.rc2

