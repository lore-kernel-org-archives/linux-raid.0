From: mwilck@arcor.de
Subject: [PATCH 15/27] DDF: validate_geometry_ddf: support RAID10
Date: Wed,  3 Jul 2013 22:27:55 +0200
Message-ID: <1372883287-8859-16-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Make validate_geometry_ddf() use the same logic to check supported
RAID levels that init_super_ddf_bvd() uses.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index f42bb16..1893f45 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3071,8 +3071,8 @@ static int validate_geometry_ddf(struct supertype *st,
 		struct vd_config conf;
 		if (layout_md2ddf(&array, &conf) == -1) {
 			if (verbose)
-				pr_err("DDF does not support level %d arrays\n",
-				       level);
+				pr_err("DDF does not support level %d /layout %d arrays with %d disks\n",
+				       level, layout, raiddisks);
 			return 0;
 		}
 		/* Should check layout? etc */
-- 
1.7.1
