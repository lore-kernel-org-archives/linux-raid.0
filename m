From: mwilck@arcor.de
Subject: [PATCH 2/2] DDF: add_to_super_ddf: be careful with workspace_lba
Date: Tue, 24 Sep 2013 19:18:52 +0200
Message-ID: <1380043132-8099-3-git-send-email-mwilck@arcor.de>
References: <1380043132-8099-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1380043132-8099-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Some vendor DDF structures interpret workspace_lba
very differently then us. Make a sanity check on the value
before using it for config_size.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 3e13ff0..7711f96 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2703,6 +2703,31 @@ static unsigned int find_unused_pde(const struct ddf_super *ddf)
 	return DDF_NOTFOUND;
 }
 
+static void _set_config_size(struct phys_disk_entry *pde, const struct dl *dl)
+{
+	__u64 cfs, t;
+	cfs = min(dl->size - 32*1024*2ULL, be64_to_cpu(dl->primary_lba));
+	t = be64_to_cpu(dl->secondary_lba);
+	if (t != ~(__u64)0)
+		cfs = min(cfs, t);
+	/*
+	 * Some vendor DDF structures interpret workspace_lba
+	 * very differently then us. Make a sanity check on the value.
+	 */
+	t = be64_to_cpu(dl->workspace_lba);
+	if (t < cfs) {
+		__u64 wsp = cfs - t;
+		if (wsp > 1024*1024*2ULL && wsp > dl->size / 16) {
+			pr_err("%s: %x:%x: workspace size 0x%llx too big, ignoring\n",
+			       __func__, dl->major, dl->minor, wsp);
+		} else
+			cfs = t;
+	}
+	pde->config_size = cpu_to_be64(cfs);
+	dprintf("%s: %x:%x config_size %llx, DDF structure is %llx blocks\n",
+		__func__, dl->major, dl->minor, cfs, dl->size-cfs);
+}
+
 /* add a device to a container, either while creating it or while
  * expanding a pre-existing container
  */
@@ -2826,7 +2851,7 @@ static int add_to_super_ddf(struct supertype *st,
 		dd->secondary_lba = ddf->active->secondary_lba;
 	else
 		__calc_lba(dd, ddf->dlist, secondary_lba, 32);
-	pde->config_size = dd->workspace_lba;
+	_set_config_size(pde, dd);
 
 	sprintf(pde->path, "%17.17s","Information: nil") ;
 	memset(pde->pad, 0xff, 6);
-- 
1.7.3.4
