From: mwilck@arcor.de
Subject: [PATCH 36/39] DDF: ddf_process_update: add debug messages fore adding VDs
Date: Mon,  8 Jul 2013 23:50:45 +0200
Message-ID: <1373320248-7520-10-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Add some debug messages for the DDF_VIRTR_RECORDS_MAGIC case.
---
 super-ddf.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 1b9944f..1cb0a9f 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4356,6 +4356,13 @@ static void ddf_process_update(struct supertype *st,
 				return;
 		} else {
 
+			ent = find_vde_by_guid(ddf, vd->entries[0].guid);
+			if (ent != DDF_NOTFOUND) {
+				dprintf("%s: VD %s exists already in slot %d\n",
+					__func__, guid_str(vd->entries[0].guid),
+					ent);
+				return;
+			}
 			ent = find_unused_vde(ddf);
 			if (ent == DDF_NOTFOUND)
 				return;
@@ -4364,6 +4371,8 @@ static void ddf_process_update(struct supertype *st,
 				__cpu_to_be16(
 					1 + __be16_to_cpu(
 						ddf->virt->populated_vdes));
+			dprintf("%s: added VD %s in slot %d\n",
+				__func__, guid_str(vd->entries[0].guid), ent);
 		}
 		ddf_set_updates_pending(ddf);
 		break;
-- 
1.7.1
