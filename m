From: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH v2] mdadm: make --update=homehost work again
Date: Wed,  6 Feb 2013 12:07:17 -0800
Message-ID: <1360181237-11760-1-git-send-email-jmaggard10@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, Justin Maggard <jmaggard10@gmail.com>
List-Id: linux-raid.ids

Commit 1e2b276535cea41c348292a019bdda8a58cb1679 (Report error in --update
string is not recognised) broke homehost updating functionality because it
depended on each string comparison being done even after we already found
a match.  Make it work again by using a goto instead.

---
 super0.c |    3 ++-
 super1.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/super0.c b/super0.c
index ecb6b38..f15f1e0 100644
--- a/super0.c
+++ b/super0.c
@@ -554,10 +554,11 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
 	} else if (strcmp(update, "homehost") == 0 &&
 		   homehost) {
 		uuid_set = 0;
-		update = "uuid";
 		info->uuid[0] = sb->set_uuid0;
 		info->uuid[1] = sb->set_uuid1;
+		goto update_uuid;
 	} else if (strcmp(update, "uuid") == 0) {
+ update_uuid:
 		if (!uuid_set && homehost) {
 			char buf[20];
 			char *hash = sha1_buffer(homehost,
diff --git a/super1.c b/super1.c
index 5bb1f01..fc31948 100644
--- a/super1.c
+++ b/super1.c
@@ -987,14 +987,15 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 	} else if (strcmp(update, "homehost") == 0 &&
 		   homehost) {
 		char *c;
-		update = "name";
 		c = strchr(sb->set_name, ':');
 		if (c)
 			strncpy(info->name, c+1, 31 - (c-sb->set_name));
 		else
 			strncpy(info->name, sb->set_name, 32);
 		info->name[32] = 0;
+		goto update_name;
 	} else if (strcmp(update, "name") == 0) {
+ update_name:
 		if (info->name[0] == 0)
 			sprintf(info->name, "%d", info->array.md_minor);
 		memset(sb->set_name, 0, sizeof(sb->set_name));
-- 
1.7.9.5

