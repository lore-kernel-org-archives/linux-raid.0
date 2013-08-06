From: mwilck@arcor.de
Subject: [PATCH 8/9] DDF: ddf_open_new: check device status for new subarray
Date: Tue,  6 Aug 2013 23:38:02 +0200
Message-ID: <1375825083-7856-4-git-send-email-mwilck@arcor.de>
References: <52016A06.8070400@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52016A06.8070400@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

It is possible that mdadm creates a new subarray containing failed
devices. This may happen if a device has failed, but the meta data
containing that information hasn't been written out yet.

This code tests for this situation, and handles it in the monitor.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 23c5439..7f393ff 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3996,11 +3996,36 @@ static int ddf_open_new(struct supertype *c, struct active_array *a, char *inst)
 {
 	struct ddf_super *ddf = c->sb;
 	int n = atoi(inst);
+	struct mdinfo *dev;
+	struct dl *dl;
+	static const char faulty[] = "faulty";
+
 	if (all_ff(ddf->virt->entries[n].guid)) {
 		pr_err("%s: subarray %d doesn't exist\n", __func__, n);
 		return -ENODEV;
 	}
-	dprintf("ddf: open_new %d\n", n);
+	dprintf("%s: new subarray %d, GUID: %s\n", __func__, n,
+		guid_str(ddf->virt->entries[n].guid));
+	for (dev = a->info.devs; dev; dev = dev->next) {
+		for (dl = ddf->dlist; dl; dl = dl->next)
+			if (dl->major == dev->disk.major &&
+			    dl->minor == dev->disk.minor)
+				break;
+		if (!dl) {
+			pr_err("%s: device %d/%d of subarray %d not found in meta data\n",
+				__func__, dev->disk.major, dev->disk.minor, n);
+			return -1;
+		}
+		if ((be16_to_cpu(ddf->phys->entries[dl->pdnum].state) &
+			(DDF_Online|DDF_Missing|DDF_Failed)) != DDF_Online) {
+			pr_err("%s: new subarray %d contains broken device %d/%d (%02x)\n",
+				__func__, n, dl->major, dl->minor,
+				be16_to_cpu(
+					ddf->phys->entries[dl->pdnum].state));
+			write(dev->state_fd, faulty, sizeof(faulty)-1);
+			dev->curr_state = DS_FAULTY;
+		}
+	}
 	a->info.container_member = n;
 	return 0;
 }
-- 
1.7.1
