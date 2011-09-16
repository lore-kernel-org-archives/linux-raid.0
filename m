From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/14] Add Grow_continue_command
Date: Fri, 16 Sep 2011 13:54:25 +0200
Message-ID: <20110916115425.5201.99417.stgit@gklab-128-013.igk.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

Add function that will be executed in grow-continue case
for external metadata. It checks if any reshape is in progress.
If it finds reshape in progress, Grow_continue() function
is called as during boot time for reshape continuation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c  |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mdadm.c |    7 +++-
 mdadm.h |    2 +
 3 files changed, 121 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index cec32d7..2b2cb5a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3578,6 +3578,119 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 	return 1;
 }
 
+int Grow_continue_command(char *devname, int fd,
+			  char *backup_file, int verbose)
+{
+	int ret_val = 0;
+	struct supertype *st = NULL;
+	struct mdinfo *content = NULL;
+	char *subarray = NULL;
+	struct mdinfo *cc = NULL;
+	struct mdstat_ent *mdstat = NULL;
+	char container[20];
+	int cfd = -1;
+	int fd2 = -1;
+
+	dprintf("Grow continue from command line called for %s\n",
+		devname);
+
+	st = super_by_fd(fd, &subarray);
+	if (!st) {
+		fprintf(stderr,
+			Name ": Unable to determine metadata format for %s\n",
+			devname);
+		return 1;
+	}
+	dprintf("Grow continue is run for ");
+	if (st->ss->external == 0) {
+		dprintf("native array (%s)\n", devname);
+		/* FIXME : temporary just exit
+		 * for native metadata case
+		 */
+		st->ss->free_super(st);
+		free(subarray);
+		exit(0);
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
+		fmt_devname(container, container_dev);
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
+	}
+
+	/* continue reshape
+	 */
+	ret_val = Grow_continue(fd, st, content, backup_file);
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
 		  char *backup_file)
 {
diff --git a/mdadm.c b/mdadm.c
index f30534a..3bd4ebe 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1649,7 +1649,12 @@ int main(int argc, char *argv[])
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
index 7e3a618..7761db6 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1024,6 +1024,8 @@ extern int Grow_restart(struct supertype *st, struct mdinfo *info,
 			int *fdlist, int cnt, char *backup_file, int verbose);
 extern int Grow_continue(int mdfd, struct supertype *st,
 			 struct mdinfo *info, char *backup_file);
+extern int Grow_continue_command(char *devname, int fd,
+				 char *backup_file, int verbose);
 
 extern int Assemble(struct supertype *st, char *mddev,
 		    struct mddev_ident *ident,

