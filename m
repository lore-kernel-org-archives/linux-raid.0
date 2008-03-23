From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 1/8] md: Simplify uuid_equal().
Date: Sun, 23 Mar 2008 16:09:42 +0100
Message-ID: <S1754097AbYGHQdj/20080708163339Z+61@vger.kernel.org>
References: <20080708155541.GS23944@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080708155541.GS23944@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2580ac1..c559b9e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -543,17 +543,12 @@ fail:
 
 static int uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 {
-	if (	(sb1->set_uuid0 == sb2->set_uuid0) &&
-		(sb1->set_uuid1 == sb2->set_uuid1) &&
-		(sb1->set_uuid2 == sb2->set_uuid2) &&
-		(sb1->set_uuid3 == sb2->set_uuid3))
-
-		return 1;
-
-	return 0;
+	return 	sb1->set_uuid0 == sb2->set_uuid0 &&
+		sb1->set_uuid1 == sb2->set_uuid1 &&
+		sb1->set_uuid2 == sb2->set_uuid2 &&
+		sb1->set_uuid3 == sb2->set_uuid3;
 }
 
-
 static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 {
 	int ret;
-- 
1.5.3.8

