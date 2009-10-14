From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 10/12] mdmon: avoid writes in the startup path for mdmon
	on root arrays
Date: Tue, 13 Oct 2009 19:11:06 -0700
Message-ID: <20091014021106.31570.6034.stgit@dwillia2-linux.ch.intel.com>
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

When killing a previous monitor be careful not to cause writes to the
filesystem until the reads necessary to get the monitor operational have
completed.

The code is already prepared for errors creating the pid and socket
files, so simply defer creation of these files until after the first
call to manage().

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 managemon.c |    6 +++++
 mdmon.c     |   78 ++++++++++++++++++++++++-----------------------------------
 2 files changed, 38 insertions(+), 46 deletions(-)

diff --git a/managemon.c b/managemon.c
index f9d545d..5958e18 100644
--- a/managemon.c
+++ b/managemon.c
@@ -680,6 +680,12 @@ void do_manager(struct supertype *container)
 			read_sock(container);
 
 			if (container->sock < 0 || socket_hup_requested) {
+				/* If this fails, we hope it already exists
+				 * pid file lives in /var/run/mdadm/mdXX.pid
+				 */
+				mkdir("/var", 0600);
+				mkdir("/var/run", 0600);
+				mkdir("/var/run/mdadm", 0600);
 				close(container->sock);
 				container->sock = make_control_sock(container->devname);
 				make_pidfile(container->devname, 0);
diff --git a/mdmon.c b/mdmon.c
index 31994d8..5f87e78 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -113,6 +113,14 @@ static struct superswitch *find_metadata_methods(char *vers)
 	return NULL;
 }
 
+static int test_pidfile(char *devname)
+{
+	char path[100];
+	struct stat st;
+
+	sprintf(path, "/var/run/mdadm/%s.pid", devname);
+	return stat(path, &st);
+}
 
 int make_pidfile(char *devname, int o_excl)
 {
@@ -149,26 +157,29 @@ int is_container_member(struct mdstat_ent *mdstat, char *container)
 	return 1;
 }
 
-void remove_pidfile(char *devname);
-static void try_kill_monitor(char *devname)
+pid_t devname2mdmon(char *devname)
 {
 	char buf[100];
+	pid_t pid = -1;
 	int fd;
-	pid_t pid;
-	struct mdstat_ent *mdstat;
 
 	sprintf(buf, "/var/run/mdadm/%s.pid", devname);
-	fd = open(buf, O_RDONLY);
+	fd = open(buf, O_RDONLY|O_NOATIME);
 	if (fd < 0)
-		return;
-
-	if (read(fd, buf, sizeof(buf)) < 0) {
-		close(fd);
-		return;
-	}
+		return -1;
 
+	if (read(fd, buf, sizeof(buf)) > 0)
+		sscanf(buf, "%d\n", &pid);
 	close(fd);
-	pid = strtoul(buf, NULL, 10);
+
+	return pid;
+}
+
+static void try_kill_monitor(pid_t pid, char *devname)
+{
+	char buf[100];
+	int fd;
+	struct mdstat_ent *mdstat;
 
 	/* first rule of survival... don't off yourself */
 	if (pid == getpid())
@@ -197,7 +208,6 @@ static void try_kill_monitor(char *devname)
 			WaitClean(buf, 0);
 		}
 	free_mdstat(mdstat);
-	remove_pidfile(devname);
 }
 
 void remove_pidfile(char *devname)
@@ -355,6 +365,7 @@ int mdmon(char *devname, int devnum, int scan, char *switchroot)
 	int pfd[2];
 	int status;
 	int ignore;
+	pid_t victim = -1;
 
 	dprintf("starting mdmon for %s in %s\n",
 		devname, switchroot ? : "/");
@@ -400,6 +411,7 @@ int mdmon(char *devname, int devnum, int scan, char *switchroot)
 	container->devname = devname;
 	container->arrays = NULL;
 	container->subarray[0] = 0;
+	container->sock = -1;
 
 	if (!container->devname) {
 		fprintf(stderr, "mdmon: failed to allocate container name string\n");
@@ -464,12 +476,9 @@ int mdmon(char *devname, int devnum, int scan, char *switchroot)
 
 	if (switchroot) {
 		/* we assume we assume that /sys /proc /dev are available in
-		 * the new root (see nash:setuproot)
-		 *
-		 * kill any monitors in the current namespace and change
-		 * to the new one
+		 * the new root
 		 */
-		try_kill_monitor(container->devname);
+		victim = devname2mdmon(container->devname);
 		if (chroot(switchroot) != 0) {
 			fprintf(stderr, "mdmon: failed to chroot to '%s': %s\n",
 				switchroot, strerror(errno));
@@ -477,40 +486,15 @@ int mdmon(char *devname, int devnum, int scan, char *switchroot)
 		}
 	}
 
-	/* If this fails, we hope it already exists 
-	 * pid file lives in /var/run/mdadm/mdXX.pid
-	 */
-	mkdir("/var", 0600);
-	mkdir("/var/run", 0600);
-	mkdir("/var/run/mdadm", 0600);
 	ignore = chdir("/");
-	if (make_pidfile(container->devname, O_EXCL) < 0) {
+	if (victim < 0 && test_pidfile(container->devname) == 0) {
 		if (ping_monitor(container->devname) == 0) {
 			fprintf(stderr, "mdmon: %s already managed\n",
 				container->devname);
 			exit(3);
-		} else {
-			int err;
-
-			/* cleanup the old monitor, this one is taking over */
-			try_kill_monitor(container->devname);
-			err = make_pidfile(container->devname, 0);
-			if (err < 0) {
-				fprintf(stderr, "mdmon: %s Cannot create pidfile\n",
-					container->devname);
-				if (err == -EROFS) {
-					/* FIXME implement a mechanism to
-					 * prevent duplicate monitor instances
-					 */
-					fprintf(stderr,
-						"mdmon: continuing on read-only file system\n");
-				} else
-					exit(3);
-			}
-		}
+		} else if (victim < 0)
+			victim = devname2mdmon(container->devname);
 	}
-	container->sock = make_control_sock(container->devname);
-
 	if (container->ss->load_super(container, mdfd, devname)) {
 		fprintf(stderr, "mdmon: Cannot load metadata for %s\n",
 			devname);
@@ -544,6 +528,8 @@ int mdmon(char *devname, int devnum, int scan, char *switchroot)
 		exit(2);
 	}
 
+	if (victim > -1)
+		try_kill_monitor(victim, container->devname);
 	do_manager(container);
 
 	exit(0);

