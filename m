From: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] Fix --update=homehost
Date: Tue, 10 Jul 2012 12:45:42 -0700
Message-ID: <1341949542-9852-1-git-send-email-jmaggard10@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Justin Maggard <jmaggard10@gmail.com>
List-Id: linux-raid.ids

The --update=homehost mdadm option does not actually update the
name field.  Fix it by recursively calling update_super1();

Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
---
 super1.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/super1.c b/super1.c
index b04945f..5aac5da 100644
--- a/super1.c
+++ b/super1.c
@@ -824,6 +824,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		else
 			strncpy(info->name, sb->set_name, 32);
 		info->name[32] = 0;
+		update_super1(st, info, update, devname, verbose, uuid_set, homehost);
 	} else if (strcmp(update, "name") == 0) {
 		if (info->name[0] == 0)
 			sprintf(info->name, "%d", info->array.md_minor);
-- 
1.7.9.5

