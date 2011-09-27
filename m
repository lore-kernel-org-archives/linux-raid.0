From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/8] Add continue option to grow command
Date: Tue, 27 Sep 2011 14:04:48 +0200
Message-ID: <20110927120448.4890.78828.stgit@gklab-128-013.igk.intel.com>
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

To allow for reshape continuation '--continue' option is added
to grow command.
Function that will be executed in grow-continue case doesn't require
information about reshape geometry. All required information are read
from metadata.
For external metadata reshape can be run for monitored array/container
only. In case when array/container is not monitored run mdmon for it.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c   |  132 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ReadMe.c |    1 
 mdadm.c  |   14 ++++++-
 mdadm.h  |    6 +++
 4 files changed, 151 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 4509488..768fc86 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3636,6 +3636,138 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 	return 1;
 }
 
+int Grow_continue_command(char *devname, int fd,
+			  char *backup_file, int verbose)
+{
+	int ret_val = 0;
+	struct supertype *st = NULL;
+	struct mdinfo *content = NULL;
+	struct mdinfo array;
+	char *subarray = NULL;
+	struct mdinfo *cc = NULL;
+	struct mdstat_ent *mdstat = NULL;
+	char buf[40];
+	int cfd = -1;
+	int fd2 = -1;
+
+	dprintf("Grow continue from command line called for %s\n",
+		devname);
+
+	st = super_by_fd(fd, &subarray);
+	if (!st || !st->ss) {
+		fprintf(stderr,
+			Name ": Unable to determine metadata format for %s\n",
+			devname);
+		return 1;
+	}
+	dprintf("Grow continue is run for ");
+	if (st->ss->external == 0) {
+		dprintf("native array (%s)\n", devname);
+		if (ioctl(fd, GET_ARRAY_INFO, &array) < 0) {
+			fprintf(stderr, Name ": %s is not an active md array -"
+				" aborting\n", devname);
+			ret_val = 1;
+			goto Grow_continue_command_exit;
+		}
+		content = &array;
+		sysfs_init(content, fd, st->devnum);
+	} else {
+		int container_dev;
+
+		if (subarray) {
+			dprintf("subarray (%s)\n", subarray);
+			container_dev = st->container_dev;
+			cfd = open_dev_excl(st->container_dev);
+		} else {
+			container_dev = st->devnum;
+			close(fd);
+			cfd = open_dev_excl(st->devnum);
+			dprintf("container (%i)\n", container_dev);
+			fd = cfd;
+		}
+		if (cfd < 0) {
+			fprintf(stderr, Name ": Unable to open container "
+				"for %s\n", devname);
+			ret_val = 1;
+			goto Grow_continue_command_exit;
+		}
+		fmt_devname(buf, container_dev);
+
+		/* find in container array under reshape
+		 */
+		ret_val = st->ss->load_container(st, cfd, NULL);
+		if (ret_val) {
+			fprintf(stderr,
+				Name ": Cannot read superblock for %s\n",
+				devname);
+			ret_val = 1;
+			goto Grow_continue_command_exit;
+		}
+
+		cc = st->ss->container_content(st, NULL);
+		for (content = cc; content ; content = content->next) {
+			char *array;
+
+			if (content->reshape_active == 0)
+				continue;
+
+			array = strchr(content->text_version+1, '/')+1;
+			mdstat = mdstat_by_subdev(array, container_dev);
+			if (!mdstat)
+				continue;
+			break;
+		}
+		if (!content) {
+			fprintf(stderr,
+				Name ": Unable to determine reshaped "
+				"array for %s\n", devname);
+			ret_val = 1;
+			goto Grow_continue_command_exit;
+		}
+		fd2 = open_dev(mdstat->devnum);
+		if (fd2 < 0) {
+			fprintf(stderr, Name ": cannot open (md%i)\n",
+				mdstat->devnum);
+			ret_val = 1;
+			goto Grow_continue_command_exit;
+		}
+
+		sysfs_init(content, fd2, mdstat->devnum);
+
+		/* start mdmon in case it is not run
+		 */
+		if (!mdmon_running(container_dev))
+			start_mdmon(container_dev);
+		ping_monitor(buf);
+
+		if (mdmon_running(container_dev))
+			st->update_tail = &st->updates;
+		else {
+			fprintf(stderr, Name ":  No mdmon found. "
+				"Grow cannot continue.\n");
+			ret_val = 1;
+			goto Grow_continue_command_exit;
+		}
+	}
+
+	/* continue reshape
+	 */
+	ret_val = Grow_continue(fd, st, content, backup_file,
+				FREEZE_RESHAPE_NONE);
+
+Grow_continue_command_exit:
+	if (fd2 > -1)
+		close(fd2);
+	if (cfd > -1)
+		close(cfd);
+	st->ss->free_super(st);
+	free_mdstat(mdstat);
+	sysfs_free(cc);
+	free(subarray);
+
+	return ret_val;
+}
+
 int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 		  char *backup_file, int freeze_reshape)
 {
diff --git a/ReadMe.c b/ReadMe.c
index 89dd7af..25426d3 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -191,6 +191,7 @@ struct option long_options[] = {
     {"backup-file", 1,0, BackupFile},
     {"invalid-backup",0,0,InvalidBackup},
     {"array-size", 1, 0, 'Z'},
+    {"continue", 0, 0, Continue},
 
     /* For Incremental */
     {"rebuild-map", 0, 0, RebuildMapOpt},
diff --git a/mdadm.c b/mdadm.c
index 18ca2ee..9fe09ea 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -74,6 +74,7 @@ int main(int argc, char *argv[])
 	int export = 0;
 	int assume_clean = 0;
 	char *symlinks = NULL;
+	int grow_continue = FREEZE_RESHAPE_NONE;
 	/* autof indicates whether and how to create device node.
 	 * bottom 3 bits are style.  Rest (when shifted) are number of parts
 	 * 0  - unset
@@ -995,7 +996,11 @@ int main(int argc, char *argv[])
 			}
 			backup_file = optarg;
 			continue;
-
+		case O(GROW, Continue):
+			/* Continuer broken grow
+			 */
+			grow_continue = FREEZE_RESHAPE_CONTINUE;
+			continue;
 		case O(ASSEMBLE, InvalidBackup):
 			/* Acknowledge that the backupfile is invalid, but ask
 			 * to continue anyway
@@ -1649,7 +1654,12 @@ int main(int argc, char *argv[])
 				delay = DEFAULT_BITMAP_DELAY;
 			rv = Grow_addbitmap(devlist->devname, mdfd, bitmap_file,
 					    bitmap_chunk, delay, write_behind, force);
-		} else if (size >= 0 || raiddisks != 0 || layout_str != NULL
+		} else if (grow_continue) {
+			rv = Grow_continue_command(devlist->devname,
+						   mdfd, backup_file,
+						   verbose);
+			break;
+		} else	if (size >= 0 || raiddisks != 0 || layout_str != NULL
 			   || chunk != 0 || level != UnSet) {
 			rv = Grow_reshape(devlist->devname, mdfd, quiet, backup_file,
 					  size, level, layout_str, chunk, raiddisks,
diff --git a/mdadm.h b/mdadm.h
index 073deb9..8f3e786 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -314,6 +314,7 @@ enum special_options {
 	InvalidBackup,
 	UdevRules,
 	FreezeReshape,
+	Continue,
 };
 
 /* structures read from config file */
@@ -1037,9 +1038,11 @@ extern int Grow_continue(int mdfd, struct supertype *st,
 /* define stages for freeze assembly feature
  * FREEZE_RESHAPE_NONE     : disabled
  * FREEZE_RESHAPE_ASSEMBLY : assemby phase
+ * FREEZE_RESHAPE_CONTINUE : grow continue phase
  */
 #define FREEZE_RESHAPE_NONE		0
 #define FREEZE_RESHAPE_ASSEMBLY		1
+#define FREEZE_RESHAPE_CONTINUE		2
 
 extern int restore_backup(struct supertype *st,
 			  struct mdinfo *content,
@@ -1047,6 +1050,8 @@ extern int restore_backup(struct supertype *st,
 			  int spares,
 			  char *backup_file,
 			  int verbose);
+extern int Grow_continue_command(char *devname, int fd,
+				 char *backup_file, int verbose);
 
 extern int Assemble(struct supertype *st, char *mddev,
 		    struct mddev_ident *ident,
@@ -1185,6 +1190,7 @@ extern char *human_size(long long bytes);
 extern char *human_size_brief(long long bytes);
 extern void print_r10_layout(int layout);
 
+
 #define NoMdDev (1<<23)
 extern int find_free_devnum(int use_partitions);
 

