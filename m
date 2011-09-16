From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 09/14] Move restore backup code to function
Date: Fri, 16 Sep 2011 13:54:55 +0200
Message-ID: <20110916115455.5201.60281.stgit@gklab-128-013.igk.intel.com>
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

Reshape backup should be able to be restored during reshape continuation
also. To reuse already existing code it is moved to function.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |   40 +++------------------------------------
 Grow.c     |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mdadm.h    |    6 ++++++
 3 files changed, 71 insertions(+), 37 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 66d2ee4..6188fb5 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1555,44 +1555,10 @@ int assemble_container_content(struct supertype *st, int mdfd,
 
 		if (content->reshape_active) {
 			int spare = content->array.raid_disks + expansion;
-			int i;
-			int *fdlist = malloc(sizeof(int) *
-					     (working + expansion
-					      + content->array.raid_disks));
-			for (i=0; i<spare; i++)
-				fdlist[i] = -1;
-			for (dev = content->devs; dev; dev = dev->next) {
-				char buf[20];
-				int fd;
-				sprintf(buf, "%d:%d",
-					dev->disk.major,
-					dev->disk.minor);
-				fd = dev_open(buf, O_RDWR);
-
-				if (dev->disk.raid_disk >= 0)
-					fdlist[dev->disk.raid_disk] = fd;
-				else
-					fdlist[spare++] = fd;
-			}
-			if (st->ss->external && st->ss->recover_backup)
-				err = st->ss->recover_backup(st, content);
-			else
-				err = Grow_restart(st, content, fdlist, spare,
-						   backup_file, verbose > 0);
-			while (spare > 0) {
-				spare--;
-				if (fdlist[spare] >= 0)
-					close(fdlist[spare]);
-			}
-			free(fdlist);
-			if (err) {
-				fprintf(stderr, Name ": Failed to restore critical"
-					" section for reshape - sorry.\n");
-				if (!backup_file)
-					fprintf(stderr, Name ":  Possibly you need"
-						" to specify a --backup-file\n");
+			if (restore_backup(st, content,
+					   working,
+					   spare, backup_file, verbose))
 				return 1;
-			}
 
 			err = Grow_continue(mdfd, st, content, backup_file);
 		} else switch(content->array.level) {
diff --git a/Grow.c b/Grow.c
index b331287..0b96f7a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3578,6 +3578,68 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 	return 1;
 }
 
+int restore_backup(struct supertype *st,
+		   struct mdinfo *content,
+		   int working_disks,
+		   int spares,
+		   char *backup_file,
+		   int verbose)
+{
+	int i;
+	int *fdlist;
+	struct mdinfo *dev;
+	int err;
+	int disk_count = working_disks + spares;
+	int next_spare = working_disks;
+
+	dprintf("Called restore_backup()\n");
+	fdlist = malloc(sizeof(int) * disk_count);
+	if (fdlist == NULL) {
+		fprintf(stderr,
+			Name ": cannot allocate memory for disk list\n");
+		return 1;
+	}
+	for (i = 0; i < disk_count; i++)
+		fdlist[i] = -1;
+	for (dev = content->devs; dev; dev = dev->next) {
+		char buf[22];
+		int fd;
+		sprintf(buf, "%d:%d",
+			dev->disk.major,
+			dev->disk.minor);
+		fd = dev_open(buf, O_RDWR);
+
+		if (dev->disk.raid_disk >= 0)
+			fdlist[dev->disk.raid_disk] = fd;
+		else
+			fdlist[next_spare++] = fd;
+	}
+
+	if (st->ss->external && st->ss->recover_backup)
+		err = st->ss->recover_backup(st, content);
+	else
+		err = Grow_restart(st, content, fdlist, spares,
+				   backup_file, verbose > 0);
+
+	while (disk_count > 0) {
+		disk_count--;
+		if (fdlist[disk_count] >= 0)
+			close(fdlist[disk_count]);
+	}
+	free(fdlist);
+	if (err) {
+		fprintf(stderr, Name ": Failed to restore critical"
+			" section for reshape - sorry.\n");
+		if (!backup_file)
+			fprintf(stderr, Name ":  Possibly you need"
+				" to specify a --backup-file\n");
+		return 1;
+	}
+
+	dprintf("restore_backup() returns status OK.\n");
+	return 0;
+}
+
 int Grow_continue_command(char *devname, int fd,
 			  char *backup_file, int verbose)
 {
diff --git a/mdadm.h b/mdadm.h
index 7761db6..6165979 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1026,6 +1026,12 @@ extern int Grow_continue(int mdfd, struct supertype *st,
 			 struct mdinfo *info, char *backup_file);
 extern int Grow_continue_command(char *devname, int fd,
 				 char *backup_file, int verbose);
+extern int restore_backup(struct supertype *st,
+			  struct mdinfo *content,
+			  int working_disks,
+			  int spares,
+			  char *backup_file,
+			  int verbose);
 
 extern int Assemble(struct supertype *st, char *mddev,
 		    struct mddev_ident *ident,

