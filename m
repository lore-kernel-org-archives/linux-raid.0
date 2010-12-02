From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 06/10] FIX: open backup file for reshape as function
Date: Thu, 02 Dec 2010 09:19:27 +0100
Message-ID: <20101202081927.4639.74895.stgit@gklab-170-024.igk.intel.com>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Move opening backup file to the function for future reuse during container reshape.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c  |  109 ++++++++++++++++++++++++++++++++++++++-------------------------
 mdadm.h |    8 ++++-
 2 files changed, 73 insertions(+), 44 deletions(-)

diff --git a/Grow.c b/Grow.c
index eb0c7e0..96c9526 100644
--- a/Grow.c
+++ b/Grow.c
@@ -913,6 +913,66 @@ int reshape_prepare_fdlist(char *devname,
 release:
 	return d;
 }
+int reshape_open_backup_file(char *backup_file,
+			     int fd,
+			     char *devname,
+			     int d,
+			     long blocks,
+			     int *fdlist,
+			     unsigned long long *offsets)
+{
+	/* need to check backup file is large enough */
+	char buf[512];
+	struct stat stb;
+	unsigned int dev;
+	int ret_val = -1;
+	int i;
+
+	fdlist[d] = open(backup_file, O_RDWR|O_CREAT|O_EXCL,
+			 S_IRUSR | S_IWUSR);
+	offsets[d] = 8 * 512;
+	if (fdlist[d] < 0) {
+		fprintf(stderr, Name ": %s: cannot create backup file %s: %s\n",
+			devname, backup_file, strerror(errno));
+		ret_val = 1;
+		return ret_val;
+	}
+	/* Guard against backup file being on array device.
+	 * If array is partitioned or if LVM etc is in the
+	 * way this will not notice, but it is better than
+	 * nothing.
+	 */
+	fstat(fdlist[d], &stb);
+	dev = stb.st_dev;
+	fstat(fd, &stb);
+	if (stb.st_rdev == dev) {
+		fprintf(stderr, Name ": backup file must NOT be"
+			" on the array being reshaped.\n");
+		ret_val = 1;
+		close(fdlist[d]);
+		return ret_val;
+	}
+
+	memset(buf, 0, 512);
+	for (i=0; i < blocks + 1 ; i++) {
+		if (write(fdlist[d], buf, 512) != 512) {
+			fprintf(stderr, Name ": %s: cannot create backup file %s: %s\n",
+				devname, backup_file, strerror(errno));
+			ret_val = 1;
+			return ret_val;
+		}
+	}
+	if (fsync(fdlist[d]) != 0) {
+		fprintf(stderr, Name ": %s: cannot create backup file %s: %s\n",
+			devname, backup_file, strerror(errno));
+		ret_val = 1;
+		return ret_val;
+	}
+
+	ret_val = d + 1;
+
+	return ret_val;
+}
 
 unsigned long compute_backup_blocks(int nchunk, int ochunk,
 				    unsigned int ndata, unsigned int odata)
@@ -974,7 +1034,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 	char alt_layout[40];
 	int *fdlist;
 	unsigned long long *offsets;
-	int d, i;
+	int d;
 	int nrdisks;
 	int err;
 	int frozen;
@@ -1652,51 +1712,14 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				break;
 			}
 		} else {
-			/* need to check backup file is large enough */
-			char buf[512];
-			struct stat stb;
-			unsigned int dev;
-			fdlist[d] = open(backup_file, O_RDWR|O_CREAT|O_EXCL,
-				     S_IRUSR | S_IWUSR);
-			offsets[d] = 8 * 512;
-			if (fdlist[d] < 0) {
-				fprintf(stderr, Name ": %s: cannot create backup file %s: %s\n",
-					devname, backup_file, strerror(errno));
-				rv = 1;
-				break;
-			}
-			/* Guard against backup file being on array device.
-			 * If array is partitioned or if LVM etc is in the
-			 * way this will not notice, but it is better than
-			 * nothing.
-			 */
-			fstat(fdlist[d], &stb);
-			dev = stb.st_dev;
-			fstat(fd, &stb);
-			if (stb.st_rdev == dev) {
-				fprintf(stderr, Name ": backup file must NOT be"
-					" on the array being reshaped.\n");
-				rv = 1;
-				close(fdlist[d]);
-				break;
-			}
-
-			memset(buf, 0, 512);
-			for (i=0; i < (signed)blocks + 1 ; i++) {
-				if (write(fdlist[d], buf, 512) != 512) {
-					fprintf(stderr, Name ": %s: cannot create backup file %s: %s\n",
-						devname, backup_file, strerror(errno));
-					rv = 1;
-					break;
-				}
-			}
-			if (fsync(fdlist[d]) != 0) {
-				fprintf(stderr, Name ": %s: cannot create backup file %s: %s\n",
-					devname, backup_file, strerror(errno));
+			int handlers = reshape_open_backup_file(backup_file, fd, devname,
+								d, (signed)blocks,
+								fdlist, offsets);
+			if (handlers < 0) {
 				rv = 1;
 				break;
 			}
-			d++;
+			d = handlers;
 		}
 
 		/* check that the operation is supported by the metadata */
diff --git a/mdadm.h b/mdadm.h
index a0126eb..839fb6c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -486,7 +486,13 @@ extern int reshape_prepare_fdlist(char *devname,
 extern void reshape_free_fdlist(int *fdlist,
 				unsigned long long *offsets,
 				int size);
-
+extern int reshape_open_backup_file(char *backup,
+				    int fd,
+				    char *devname,
+				    int d,
+				    long blocks,
+				    int *fdlist,
+				    unsigned long long *offsets);
 extern unsigned long compute_backup_blocks(int nchunk, int ochunk,
 					   unsigned int ndata, unsigned int odata);
 

