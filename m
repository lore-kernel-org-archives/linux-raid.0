From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 13/13] External reshape (step 2): Freeze container
Date: Thu, 18 Nov 2010 10:23:08 +0100
Message-ID: <20101118092308.29508.21225.stgit@gklab-170-111.igk.intel.com>
References: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

When growing the number of raid disks the reshape process will promote
container-spares to subarray-spares (later the kernel promotes them to
subarray-members in raid5_start_reshape()).  The automatic spare
promotion that mdmon performs upon seeing a degraded array must be
disabled until the reshape process has been initiated.  Otherwise, mdmon
may start a rebuild before the reshape parameters can be specified.

In the external case we arrange for the monitor to be blocked, and turn off the safemode delay.
Mdmon is updated to check sync_action is not frozen before initiating
recovery.  This introduces a need to check which version of mdmon is
running to be sure it honors the expected semantics.  Extend
ping_monitor() to report the version of mdmon.  This also permits
discrimination of known buggy mdmon implementations in the future.
Note, it's not enough to know the current version of mdadm because the
mdmon instance may have originated from the initrd, so there is no
guaratee that mdadm and mdmon versions are synchronized.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Grow.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 69 insertions(+), 19 deletions(-)

diff --git a/Grow.c b/Grow.c
index 59032ef..4139265 100644
--- a/Grow.c
+++ b/Grow.c
@@ -432,29 +432,78 @@ static int child_same_size(int afd, struct mdinfo *sra, unsigned long blocks,
 			   int disks, int chunk, int level, int layout, int data,
 			   int dests, int *destfd, unsigned long long *destoffsets);
 
-static int freeze_array(struct mdinfo *sra)
+static int freeze_container(struct supertype *st)
 {
-	/* Try to freeze resync on this array.
+	int container_dev = st->subarray[0] ? st->container_dev : st->devnum;
+	char *container = devnum2devname(container_dev);
+
+	if (!container) {
+		fprintf(stderr, Name
+			": could not determine container name, freeze aborted\n");
+		return -2;
+	}
+
+	if (block_monitor(container, 1)) {
+		fprintf(stderr, Name ": failed to freeze container\n");
+		return -2;
+	}
+
+	return 1;
+}
+
+static void unfreeze_container(struct supertype *st)
+{
+	int container_dev = st->subarray[0] ? st->container_dev : st->devnum;
+	char *container = devnum2devname(container_dev);
+
+	if (!container) {
+		fprintf(stderr, Name
+			": could not determine container name, unfreeze aborted\n");
+		return;
+	}
+
+	unblock_monitor(container, 1);
+}
+
+static int freeze(struct supertype *st)
+{
+	/* Try to freeze resync/rebuild on this array/container.
 	 * Return -1 if the array is busy,
+	 * return -2 container cannot be frozen,
 	 * return 0 if this kernel doesn't support 'frozen'
 	 * return 1 if it worked.
 	 */
-	char buf[20];
-	if (sysfs_get_str(sra, NULL, "sync_action", buf, 20) <= 0)
-		return 0;
-	if (strcmp(buf, "idle\n") != 0 &&
-	    strcmp(buf, "frozen\n") != 0)
-		return -1;
-	if (sysfs_set_str(sra, NULL, "sync_action", "frozen") < 0)
-		return 0;
-	return 1;
+	if (st->ss->external)
+		return freeze_container(st);
+	else {
+		struct mdinfo *sra = sysfs_read(-1, st->devnum, GET_VERSION);
+		int err;
+
+		if (!sra)
+			return -1;
+		err = sysfs_freeze_array(sra);
+		sysfs_free(sra);
+		return err;
+	}
 }
 
-static void unfreeze_array(struct mdinfo *sra, int frozen)
+static void unfreeze(struct supertype *st, int frozen)
 {
 	/* If 'frozen' is 1, unfreeze the array */
-	if (frozen > 0)
-		sysfs_set_str(sra, NULL, "sync_action", "idle");
+	if (frozen <= 0)
+		return;
+
+	if (st->ss->external)
+		return unfreeze_container(st);
+	else {
+		struct mdinfo *sra = sysfs_read(-1, st->devnum, GET_VERSION);
+
+		if (sra)
+			sysfs_set_str(sra, NULL, "sync_action", "idle");
+		else
+			fprintf(stderr, Name ": failed to unfreeze array\n");
+		sysfs_free(sra);
+	}
 }
 
 static void wait_reshape(struct mdinfo *sra)
@@ -818,19 +867,21 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			array.level = LEVEL_CONTAINER;
 			sra->array.level = LEVEL_CONTAINER;
 		}
-		frozen = freeze_array(sra);
 	} else {
 		fprintf(stderr, Name ": failed to read sysfs parameters for %s\n",
 			devname);
 		return 1;
 	}
-	if (frozen < 0) {
+	frozen = freeze(st);
+	if (frozen < -1) {
+		/* freeze() already spewed the reason */
+		return 1;
+	} else if (frozen < 0) {
 		fprintf(stderr, Name ": %s is performing resync/recovery and cannot"
 			" be reshaped\n", devname);
 		return 1;
 	}
 
-
 	/* ========= set size =============== */
 	if (size >= 0 && (size == 0 || size != array.size)) {
 		long long orig_size = array.size;
@@ -1611,8 +1662,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		if (c && sysfs_set_str(sra, NULL, "level", c) == 0)
 			fprintf(stderr, Name ": aborting level change\n");
 	}
-	if (sra)
-		unfreeze_array(sra, frozen);
+	unfreeze(st, frozen);
 	return rv;
 }
 

