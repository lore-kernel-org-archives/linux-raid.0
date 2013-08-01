From: mwilck@arcor.de
Subject: [PATCH 2/4] DDF: no need for GET_LAYOUT any more
Date: Fri,  2 Aug 2013 00:35:15 +0200
Message-ID: <1375396517-8479-2-git-send-email-mwilck@arcor.de>
References: <1375396517-8479-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375396517-8479-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

With the previous patch, mdmon will provide the layout property for us.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 65472a2..7a7f5fe 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4697,16 +4697,10 @@ static int raid10_degraded(struct mdinfo *info)
 {
 	int n_prim, n_bvds;
 	int i;
-	struct mdinfo *d, *sra;
+	struct mdinfo *d;
 	char *found;
 	int ret = -1;
 
-	if (info->array.layout == 0) {
-		sra = sysfs_read(-1, info->sys_name, GET_LAYOUT);
-		info->array.layout = sra->array.layout;
-		free(sra);
-	}
-
 	n_prim = info->array.layout & ~0x100;
 	n_bvds = info->array.raid_disks / n_prim;
 	found = xmalloc(n_bvds);
-- 
1.7.1
