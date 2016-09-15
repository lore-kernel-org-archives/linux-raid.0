From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] mdadm: replace hard coded string length
Date: Wed, 14 Sep 2016 17:13:27 -0700
Message-ID: <1473898407-3049094-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

This patch replaces hard coded 32 with sizeof(sb->set_name) in a
couple places.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 super1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index 9f62d23..7d03b1f 100644
--- a/super1.c
+++ b/super1.c
@@ -1030,7 +1030,7 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 
 	memcpy(info->uuid, sb->set_uuid, 16);
 
-	strncpy(info->name, sb->set_name, 32);
+	strncpy(info->name, sb->set_name, sizeof(sb->set_name));
 	info->name[32] = 0;
 
 	if ((__le32_to_cpu(sb->feature_map)&MD_FEATURE_REPLACEMENT)) {
@@ -1124,7 +1124,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		if (c)
 			strncpy(info->name, c+1, 31 - (c-sb->set_name));
 		else
-			strncpy(info->name, sb->set_name, 32);
+			strncpy(info->name, sb->set_name, sizeof(sb->set_name));
 		info->name[32] = 0;
 	}
 
-- 
2.8.0.rc2

