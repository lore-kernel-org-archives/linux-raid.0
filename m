From: mwilck@arcor.de
Subject: [PATCH 22/27] DDF: getinfo_super_ddf_bvd: lba_offset calculation for RAID10
Date: Wed,  3 Jul 2013 22:28:02 +0200
Message-ID: <1372883287-8859-23-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Secondary RAID needs some extra logic here, too.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 0247ca5..cd6f298 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1829,10 +1829,12 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	struct ddf_super *ddf = st->sb;
 	struct vcl *vc = ddf->currentconf;
 	int cd = ddf->currentdev;
+	int n_prim;
 	int j;
 	struct dl *dl;
 	int map_disks = info->array.raid_disks;
 	__u32 *cptr;
+	struct vd_config *conf;
 
 	memset(info, 0, sizeof(*info));
 	if (layout_ddf2md(&vc->conf, &info->array) == -1)
@@ -1844,6 +1846,14 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	info->array.chunk_size	  = 512 << vc->conf.chunk_shift;
 	info->custom_array_size	  = 0;
 
+	conf = &vc->conf;
+	n_prim = __be16_to_cpu(conf->prim_elmnt_count);
+	if (conf->sec_elmnt_count > 1 && cd >= n_prim) {
+		int ibvd = cd / n_prim - 1;
+		cd %= n_prim;
+		conf = vc->other_bvds[ibvd];
+	}
+
 	if (cd >= 0 && (unsigned)cd < ddf->mppe) {
 		info->data_offset =
 			__be64_to_cpu(LBA_OFFSET(ddf, &vc->conf)[cd]);
-- 
1.7.1
