From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 01/14] Stop array reshape when mounted initramfs is detected
Date: Fri, 16 Sep 2011 13:53:54 +0200
Message-ID: <20110916115354.5201.38688.stgit@gklab-128-013.igk.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

During remounting file system from initramfs to real one,
mdadm is not able to continue reshape procedure due to lost
filesystem context.
To avoid this mdadm detects mounted initramfs and performs
critical section restore only. Array is set for later
reshape continuation.

Reshape continuation will be possible to invoking manually,
using '--continue' option.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c  |   25 +++++++++++++++++++++++--
 mdadm.h |    4 ++++
 util.c  |   22 ++++++++++++++++++++++
 3 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 17d14b6..420177c 100644
--- a/Grow.c
+++ b/Grow.c
@@ -635,10 +635,21 @@ static int subarray_set_num(char *container, struct mdinfo *sra, char *name, int
 	return rc;
 }
 
+/* possible return values:
+ * 0 : success
+ * -1: error
+ * INITRAMFS_IS_IN_USE: continue reshape later
+ */
 int start_reshape(struct mdinfo *sra, int already_running)
 {
 	int err;
-	sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
+
+	/* do not block array as we not continue reshape this time
+	 */
+	if (initramfs_is_in_use() == INITRAMFS_NOT_USED)
+		sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
+	else
+		sysfs_set_num(sra, NULL, "suspend_lo", 0);
 	err = sysfs_set_num(sra, NULL, "suspend_hi", 0);
 	err = err ?: sysfs_set_num(sra, NULL, "suspend_lo", 0);
 	if (!already_running)
@@ -2190,6 +2201,14 @@ started:
 	}
 	if (restart)
 		sysfs_set_str(sra, NULL, "array_state", "active");
+	if (initramfs_is_in_use() == INITRAMFS_IS_IN_USE) {
+		free(fdlist);
+		free(offsets);
+		sysfs_free(sra);
+		fprintf(stderr, Name ": Reshape has to be continued "
+			"when root fileststem will be mounted\n");
+		return 1;
+	}
 
 	/* Now we just need to kick off the reshape and watch, while
 	 * handling backups of the data...
@@ -2357,7 +2376,9 @@ int reshape_container(char *container, char *devname,
 		unfreeze(st);
 		return 1;
 	default: /* parent */
-		printf(Name ": multi-array reshape continues in background\n");
+		if (initramfs_is_in_use() == INITRAMFS_NOT_USED)
+			printf(Name ": multi-array reshape continues "
+			       "in background\n");
 		return 0;
 	case 0: /* child */
 		break;
diff --git a/mdadm.h b/mdadm.h
index d616966..9035e67 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1161,6 +1161,10 @@ extern char *human_size(long long bytes);
 extern char *human_size_brief(long long bytes);
 extern void print_r10_layout(int layout);
 
+extern int initramfs_is_in_use(void);
+#define INITRAMFS_IS_IN_USE		1
+#define INITRAMFS_NOT_USED		0
+
 #define NoMdDev (1<<23)
 extern int find_free_devnum(int use_partitions);
 
diff --git a/util.c b/util.c
index 0ea7e0d..7186f3f 100644
--- a/util.c
+++ b/util.c
@@ -1768,3 +1768,25 @@ struct mdinfo *container_choose_spares(struct supertype *st,
 	}
 	return disks;
 }
+
+int initramfs_is_in_use(void)
+{
+	int ret_val;
+	struct stat sts;
+
+	/* /init
+	 *	common script for many Linux distribution
+	 * /sysboot
+	 *	is specific for RH
+	 * /mkinitrd.config
+	 *	is specific for SLES
+	 */
+	if ((stat("/init", &sts) == -1) ||
+	    ((stat("/sysroot", &sts) == -1) &&
+	     (stat("/mkinitrd.config", &sts) == -1)))
+		ret_val = INITRAMFS_NOT_USED;
+	else
+		ret_val = INITRAMFS_IS_IN_USE;
+
+	return ret_val;
+}

