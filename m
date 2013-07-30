From: mwilck@arcor.de
Subject: [PATCH 05/10] DDF: ddf_set_disk: add some debug messages
Date: Tue, 30 Jul 2013 23:18:29 +0200
Message-ID: <1375219114-5626-6-git-send-email-mwilck@arcor.de>
References: <51F82D3B.6060104@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F82D3B.6060104@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

Adds more verbose debugging in ddf_set_disk, to understand failures
better.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index f55cc11..744d52b 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4152,7 +4152,8 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 	int pd;
 	struct mdinfo *mdi;
 	struct dl *dl;
-
+	
+	dprintf("%s: %d to %x\n", __func__, n, state);
 	if (vc == NULL) {
 		dprintf("ddf: cannot find instance %d!!\n", inst);
 		return;
@@ -4161,8 +4162,11 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 	for (mdi = a->info.devs; mdi; mdi = mdi->next)
 		if (mdi->disk.raid_disk == n)
 			break;
-	if (!mdi)
+	if (!mdi) {
+		pr_err("%s: cannot find raid disk %d\n",
+		       __func__, n);
 		return;
+	}
 
 	/* and find the 'dl' entry corresponding to that. */
 	for (dl = ddf->dlist; dl; dl = dl->next)
@@ -4170,8 +4174,12 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 		    mdi->disk.major == dl->major &&
 		    mdi->disk.minor == dl->minor)
 			break;
-	if (!dl)
+	if (!dl) {
+		pr_err("%s: cannot find raid disk %d (%d/%d)\n",
+		       __func__, n,
+		       mdi->disk.major, mdi->disk.minor);
 		return;
+	}
 
 	pd = find_phys(ddf, vc->phys_refnum[n_bvd]);
 	if (pd < 0 || pd != dl->pdnum) {
@@ -4209,8 +4217,9 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 			ddf_set_updates_pending(ddf);
 	}
 
-	dprintf("ddf: set_disk %d (%08x) to %x\n", n,
-		be32_to_cpu(dl->disk.refnum), state);
+	dprintf("ddf: set_disk %d (%08x) to %x->%02x\n", n,
+		be32_to_cpu(dl->disk.refnum), state,
+		be16_to_cpu(ddf->phys->entries[pd].state));
 
 	/* Now we need to check the state of the array and update
 	 * virtual_disk.entries[n].state.
-- 
1.7.1
