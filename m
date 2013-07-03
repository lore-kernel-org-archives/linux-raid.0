From: mwilck@arcor.de
Subject: [PATCH 09/27] DDF: get_svd_state: Status logic for secondary RAID level
Date: Wed,  3 Jul 2013 22:27:49 +0200
Message-ID: <1372883287-8859-10-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Implement logic to derive the status of a secondary RAID
from its members. Use it in ddf_set_disk.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   37 +++++++++++++++++++++++++++++++++----
 1 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 322ad5e..8b7a621 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3861,6 +3861,38 @@ static int get_bvd_state(const struct ddf_super *ddf,
 	return state;
 }
 
+static int secondary_state(int state, int other, int seclevel)
+{
+	if (state == DDF_state_optimal && other == DDF_state_optimal)
+		return DDF_state_optimal;
+	if (seclevel == DDF_2MIRRORED) {
+		if (state == DDF_state_optimal || other == DDF_state_optimal)
+			return DDF_state_part_optimal;
+		if (state == DDF_state_failed && other == DDF_state_failed)
+			return DDF_state_failed;
+		return DDF_state_degraded;
+	} else {
+		if (state == DDF_state_failed || other == DDF_state_failed)
+			return DDF_state_failed;
+		if (state == DDF_state_degraded || other == DDF_state_degraded)
+			return DDF_state_degraded;
+		return DDF_state_part_optimal;
+	}
+}
+
+static int get_svd_state(const struct ddf_super *ddf, const struct vcl *vcl)
+{
+	int state = get_bvd_state(ddf, &vcl->conf);
+	unsigned int i;
+	for (i = 1; i < vcl->conf.sec_elmnt_count; i++) {
+		state = secondary_state(
+			state,
+			get_bvd_state(ddf, vcl->other_bvds[i-1]),
+			vcl->conf.srl);
+	}
+	return state;
+}
+
 /*
  * The state of each disk is stored in the global phys_disk structure
  * in phys_disk.entries[n].state.
@@ -3946,10 +3978,7 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 	 * It needs to be one of "optimal", "degraded", "failed".
 	 * I don't understand 'deleted' or 'missing'.
 	 */
-	state = get_bvd_state(ddf, vc);
-	if (vc->sec_elmnt_count > 1) {
-		/* treat secondary level */
-	}
+	state = get_svd_state(ddf, vcl);
 
 	if (ddf->virt->entries[inst].state !=
 	    ((ddf->virt->entries[inst].state & ~DDF_state_mask)
-- 
1.7.1
