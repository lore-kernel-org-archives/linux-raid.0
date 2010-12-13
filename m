From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/16] mdadm: support restore_stripes() from the given buffer
Date: Mon, 13 Dec 2010 15:46:16 +0100
Message-ID: <20101213144616.4384.73070.stgit@gklab-170-024.igk.intel.com>
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

Currently restore_stripes() function is able to restore data only from the given backup file handles and it is used only for assembling partially reshaped arrays.
As this function will be very helpful for external metadata backup mechanism, add the support for restoring data from the given source buffer.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c        |    4 ++--
 mdadm.h       |    3 ++-
 restripe.c    |   49 +++++++++++++++++++++++++++++++------------------
 super-intel.c |    2 +-
 4 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/Grow.c b/Grow.c
index 2ca1b6f..9fbdd0e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2621,7 +2621,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 				    info->new_layout,
 				    fd, __le64_to_cpu(bsb.devstart)*512,
 				    __le64_to_cpu(bsb.arraystart)*512,
-				    __le64_to_cpu(bsb.length)*512)) {
+				    __le64_to_cpu(bsb.length)*512, NULL)) {
 			/* didn't succeed, so giveup */
 			if (verbose)
 				fprintf(stderr, Name ": Error restoring backup from %s\n",
@@ -2638,7 +2638,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 				    fd, __le64_to_cpu(bsb.devstart)*512 +
 				    __le64_to_cpu(bsb.devstart2)*512,
 				    __le64_to_cpu(bsb.arraystart2)*512,
-				    __le64_to_cpu(bsb.length2)*512)) {
+				    __le64_to_cpu(bsb.length2)*512, NULL)) {
 			/* didn't succeed, so giveup */
 			if (verbose)
 				fprintf(stderr, Name ": Error restoring second backup from %s\n",
diff --git a/mdadm.h b/mdadm.h
index 8229b66..45c6b3c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -515,7 +515,8 @@ extern int save_stripes(int *source, unsigned long long *offsets,
 extern int restore_stripes(int *dest, unsigned long long *offsets,
 			   int raid_disks, int chunk_size, int level, int layout,
 			   int source, unsigned long long read_offset,
-			   unsigned long long start, unsigned long long length);
+			   unsigned long long start, unsigned long long length,
+			   char *src_buf);
 
 #ifndef Sendmail
 #define Sendmail "/usr/lib/sendmail -t"
diff --git a/restripe.c b/restripe.c
index d33dbba..066eafd 100644
--- a/restripe.c
+++ b/restripe.c
@@ -536,11 +536,10 @@ int save_stripes(int *source, unsigned long long *offsets,
 						  fdisk[0], fdisk[1], bufs);
 			}
 		}
-
-		for (i=0; i<nwrites; i++)
-			if (write(dest[i], buf, len) != len)
-				return -1;
-
+		if (dest)
+			for (i = 0; i < nwrites; i++)
+				if (write(dest[i], buf, len) != len)
+					return -1;
 		length -= len;
 		start += len;
 	}
@@ -561,7 +560,8 @@ int save_stripes(int *source, unsigned long long *offsets,
 int restore_stripes(int *dest, unsigned long long *offsets,
 		    int raid_disks, int chunk_size, int level, int layout,
 		    int source, unsigned long long read_offset,
-		    unsigned long long start, unsigned long long length)
+		    unsigned long long start, unsigned long long length,
+		    char *src_buf)
 {
 	char *stripe_buf;
 	char **stripes = malloc(raid_disks * sizeof(char*));
@@ -579,13 +579,17 @@ int restore_stripes(int *dest, unsigned long long *offsets,
 	}
 	if (stripe_buf == NULL || stripes == NULL || blocks == NULL
 	    || zero == NULL) {
-		free(stripe_buf);
-		free(stripes);
-		free(blocks);
-		free(zero);
+		if (stripe_buf != NULL)
+			free(stripe_buf);
+		if (stripes != NULL)
+			free(stripes);
+		if (blocks != NULL)
+			free(blocks);
+		if (zero != NULL)
+			free(zero);
 		return -2;
 	}
-	for (i=0; i<raid_disks; i++)
+	for (i = 0; i < raid_disks; i++)
 		stripes[i] = stripe_buf + i * chunk_size;
 	while (length > 0) {
 		unsigned int len = data_disks * chunk_size;
@@ -594,15 +598,24 @@ int restore_stripes(int *dest, unsigned long long *offsets,
 		int syndrome_disks;
 		if (length < len)
 			return -3;
-		for (i=0; i < data_disks; i++) {
+		for (i = 0; i < data_disks; i++) {
 			int disk = geo_map(i, start/chunk_size/data_disks,
 					   raid_disks, level, layout);
-			if ((unsigned long long)lseek64(source, read_offset, 0)
-			    != read_offset)
-				return -1;
-			if (read(source, stripes[disk],
-						     chunk_size) != chunk_size)
-				return -1;
+			if (src_buf == NULL) {
+				/* read from file */
+				if (lseek64(source,
+					read_offset, 0) != (off64_t)read_offset)
+					return -1;
+				if (read(source,
+					 stripes[disk],
+					 chunk_size) != chunk_size)
+					return -1;
+			} else {
+				/* read from input buffer */
+				memcpy(stripes[disk],
+				       src_buf + read_offset,
+				       chunk_size);
+			}
 			read_offset += chunk_size;
 		}
 		/* We have the data, now do the parity */
diff --git a/super-intel.c b/super-intel.c
index 82371d5..349e583 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1656,7 +1656,7 @@ static int write_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 	int retval = -1;
 
 	for (sd = info->devs ; sd ; sd = sd->next) {
-		/* read only from one of the first two slots */
+		/* write only to the first two slots */
 		if (sd->disk.raid_disk > 1)
 			continue;
 		sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);

