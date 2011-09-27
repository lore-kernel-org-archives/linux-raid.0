From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/8] Do not continue reshape during initrd phase
Date: Tue, 27 Sep 2011 14:04:39 +0200
Message-ID: <20110927120439.4890.75281.stgit@gklab-128-013.igk.intel.com>
References: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

During initrd phase continuing reshape will cause file system context
lost. This blocks ability to control reshape using checkpoints.

To avoid this, during initrd phase assemble has to be executed with
'--freeze-reshape' option. This causes that mdadm restores reshape
critical section only.

Reshape can be continued later after system full boot.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c    |   12 +++++++-----
 Grow.c        |   52 ++++++++++++++++++++++++++++++++++++++--------------
 Incremental.c |   16 ++++++++++------
 ReadMe.c      |    1 +
 mdadm.c       |   33 ++++++++++++++++++++++++---------
 mdadm.h       |   18 ++++++++++++++----
 6 files changed, 94 insertions(+), 38 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index c6aad20..afca38e 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -138,7 +138,7 @@ int Assemble(struct supertype *st, char *mddev,
 	     char *backup_file, int invalid_backup,
 	     int readonly, int runstop,
 	     char *update, char *homehost, int require_homehost,
-	     int verbose, int force)
+	     int verbose, int force, int freeze_reshape)
 {
 	/*
 	 * The task of Assemble is to find a collection of
@@ -697,7 +697,7 @@ int Assemble(struct supertype *st, char *mddev,
 		int err;
 		err = assemble_container_content(st, mdfd, content, runstop,
 						 chosen_name, verbose,
-						 backup_file);
+						 backup_file, freeze_reshape);
 		close(mdfd);
 		return err;
 	}
@@ -1344,7 +1344,8 @@ int Assemble(struct supertype *st, char *mddev,
 #ifndef MDASSEMBLE
 			if (content->reshape_active &&
 			    content->delta_disks <= 0)
-				rv = Grow_continue(mdfd, st, content, backup_file);
+				rv = Grow_continue(mdfd, st, content,
+						   backup_file, freeze_reshape);
 			else
 #endif
 				rv = ioctl(mdfd, RUN_ARRAY, NULL);
@@ -1511,7 +1512,7 @@ int Assemble(struct supertype *st, char *mddev,
 int assemble_container_content(struct supertype *st, int mdfd,
 			       struct mdinfo *content, int runstop,
 			       char *chosen_name, int verbose,
-			       char *backup_file)
+			       char *backup_file, int freeze_reshape)
 {
 	struct mdinfo *dev, *sra;
 	int working = 0, preexist = 0;
@@ -1560,7 +1561,8 @@ int assemble_container_content(struct supertype *st, int mdfd,
 					   spare, backup_file, verbose) == 1)
 				return 1;
 
-			err = Grow_continue(mdfd, st, content, backup_file);
+			err = Grow_continue(mdfd, st, content, backup_file,
+					    freeze_reshape);
 		} else switch(content->array.level) {
 		case LEVEL_LINEAR:
 		case LEVEL_MULTIPATH:
diff --git a/Grow.c b/Grow.c
index 4a25165..4509488 100644
--- a/Grow.c
+++ b/Grow.c
@@ -696,10 +696,16 @@ static int subarray_set_num(char *container, struct mdinfo *sra, char *name, int
 	return rc;
 }
 
-int start_reshape(struct mdinfo *sra, int already_running)
+int start_reshape(struct mdinfo *sra, int already_running, int freeze_reshape)
 {
 	int err;
-	sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
+
+	/* do not block array as we not continue reshape this time
+	 */
+	if (freeze_reshape == FREEZE_RESHAPE_NONE)
+		sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
+	else
+		sysfs_set_num(sra, NULL, "suspend_lo", 0);
 	err = sysfs_set_num(sra, NULL, "suspend_hi", 0);
 	err = err ?: sysfs_set_num(sra, NULL, "suspend_lo", 0);
 	if (!already_running)
@@ -1344,13 +1350,13 @@ static int reshape_array(char *container, int fd, char *devname,
 			 struct supertype *st, struct mdinfo *info,
 			 int force, struct mddev_dev *devlist,
 			 char *backup_file, int quiet, int forked,
-			 int restart);
+			 int restart, int freeze_reshape);
 static int reshape_container(char *container, char *devname,
 			     struct supertype *st, 
 			     struct mdinfo *info,
 			     int force,
 			     char *backup_file,
-			     int quiet, int restart);
+			     int quiet, int restart, int freeze_reshape);
 
 int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 long long size,
