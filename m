From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: [PATCHv2 2/2] super1: check and output faulty dev role
Date: Mon, 20 Mar 2017 10:51:57 +0100
Message-ID: <1490003517-4216-3-git-send-email-gi-oh.kim@profitbricks.com>
References: <1490003517-4216-1-git-send-email-gi-oh.kim@profitbricks.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1490003517-4216-1-git-send-email-gi-oh.kim@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

From: Jack Wang <jinpu.wang@profitbricks.com>

Output the real dev role in examine_super1, it will help to
find problem.

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
Reviewed-by: Gioh Kim <gi-oh.kim@profitbricks.com>
---
 super1.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index f3520ac..c903371 100644
--- a/super1.c
+++ b/super1.c
@@ -501,8 +501,10 @@ static void examine_super1(struct supertype *st, char *homehost)
 #endif
 	printf("   Device Role : ");
 	role = role_from_sb(sb);
-	if (role >= MD_DISK_ROLE_FAULTY)
-		printf("spare\n");
+	if (role == MD_DISK_ROLE_SPARE)
+		printf("Spare\n");
+	else if (role == MD_DISK_ROLE_FAULTY)
+		printf("Faulty\n");
 	else if (role == MD_DISK_ROLE_JOURNAL)
 		printf("Journal\n");
 	else if (sb->feature_map & __cpu_to_le32(MD_FEATURE_REPLACEMENT))
-- 
2.5.0

