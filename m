From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 27/31] mdadm: support restore_stripes() from the given buffer
Date: Tue, 9 Nov 2010 17:01:26 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CAAB@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Currently restore_stripes() function is able to restore data only from the given backup file handles and it is used only for assembling partially reshaped arrays.
As this function will be very helpful for external metadata backup mechanism, add the support for restoring data from the given source buffer.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Grow.c     |    4 ++--
 mdadm/mdadm/mdadm.h    |    3 ++-
 mdadm/mdadm/restripe.c |   44 ++++++++++++++++++++++++++------------------
 3 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/mdadm/mdadm/Grow.c b/mdadm/mdadm/Grow.c index a0d91e1..e4bdc95 100644
--- a/mdadm/mdadm/Grow.c
+++ b/mdadm/mdadm/Grow.c
@@ -2403,7 +2403,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 				    info->new_layout,
 				    fd, __le64_to_cpu(bsb.devstart)*512,
 				    __le64_to_cpu(bsb.arraystart)*512,
-				    __le64_to_cpu(bsb.length)*512)) {
+				    __le64_to_cpu(bsb.length)*512, NULL)) {
 			/* didn't succeed, so giveup */
 			if (verbose)
 				fprintf(stderr, Name ": Error restoring backup from %s\n", @@ -2420,7 +2420,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 				    fd, __le64_to_cpu(bsb.devstart)*512 +
 				    __le64_to_cpu(bsb.devstart2)*512,
 				    __le64_to_cpu(bsb.arraystart2)*512,
-				    __le64_to_cpu(bsb.length2)*512)) {
+				    __le64_to_cpu(bsb.length2)*512, NULL)) {
 			/* didn't succeed, so giveup */
 			if (verbose)
 				fprintf(stderr, Name ": Error restoring second backup from %s\n", diff --git a/mdadm/mdadm/mdadm.h b/mdadm/mdadm/mdadm.h index b46b90e..4eed084 100644
--- a/mdadm/mdadm/mdadm.h
+++ b/mdadm/mdadm/mdadm.h
@@ -479,7 +479,8 @@ extern int save_stripes(int *source, unsigned long long *offsets,  extern int restore_stripes(int *dest, unsigned long long *offsets,
 			   int raid_disks, int chunk_size, int level, int layout,
 			   int source, unsigned long long read_offset,
-			   unsigned long long start, unsigned long long length);
+			   unsigned long long start, unsigned long long length,
+			   char *src_buf);
 
 
 #ifndef Sendmail
diff --git a/mdadm/mdadm/restripe.c b/mdadm/mdadm/restripe.c index c2fbe5b..7add7ce 100644
--- a/mdadm/mdadm/restripe.c
+++ b/mdadm/mdadm/restripe.c
@@ -533,11 +533,10 @@ int save_stripes(int *source, unsigned long long *offsets,
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
@@ -558,7 +557,8 @@ int save_stripes(int *source, unsigned long long *offsets,  int restore_stripes(int *dest, unsigned long long *offsets,
 		    int raid_disks, int chunk_size, int level, int layout,
 		    int source, unsigned long long read_offset,
-		    unsigned long long start, unsigned long long length)
+		    unsigned long long start, unsigned long long length,
+		    char *src_buf)
 {
 	char *stripe_buf;
 	char **stripes = malloc(raid_disks * sizeof(char*)); @@ -576,13 +576,17 @@ int restore_stripes(int *dest, unsigned long long *offsets,
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
 		unsigned int len = data_disks * chunk_size; @@ -591,15 +595,19 @@ int restore_stripes(int *dest, unsigned long long *offsets,
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
+				if (lseek64(source, read_offset, 0) != (off64_t)read_offset)
+					return -1;
+				if (read(source, stripes[disk], chunk_size) != chunk_size)
+					return -1;
+			} else {
+				/* read from input buffer */
+				memcpy(stripes[disk], src_buf + read_offset, chunk_size);
+			}
 			read_offset += chunk_size;
 		}
 		/* We have the data, now do the parity */

