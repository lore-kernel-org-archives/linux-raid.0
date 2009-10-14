From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 12/12] mdmon: preserve socket over chroot
Date: Tue, 13 Oct 2009 19:11:17 -0700
Message-ID: <20091014021117.31570.97399.stgit@dwillia2-linux.ch.intel.com>
References: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

Connect to the monitor in the old namespace and use that connection for
WaitClean requests when stopping the victim mdmon instance.  This allows
ping_monitor() to work post chroot().

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mdadm.c |    4 ++--
 mdadm.h |    2 +-
 mdmon.c |   12 ++++++++----
 msg.c   |   14 +++++++++++---
 msg.h   |    1 +
 sysfs.c |    5 +++--
 6 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index bb3e5bb..6f43dc3 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1276,7 +1276,7 @@ int main(int argc, char *argv[])
 								     export, test,
 								     homehost);
 						else
-							rv |= WaitClean(name, v);
+							rv |= WaitClean(name, -1, v);
 						put_md_name(name);
 					}
 					free_mdstat(ms);
@@ -1337,7 +1337,7 @@ int main(int argc, char *argv[])
 				case 'W':
 					rv |= Wait(dv->devname); continue;
 				case Waitclean:
-					rv |= WaitClean(dv->devname, verbose-quiet); continue;
+					rv |= WaitClean(dv->devname, -1, verbose-quiet); continue;
 				}
 				mdfd = open_mddev(dv->devname, 1);
 				if (mdfd>=0) {
diff --git a/mdadm.h b/mdadm.h
index 8212a2c..ffa5f53 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -753,7 +753,7 @@ extern int Monitor(mddev_dev_t devlist,
 
 extern int Kill(char *dev, int force, int quiet, int noexcl);
 extern int Wait(char *dev);
-extern int WaitClean(char *dev, int verbose);
+extern int WaitClean(char *dev, int sock, int verbose);
 
 extern int Incremental(char *devname, int verbose, int runstop,
 		       struct supertype *st, char *homehost, int require_homehost,
diff --git a/mdmon.c b/mdmon.c
index d3e8be5..50c7be6 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -175,7 +175,7 @@ pid_t devname2mdmon(char *devname)
 	return pid;
 }
 
-static void try_kill_monitor(pid_t pid, char *devname)
+static void try_kill_monitor(pid_t pid, char *devname, int sock)
 {
 	char buf[100];
 	int fd;
@@ -205,7 +205,7 @@ static void try_kill_monitor(pid_t pid, char *devname)
 	for ( ; mdstat; mdstat = mdstat->next)
 		if (is_container_member(mdstat, devname)) {
 			sprintf(buf, "/dev/%s", mdstat->dev);
-			WaitClean(buf, 0);
+			WaitClean(buf, sock, 0);
 		}
 	free_mdstat(mdstat);
 }
@@ -366,6 +366,7 @@ int mdmon(char *devname, int devnum, int scan, char *switchroot)
 	int status;
 	int ignore;
 	pid_t victim = -1;
+	int victim_sock = -1;
 
 	dprintf("starting mdmon for %s in %s\n",
 		devname, switchroot ? : "/");
@@ -502,6 +503,7 @@ int mdmon(char *devname, int devnum, int scan, char *switchroot)
 		 * the new root
 		 */
 		victim = devname2mdmon(container->devname);
+		victim_sock = connect_monitor(container->devname);
 		if (chroot(switchroot) != 0) {
 			fprintf(stderr, "mdmon: failed to chroot to '%s': %s\n",
 				switchroot, strerror(errno));
@@ -551,8 +553,10 @@ int mdmon(char *devname, int devnum, int scan, char *switchroot)
 		exit(2);
 	}
 
-	if (victim > -1)
-		try_kill_monitor(victim, container->devname);
+	if (victim > -1) {
+		try_kill_monitor(victim, container->devname, victim_sock);
+		close(victim_sock);
+	}
 	do_manager(container);
 
 	exit(0);
diff --git a/msg.c b/msg.c
index 5a4839f..8d52b94 100644
--- a/msg.c
+++ b/msg.c
@@ -177,10 +177,8 @@ int connect_monitor(char *devname)
 	return sfd;
 }
 
-/* give the monitor a chance to update the metadata */
-int ping_monitor(char *devname)
+int fping_monitor(int sfd)
 {
-	int sfd = connect_monitor(devname);
 	int err = 0;
 
 	if (sfd < 0)
@@ -194,6 +192,16 @@ int ping_monitor(char *devname)
 	if (!err && wait_reply(sfd, 20) != 0)
 		err = -1;
 
+	return err;
+}
+
+
+/* give the monitor a chance to update the metadata */
+int ping_monitor(char *devname)
+{
+	int sfd = connect_monitor(devname);
+	int err = fping_monitor(sfd);
+
 	close(sfd);
 	return err;
 }
diff --git a/msg.h b/msg.h
index b9bd205..f8e89fd 100644
--- a/msg.h
+++ b/msg.h
@@ -27,6 +27,7 @@ extern int ack(int fd, int tmo);
 extern int wait_reply(int fd, int tmo);
 extern int connect_monitor(char *devname);
 extern int ping_monitor(char *devname);
+extern int fping_monitor(int sock);
 extern int ping_manager(char *devname);
 
 #define MSG_MAX_LEN (4*1024*1024)
diff --git a/sysfs.c b/sysfs.c
index 81ccb53..d327e3d 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -764,7 +764,7 @@ int sysfs_unique_holder(int devnum, long rdev)
 static char *clean_states[] = {
 	"clear", "inactive", "readonly", "read-auto", "clean", NULL };
 
-int WaitClean(char *dev, int verbose)
+int WaitClean(char *dev, int sock, int verbose)
 {
 	int fd;
 	struct mdinfo *mdi;
@@ -840,7 +840,8 @@ int WaitClean(char *dev, int verbose)
 		}
 		if (rv < 0)
 			rv = 1;
-		else if (ping_monitor(mdi->text_version) == 0) {
+		else if (fping_monitor(sock) == 0 ||
+			 ping_monitor(mdi->text_version) == 0) {
 			/* we need to ping to close the window between array
 			 * state transitioning to clean and the metadata being
 			 * marked clean

