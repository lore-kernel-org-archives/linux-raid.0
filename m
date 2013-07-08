From: mwilck@arcor.de
Subject: [PATCH 34/39] DDF: fix endianness of refnum in debug messages
Date: Mon,  8 Jul 2013 23:50:43 +0200
Message-ID: <1373320248-7520-8-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This makes it easier to match the debug output to existing
structures.
---
 super-ddf.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 7da4ce0..c96fac5 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2805,7 +2805,8 @@ static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type,
 		}
 		if (c) {
 			dprintf("writing conf record %i on disk %08x for %s/%u\n",
-				i, d->disk.refnum, guid_str(vdc->guid),
+				i, __be32_to_cpu(d->disk.refnum),
+				guid_str(vdc->guid),
 				vdc->sec_elmnt_seq);
 			vdc->seqnum = header->seq;
 			vdc->crc = calc_crc(vdc, conf_size);
@@ -3894,7 +3895,7 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 		}
 		first->dlist = dl1;
 		dprintf("%s: added disk %d: %08x\n", __func__, dl1->pdnum,
-			dl1->disk.refnum);
+			__be32_to_cpu(dl1->disk.refnum));
 	}
 
 	return 0;
@@ -4097,7 +4098,7 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 		 * If it is now in_sync, insert it. */
 		dprintf("%s: phys disk not found for %d: %d/%d ref %08x\n",
 			__func__, dl->pdnum, dl->major, dl->minor,
-			dl->disk.refnum);
+			__be32_to_cpu(dl->disk.refnum));
 		dprintf("%s: array %u disk %u ref %08x pd %d\n",
 			__func__, inst, n_bvd, vc->phys_refnum[n_bvd], pd);
 		if ((state & DS_INSYNC) && ! (state & DS_FAULTY)) {
@@ -4432,7 +4433,8 @@ static void ddf_process_update(struct supertype *st,
 				if (dn == DDF_NOTFOUND)
 					continue;
 				dprintf("dev %d/%08x has %s (sec=%u) at %d\n",
-					dl->pdnum, dl->disk.refnum,
+					dl->pdnum,
+					__be32_to_cpu(dl->disk.refnum),
 					guid_str(conf->guid),
 					conf->sec_elmnt_seq, vn);
 				/* Clear the Transition flag */
-- 
1.7.1
