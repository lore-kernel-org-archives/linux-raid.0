From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/6] FIX: reshape raid0 on second array
Date: Thu, 13 Jan 2011 15:50:26 +0100
Message-ID: <20110113145026.12728.94558.stgit@gklab-128-013.igk.intel.com>
References: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When reshape_array() is called for raid0 array (second and next),
we know that mdmon will update metadata. To do this after takeover
and mdmon start(optional) metadata is reread to be sure that
we should reshape this array and what reshape conditions we should check.

If info was read internally we should release it before exit.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/Grow.c b/Grow.c
index fadaf2d..7cc6bae 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1240,7 +1240,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 	return NULL;
 }
 
-static int reshape_array(char *container, int fd, char *devname,
+static int reshape_array(char *container, int cfd, int fd, char *devname,
 			 struct supertype *st, struct mdinfo *info,
 			 int force, char *backup_file, int quiet, int forked);
 static int reshape_container(char *container, int cfd, char *devname,
@@ -1560,8 +1560,8 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			goto release;
 		}
 		sync_metadata(st);
-		rv = reshape_array(container, fd, devname, st, &info, force,
-				   backup_file, quiet, 0);
+		rv = reshape_array(container, cfd, fd, devname,
+				   st, &info, force, backup_file, quiet, 0);
 		frozen = 0;
 	}
 release:
@@ -1570,7 +1570,7 @@ release:
 	return rv;
 }
 
-static int reshape_array(char *container, int fd, char *devname,
+static int reshape_array(char *container, int cfd, int fd, char *devname,
 			 struct supertype *st, struct mdinfo *info,
 			 int force,
 			 char *backup_file, int quiet, int forked)
@@ -1595,6 +1595,8 @@ static int reshape_array(char *container, int fd, char *devname,
 	unsigned long long array_size;
 	int done;
 	struct mdinfo *sra;
+	int info_reloaded = 0;
+
 
 	msg = analyse_change(info, &reshape);
 	if (msg) {
@@ -1648,7 +1650,43 @@ static int reshape_array(char *container, int fd, char *devname,
 	if (reshape.level > 0 && st->ss->external &&
 	    !mdmon_running(st->container_dev)) {
 		start_mdmon(st->container_dev);
-		ping_monitor(container);
+	}
+	ping_monitor(container);
+
+	/* reload metadat as it is possible to change made by monitor
+	 */
+	if ((cfd >= 0) &&
+	   (info->array.level == 0)) {
+		char *subarray = strchr(info->text_version+1, '/')+1;
+
+		st->ss->load_container(st, cfd, NULL);
+		info = st->ss->container_content(st, subarray);
+		sysfs_init(info, fd, st->devnum);
+		info_reloaded = 1;
+		msg = analyse_change(info, &reshape);
+		if (msg) {
+			fprintf(stderr, Name ": %s\n", msg);
+			return 1;
+		}
+	}
+
+	if (ioctl(fd, GET_ARRAY_INFO, &array) != 0) {
+		dprintf("Canot get array information.\n");
+		return 1;
+	}
+	spares_needed = max(reshape.before.data_disks,
+			    reshape.after.data_disks)
+		+ reshape.parity - array.raid_disks;
+
+	if (!force && spares_needed < info->array.spare_disks) {
+		fprintf(stderr,
+			Name ": Need %d spare%s to avoid degraded array,"
+				" and only have %d.\n"
+				"       Use --force to over-ride this check.\n",
+			spares_needed,
+			spares_needed == 1 ? "" : "s",
+			info->array.spare_disks);
+		return 1;
 	}
 
 	/* ->reshape_super might have chosen some spares from the
@@ -2033,6 +2071,8 @@ static int reshape_array(char *container, int fd, char *devname,
 		}
 	}
 out:
+	if (info_reloaded)
+		sysfs_free(info);
 	if (forked)
 		return 0;
 	exit(0);
@@ -2045,6 +2085,8 @@ release:
 	}
 	if (!forked)
 		unfreeze(st);
+	if (info_reloaded)
+		sysfs_free(info);
 	return rv;
 }
 
@@ -2153,7 +2195,7 @@ int reshape_container(char *container, int cfd, char *devname,
 
 		sysfs_init(content, fd, mdstat->devnum);
 
-		rv = reshape_array(container, fd, adev, st,
+		rv = reshape_array(container, cfd, fd, adev, st,
 				   content, force,
 				   backup_file, quiet, 1);
 		close(fd);
@@ -3178,7 +3220,8 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 	int err = sysfs_set_str(info, NULL, "array_state", "readonly");
 	if (err)
 		return err;
-	return reshape_array(NULL, mdfd, "array", st, info, 1, backup_file, 0, 0);
+	return reshape_array(NULL, -1, mdfd, "array", st,
+			     info, 1, backup_file, 0, 0);
 }
 
 

