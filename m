From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2] mdadm: fix a buffer overflow
Date: Wed, 7 Sep 2016 17:43:35 -0700
Message-ID: <1473295415-1859888-1-git-send-email-songliubraving@fb.com>
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
 super1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index f3e4023..46fed54 100644
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
@@ -1444,7 +1444,7 @@ static int init_super1(struct supertype *st, mdu_array_info_t *info,
 		strcat(sb->set_name, ":");
 		strcat(sb->set_name, name);
 	} else
-		strcpy(sb->set_name, name);
+		strncpy(sb->set_name, name, 32);
 
 	sb->ctime = __cpu_to_le64((unsigned long long)time(0));
 	sb->level = __cpu_to_le32(info->level);
-- 
2.8.0.rc2

