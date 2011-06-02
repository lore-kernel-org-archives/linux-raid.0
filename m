From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 02/22] Support restore_stripes() from the given buffer
Date: Thu, 02 Jun 2011 16:48:26 +0200
Message-ID: <20110602144826.27355.78387.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

For external metadata backup location and saving methods depends
on metadata specific implementation details. Currently restore_stripes()
function is able to restore data only from the given backup file handles
and it is used only for assembling partially reshaped arrays.
As this function will be very helpful for external metadata backup
mechanism, add the support for restoring data from the given source buffer.
Add possibility for save_stripes() to work without designation targets.
Save_stripes() can now prepare data for restore_stripes() only.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Grow.c     |    4 +-
 mdadm.h    |    3 +-
 restripe.c |  101 +++++++++++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 77 insertions(+), 31 deletions(-)

diff --git a/Grow.c b/Grow.c
index 62622bd..7a8ffdb 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3380,7 +3380,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 				    info->new_layout,
 				    fd, __le64_to_cpu(bsb.devstart)*512,
 				    __le64_to_cpu(bsb.arraystart)*512,
-				    __le64_to_cpu(bsb.length)*512)) {
+				    __le64_to_cpu(bsb.length)*512, NULL)) {
 			/* didn't succeed, so giveup */
 			if (verbose)
 				fprintf(stderr, Name ": Error restoring backup from %s\n",
@@ -3397,7 +3397,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 				    fd, __le64_to_cpu(bsb.devstart)*512 +
 				    __le64_to_cpu(bsb.devstart2)*512,
 				    __le64_to_cpu(bsb.arraystart2)*512,
-				    __le64_to_cpu(bsb.length2)*512)) {
+				    __le64_to_cpu(bsb.length2)*512, NULL)) {
 			/* didn't succeed, so giveup */
 			if (verbose)
 				fprintf(stderr, Name ": Error restoring second backup from %s\n",
diff --git a/mdadm.h b/mdadm.h
index 9437d04..e97cab0 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -507,7 +507,8 @@ extern int save_stripes(int *source, unsigned long long *offsets,
 extern int restore_stripes(int *dest, unsigned long long *offsets,
 			   int raid_disks, int chunk_size, int level, int layout,
 			   int source, unsigned long long read_offset,
-			   unsigned long long start, unsigned long long length);
+			   unsigned long long start, unsigned long long length,
+			   char *src_buf);
 
 #ifndef Sendmail
 #define Sendmail "/usr/lib/sendmail -t"
diff --git a/restripe.c b/restripe.c
index 63a2a64..648fe78 100644
--- a/restripe.c
+++ b/restripe.c
@@ -467,16 +467,35 @@ int raid6_check_disks(int data_disks, int start, int chunk_size,
 	return curr_broken_disk;
 }
 
-/* Save data:
- * We are given:
- *  A list of 'fds' of the active disks.  Some may be absent.
- *  A geometry: raid_disks, chunk_size, level, layout
- *  A list of 'fds' for mirrored targets.  They are already seeked to
- *    right (Write) location
- *  A start and length which must be stripe-aligned
- *  'buf' is large enough to hold one stripe, and is aligned
- */
-
+/*******************************************************************************
+ * Function:	save_stripes
+ * Description:
+ *	Function reads data (only data without P and Q) from array and writes
+ * it to buf and opcjonaly to backup files
+ * Parameters:
+ *	source		: A list of 'fds' of the active disks.
+ *			  Some may be absent
+ *	offsets		: A list of offsets on disk belonging
+ *			 to the array [bytes]
+ *	raid_disks	: geometry: number of disks in the array
+ *	chunk_size	: geometry: chunk size [bytes]
+ *	level		: geometry: RAID level
+ *	layout		: geometry: layout
+ *	nwrites		: number of backup files
+ *	dest		: A list of 'fds' for mirrored targets
+ *			  (e.g. backup files). They are already seeked to right
+ *			  (write) location. If NULL, data will be wrote
+ *			  to the buf only
+ *	start		: start address of data to read (must be stripe-aligned)
+ *			  [bytes]
+ *	length	-	: length of data to read (must be stripe-aligned)
+ *			  [bytes]
+ *	buf		: buffer for data. It is large enough to hold
+ *			  one stripe. It is stripe aligned
+ * Returns:
+ *	 0 : success
+ *	-1 : fail
+ ******************************************************************************/
 int save_stripes(int *source, unsigned long long *offsets,
 		 int raid_disks, int chunk_size, int level, int layout,
 		 int nwrites, int *dest,
@@ -487,6 +506,7 @@ int save_stripes(int *source, unsigned long long *offsets,
 	int data_disks = raid_disks - (level == 0 ? 0 : level <=5 ? 1 : 2);
 	int disk;
 	int i;
+	unsigned long long length_test;
 
 	if (!tables_ready)
 		make_tables();
@@ -501,6 +521,18 @@ int save_stripes(int *source, unsigned long long *offsets,
 	}
 
 	len = data_disks * chunk_size;
+	length_test = length / len;
+	length_test *= len;
+
+	if (length != length_test) {
+		dprintf("Error: save_stripes(): Data are not alligned. EXIT\n");
+		dprintf("\tArea for saving stripes (length) = %llu\n", length);
+		dprintf("\tWork step (len)                  = %i\n", len);
+		dprintf("\tExpected save area (length_test) = %llu\n",
+			length_test);
+		abort();
+	}
+
 	while (length > 0) {
 		int failed = 0;
 		int fdisk[3], fblock[3];
@@ -620,11 +652,10 @@ int save_stripes(int *source, unsigned long long *offsets,
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
@@ -645,7 +676,8 @@ int save_stripes(int *source, unsigned long long *offsets,
 int restore_stripes(int *dest, unsigned long long *offsets,
 		    int raid_disks, int chunk_size, int level, int layout,
 		    int source, unsigned long long read_offset,
-		    unsigned long long start, unsigned long long length)
+		    unsigned long long start, unsigned long long length,
+		    char *src_buf)
 {
 	char *stripe_buf;
 	char **stripes = malloc(raid_disks * sizeof(char*));
@@ -668,13 +700,17 @@ int restore_stripes(int *dest, unsigned long long *offsets,
 
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
@@ -683,15 +719,24 @@ int restore_stripes(int *dest, unsigned long long *offsets,
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

