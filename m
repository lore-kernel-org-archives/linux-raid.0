From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] Fix serious memory leak
Date: Fri, 16 Sep 2011 13:19:14 +0200
Message-ID: <20110916111913.20840.13403.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

During reshape function restore_stripes is called periodically
and every time the buffer stripe_buf (of size raid_disks*chunk_size)
is allocated but is not freed. It happens also upon successful completion.
In case of huge arrays it can lead to the seizure of the entire
system memory (even of the order of gigabytes).

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 restripe.c |   43 +++++++++++++++++++++++++++++++------------
 1 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/restripe.c b/restripe.c
index 9c83e2e..7cabbd0 100644
--- a/restripe.c
+++ b/restripe.c
@@ -687,6 +687,7 @@ int restore_stripes(int *dest, unsigned long long *offsets,
 	char **stripes = malloc(raid_disks * sizeof(char*));
 	char **blocks = malloc(raid_disks * sizeof(char*));
 	int i;
+	int rv = 0;
 
 	int data_disks = raid_disks - (level == 0 ? 0 : level <= 5 ? 1 : 2);
 
@@ -717,20 +718,26 @@ int restore_stripes(int *dest, unsigned long long *offsets,
 		unsigned long long offset;
 		int disk, qdisk;
 		int syndrome_disks;
-		if (length < len)
-			return -3;
+		if (length < len) {
+			rv = -3;
+			goto abort;
+		}
 		for (i = 0; i < data_disks; i++) {
 			int disk = geo_map(i, start/chunk_size/data_disks,
 					   raid_disks, level, layout);
 			if (src_buf == NULL) {
 				/* read from file */
-				if (lseek64(source,
-					read_offset, 0) != (off64_t)read_offset)
-					return -1;
+				if (lseek64(source, read_offset, 0) !=
+					 (off64_t)read_offset) {
+					rv = -1;
+					goto abort;
+				}
 				if (read(source,
 					 stripes[disk],
-					 chunk_size) != chunk_size)
-					return -1;
+					 chunk_size) != chunk_size) {
+					rv = -1;
+					goto abort;
+				}
 			} else {
 				/* read from input buffer */
 				memcpy(stripes[disk],
@@ -782,15 +789,27 @@ int restore_stripes(int *dest, unsigned long long *offsets,
 		}
 		for (i=0; i < raid_disks ; i++)
 			if (dest[i] >= 0) {
-				if (lseek64(dest[i], offsets[i]+offset, 0) < 0)
-					return -1;
-				if (write(dest[i], stripes[i], chunk_size) != chunk_size)
-					return -1;
+				if (lseek64(dest[i],
+					 offsets[i]+offset, 0) < 0) {
+					rv = -1;
+					goto abort;
+				}
+				if (write(dest[i], stripes[i],
+					 chunk_size) != chunk_size) {
+					rv = -1;
+					goto abort;
+				}
 			}
 		length -= len;
 		start += len;
 	}
-	return 0;
+	rv = 0;
+
+abort:
+	free(stripe_buf);
+	free(stripes);
+	free(blocks);
+	return rv;
 }
 
 #ifdef MAIN

