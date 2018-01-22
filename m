From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V3 3/3] Assemble: cleanup the failure path
Date: Mon, 22 Jan 2018 17:12:10 +0800
Message-ID: <20180122091210.29910-4-gqjiang@suse.com>
References: <20180122091210.29910-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180122091210.29910-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

There are some failure paths which share common codes
before return, so simplify them by move common codes
to the end of function, and just goto out in case
failure happened.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Assemble.c | 62 ++++++++++++++++++++++----------------------------------------
 1 file changed, 22 insertions(+), 40 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 894ff361cf30..96ea2fd53146 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1295,13 +1295,13 @@ int Assemble(struct supertype *st, char *mddev,
 	 *    START_ARRAY
 	 *
 	 */
-	int rv;
-	int mdfd;
+	int rv = -1;
+	int mdfd = -1;
 	int clean;
 	int auto_assem = (mddev == NULL && !ident->uuid_set &&
 			  ident->super_minor == UnSet && ident->name[0] == 0 &&
 			  (ident->container == NULL || ident->member == NULL));
-	struct devs *devices;
+	struct devs *devices = NULL;
 	char *devmap;
 	int *best = NULL; /* indexed by raid_disk */
 	int bestcnt = 0;
@@ -1416,9 +1416,7 @@ try_again:
 			pr_err("Found some drive for an array that is already active: %s\n",
 			       mp->path);
 			pr_err("giving up.\n");
-			if (locked == 1)
-				cluster_release_dlmlock();
-			return 1;
+			goto out;
 		}
 		for (dv = pre_exist->devs; dv; dv = dv->next) {
 			/* We want to add this device to our list,
@@ -1491,9 +1489,7 @@ try_again:
 		st->ss->free_super(st);
 		if (auto_assem)
 			goto try_again;
-		if (locked == 1)
-			cluster_release_dlmlock();
-		return 1;
+		goto out;
 	}
 	mddev = chosen_name;
 	if (pre_exist == NULL) {
@@ -1512,9 +1508,7 @@ try_again:
 			st->ss->free_super(st);
 			if (auto_assem)
 				goto try_again;
-			if (locked == 1)
-				cluster_release_dlmlock();
-			return 1;
+			goto out;
 		}
 		/* just incase it was started but has no content */
 		ioctl(mdfd, STOP_ARRAY, NULL);
@@ -1538,9 +1532,8 @@ try_again:
 			      c, content, mdfd, mddev,
 			      &most_recent, &bestcnt, &best, inargv);
 	if (devcnt < 0) {
-		if (locked == 1)
-			cluster_release_dlmlock();
-		return 1;
+		mdfd = -3;
+		goto out;
 	}
 
 	if (devcnt == 0) {
@@ -1548,10 +1541,8 @@ try_again:
 		       mddev);
 		if (st)
 			st->ss->free_super(st);
-		close(mdfd);
-		free(devices);
 		free(devmap);
-		return 1;
+		goto out;
 	}
 
 	if (c->update && strcmp(c->update, "byteorder")==0)
@@ -1665,32 +1656,24 @@ try_again:
 				 : (O_RDONLY|O_EXCL)))< 0) {
 			pr_err("Cannot open %s: %s\n",
 			       devices[j].devname, strerror(errno));
-			close(mdfd);
-			free(devices);
-			return 1;
+			goto out;
 		}
 		if (st->ss->load_super(st,fd, NULL)) {
 			close(fd);
 			pr_err("RAID superblock has disappeared from %s\n",
 			       devices[j].devname);
-			close(mdfd);
-			free(devices);
-			return 1;
+			goto out;
 		}
 		close(fd);
 	}
 	if (st->sb == NULL) {
 		pr_err("No suitable drives found for %s\n", mddev);
-		close(mdfd);
-		free(devices);
-		return 1;
+		goto out;
 	}
 	st->ss->getinfo_super(st, content, NULL);
 	if (sysfs_init(content, mdfd, NULL)) {
 		pr_err("Unable to initialize sysfs\n");
-		close(mdfd);
-		free(devices);
-		return 1;
+		goto out;
 	}
 
 	/* after reload context, store journal_clean in context */
@@ -1756,17 +1739,13 @@ try_again:
 		if (fd < 0) {
 			pr_err("Could not open %s for write - cannot Assemble array.\n",
 			       devices[chosen_drive].devname);
-			close(mdfd);
-			free(devices);
-			return 1;
+			goto out;
 		}
 		if (st->ss->store_super(st, fd)) {
 			close(fd);
 			pr_err("Could not re-write superblock on %s\n",
 			       devices[chosen_drive].devname);
-			close(mdfd);
-			free(devices);
-			return 1;
+			goto out;
 		}
 		if (c->verbose >= 0)
 			pr_err("Marking array %s as 'clean'\n",
@@ -1824,9 +1803,7 @@ try_again:
 			pr_err("Failed to restore critical section for reshape, sorry.\n");
 			if (c->backup_file == NULL)
 				cont_err("Possibly you needed to specify the --backup-file\n");
-			close(mdfd);
-			free(devices);
-			return err;
+			goto out;
 		}
 	}
 
@@ -1855,6 +1832,7 @@ try_again:
 		ioctl(mdfd, STOP_ARRAY, NULL);
 	free(devices);
 	map_unlock(&map);
+out:
 	if (rv == 0) {
 		wait_for(chosen_name, mdfd);
 		close(mdfd);
@@ -1884,12 +1862,16 @@ try_again:
 				usecs <<= 1;
 			}
 		}
-	} else
+	} else if (mdfd >= 0)
 		close(mdfd);
 
 	/* '2' means 'OK, but not started yet' */
 	if (locked == 1)
 		cluster_release_dlmlock();
+	if (rv == -1) {
+		free(devices);
+		return 1;
+	}
 	return rv == 2 ? 0 : rv;
 }
 
-- 
2.13.6

