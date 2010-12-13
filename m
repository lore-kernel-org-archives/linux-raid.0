From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/16] FIX: wait_backup() sometimes hangs
Date: Mon, 13 Dec 2010 15:45:30 +0100
Message-ID: <20101213144530.4384.18368.stgit@gklab-170-024.igk.intel.com>
References: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Sometimes wait_backup() meets condition on reshape finish:
      array state    : reshape
      sync_completed : 0
this causes one more loop and hung on select() command
and there is no more changes of sync_completed.

This fix extends wait_backup()interface and for external metadata pings monitor
to speed up array state change and test already up to date state.

Other fix options:
 - would be add to select() additional watching handle for 'sync_action' to detect reshape finish.
 - or add break command on sync_completed == 0

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c        |   51 ++++++++++++++++++++++++++++++++++-----------------
 mdadm.h       |    3 ++-
 mdmon.c       |    3 ++-
 super-intel.c |    2 +-
 4 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/Grow.c b/Grow.c
index a01051f..2ca1b6f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -453,11 +453,13 @@ static __u32 bsb_csum(char *buf, int len)
 	return __cpu_to_le32(csum);
 }
 
-static int child_shrink(int afd, struct mdinfo *sra, unsigned long blocks,
+static int child_shrink(struct supertype *st,
+			int afd, struct mdinfo *sra, unsigned long blocks,
 			int *fds, unsigned long long *offsets,
 			int disks, int chunk, int level, int layout, int data,
 			int dests, int *destfd, unsigned long long *destoffsets);
-static int child_same_size(int afd, struct mdinfo *sra, unsigned long blocks,
+static int child_same_size(struct supertype *st,
+			   int afd, struct mdinfo *sra, unsigned long blocks,
 			   int *fds, unsigned long long *offsets,
 			   unsigned long long start,
 			   int disks, int chunk, int level, int layout, int data,
@@ -1910,17 +1912,17 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			mlockall(MCL_FUTURE);
 
 			if (odata < ndata)
-				done = child_grow(fd, sra, stripes,
+				done = child_grow(st, fd, sra, stripes,
 						  fdlist, offsets,
 						  odisks, ochunk, array.level, olayout, odata,
 						  d - odisks, fdlist+odisks, offsets+odisks);
 			else if (odata > ndata)
-				done = child_shrink(fd, sra, stripes,
+				done = child_shrink(st, fd, sra, stripes,
 						    fdlist, offsets,
 						    odisks, ochunk, array.level, olayout, odata,
 						    d - odisks, fdlist+odisks, offsets+odisks);
 			else
-				done = child_same_size(fd, sra, stripes,
+				done = child_same_size(st, fd, sra, stripes,
 						       fdlist, offsets,
 						       0,
 						       odisks, ochunk, array.level, olayout, odata,
@@ -2120,7 +2122,8 @@ static int grow_backup(struct mdinfo *sra,
  * every works.
  */
 /* FIXME return value is often ignored */
-static int wait_backup(struct mdinfo *sra,
+static int wait_backup(struct supertype *st,
+		struct mdinfo *sra,
 		unsigned long long offset, /* per device */
 		unsigned long long blocks, /* per device */
 		unsigned long long blocks2, /* per device - hack */
@@ -2155,6 +2158,15 @@ static int wait_backup(struct mdinfo *sra,
 			close(fd);
 			return -1;
 		}
+		if (st && st->ss->external) {
+			int container_dev = (st->container_dev != NoMdDev
+					     ? st->container_dev : st->devnum);
+			char *container = devnum2devname(container_dev);
+			if (container) {
+				ping_monitor(container);
+				free(container);
+			}
+		}
 		if (sysfs_get_str(sra, NULL, "sync_action",
 				  action, 20) > 0 &&
 		    strncmp(action, "reshape", 7) != 0)
@@ -2281,7 +2293,7 @@ static void validate(int afd, int bfd, unsigned long long offset)
 	}
 }
 
-int child_grow(int afd, struct mdinfo *sra,
+int child_grow(struct supertype *st, int afd, struct mdinfo *sra,
 	       unsigned long stripes, int *fds, unsigned long long *offsets,
 	       int disks, int chunk, int level, int layout, int data,
 	       int dests, int *destfd, unsigned long long *destoffsets)
@@ -2299,7 +2311,8 @@ int child_grow(int afd, struct mdinfo *sra,
 		    dests, destfd, destoffsets,
 		    0, &degraded, buf);
 	validate(afd, destfd[0], destoffsets[0]);
-	wait_backup(sra, 0, stripes * (chunk / 512), stripes * (chunk / 512),
+	wait_backup(st, sra, 0, stripes * (chunk / 512),
+		    stripes * (chunk / 512),
 		    dests, destfd, destoffsets,
 		    0);
 	sysfs_set_num(sra, NULL, "suspend_lo", (stripes * (chunk/512)) * data);
@@ -2309,7 +2322,8 @@ int child_grow(int afd, struct mdinfo *sra,
 	return 1;
 }
 
-static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
+static int child_shrink(struct supertype *st,
+			int afd, struct mdinfo *sra, unsigned long stripes,
 			int *fds, unsigned long long *offsets,
 			int disks, int chunk, int level, int layout, int data,
 			int dests, int *destfd, unsigned long long *destoffsets)
@@ -2326,7 +2340,8 @@ static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
 	sysfs_set_str(sra, NULL, "sync_action", "reshape");
 	sysfs_set_num(sra, NULL, "suspend_lo", 0);
 	sysfs_set_num(sra, NULL, "suspend_hi", 0);
-	rv = wait_backup(sra, 0, start - stripes * (chunk/512), stripes * (chunk/512),
+	rv = wait_backup(st, sra, 0, start - stripes * (chunk/512),
+			 stripes * (chunk/512),
 			 dests, destfd, destoffsets, 0);
 	if (rv < 0)
 		return 0;
@@ -2336,7 +2351,7 @@ static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
 		    dests, destfd, destoffsets,
 		    0, &degraded, buf);
 	validate(afd, destfd[0], destoffsets[0]);
-	wait_backup(sra, start, stripes*(chunk/512), 0,
+	wait_backup(st, sra, start, stripes*(chunk/512), 0,
 		    dests, destfd, destoffsets, 0);
 	sysfs_set_num(sra, NULL, "suspend_lo", (stripes * (chunk/512)) * data);
 	free(buf);
@@ -2345,7 +2360,7 @@ static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
 	return 1;
 }
 
-int child_same_size(int afd,
+int child_same_size(struct supertype *st, int afd,
 		    struct mdinfo *sra, unsigned long stripes,
 		    int *fds, unsigned long long *offsets,
 		    unsigned long long start,
@@ -2384,7 +2399,7 @@ int child_same_size(int afd,
 	start += stripes * 2; /* where to read next */
 	size = sra->component_size / (chunk/512);
 	while (start < size) {
-		if (wait_backup(sra, (start-stripes*2)*(chunk/512),
+		if (wait_backup(st, sra, (start-stripes*2)*(chunk/512),
 				stripes*(chunk/512), 0,
 				dests, destfd, destoffsets,
 				part) < 0)
@@ -2402,12 +2417,14 @@ int child_same_size(int afd,
 		part = 1 - part;
 		validate(afd, destfd[0], destoffsets[0]);
 	}
-	if (wait_backup(sra, (start-stripes*2) * (chunk/512), stripes * (chunk/512), 0,
+	if (wait_backup(st, sra, (start-stripes*2) * (chunk/512),
+			stripes * (chunk/512), 0,
 			dests, destfd, destoffsets,
 			part) < 0)
 		return 0;
 	sysfs_set_num(sra, NULL, "suspend_lo", ((start-stripes)*(chunk/512)) * data);
-	wait_backup(sra, (start-stripes) * (chunk/512), tailstripes * (chunk/512), 0,
+	wait_backup(st, sra, (start-stripes) * (chunk/512),
+		    tailstripes * (chunk/512), 0,
 		    dests, destfd, destoffsets,
 		    1-part);
 	sysfs_set_num(sra, NULL, "suspend_lo", (size*(chunk/512)) * data);
@@ -2829,7 +2846,7 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 		close(mdfd);
 		mlockall(MCL_FUTURE);
 		if (info->delta_disks < 0)
-			done = child_shrink(-1, info, stripes,
+			done = child_shrink(st, -1, info, stripes,
 					    fds, offsets,
 					    info->array.raid_disks,
 					    info->array.chunk_size,
@@ -2843,7 +2860,7 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 			 */
 			unsigned long long start = info->reshape_progress / ndata;
 			start /= (info->array.chunk_size/512);
-			done = child_same_size(-1, info, stripes,
+			done = child_same_size(st, -1, info, stripes,
 					       fds, offsets,
 					       start,
 					       info->array.raid_disks,
diff --git a/mdadm.h b/mdadm.h
index ceffb81..1fb1cbc 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -500,7 +500,8 @@ extern int reshape_open_backup_file(char *backup,
 extern unsigned long compute_backup_blocks(int nchunk, int ochunk,
 					   unsigned int ndata, unsigned int odata);
 extern struct mdinfo *sysfs_get_unused_spares(int container_fd, int fd);
-extern int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
+extern int child_grow(struct supertype *st,
+		      int afd, struct mdinfo *sra, unsigned long stripes,
 		      int *fds, unsigned long long *offsets,
 		      int disks, int chunk, int level, int layout, int data,
 		      int dests, int *destfd, unsigned long long *destoffsets);
diff --git a/mdmon.c b/mdmon.c
index ebadff7..85890de 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -559,7 +559,8 @@ int reshape_open_backup_file(char *backup_file,
 	return -1;
 }
 
-int child_grow(int afd, struct mdinfo *sra,
+int child_grow(struct supertype *st,
+	       int afd, struct mdinfo *sra,
 	       unsigned long stripes, int *fds, unsigned long long *offsets,
 	       int disks, int chunk, int level, int layout, int data,
 	       int dests, int *destfd, unsigned long long *destoffsets)
diff --git a/super-intel.c b/super-intel.c
index bee28bc..0896f1d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7893,7 +7893,7 @@ int imsm_child_grow(struct supertype *st,
 		sra->new_chunk = sra->array.chunk_size;
 
 		stripes = blocks / (sra->array.chunk_size/512) / odata;
-		child_grow(validate_fd, sra, stripes,
+		child_grow(st, validate_fd, sra, stripes,
 			fdlist, offsets,
 			odisks, sra->array.chunk_size,
 			sra->array.level, sra->array.layout, odata,

