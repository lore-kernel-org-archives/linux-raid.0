From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/3] FIX: Remove error message during reshape restart (v2)
Date: Thu, 29 Sep 2011 17:53:54 +0200
Message-ID: <20110929155353.22854.5948.stgit@gklab-128-013.igk.intel.com>
References: <20110929154756.22854.13187.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929154756.22854.13187.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When reshape is started in container on single array, all other container
members are blocked from monitoring also. After container reassembly
we have to construct the same situation.
Currently array under reshape is blocked only.

To block whole container during reshape we have 2 cases:
  1. first assembled array is not reshaped and second is under reshape
  2. first assembled array not reshaped and second is not under reshape

This patch addresses second case.
  First assembled array is not reshaped and not blocked. Second reshaped
  array is under reshape and it is blocked. When all reshaped array
  parameters are verified and set in reshape continue freeze_container()
  function block all other present in container and not blocked array(s).

This call to freeze_container() serves for native metadata case also.

This patch replaces its previous version that hides error message only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   18 +++++++++---------
 msg.c  |   10 +++++++---
 msg.h  |    2 +-
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/Grow.c b/Grow.c
index 3e13c8f..8f75ab8 100644
--- a/Grow.c
+++ b/Grow.c
@@ -566,8 +566,7 @@ int block_array_if_any_is_blocked(struct supertype *st, struct mdinfo *content)
 	return 1;
 }
 
-
-static int freeze_container(struct supertype *st)
+static int freeze_container(struct supertype *st, int restart)
 {
 	int container_dev = (st->container_dev != NoMdDev
 			     ? st->container_dev : st->devnum);
@@ -575,11 +574,12 @@ static int freeze_container(struct supertype *st)
 
 	if (!check_idle(st))
 		return -1;
-	
+
 	fmt_devname(container, container_dev);
 
-	if (block_monitor(container, 1)) {
-		fprintf(stderr, Name ": failed to freeze container\n");
+	if (block_monitor(container, 1, restart)) {
+		if (!restart)
+			fprintf(stderr, Name ": failed to freeze container\n");
 		return -2;
 	}
 
@@ -597,7 +597,7 @@ static void unfreeze_container(struct supertype *st)
 	unblock_monitor(container, 1);
 }
 
-static int freeze(struct supertype *st)
+static int freeze(struct supertype *st, int restart)
 {
 	/* Try to freeze resync/rebuild on this array/container.
 	 * Return -1 if the array is busy,
@@ -606,7 +606,7 @@ static int freeze(struct supertype *st)
 	 * return 1 if it worked.
 	 */
 	if (st->ss->external)
-		return freeze_container(st);
+		return freeze_container(st, restart);
 	else {
 		struct mdinfo *sra = sysfs_read(-1, st->devnum, GET_VERSION);
 		int err;
@@ -1522,7 +1522,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			devname);
 		return 1;
 	}
-	frozen = freeze(st);
+	frozen = freeze(st, 0);
 	if (frozen < -1) {
 		/* freeze() already spewed the reason */
 		return 1;
@@ -3653,7 +3653,7 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 	if (st->ss->external) {
 		fmt_devname(buf, st->container_dev);
 		container = buf;
-		freeze(st);
+		freeze(st, 1);
 
 		if (!mdmon_running(st->container_dev))
 			start_mdmon(st->container_dev);
diff --git a/msg.c b/msg.c
index f903afb..48a5bc3 100644
--- a/msg.c
+++ b/msg.c
@@ -334,7 +334,7 @@ int check_mdmon_version(char *container)
  * As older versions of mdmon (which might run from initrd) don't understand
  * this, we first check that the running mdmon is new enough.
  */
-int block_monitor(char *container, const int freeze)
+int block_monitor(char *container, const int freeze, const int restart)
 {
 	struct mdstat_ent *ent, *e, *e2;
 	struct mdinfo *sra = NULL;
@@ -364,8 +364,12 @@ int block_monitor(char *container, const int freeze)
 			break;
 		}
 		/* can't reshape an array that we can't monitor */
-		if (sra->text_version[0] == '-')
-			break;
+		if (sra->text_version[0] == '-') {
+			if (restart)
+				continue;
+			else
+				break;
+		}
 
 		if (freeze && sysfs_freeze_array(sra) < 1)
 			break;
diff --git a/msg.h b/msg.h
index fb5815e..15aef2a 100644
--- a/msg.h
+++ b/msg.h
@@ -30,7 +30,7 @@ extern int ping_monitor(char *devname);
 extern int ping_monitor_by_id(int devnum);
 extern int block_subarray(struct mdinfo *sra);
 extern int unblock_subarray(struct mdinfo *sra, const int unfreeze);
-extern int block_monitor(char *container, const int freeze);
+extern int block_monitor(char *container, const int freeze, const int restart);
 extern void unblock_monitor(char *container, const int unfreeze);
 extern int check_blocked_monitor(char *container);
 extern int fping_monitor(int sock);

