From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/4] FIX: ping_monitor() usage causes memory leaks
Date: Tue, 15 Mar 2011 14:48:48 +0100
Message-ID: <20110315134848.32643.78856.stgit@gklab-128-013.igk.intel.com>
References: <20110315134000.32643.1818.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110315134000.32643.1818.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When for ping_monitor() input devnum2devname() is used,
received string pointer should be passed to free() for memory release.
It is not made in several places. This use case should have function
to avoid memory leak.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c    |    2 +-
 Create.c      |    2 +-
 Grow.c        |    2 +-
 Incremental.c |   10 ++++------
 Manage.c      |    9 ++-------
 Monitor.c     |    2 +-
 msg.c         |   14 ++++++++++++++
 msg.h         |    1 +
 8 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index bfc879c..ee0346a 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1598,7 +1598,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 			if (!err) {
 				if (!mdmon_running(st->container_dev))
 					start_mdmon(st->container_dev);
-				ping_monitor(devnum2devname(st->container_dev));
+				ping_monitor_by_id(st->container_dev);
 			}
 			break;
 		}
diff --git a/Create.c b/Create.c
index 6349f86..9f34425 100644
--- a/Create.c
+++ b/Create.c
@@ -929,7 +929,7 @@ int Create(struct supertype *st, char *mddev,
 			if (need_mdmon)
 				start_mdmon(st->container_dev);
 
-			ping_monitor(devnum2devname(st->container_dev));
+			ping_monitor_by_id(st->container_dev);
 			close(container_fd);
 		}
 		wait_for(chosen_name, mdfd);
diff --git a/Grow.c b/Grow.c
index 40e693e..b639585 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3416,7 +3416,7 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 
 		if (!mdmon_running(st->container_dev))
 			start_mdmon(st->container_dev);
-		ping_monitor(devnum2devname(st->container_dev));
+		ping_monitor_by_id(st->container_dev);
 
 
 		if (info->reshape_active == 2) {
diff --git a/Incremental.c b/Incremental.c
index 300bdca..7218060 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -438,7 +438,7 @@ int Incremental(char *devname, int verbose, int runstop,
 	/* 7/ Is there enough devices to possibly start the array? */
 	/* 7a/ if not, finish with success. */
 	if (info.array.level == LEVEL_CONTAINER) {
-		char *devname = NULL;
+		int devnum;
 		/* Try to assemble within the container */
 		map_unlock(&map);
 		sysfs_uevent(&info, "change");
@@ -448,7 +448,7 @@ int Incremental(char *devname, int verbose, int runstop,
 				chosen_name, info.array.working_disks);
 		wait_for(chosen_name, mdfd);
 		if (st->ss->external)
-			devname = devnum2devname(fd2devnum(mdfd));
+			devnum = fd2devnum(mdfd);
 		close(mdfd);
 		sysfs_free(sra);
 		rv = Incremental(chosen_name, verbose, runstop,
@@ -460,10 +460,8 @@ int Incremental(char *devname, int verbose, int runstop,
 			rv = 0;
 		/* after spare is added, ping monitor for external metadata
 		 * so that it can eg. try to rebuild degraded array */
-		if (st->ss->external) {
-			ping_monitor(devname);
-			free(devname);
-		}
+		if (st->ss->external)
+			ping_monitor_by_id(devnum);
 		return rv;
 	}
 
diff --git a/Manage.c b/Manage.c
index 0349aa3..bdf3e04 100644
--- a/Manage.c
+++ b/Manage.c
@@ -903,13 +903,8 @@ int Manage_subdevs(char *devname, int fd,
 					sysfs_free(sra);
 					return 1;
 				}
-				if (mdmon_running(devnum)) {
-					char *cont = devnum2devname(devnum);
-					if (cont) {
-						ping_monitor(cont);
-						free(cont);
-					}
-				}
+				if (mdmon_running(devnum))
+					ping_monitor_by_id(devnum);
 				sysfs_free(sra);
 				close(container_fd);
 			} else {
diff --git a/Monitor.c b/Monitor.c
index d3795b1..3f211b5 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -975,7 +975,7 @@ int Wait(char *dev)
 				if (is_subarray(&e->metadata_version[9]))
 					ping_monitor(&e->metadata_version[9]);
 				else
-					ping_monitor(devnum2devname(devnum));
+					ping_monitor_by_id(devnum);
 			}
 			free_mdstat(ms);
 			return rv;
diff --git a/msg.c b/msg.c
index a1f4bc6..a10c930 100644
--- a/msg.c
+++ b/msg.c
@@ -213,6 +213,20 @@ int ping_monitor(char *devname)
 	return err;
 }
 
+/* ping monitor using device number */
+int ping_monitor_by_id(int devnum)
+{
+	int err = -1;
+	char *container = devnum2devname(devnum);
+
+	if (container) {
+		err = ping_monitor(container);
+		free(container);
+	}
+
+	return err;
+}
+
 static char *ping_monitor_version(char *devname)
 {
 	int sfd = connect_monitor(devname);
diff --git a/msg.h b/msg.h
index 91a7798..c6d037d 100644
--- a/msg.h
+++ b/msg.h
@@ -27,6 +27,7 @@ extern int ack(int fd, int tmo);
 extern int wait_reply(int fd, int tmo);
 extern int connect_monitor(char *devname);
 extern int ping_monitor(char *devname);
+extern int ping_monitor_by_id(int devnum);
 extern int block_subarray(struct mdinfo *sra);
 extern int unblock_subarray(struct mdinfo *sra, const int unfreeze);
 extern int block_monitor(char *container, const int freeze);

