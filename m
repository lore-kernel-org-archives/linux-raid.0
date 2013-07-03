From: mwilck@arcor.de
Subject: [PATCH 02/27] DDF: check_secondary: fix treatment of missing BVDs
Date: Wed,  3 Jul 2013 22:27:42 +0200
Message-ID: <1372883287-8859-3-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Unused BVDs should just be skipped instead of bailing out.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 91feb87..c445df2 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3222,10 +3222,8 @@ static int check_secondary(const struct vcl *vc)
 	__set_sec_seen(conf->sec_elmnt_seq);
 	for (i = 0; i < conf->sec_elmnt_count-1; i++) {
 		const struct vd_config *bvd = vc->other_bvds[i];
-		if (bvd == NULL) {
-			pr_err("BVD %d is missing\n", i+1);
-			return -1;
-		}
+		if (bvd == NULL)
+			continue;
 		if (bvd->srl != conf->srl) {
 			pr_err("Inconsistent secondary RAID level across BVDs\n");
 			return -1;
-- 
1.7.1
