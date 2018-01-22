From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V3 2/3] Assemble: provide protection when clustered raid do assemble
Date: Mon, 22 Jan 2018 17:12:09 +0800
Message-ID: <20180122091210.29910-3-gqjiang@suse.com>
References: <20180122091210.29910-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180122091210.29910-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The previous patch provides protection for other modes
such as CREATE, MANAGE, GROW and INCREMENTAL. And for
ASSEMBLE mode, we also need to protect during the process
of assemble clustered raid.

However, we can only know the array is clustered or not
when the metadata is ready, so the lock_cluster is called
after select_devices(). And we could re-read the metadata
when doing auto-assembly, so refresh the locking.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Assemble.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/Assemble.c b/Assemble.c
index 3c10b6cd27c2..894ff361cf30 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1326,6 +1326,9 @@ int Assemble(struct supertype *st, char *mddev,
 	char chosen_name[1024];
 	struct map_ent *map = NULL;
 	struct map_ent *mp;
+	int locked = 0;
+	struct mdp_superblock_1 *sb;
+	bitmap_super_t *bms;
 
 	/*
 	 * If any subdevs are listed, then any that don't
@@ -1356,6 +1359,12 @@ try_again:
 	 * set of devices failed.  Those are now marked as ->used==2 and
 	 * we ignore them and try again
 	 */
+	if (locked)
+		/*
+		 * if come back try_again is called, then need to unlock first,
+		 * and lock again since the metadate is re-read.
+		 */
+		cluster_release_dlmlock();
 	if (!st && ident->st)
 		st = ident->st;
 	if (c->verbose>0)
@@ -1373,6 +1382,14 @@ try_again:
 	if (!st || !st->sb || !content)
 		return 2;
 
+	sb = st->sb;
+	bms = (bitmap_super_t*)(((char*)sb) + 4096);
+	if (sb && bms->version == BITMAP_MAJOR_CLUSTERED) {
+		locked = cluster_get_dlmlock();
+		if (locked != 1)
+			return 1;
+	}
+
 	/* We have a full set of devices - we now need to find the
 	 * array device.
 	 * However there is a risk that we are racing with "mdadm -I"
@@ -1399,6 +1416,8 @@ try_again:
 			pr_err("Found some drive for an array that is already active: %s\n",
 			       mp->path);
 			pr_err("giving up.\n");
+			if (locked == 1)
+				cluster_release_dlmlock();
 			return 1;
 		}
 		for (dv = pre_exist->devs; dv; dv = dv->next) {
@@ -1472,6 +1491,8 @@ try_again:
 		st->ss->free_super(st);
 		if (auto_assem)
 			goto try_again;
+		if (locked == 1)
+			cluster_release_dlmlock();
 		return 1;
 	}
 	mddev = chosen_name;
@@ -1491,6 +1512,8 @@ try_again:
 			st->ss->free_super(st);
 			if (auto_assem)
 				goto try_again;
+			if (locked == 1)
+				cluster_release_dlmlock();
 			return 1;
 		}
 		/* just incase it was started but has no content */
@@ -1503,6 +1526,8 @@ try_again:
 		err = assemble_container_content(st, mdfd, content, c,
 						 chosen_name, NULL);
 		close(mdfd);
+		if (locked == 1)
+			cluster_release_dlmlock();
 		return err;
 	}
 
@@ -1512,8 +1537,11 @@ try_again:
 	devcnt = load_devices(devices, devmap, ident, &st, devlist,
 			      c, content, mdfd, mddev,
 			      &most_recent, &bestcnt, &best, inargv);
-	if (devcnt < 0)
+	if (devcnt < 0) {
+		if (locked == 1)
+			cluster_release_dlmlock();
 		return 1;
+	}
 
 	if (devcnt == 0) {
 		pr_err("no devices found for %s\n",
@@ -1860,6 +1888,8 @@ try_again:
 		close(mdfd);
 
 	/* '2' means 'OK, but not started yet' */
+	if (locked == 1)
+		cluster_release_dlmlock();
 	return rv == 2 ? 0 : rv;
 }
 
-- 
2.13.6

