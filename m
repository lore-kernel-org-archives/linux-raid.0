From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 33/34] Raid0: Reload disk list on 'next' raid0 array
Date: Tue, 04 Jan 2011 15:39:58 +0100
Message-ID: <20110104143958.6697.19620.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

To execute second raid0 array reshape, metadata has to be reloaded after takeover (and update by monitor).
To do this container handle has to be passed to reshape_array() and takeover operation is moved to begin of reshape_array().
For adding disks metadata is reloaded to get added disk list, updated after takeover).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   63 ++++++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/Grow.c b/Grow.c
index 4d12eda..ef75b97 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1277,7 +1277,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 	return NULL;
 }
 
-static int reshape_array(char *container, int fd, char *devname,
+static int reshape_array(char *container, int cfd, int fd, char *devname,
 			 struct supertype *st, struct mdinfo *info,
 			 int force, char *backup_file, int quiet, int forked);
 static int reshape_container(char *container, int cfd, char *devname,
@@ -1594,15 +1594,15 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			goto release;
 		}
 		sync_metadata(st);
-		rv = reshape_array(container, fd, devname, st, &info, force,
-				   backup_file, quiet, 0);
+		rv = reshape_array(container, cfd, fd, devname, st, &info,
+				   force, backup_file, quiet, 0);
 	}
 release:
 	unfreeze(st, frozen);
 	return rv;
 }
 
-static int reshape_array(char *container, int fd, char *devname,
+static int reshape_array(char *container, int cfd, int fd, char *devname,
 			 struct supertype *st, struct mdinfo *info,
 			 int force,
 			 char *backup_file, int quiet, int forked)
@@ -1637,24 +1637,6 @@ static int reshape_array(char *container, int fd, char *devname,
 		fprintf(stderr, Name ": %s\n", msg);
 		return 1;
 	}
-	if (ioctl(fd, GET_ARRAY_INFO, &array) != 0) {
-		dprintf("Canot get array information.\n");
-		return 1;
-	}
-	spares_needed =  max(reshape.before.raid_disks,
-			     reshape.after.raid_disks) - array.raid_disks;
-
-	if (!force && spares_needed < info->array.spare_disks) {
-		fprintf(stderr,
-			Name ": Need %d spare%s to avoid degraded array,"
-			" and only have %d.\n"
-			"       Use --force to over-ride this check.\n",
-			spares_needed,
-			spares_needed == 1 ? "" : "s", 
-			info->array.spare_disks);
-		return 1;
-	}
-
 	if (reshape.level != info->array.level) {
 		char *c = map_num(pers, reshape.level);
 		int err;
@@ -1676,12 +1658,33 @@ static int reshape_array(char *container, int fd, char *devname,
 			fprintf(stderr, Name " level of %s changed to %s\n",
 				devname, c);	
 		orig_level = info->array.level;
-	}
+		if (mdmon_running(st->container_dev) &&
+		    (orig_level == 0))
+			ping_manager(container);
 
-	if (reshape.level > 0 && st->ss->external &&
-	    !mdmon_running(st->container_dev)) {
-		start_mdmon(st->container_dev);
+		if (reshape.level > 0 && st->ss->external &&
+		    !mdmon_running(st->container_dev))
+			start_mdmon(st->container_dev);
 		ping_monitor(container);
+
+	}
+
+	if (ioctl(fd, GET_ARRAY_INFO, &array) != 0) {
+		dprintf("Canot get array information.\n");
+		return 1;
+	}
+	spares_needed =  max(reshape.before.raid_disks,
+			     reshape.after.raid_disks) - array.raid_disks;
+
+	if (!force && spares_needed < info->array.spare_disks) {
+		fprintf(stderr,
+			Name ": Need %d spare%s to avoid degraded array,"
+			" and only have %d.\n"
+			"       Use --force to over-ride this check.\n",
+			spares_needed,
+			spares_needed == 1 ? "" : "s",
+			info->array.spare_disks);
+		return 1;
 	}
 
 	/* ->reshape_super might have chosen some spares from the
@@ -1690,10 +1693,11 @@ static int reshape_array(char *container, int fd, char *devname,
 	 * them to the kernel.
 	 */
 	if (st->ss->reshape_super && st->ss->container_content) {
-		struct mdinfo *info2 =
-			st->ss->container_content(st, subarray);
+		struct mdinfo *info2;
 		struct mdinfo *d;
 
+		st->ss->load_container(st, cfd, NULL);
+		info2 = st->ss->container_content(st, subarray);
 		if (info2) {
 			int before_raid_disks = reshape.before.raid_disks;
 			if (orig_level == 0)
@@ -2189,7 +2193,8 @@ int reshape_container(char *container, int cfd, char *devname,
 			cc_fresh->delta_disks = delta_disks;
 		} else
 			delta_disks = cc_fresh->delta_disks;
-		rv = reshape_array(container, fd, adev, st,
+
+		rv = reshape_array(container, cfd, fd, adev, st,
 				   cc_fresh, force,
 				   backup_file, quiet, 1);
 		close(fd);

