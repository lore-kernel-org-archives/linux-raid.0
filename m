From: mwilck@arcor.de
Subject: [PATCH 06/27] DDF: ddf_open_new: implement minimal consistency check
Date: Wed,  3 Jul 2013 22:27:46 +0200
Message-ID: <1372883287-8859-7-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Added a minimal consitency check as in imsm_open_new().

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index b3c846d..ae24bb9 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3695,8 +3695,14 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
  */
 static int ddf_open_new(struct supertype *c, struct active_array *a, char *inst)
 {
-	dprintf("ddf: open_new %s\n", inst);
-	a->info.container_member = atoi(inst);
+	struct ddf_super *ddf = c->sb;
+	int n = atoi(inst);
+	if (n >= (int)__be16_to_cpu(ddf->virt->populated_vdes)) {
+		pr_err("%s: subarray index %d out of range\n", __func__, n);
+		return -ENODEV;
+	}
+	dprintf("ddf: open_new %d\n", n);
+	a->info.container_member = n;
 	return 0;
 }
 
-- 
1.7.1
