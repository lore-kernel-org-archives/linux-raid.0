From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 7/8] sb_equal(): Fix misleading printk.
Date: Sun, 23 Mar 2008 16:10:33 +0100
Message-ID: <S1752249AbYGGIdt/20080707083350Z+1937@vger.kernel.org>
References: <20080707075532.GA32617@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080707075532.GA32617@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fe4d9af..0d8f5a3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -564,7 +564,7 @@ static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 
 	if (!tmp1 || !tmp2) {
 		ret = 0;
-		printk(KERN_INFO "md.c: sb1 is not equal to sb2!\n");
+		printk(KERN_INFO "md.c sb_equal(): failed to allocate memory!\n");
 		goto abort;
 	}
 
-- 
1.5.3.8

