From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: Close unused handle in child process during reshape
	restart
Date: Wed, 26 Oct 2011 18:16:55 +0200
Message-ID: <20111026161654.13887.42747.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When array reshape (e.g. raid0->raid5 migration) is restarted during
array assembly, file system placed on this array cannot be mounted until
reshape is finished due to "busy" error.

This is caused when reshape is executed on array for external metadata
and array handle is cloned /forked/ to child process environment but not
closed.

Handle can't be closed before executing Grow_continue() because it is
used later in code.

Close unused handle in child process /reshape_container()/.
It is similar to close fd handle in reshape_array() before calling
manage_reshape()/child_monitor() in Grow.c:2290.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 0e4dd10..93a69fd 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1350,6 +1350,7 @@ static int reshape_array(char *container, int fd, char *devname,
 			 char *backup_file, int quiet, int forked,
 			 int restart, int freeze_reshape);
 static int reshape_container(char *container, char *devname,
+			     int mdfd,
 			     struct supertype *st, 
 			     struct mdinfo *info,
 			     int force,
@@ -1768,7 +1769,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 * number of devices (On-Line Capacity Expansion) must be
 		 * performed at the level of the container
 		 */
-		rv = reshape_container(container, devname, st, &info,
+		rv = reshape_container(container, devname, -1, st, &info,
 				       force, backup_file, quiet, 0, 0);
 		frozen = 0;
 	} else {
@@ -2403,7 +2404,10 @@ release:
 	return 1;
 }
 
+/* mdfd handle is passed to be closed in child process (after fork).
+ */
 int reshape_container(char *container, char *devname,
+		      int mdfd,
 		      struct supertype *st, 
 		      struct mdinfo *info,
 		      int force,
@@ -2446,6 +2450,11 @@ int reshape_container(char *container, char *devname,
 		break;
 	}
 
+	/* close unused handle in child process
+	 */
+	if (mdfd > -1)
+		close(mdfd);
+
 	while(1) {
 		/* For each member array with reshape_active,
 		 * we need to perform the reshape.
@@ -3821,7 +3830,7 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 		fmt_devname(container, st->container_dev);
 		st->ss->load_container(st, cfd, container);
 		close(cfd);
-		ret_val = reshape_container(container, NULL,
+		ret_val = reshape_container(container, NULL, mdfd,
 					    st, info, 0, backup_file,
 					    0, 1, freeze_reshape);
 	} else

