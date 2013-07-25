From: mwilck@arcor.de
Subject: [PATCH 1/4] DDF: find_vdcr: fix minor bug in debug message
Date: Thu, 25 Jul 2013 20:59:10 +0200
Message-ID: <1374778753-6252-2-git-send-email-mwilck@arcor.de>
References: <1374778753-6252-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374778753-6252-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This code could find disk -1. Fixed.
---
 super-ddf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index ae6cdf4..ac30e4e 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1731,7 +1731,7 @@ static struct vd_config *find_vdcr(struct ddf_super *ddf, unsigned int inst,
 	struct vcl *v;
 
 	for (v = ddf->conflist; v; v = v->next) {
-		unsigned int nsec, ibvd;
+		unsigned int nsec, ibvd = 0;
 		struct vd_config *conf;
 		if (inst != v->vcnum)
 			continue;
@@ -1763,7 +1763,7 @@ static struct vd_config *find_vdcr(struct ddf_super *ddf, unsigned int inst,
 				       n - nsec*conf->sec_elmnt_count, n_bvd))
 			goto bad;
 		dprintf("%s: found disk %u as member %u in bvd %d of array %u\n"
-			, __func__, n, *n_bvd, ibvd-1, inst);
+			, __func__, n, *n_bvd, ibvd, inst);
 		*vcl = v;
 		return conf;
 	}
-- 
1.7.1
