From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/2] Fix sign extension of bitmap_offset in super1.c
Date: Thu, 26 Apr 2012 17:12:56 +0200
Message-ID: <1335453177-8515-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1335453177-8515-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1335453177-8515-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, joe.lawrence@stratus.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

fbdef49811c9e2b54e2064d9af68cfffa77c6e77 incorrectly tried to fix sign
extension of the bitmap offset. However mdinfo->bitmap_offset is a u32
and needs to be converted to a 32 bit signed integer before the sign
extension.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super1.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index 36369d8..be77c33 100644
--- a/super1.c
+++ b/super1.c
@@ -620,7 +620,7 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 	info->data_offset = __le64_to_cpu(sb->data_offset);
 	info->component_size = __le64_to_cpu(sb->size);
 	if (sb->feature_map & __le32_to_cpu(MD_FEATURE_BITMAP_OFFSET))
-		info->bitmap_offset = (long)__le32_to_cpu(sb->bitmap_offset);
+		info->bitmap_offset = (int32_t)__le32_to_cpu(sb->bitmap_offset);
 
 	info->disk.major = 0;
 	info->disk.minor = 0;
@@ -1651,7 +1651,7 @@ add_internal_bitmap1(struct supertype *st,
 		offset = -room;
 	}
 
-	sb->bitmap_offset = (long)__cpu_to_le32(offset);
+	sb->bitmap_offset = (int32_t)__cpu_to_le32(offset);
 
 	sb->feature_map = __cpu_to_le32(__le32_to_cpu(sb->feature_map)
 					| MD_FEATURE_BITMAP_OFFSET);
-- 
1.7.7.6

