From: mwilck@arcor.de
Subject: [PATCH 2/4] DDF: ddf_activate_spare: Add RAID10 code
Date: Thu, 25 Jul 2013 20:59:11 +0200
Message-ID: <1374778753-6252-3-git-send-email-mwilck@arcor.de>
References: <1374778753-6252-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374778753-6252-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The check for degraded array is a bit more complex for RAID10.
Fixing it.
---
 super-ddf.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index ac30e4e..13a2e61 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4655,6 +4655,55 @@ static void ddf_prepare_update(struct supertype *st,
 }
 
 /*
+ * Check degraded state of a RAID10.
+ * returns 2 for good, 1 for degraded, 0 for failed, and -1 for error
+ */
+static int raid10_degraded(struct mdinfo *info)
+{
+	int n_prim, n_bvds;
+	int i;
+	struct mdinfo *d, *sra;
+	char *found;
+	int ret = -1;
+
+	if (info->array.layout == 0) {
+		sra = sysfs_read(-1, info->sys_name, GET_LAYOUT);
+		info->array.layout = sra->array.layout;
+		free(sra);
+	}
+
+	n_prim = info->array.layout & ~0x100;
+	n_bvds = info->array.raid_disks / n_prim;
+	found = xmalloc(n_bvds);
+	if (found == NULL)
+		return ret;
+	memset(found, 0, n_bvds);
+	for (d = info->devs; d; d = d->next) {
+		i = d->disk.raid_disk / n_prim;
+		if (i >= n_bvds) {
+			pr_err("%s: BUG: invalid raid disk\n", __func__);
+			goto out;
+		}
+		if (d->state_fd > 0)
+			found[i]++;
+	}
+	ret = 2;
+	for (i = 0; i < n_bvds; i++)
+		if (!found[i]) {
+			dprintf("%s: BVD %d/%d failed\n", __func__, i, n_bvds);
+			ret = 0;
+			goto out;
+		} else if (found[i] < n_prim) {
+			dprintf("%s: BVD %d/%d degraded\n", __func__, i,
+				n_bvds);
+			ret = 1;
+		}
+out:
+	free(found);
+	return ret;
+}
+
+/*
  * Check if the array 'a' is degraded but not failed.
  * If it is, find as many spares as are available and needed and
  * arrange for their inclusion.
@@ -4694,7 +4743,7 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 			working ++;
 	}
 
-	dprintf("ddf_activate: working=%d (%d) level=%d\n", working,
+	dprintf("%s: working=%d (%d) level=%d\n", __func__, working,
 		a->info.array.raid_disks,
 		a->info.array.level);
 	if (working == a->info.array.raid_disks)
@@ -4713,6 +4762,10 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 		if (working < a->info.array.raid_disks - 2)
 			return NULL; /* failed */
 		break;
+	case 10:
+		if (raid10_degraded(&a->info) < 1)
+			return NULL;
+		break;
 	default: /* concat or stripe */
 		return NULL; /* failed */
 	}
-- 
1.7.1
