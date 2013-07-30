From: mwilck@arcor.de
Subject: [PATCH 03/10] DDF: ddf_process_update: log offsets for conf changes
Date: Tue, 30 Jul 2013 23:18:27 +0200
Message-ID: <1375219114-5626-4-git-send-email-mwilck@arcor.de>
References: <51F82D3B.6060104@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F82D3B.6060104@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

I needed this for tracking a bug with wrong offsets after array
creation.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 20f4cf4..b639f07 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4495,10 +4495,27 @@ static void ddf_process_update(struct supertype *st,
 			 * fields
 			 */
 			unsigned int i;
+			unsigned int k;
 			copy_matching_bvd(ddf, &vcl->conf, update);
-			for (i = 1; i < vc->sec_elmnt_count; i++)
+			for (k = 0; k < be16_to_cpu(vc->prim_elmnt_count); k++)
+				dprintf("BVD %u has %08x at %llu\n", 0,
+					be32_to_cpu(vcl->conf.phys_refnum[k]),
+					be64_to_cpu(LBA_OFFSET(ddf,
+							       &vcl->conf)[k]));
+			for (i = 1; i < vc->sec_elmnt_count; i++) {
 				copy_matching_bvd(ddf, vcl->other_bvds[i-1],
 						  update);
+				for (k = 0; k < be16_to_cpu(
+					     vc->prim_elmnt_count); k++)
+					dprintf("BVD %u has %08x at %llu\n", i,
+						be32_to_cpu
+						(vcl->other_bvds[i-1]->
+						 phys_refnum[k]),
+						be64_to_cpu
+						(LBA_OFFSET
+						 (ddf,
+						  vcl->other_bvds[i-1])[k]));
+			}
 		} else {
 			/* A new VD_CONF */
 			unsigned int i;
-- 
1.7.1
