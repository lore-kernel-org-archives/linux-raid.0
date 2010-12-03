From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 06/10] FIX: open backup file for reshape as function
Date: Fri, 3 Dec 2010 15:01:16 +1100
Message-ID: <20101203150116.516e9de2@notabene.brown>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
	<20101202081927.4639.74895.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202081927.4639.74895.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 02 Dec 2010 09:19:27 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Move opening backup file to the function for future reuse during container reshape.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Your return-value handling from the new function was somewhat confused.  It
would never return -1 for example.

I have tidied it up and applied the following.  Note that I avoided passing
'd' to the function.

NeilBrown


commit e6e9d47b76227f4f30e27dcd00e6b0d815370b7c
Author: Adam Kwolek <adam.kwolek@intel.com>
Date:   Fri Dec 3 15:00:16 2010 +1100

    Grow: open backup file for reshape as function
    
    Move opening backup file to the function for future reuse during
    container reshape.
    
    Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Grow.c b/Grow.c
index 6e88d6d..c408a92 100644
--- a/Grow.c
+++ b/Grow.c
@@ -914,6 +914,61 @@ release:
 	return d;
 }
 
+int reshape_open_backup_file(char *backup_file,
+			     int fd,
+			     char *devname,
+			     long blocks,
+			     int *fdlist,
+			     unsigned long long *offsets)
+{
+	/* Return 1 on success, 0 on any form of failure */
+	/* need to check backup file is large enough */
+	char buf[512];
+	struct stat stb;
+	unsigned int dev;
+	int i;
+
+	*fdlist = open(backup_file, O_RDWR|O_CREAT|O_EXCL,
+		       S_IRUSR | S_IWUSR);
+	*offsets = 8 * 512;
+	if (*fdlist < 0) {
+		fprintf(stderr, Name ": %s: cannot create backup file %s: %s\n",
+			devname, backup_file, strerror(errno));
+		return 0;
+	}
+	/* Guard against backup file being on array device.
+	 * If array is partitioned or if LVM etc is in the
+	 * way this will not notice, but it is better than
+	 * nothing.
+	 */
+	fstat(*fdlist, &stb);
+	dev = stb.st_dev;
+	fstat(fd, &stb);
+	if (stb.st_rdev == dev) {
+		fprintf(stderr, Name ": backup file must NOT be"
+			" on the array being reshaped.\n");
+		close(*fdlist);
+		return 0;
+	}
+
+	memset(buf, 0, 512);
+	for (i=0; i < blocks + 1 ; i++) {
+		if (write(*fdlist, buf, 512) != 512) {
+			fprintf(stderr, Name ": %s: cannot create"
+				" backup file %s: %s\n",
+				devname, backup_file, strerror(errno));
+			return 0;
+		}
+	}
+	if (fsync(*fdlist) != 0) {
+		fprintf(stderr, Name ": %s: cannot create backup file %s: %s\n",
+			devname, backup_file, strerror(errno));
+		return 0;
+	}
+
+	return 1;
+}
+
 unsigned long compute_backup_blocks(int nchunk, int ochunk,
 				    unsigned int ndata, unsigned int odata)
 {
@@ -974,7 +1029,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 	char alt_layout[40];
 	int *fdlist;
 	unsigned long long *offsets;
-	int d, i;
+	int d;
 	int nrdisks;
 	int err;
 	int frozen;
@@ -1649,47 +1704,9 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
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
+			if (!reshape_open_backup_file(backup_file, fd, devname,
+						      (signed)blocks,
+						      fdlist+d, offsets+d)) {
 				rv = 1;
 				break;
 			}
diff --git a/mdadm.h b/mdadm.h
index a0126eb..175d228 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -486,7 +486,12 @@ extern int reshape_prepare_fdlist(char *devname,
 extern void reshape_free_fdlist(int *fdlist,
 				unsigned long long *offsets,
 				int size);
-
+extern int reshape_open_backup_file(char *backup,
+				    int fd,
+				    char *devname,
+				    long blocks,
+				    int *fdlist,
+				    unsigned long long *offsets);
 extern unsigned long compute_backup_blocks(int nchunk, int ochunk,
 					   unsigned int ndata, unsigned int odata);
 
