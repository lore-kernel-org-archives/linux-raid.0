From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] md: Combine two kmalloc() calls into one in sb_equal()
Date: Fri, 9 Dec 2016 19:30:05 +0100
Message-ID: <f4df733d-8e06-8ba1-c4c3-800d8c5615ba@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 9 Dec 2016 19:09:13 +0100

The function "kmalloc" was called in one case by the function "sb_equal"
without checking immediately if it failed.
This issue was detected by using the Coccinelle software.

Perform the desired memory allocation (and release at the end)
by a single function call instead.

Fixes: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 ("Linux-2.6.12-rc2")

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b088668269b0..86caf2536255 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -843,15 +843,12 @@ static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 	int ret;
 	mdp_super_t *tmp1, *tmp2;
 
-	tmp1 = kmalloc(sizeof(*tmp1),GFP_KERNEL);
-	tmp2 = kmalloc(sizeof(*tmp2),GFP_KERNEL);
-
-	if (!tmp1 || !tmp2) {
-		ret = 0;
-		goto abort;
-	}
+	tmp1 = kmalloc(2 * sizeof(*tmp1), GFP_KERNEL);
+	if (!tmp1)
+		return 0;
 
 	*tmp1 = *sb1;
+	tmp2 = tmp1 + 1;
 	*tmp2 = *sb2;
 
 	/*
@@ -861,9 +858,7 @@ static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 	tmp2->nr_disks = 0;
 
 	ret = (memcmp(tmp1, tmp2, MD_SB_GENERIC_CONSTANT_WORDS * 4) == 0);
-abort:
 	kfree(tmp1);
-	kfree(tmp2);
 	return ret;
 }
 
-- 
2.11.0
