From: mwilck@arcor.de
Subject: [PATCH 3/6] DDF: getinfo_super_ddf_bvd: fix offset calculation for SVDs
Date: Fri, 19 Jul 2013 21:04:12 +0200
Message-ID: <1374260655-5788-4-git-send-email-mwilck@arcor.de>
References: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Fix a bug that caused the wrong conf record to be used to derive
data offset and size on secondary RAID (RAID10).
---
 super-ddf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index dc3f69b..d7da4c1 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1881,11 +1881,11 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 
 	if (cd >= 0 && (unsigned)cd < ddf->mppe) {
 		info->data_offset =
-			__be64_to_cpu(LBA_OFFSET(ddf, &vc->conf)[cd]);
+			__be64_to_cpu(LBA_OFFSET(ddf, conf)[cd]);
 		if (vc->block_sizes)
 			info->component_size = vc->block_sizes[cd];
 		else
-			info->component_size = __be64_to_cpu(vc->conf.blocks);
+			info->component_size = __be64_to_cpu(conf->blocks);
 	}
 
 	for (dl = ddf->dlist; dl ; dl = dl->next)
-- 
1.7.1
