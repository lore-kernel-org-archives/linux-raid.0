From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 06/12] Flush mdmon before next reshape step during container
	operation
Date: Tue, 07 Feb 2012 15:03:43 +0100
Message-ID: <20120207140343.20627.51176.stgit@gklab-128-013.igk.intel.com>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

Using takeover operation for grow purposes, mdadm has to be sure
that mdmon processes all updates, and if necessary it will be closed
at takeover to raid0 operation. If mdmon is late, next array in container
is processed and due to race condition mdmon closes itself instead to monitor
next reshape operation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   12 ++++++++++--
 msg.c  |   10 ++++++++++
 msg.h  |    1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 36a1de7..70bdee1 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2003,6 +2003,9 @@ static int reshape_array(char *container, int fd, char *devname,
 
 		if (reshape.level > 0 && st->ss->external) {
 			/* make sure mdmon is aware of the new level */
+			if (mdmon_running(st->container_dev))
+				flush_mdmon(container);
+
 			if (!mdmon_running(st->container_dev))
 				start_mdmon(st->container_dev);
 			ping_monitor(container);
@@ -2396,8 +2399,7 @@ started:
 		/* Re-load the metadata as much could have changed */
 		int cfd = open_dev(st->container_dev);
 		if (cfd >= 0) {
-			ping_manager(container);
-			ping_monitor(container);
+			flush_mdmon(container);
 			st->ss->free_super(st);
 			st->ss->load_container(st, cfd, container);
 			close(cfd);
@@ -2594,6 +2596,9 @@ int reshape_container(char *container, char *devname,
 
 		sysfs_init(content, fd, mdstat->devnum);
 
+		if (mdmon_running(devname2devnum(container)))
+			flush_mdmon(container);
+
 		rv = reshape_array(container, fd, adev, st,
 				   content, force, NULL,
 				   backup_file, quiet, 1, restart,
@@ -2608,6 +2613,9 @@ int reshape_container(char *container, char *devname,
 		restart = 0;
 		if (rv)
 			break;
+
+		if (mdmon_running(devname2devnum(container)))
+			flush_mdmon(container);
 	}
 	if (!rv)
 		unfreeze(st);
diff --git a/msg.c b/msg.c
index dc780b3..44aad1f 100644
--- a/msg.c
+++ b/msg.c
@@ -487,3 +487,13 @@ int ping_manager(char *devname)
 	close(sfd);
 	return err;
 }
+
+/* using takeover operation for grow purposes, mdadm has to be sure
+ * that mdmon processes all updates, and if necessary it will be closed
+ * at takeover to raid0 operation
+  */
+void flush_mdmon(char *container)
+{
+	ping_manager(container);
+	ping_monitor(container);
+}
diff --git a/msg.h b/msg.h
index c6d037d..eefa649 100644
--- a/msg.h
+++ b/msg.h
@@ -34,5 +34,6 @@ extern int block_monitor(char *container, const int freeze);
 extern void unblock_monitor(char *container, const int unfreeze);
 extern int fping_monitor(int sock);
 extern int ping_manager(char *devname);
+extern void flush_mdmon(char *container);
 
 #define MSG_MAX_LEN (4*1024*1024)