@@ -1761,7 +1767,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 * performed at the level of the container
 		 */
 		rv = reshape_container(container, devname, st, &info,
-				       force, backup_file, quiet, 0);
+				       force, backup_file, quiet, 0, 0);
 		frozen = 0;
 	} else {
 		/* get spare devices from external metadata
@@ -1789,7 +1795,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		}
 		sync_metadata(st);
 		rv = reshape_array(container, fd, devname, st, &info, force,
-				   devlist, backup_file, quiet, 0, 0);
+				   devlist, backup_file, quiet, 0, 0, 0);
 		frozen = 0;
 	}
 release:
@@ -1802,7 +1808,7 @@ static int reshape_array(char *container, int fd, char *devname,
 			 struct supertype *st, struct mdinfo *info,
 			 int force, struct mddev_dev *devlist,
 			 char *backup_file, int quiet, int forked,
-			 int restart)
+			 int restart, int freeze_reshape)
 {
 	struct reshape reshape;
 	int spares_needed;
@@ -2241,7 +2247,7 @@ started:
 		}
 	}
 
-	err = start_reshape(sra, restart);
+	err = start_reshape(sra, restart, freeze_reshape);
 	if (err) {
 		fprintf(stderr, 
 			Name ": Cannot %s reshape for %s\n",
@@ -2251,6 +2257,15 @@ started:
 	}
 	if (restart)
 		sysfs_set_str(sra, NULL, "array_state", "active");
+	if (freeze_reshape == FREEZE_RESHAPE_ASSEMBLY) {
+		free(fdlist);
+		free(offsets);
+		sysfs_free(sra);
+		fprintf(stderr, Name ": Reshape has to be continued from"
+			" location %llu when root fileststem will be mounted\n",
+			sra->reshape_progress);
+		return 1;
+	}
 
 	/* Now we just need to kick off the reshape and watch, while
 	 * handling backups of the data...
@@ -2389,7 +2404,7 @@ int reshape_container(char *container, char *devname,
 		      struct mdinfo *info,
 		      int force,
 		      char *backup_file,
-		      int quiet, int restart)
+		      int quiet, int restart, int freeze_reshape)
 {
 	struct mdinfo *cc = NULL;
 	int rv = restart;
@@ -2418,7 +2433,9 @@ int reshape_container(char *container, char *devname,
 		unfreeze(st);
 		return 1;
 	default: /* parent */
-		printf(Name ": multi-array reshape continues in background\n");
+		if (freeze_reshape == FREEZE_RESHAPE_NONE)
+			printf(Name ": multi-array reshape continues"
+			       "in background\n");
 		return 0;
 	case 0: /* child */
 		break;
@@ -2473,8 +2490,15 @@ int reshape_container(char *container, char *devname,
 
 		rv = reshape_array(container, fd, adev, st,
 				   content, force, NULL,
-				   backup_file, quiet, 1, restart);
+				   backup_file, quiet, 1, restart,
+				   freeze_reshape);
 		close(fd);
+
+		if (freeze_reshape) {
+			sysfs_free(cc);
+			exit(0);
+		}
+
 		restart = 0;
 		if (rv)
 			break;
@@ -3613,7 +3637,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 }
 
 int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
-		  char *backup_file)
+		  char *backup_file, int freeze_reshape)
 {
 	char buf[40];
 	char *container = NULL;
@@ -3640,9 +3664,9 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 			close(cfd);
 			return reshape_container(container, NULL,
 						 st, info, 0, backup_file,
-						 0, 1);
+						 0, 1, freeze_reshape);
 		}
 	}
 	return reshape_array(container, mdfd, "array", st, info, 1,
-			     NULL, backup_file, 0, 0, 1);
+			     NULL, backup_file, 0, 0, 1, freeze_reshape);
 }
