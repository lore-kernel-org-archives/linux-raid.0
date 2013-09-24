From: mwilck@arcor.de
Subject: [PATCH 1/2] DDF: add_to_super_ddf: leave invalid secondary_lba untouched
Date: Tue, 24 Sep 2013 19:18:51 +0200
Message-ID: <1380043132-8099-2-git-send-email-mwilck@arcor.de>
References: <1380043132-8099-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1380043132-8099-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

If the current DDF structure doesn't have a secondary header,
don't set it.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 002b271..3e13ff0 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2822,8 +2822,9 @@ static int add_to_super_ddf(struct supertype *st,
 	} while (0)
 	__calc_lba(dd, ddf->dlist, workspace_lba, 32);
 	__calc_lba(dd, ddf->dlist, primary_lba, 16);
-	if (ddf->dlist == NULL ||
-	    be64_to_cpu(ddf->dlist->secondary_lba) != ~(__u64)0)
+	if (be64_to_cpu(ddf->active->secondary_lba) == ~(__u64)0)
+		dd->secondary_lba = ddf->active->secondary_lba;
+	else
 		__calc_lba(dd, ddf->dlist, secondary_lba, 32);
 	pde->config_size = dd->workspace_lba;
 
-- 
1.7.3.4
