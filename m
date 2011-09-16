From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: Remove error message during reshape restart
Date: Fri, 16 Sep 2011 15:56:38 +0200
Message-ID: <20110916135637.10460.87995.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

When reshape is restarted freeze() is called on blocked already array.
Meaningless error message is displayed and reshape is continued
without interruption.

Disable error message for reshape restart displayed by freeze()
function.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   17 +++++++++--------
 msg.c  |    7 ++++---
 msg.h  |    2 +-
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/Grow.c b/Grow.c
index 04e6679..15d4a65 100644
--- a/Grow.c
+++ b/Grow.c
@@ -478,7 +478,7 @@ static int check_idle(struct supertype *st)
 	return is_idle;
 }
 
-static int freeze_container(struct supertype *st)
+static int freeze_container(struct supertype *st, int restart)
 {
 	int container_dev = (st->container_dev != NoMdDev
 			     ? st->container_dev : st->devnum);
@@ -486,11 +486,12 @@ static int freeze_container(struct supertype *st)
 
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
 
@@ -508,7 +509,7 @@ static void unfreeze_container(struct supertype *st)
 	unblock_monitor(container, 1);
 }
 
-static int freeze(struct supertype *st)
+static int freeze(struct supertype *st, int restart)
 {
 	/* Try to freeze resync/rebuild on this array/container.
 	 * Return -1 if the array is busy,
@@ -517,7 +518,7 @@ static int freeze(struct supertype *st)
 	 * return 1 if it worked.
 	 */
 	if (st->ss->external)
-		return freeze_container(st);
+		return freeze_container(st, restart);
 	else {
 		struct mdinfo *sra = sysfs_read(-1, st->devnum, GET_VERSION);
 		int err;
@@ -1444,7 +1445,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			devname);
 		return 1;
 	}
-	frozen = freeze(st);
+	frozen = freeze(st, 0);
 	if (frozen < -1) {
 		/* freeze() already spewed the reason */
 		return 1;
@@ -3846,7 +3847,7 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 	if (st->ss->external) {
 		fmt_devname(buf, st->container_dev);
 		container = buf;
-		freeze(st);
+		freeze(st, 1);
 
 		if (!mdmon_running(st->container_dev))
 			start_mdmon(st->container_dev);
diff --git a/msg.c b/msg.c
index a10c930..0cae6ba 100644
--- a/msg.c
+++ b/msg.c
@@ -300,7 +300,7 @@ int block_subarray(struct mdinfo *sra)
  * As older versions of mdmon (which might run from initrd) don't understand
  * this, we first check that the running mdmon is new enough.
  */
-int block_monitor(char *container, const int freeze)
+int block_monitor(char *container, const int freeze, const int restart)
 {
 	int devnum = devname2devnum(container);
 	struct mdstat_ent *ent, *e, *e2;
@@ -388,8 +388,9 @@ int block_monitor(char *container, const int freeze)
 	}
 
 	if (e) {
-		fprintf(stderr, Name ": failed to freeze subarray%s\n",
-			to_subarray(e, container));
+		if (!restart)
+			fprintf(stderr, Name ": failed to freeze subarray%s\n",
+				to_subarray(e, container));
 
 		/* thaw the partially frozen container */
 		for (e2 = ent; e2 && e2 != e; e2 = e2->next) {
diff --git a/msg.h b/msg.h
index c6d037d..1c8565b 100644
--- a/msg.h
+++ b/msg.h
@@ -30,7 +30,7 @@ extern int ping_monitor(char *devname);
 extern int ping_monitor_by_id(int devnum);
 extern int block_subarray(struct mdinfo *sra);
 extern int unblock_subarray(struct mdinfo *sra, const int unfreeze);
-extern int block_monitor(char *container, const int freeze);
+extern int block_monitor(char *container, const int freeze, const int restart);
 extern void unblock_monitor(char *container, const int unfreeze);
 extern int fping_monitor(int sock);
 extern int ping_manager(char *devname);