diff --git a/Incremental.c b/Incremental.c
index 791ad85..571d45d 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -44,7 +44,8 @@ static int try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 
 static int Incremental_container(struct supertype *st, char *devname,
 				 char *homehost,
-				 int verbose, int runstop, int autof);
+				 int verbose, int runstop, int autof,
+				 int freeze_reshape);
 
 static struct mddev_ident *search_mdstat(struct supertype *st,
 					   struct mdinfo *info,
@@ -53,7 +54,7 @@ static struct mddev_ident *search_mdstat(struct supertype *st,
 
 int Incremental(char *devname, int verbose, int runstop,
 		struct supertype *st, char *homehost, int require_homehost,
-		int autof)
+		int autof, int freeze_reshape)
 {
 	/* Add this device to an array, creating the array if necessary
 	 * and starting the array if sensible or - if runstop>0 - if possible.
@@ -140,7 +141,8 @@ int Incremental(char *devname, int verbose, int runstop,
 		close(dfd);
 		if (!rv && st->ss->container_content)
 			return Incremental_container(st, devname, homehost,
-						     verbose, runstop, autof);
+						     verbose, runstop, autof,
+						     freeze_reshape);
 
 		fprintf(stderr, Name ": %s is not part of an md array.\n",
 			devname);
@@ -450,7 +452,8 @@ int Incremental(char *devname, int verbose, int runstop,
 		close(mdfd);
 		sysfs_free(sra);
 		rv = Incremental(chosen_name, verbose, runstop,
-				 NULL, homehost, require_homehost, autof);
+				 NULL, homehost, require_homehost, autof,
+				 freeze_reshape);
 		if (rv == 1)
 			/* Don't fail the whole -I if a subarray didn't
 			 * have enough devices to start yet
@@ -1416,7 +1419,7 @@ static char *container2devname(char *devname)
 
 static int Incremental_container(struct supertype *st, char *devname,
 				 char *homehost, int verbose,
-				 int runstop, int autof)
+				 int runstop, int autof, int freeze_reshape)
 {
 	/* Collect the contents of this container and for each
 	 * array, choose a device name and assemble the array.
@@ -1551,7 +1554,8 @@ static int Incremental_container(struct supertype *st, char *devname,
 		}
 
 		assemble_container_content(st, mdfd, ra, runstop,
-					   chosen_name, verbose, NULL);
+					   chosen_name, verbose, NULL,
+					   freeze_reshape);
 		close(mdfd);
 	}
 
diff --git a/ReadMe.c b/ReadMe.c
index b658841..89dd7af 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -153,6 +153,7 @@ struct option long_options[] = {
     {"scan",      0, 0, 's'},
     {"force",	  0, 0, Force},
     {"update",	  1, 0, 'U'},
+    {"freeze-reshape", 0, 0, FreezeReshape},
 
     /* Management */
     {"add",       0, 0, Add},
diff --git a/mdadm.c b/mdadm.c
index 1533510..18ca2ee 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -112,6 +112,8 @@ int main(int argc, char *argv[])
 
 	int mdfd = -1;
 
+	int freeze_reshape = FREEZE_RESHAPE_NONE;
+
 	srandom(time(0) ^ getpid());
 
 	ident.uuid_set=0;
@@ -612,8 +614,12 @@ int main(int argc, char *argv[])
 		case O(MANAGE,Force): /* add device which is too large */
 			force=1;
 			continue;
-
 			/* now for the Assemble options */
+		case O(ASSEMBLE, FreezeReshape):   /* Freeze reshape during
+						    * initrd phase */
+		case O(INCREMENTAL, FreezeReshape):
+			freeze_reshape = FREEZE_RESHAPE_ASSEMBLY;
+			continue;
 		case O(CREATE,'u'): /* uuid of array */
 		case O(ASSEMBLE,'u'): /* uuid of array */
 			if (ident.uuid_set) {
@@ -1228,14 +1234,16 @@ int main(int argc, char *argv[])
 					       NULL, backup_file, invalid_backup,
 					       readonly, runstop, update,
 					       homehost, require_homehost,
-					       verbose-quiet, force);
+					       verbose-quiet, force,
+					       freeze_reshape);
 			}
 		} else if (!scan)
 			rv = Assemble(ss, devlist->devname, &ident,
 				      devlist->next, backup_file, invalid_backup,
 				      readonly, runstop, update,
 				      homehost, require_homehost,
-				      verbose-quiet, force);
+				      verbose-quiet, force,
+				      freeze_reshape);
 		else if (devs_found>0) {
 			if (update && devs_found > 1) {
 				fprintf(stderr, Name ": can only update a single array at a time\n");
@@ -1259,7 +1267,8 @@ int main(int argc, char *argv[])
 					       NULL, backup_file, invalid_backup,
 					       readonly, runstop, update,
 					       homehost, require_homehost,
-					       verbose-quiet, force);
+					       verbose-quiet, force,
+					       freeze_reshape);
 			}
 		} else {
 			struct mddev_ident *a, *array_list =  conf_get_ident(NULL);
@@ -1300,7 +1309,8 @@ int main(int argc, char *argv[])
 						     NULL, NULL, 0,
 						     readonly, runstop, NULL,
 						     homehost, require_homehost,
-						     verbose-quiet, force);
+						     verbose-quiet, force,
+						     freeze_reshape);
 					if (r == 0) {
 						a->assembled = 1;
 						successes++;
@@ -1325,9 +1335,13 @@ int main(int argc, char *argv[])
 						rv2 = Assemble(ss, NULL,
 							       &ident,
 							       devlist, NULL, 0,
-							       readonly, runstop, NULL,
-							       homehost, require_homehost,
-							       verbose-quiet, force);
+							       readonly,
+							       runstop, NULL,
+							       homehost,
+							       require_homehost,
+							       verbose-quiet,
+							       force,
+							       freeze_reshape);
 						if (rv2==0) {
 							cnt++;
 							acnt++;
@@ -1681,7 +1695,8 @@ int main(int argc, char *argv[])
 		else
 			rv = Incremental(devlist->devname, verbose-quiet,
 					 runstop, ss, homehost,
-					 require_homehost, autof);
+					 require_homehost, autof,
+					 freeze_reshape);
 		break;
 	case AUTODETECT:
 		autodetect();
