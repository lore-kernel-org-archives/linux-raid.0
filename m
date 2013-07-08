From: mwilck@arcor.de
Subject: [PATCH 38/39] DDF: ddf_process_update: some more debug messages
Date: Mon,  8 Jul 2013 23:50:47 +0200
Message-ID: <1373320248-7520-12-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

---
 super-ddf.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 428e8f3..b80bb3b 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4376,15 +4376,15 @@ static void ddf_process_update(struct supertype *st,
 				__cpu_to_be16(
 					1 + __be16_to_cpu(
 						ddf->virt->populated_vdes));
-			dprintf("%s: added VD %s in slot %d\n",
-				__func__, guid_str(vd->entries[0].guid), ent);
+			dprintf("%s: added VD %s in slot %d(s=%02x i=%02x)\n",
+				__func__, guid_str(vd->entries[0].guid), ent,
+				ddf->virt->entries[ent].state,
+				ddf->virt->entries[ent].init_state);
 		}
 		ddf_set_updates_pending(ddf);
 		break;
 
 	case DDF_VD_CONF_MAGIC:
-		dprintf("len %d %d\n", update->len, ddf->conf_rec_len);
-
 		mppe = __be16_to_cpu(ddf->anchor.max_primary_element_entries);
 		if ((unsigned)update->len != ddf->conf_rec_len * 512)
 			return;
@@ -4392,7 +4392,8 @@ static void ddf_process_update(struct supertype *st,
 		for (vcl = ddf->conflist; vcl ; vcl = vcl->next)
 			if (memcmp(vcl->conf.guid, vc->guid, DDF_GUID_LEN) == 0)
 				break;
-		dprintf("vcl = %p\n", vcl);
+		dprintf("%s: conf update for %s (%s)\n", __func__,
+			guid_str(vc->guid), (vcl ? "old" : "new"));
 		if (vcl) {
 			/* An update, just copy the phys_refnum and lba_offset
 			 * fields
-- 
1.7.1
