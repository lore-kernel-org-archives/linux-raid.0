From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] Always run Grow_continue() for started array.
Date: Thu, 06 Oct 2011 11:13:22 +0200
Message-ID: <20111006091322.10706.43240.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

So far there were 2 reshape continuation cases:
 1. array is started /e.g. reshape was already invoked during initrd
                      start-up stage using "--freeze-reshape" option/
 2. array is not started yet /"normal" assembling array under reshape case/

This patch narrows continuation cases in to single one. To do this
array should be started /set readonly in to array_state/ before calling
Grow_continue() function.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |   17 +++++++++++++----
 Grow.c     |   43 +++++++++++++++++++------------------------
 2 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 285eeee..2000dd0 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1343,10 +1343,14 @@ int Assemble(struct supertype *st, char *mddev,
 			int rv;
 #ifndef MDASSEMBLE
 			if (content->reshape_active &&
-			    content->delta_disks <= 0)
-				rv = Grow_continue(mdfd, st, content,
-						   backup_file, freeze_reshape);
-			else
+			    content->delta_disks <= 0) {
+				rv = sysfs_set_str(content, NULL,
+						   "array_state", "readonly");
+				if (rv == 0)
+					rv = Grow_continue(mdfd, st, content,
+							   backup_file,
+							   freeze_reshape);
+			} else
 #endif
 				rv = ioctl(mdfd, RUN_ARRAY, NULL);
 			if (rv == 0) {
@@ -1561,6 +1565,11 @@ int assemble_container_content(struct supertype *st, int mdfd,
 					   spare, backup_file, verbose) == 1)
 				return 1;
 
+			err = sysfs_set_str(content, NULL,
+					    "array_state", "readonly");
+			if (err)
+				return 1;
+
 			if (st->ss->external) {
 				if (!mdmon_running(st->container_dev))
 					start_mdmon(st->container_dev);
diff --git a/Grow.c b/Grow.c
index 6f86987..4f8b9d7 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3802,33 +3802,28 @@ Grow_continue_command_exit:
 int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 		  char *backup_file, int freeze_reshape)
 {
-	char buf[40];
-	char *container = NULL;
-	int err;
+	int ret_val = 2;
+
+	if (!info->reshape_active)
+		return ret_val;
 
-	err = sysfs_set_str(info, NULL, "array_state", "readonly");
-	if (err)
-		return err;
 	if (st->ss->external) {
-		fmt_devname(buf, st->container_dev);
-		container = buf;
+		char container[40];
+		int cfd = open_dev(st->container_dev);
 
-		if (!mdmon_running(st->container_dev))
-			start_mdmon(st->container_dev);
-		ping_monitor_by_id(st->container_dev);
+		if (cfd < 0)
+			return 1;
 
+		fmt_devname(container, st->container_dev);
+		st->ss->load_container(st, cfd, container);
+		close(cfd);
+		ret_val = reshape_container(container, NULL,
+					    st, info, 0, backup_file,
+					    0, 1, freeze_reshape);
+	} else
+		ret_val = reshape_array(NULL, mdfd, "array", st, info, 1,
+					NULL, backup_file, 0, 0, 1,
+					freeze_reshape);
 
-		if (info->reshape_active == 2) {
-			int cfd = open_dev(st->container_dev);
-			if (cfd < 0)
-				return 1;
-			st->ss->load_container(st, cfd, container);
-			close(cfd);
-			return reshape_container(container, NULL,
-						 st, info, 0, backup_file,
-						 0, 1, freeze_reshape);
-		}
-	}
-	return reshape_array(container, mdfd, "array", st, info, 1,
-			     NULL, backup_file, 0, 0, 1, freeze_reshape);
+	return ret_val;
 }

