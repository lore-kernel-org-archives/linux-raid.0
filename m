From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 2/8] md: Simplify sb_equal().
Date: Sun, 23 Mar 2008 16:21:39 +0100
Message-ID: <S1754151AbYGHQdg/20080708163337Z+60@vger.kernel.org>
References: <20080708155541.GS23944@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080708155541.GS23944@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

The only caller of sb_equal() tests the return value against
zero, so it's OK to return the negated return value of memcmp().

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c559b9e..58762dd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -572,11 +572,7 @@ static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 	tmp1->nr_disks = 0;
 	tmp2->nr_disks = 0;
 
-	if (memcmp(tmp1, tmp2, MD_SB_GENERIC_CONSTANT_WORDS * 4))
-		ret = 0;
-	else
-		ret = 1;
-
+	ret = !memcmp(tmp1, tmp2, MD_SB_GENERIC_CONSTANT_WORDS * 4);
 abort:
 	kfree(tmp1);
 	kfree(tmp2);
-- 
1.5.3.8

