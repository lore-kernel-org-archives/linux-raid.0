From: mwilck@arcor.de
Subject: [PATCH 35/39] DDF: add debug message in add_super_ddf_bvd
Date: Mon,  8 Jul 2013 23:50:44 +0200
Message-ID: <1373320248-7520-9-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

---
 super-ddf.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index c96fac5..1b9944f 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2551,6 +2551,10 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 		| get_svd_state(ddf, ddf->currentconf);
 	ddf->phys->entries[dl->pdnum].type &= ~__cpu_to_be16(DDF_Global_Spare);
 	ddf->phys->entries[dl->pdnum].type |= __cpu_to_be16(DDF_Active_in_VD);
+	dprintf("%s: added disk %d/%08x to VD %d/%s as disk %d\n",
+		__func__, dl->pdnum, __be32_to_cpu(dl->disk.refnum),
+		ddf->currentconf->vcnum, guid_str(vc->guid),
+		dk->raid_disk);
 	ddf_set_updates_pending(ddf);
 }
 
-- 
1.7.1
