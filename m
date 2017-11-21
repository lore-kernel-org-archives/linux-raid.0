From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH] Monitor/msg: Don't print error message if mdmon doesn't run
Date: Tue, 21 Nov 2017 11:30:20 +0100
Message-ID: <1511260220-26759-1-git-send-email-mariusz.tkaczyk@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
List-Id: linux-raid.ids

Commit 4515fb28a53a ("Add detail information when can not connect
monitor") was added to warn about failed connection to monitor in 
WaitClean function (see link below).

Mdmon runs for IMSM containers when they have array with redundancy so
if mdmon doesn't run, mdadm prints this error. This is misleading and
unnecessary. Just print it in WaitClean function.

The sock in WaitClean is deprecated so it is removed.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1375002
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 Monitor.c | 9 +++++----
 mdadm.c   | 4 ++--
 mdadm.h   | 2 +-
 msg.c     | 2 --
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index b60996b..c7c05d2 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -1058,7 +1058,7 @@ int Wait(char *dev)
 static char *clean_states[] = {
 	"clear", "inactive", "readonly", "read-auto", "clean", NULL };
 
-int WaitClean(char *dev, int sock, int verbose)
+int WaitClean(char *dev, int verbose)
 {
 	int fd;
 	struct mdinfo *mdi;
@@ -1125,15 +1125,16 @@ int WaitClean(char *dev, int sock, int verbose)
 		}
 		if (rv < 0)
 			rv = 1;
-		else if (fping_monitor(sock) == 0 ||
-			 ping_monitor(mdi->text_version) == 0) {
+		else if (ping_monitor(mdi->text_version) == 0) {
 			/* we need to ping to close the window between array
 			 * state transitioning to clean and the metadata being
 			 * marked clean
 			 */
 			rv = 0;
-		} else
+		} else {
 			rv = 1;
+			pr_err("Error connecting monitor with %s\n", dev);
+		}
 		if (rv && verbose)
 			pr_err("Error waiting for %s to be clean\n", dev);
 
diff --git a/mdadm.c b/mdadm.c
index 87cb33f..62d7ec3 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1863,7 +1863,7 @@ static int misc_scan(char devmode, struct context *c)
 			if (devmode == 'D')
 				rv |= Detail(name, c);
 			else
-				rv |= WaitClean(name, -1, c->verbose);
+				rv |= WaitClean(name, c->verbose);
 			put_md_name(name);
 		}
 	}
@@ -1954,7 +1954,7 @@ static int misc_list(struct mddev_dev *devlist,
 			rv |= Wait(dv->devname);
 			continue;
 		case Waitclean:
-			rv |= WaitClean(dv->devname, -1, c->verbose);
+			rv |= WaitClean(dv->devname, c->verbose);
 			continue;
 		case KillSubarray:
 			rv |= Kill_subarray(dv->devname, c->subarray, c->verbose);
diff --git a/mdadm.h b/mdadm.h
index 3cbf82f..cf4721a 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1395,7 +1395,7 @@ extern int Kill(char *dev, struct supertype *st, int force, int verbose, int noe
 extern int Kill_subarray(char *dev, char *subarray, int verbose);
 extern int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident *ident, int quiet);
 extern int Wait(char *dev);
-extern int WaitClean(char *dev, int sock, int verbose);
+extern int WaitClean(char *dev, int verbose);
 extern int SetAction(char *dev, char *action);
 
 extern int Incremental(struct mddev_dev *devlist, struct context *c,
diff --git a/msg.c b/msg.c
index c66b0a1..45cd450 100644
--- a/msg.c
+++ b/msg.c
@@ -171,8 +171,6 @@ int connect_monitor(char *devname)
 	addr.sun_family = PF_LOCAL;
 	strcpy(addr.sun_path, path);
 	if (connect(sfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
-		pr_err("Error connecting monitor with %s: %s\n",
-			addr.sun_path, strerror(errno));
 		close(sfd);
 		return -1;
 	}
-- 
1.8.3.1

