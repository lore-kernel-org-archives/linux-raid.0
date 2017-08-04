From: NeilBrown <neilb@suse.com>
Subject: [PATCH 3/4] super1: only set clustered flag when bitmap is present
Date: Fri, 04 Aug 2017 15:30:02 +1000
Message-ID: <150182460223.25561.11910300226536151781.stgit@noble>
References: <150182450644.25561.9683614144764209335.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150182450644.25561.9683614144764209335.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If no bitmap is present, then the test

	if (__le32_to_cpu(bsb->nodes) > 1)

accesses uninitialised memory.  So move that test inside
a test for a bitmap being present.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 super1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index 86ec850d03bd..47f90cd75805 100644
--- a/super1.c
+++ b/super1.c
@@ -977,14 +977,14 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 	info->array.chunk_size = __le32_to_cpu(sb->chunksize)*512;
 	info->array.state =
 		(__le64_to_cpu(sb->resync_offset) == MaxSector)	? 1 : 0;
-	if (__le32_to_cpu(bsb->nodes) > 1)
-		info->array.state |= (1 << MD_SB_CLUSTERED);
 
 	super_offset = __le64_to_cpu(sb->super_offset);
 	info->data_offset = __le64_to_cpu(sb->data_offset);
 	info->component_size = __le64_to_cpu(sb->size);
 	if (sb->feature_map & __le32_to_cpu(MD_FEATURE_BITMAP_OFFSET)) {
 		info->bitmap_offset = (int32_t)__le32_to_cpu(sb->bitmap_offset);
+		if (__le32_to_cpu(bsb->nodes) > 1)
+			info->array.state |= (1 << MD_SB_CLUSTERED);
 	} else if (sb->feature_map & __le32_to_cpu(MD_FEATURE_PPL)) {
 		info->ppl_offset = __le16_to_cpu(sb->ppl.offset);
 		info->ppl_size = __le16_to_cpu(sb->ppl.size);