diff --git a/mdadm.h b/mdadm.h
index 8dd37d9..073deb9 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -313,6 +313,7 @@ enum special_options {
 	RebuildMapOpt,
 	InvalidBackup,
 	UdevRules,
+	FreezeReshape,
 };
 
 /* structures read from config file */
@@ -1030,7 +1031,16 @@ extern int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 extern int Grow_restart(struct supertype *st, struct mdinfo *info,
 			int *fdlist, int cnt, char *backup_file, int verbose);
 extern int Grow_continue(int mdfd, struct supertype *st,
-			 struct mdinfo *info, char *backup_file);
+			 struct mdinfo *info, char *backup_file,
+			 int freeze_reshape);
+
+/* define stages for freeze assembly feature
+ * FREEZE_RESHAPE_NONE     : disabled
+ * FREEZE_RESHAPE_ASSEMBLY : assemby phase
+ */
+#define FREEZE_RESHAPE_NONE		0
+#define FREEZE_RESHAPE_ASSEMBLY		1
+
 extern int restore_backup(struct supertype *st,
 			  struct mdinfo *content,
 			  int working_disks,
@@ -1044,7 +1054,7 @@ extern int Assemble(struct supertype *st, char *mddev,
 		    char *backup_file, int invalid_backup,
 		    int readonly, int runstop,
 		    char *update, char *homehost, int require_homehost,
-		    int verbose, int force);
+		    int verbose, int force, int freeze_reshape);
 
 extern int Build(char *mddev, int chunk, int level, int layout,
 		 int raiddisks, struct mddev_dev *devlist, int assume_clean,
@@ -1078,7 +1088,7 @@ extern int WaitClean(char *dev, int sock, int verbose);
 
 extern int Incremental(char *devname, int verbose, int runstop,
 		       struct supertype *st, char *homehost, int require_homehost,
-		       int autof);
+		       int autof, int freeze_reshape);
 extern void RebuildMap(void);
 extern int IncrementalScan(int verbose);
 extern int IncrementalRemove(char *devname, char *path, int verbose);
@@ -1157,7 +1167,7 @@ extern void append_metadata_update(struct supertype *st, void *buf, int len);
 extern int assemble_container_content(struct supertype *st, int mdfd,
 				      struct mdinfo *content, int runstop,
 				      char *chosen_name, int verbose,
-				      char *backup_file);
+				      char *backup_file, int freeze_reshape);
 extern struct mdinfo *container_choose_spares(struct supertype *st,
 					      unsigned long long min_size,
 					      struct domainlist *domlist,

