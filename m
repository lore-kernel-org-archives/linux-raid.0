From: mwilck@arcor.de
Subject: [PATCH 32/39] DDF: getinfo_super_ddf_bvd: identify disk by refnum
Date: Mon,  8 Jul 2013 23:50:41 +0200
Message-ID: <1373320248-7520-6-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Use refnum rather than raiddisk for identifying the physical disk.
raiddisk should only be used for auto-layout.
---
 super-ddf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index ee4652a..bff420c 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1878,7 +1878,7 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	}
 
 	for (dl = ddf->dlist; dl ; dl = dl->next)
-		if (dl->raiddisk == ddf->currentdev)
+		if (dl->disk.refnum == conf->phys_refnum[cd])
 			break;
 
 	info->disk.major = 0;
-- 
1.7.1
