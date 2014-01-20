From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH] raid6check.c add page size check and repair
Date: Mon, 20 Jan 2014 20:10:22 +0100
Message-ID: <20140120191022.GA8006@lazy.lzy>
References: <20140118181823.GA15757@lazy.lzy>
 <52DD4ABD.5060605@itwm.fraunhofer.de>
 <20140120182223.GA4871@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140120182223.GA4871@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

I'm polluting the mailing list now... Sorry!

I found a couple of really stupid bugs, so this
re-re-patch should fix them.

Sorry for the noise.

--- --- --

Binary files a/dlink.o and b/dlink.o differ
Binary files a/lib.o and b/lib.o differ
Binary files a/maps.o and b/maps.o differ
Binary files a/raid6check and b/raid6check differ
diff -uNrp a/raid6check.c b/raid6check.c
--- a/raid6check.c	2013-09-03 06:47:47.000000000 +0200
+++ b/raid6check.c	2014-01-20 19:48:10.435721613 +0100
@@ -27,6 +27,9 @@
 #include <signal.h>
 #include <sys/mman.h>
 
+#define CHECK_PAGE_BITS (12)
+#define CHECK_PAGE_SIZE (1 << CHECK_PAGE_BITS)
+
 enum repair {
 	NO_REPAIR = 0,
 	MANUAL_REPAIR,
@@ -73,15 +76,15 @@ void raid6_collect(int chunk_size, uint8
 	}
 }
 
-/* Try to find out if a specific disk has problems */
-int raid6_stats(int *results, int raid_disks, int chunk_size)
+/* Try to find out if a specific disk has problems in a CHECK_PAGE_SIZE page size */
+int raid6_stats_blk(int *results, int raid_disks)
 {
 	int i;
 	int curr_broken_disk = -255;
 	int prev_broken_disk = -255;
 	int broken_status = 0;
 
-	for(i = 0; i < chunk_size; i++) {
+	for(i = 0; i < CHECK_PAGE_SIZE; i++) {
 
 		if(results[i] != -255)
 			curr_broken_disk = results[i];
@@ -112,6 +115,16 @@ int raid6_stats(int *results, int raid_d
 	return curr_broken_disk;
 }
 
+/* Collect disks status for a strip in CHECK_PAGE_SIZE page size blocks */
+void raid6_stats(int *disk, int *results, int raid_disks, int chunk_size)
+{
+	int i, j;
+
+	for(i = 0, j = 0; i < chunk_size; i += CHECK_PAGE_SIZE, j++) {
+		disk[j] = raid6_stats_blk(&results[i], raid_disks);
+	}
+}
+
 int lock_stripe(struct mdinfo *info, unsigned long long start,
 		int chunk_size, int data_disks, sighandler_t *sig) {
 	int rv;
@@ -152,13 +165,14 @@ int check_stripes(struct mdinfo *info, i
 	char *stripe_buf = xmalloc(raid_disks * chunk_size);
 	char **stripes = xmalloc(raid_disks * sizeof(char*));
 	char **blocks = xmalloc(raid_disks * sizeof(char*));
+	char **blocks_page = xmalloc(raid_disks * sizeof(char*));
 	int *block_index_for_slot = xmalloc(raid_disks * sizeof(int));
 	uint8_t *p = xmalloc(chunk_size);
 	uint8_t *q = xmalloc(chunk_size);
 	int *results = xmalloc(chunk_size * sizeof(int));
 	sighandler_t *sig = xmalloc(3 * sizeof(sighandler_t));
 
-	int i;
+	int i, j;
 	int diskP, diskQ;
 	int data_disks = raid_disks - 2;
 	int err = 0;
@@ -172,7 +186,7 @@ int check_stripes(struct mdinfo *info, i
 		stripes[i] = stripe_buf + i * chunk_size;
 
 	while (length > 0) {
-		int disk;
+		int disk[chunk_size >> CHECK_PAGE_BITS];
 
 		printf("pos --> %llu\n", start);
 
@@ -217,26 +231,31 @@ int check_stripes(struct mdinfo *info, i
 		block_index_for_slot[diskP] = data_disks;
 		blocks[data_disks+1] = stripes[diskQ];
 		block_index_for_slot[diskQ] = data_disks+1;
-
+/* Do we really need the code below? */
+#if 0
 		if (memcmp(p, stripes[diskP], chunk_size) != 0) {
 			printf("P(%d) wrong at %llu\n", diskP, start);
 		}
 		if (memcmp(q, stripes[diskQ], chunk_size) != 0) {
 			printf("Q(%d) wrong at %llu\n", diskQ, start);
 		}
+#endif
 		raid6_collect(chunk_size, p, q, stripes[diskP], stripes[diskQ], results);
-		disk = raid6_stats(results, raid_disks, chunk_size);
+		raid6_stats(disk, results, raid_disks, chunk_size);
 
-		if(disk >= -2) {
-			disk = geo_map(disk, start, raid_disks, level, layout);
-		}
-		if(disk >= 0) {
-			printf("Error detected at %llu: possible failed disk slot: %d --> %s\n",
-				start, disk, name[disk]);
-		}
-		if(disk == -65535) {
-			printf("Error detected at %llu: disk slot unknown\n", start);
+		for(j = 0; j < (chunk_size >> CHECK_PAGE_BITS); j++) {
+			if(disk[j] >= -2) {
+				disk[j] = geo_map(disk[j], start, raid_disks, level, layout);
+			}
+			if(disk[j] >= 0) {
+				printf("Error detected at %llu, page %d: possible failed disk slot: %d --> %s\n",
+					start, j, disk[j], name[disk[j]]);
+			}
+			if(disk[j] == -65535) {
+				printf("Error detected at %llu, page %d: disk slot unknown\n", start, j);
+			}
 		}
+
 		if(repair == MANUAL_REPAIR) {
 			printf("Repairing stripe %llu\n", start);
 			printf("Assuming slots %d (%s) and %d (%s) are incorrect\n",
@@ -325,21 +344,37 @@ int check_stripes(struct mdinfo *info, i
 				goto exitCheck;
 			}
 
-		} else if (disk >= 0 && repair == AUTO_REPAIR) {
-			printf("Auto-repairing slot %d (%s)\n", disk, name[disk]);
-			if (disk == diskQ) {
-				qsyndrome(p, (uint8_t*)stripes[diskQ], (uint8_t**)blocks, data_disks, chunk_size);
+		}
+
+		int pages_to_write_count = 0;
+		int page_to_write[chunk_size >> CHECK_PAGE_BITS];
+		for(j = 0; j < (chunk_size >> CHECK_PAGE_BITS); j++) {
+			if (disk[j] >= 0 && repair == AUTO_REPAIR) {
+				printf("Auto-repairing slot %d (%s)\n", disk[j], name[disk[j]]);
+				pages_to_write_count++;
+				page_to_write[j] = 1;
+				for(i = 0; i < raid_disks; i++) {
+					blocks_page[i] = blocks[i] + j * CHECK_PAGE_SIZE;
+				}
+				if (disk[j] == diskQ) {
+					qsyndrome(p, (uint8_t*)stripes[diskQ], (uint8_t**)blocks_page, data_disks, CHECK_PAGE_SIZE);
+				} else {
+					char *all_but_failed_blocks[data_disks];
+					int failed_block_index = block_index_for_slot[disk[j]];
+					for (i=0; i < data_disks; i++)
+						if (failed_block_index == i)
+							all_but_failed_blocks[i] = stripes[diskP] + j * CHECK_PAGE_SIZE;
+						else
+							all_but_failed_blocks[i] = blocks_page[i];
+					xor_blocks(stripes[disk[j]] + j * CHECK_PAGE_SIZE,
+					all_but_failed_blocks, data_disks, CHECK_PAGE_SIZE);
+				}
 			} else {
-				char *all_but_failed_blocks[data_disks];
-				int failed_block_index = block_index_for_slot[disk];
-				for (i=0; i < data_disks; i++)
-					if (failed_block_index == i)
-						all_but_failed_blocks[i] = stripes[diskP];
-					else
-						all_but_failed_blocks[i] = blocks[i];
-				xor_blocks(stripes[disk],
-					all_but_failed_blocks, data_disks, chunk_size);
+				page_to_write[j] = 0;
 			}
+		}
+
+		if(pages_to_write_count > 0) {
 
 			err = lock_stripe(info, start, chunk_size, data_disks, sig);
 			if(err != 0) {
@@ -348,14 +383,19 @@ int check_stripes(struct mdinfo *info, i
 				goto exitCheck;
 			}
 
-			lseek64(source[disk], offsets[disk] + start * chunk_size, 0);
-			int write_res = write(source[disk], stripes[disk], chunk_size);
+			int write_res = 0;
+			for(j = 0; j < (chunk_size >> CHECK_PAGE_BITS); j++) {
+				if(page_to_write[j] == 1) {
+					lseek64(source[disk[j]], offsets[disk[j]] + start * chunk_size + j * CHECK_PAGE_SIZE, 0);
+					write_res += write(source[disk[j]], stripes[disk[j]] + j * CHECK_PAGE_SIZE, CHECK_PAGE_SIZE);
+				}
+			}
 
 			err = unlock_all_stripes(info, sig);
-			if(err != 0 || write_res != chunk_size)
+			if (err != 0 || write_res != (CHECK_PAGE_SIZE * pages_to_write_count))
 				goto exitCheck;
 
-			if (write_res != chunk_size) {
+			if (write_res != (CHECK_PAGE_SIZE * pages_to_write_count)) {
 				fprintf(stderr, "Failed to write a full chunk.\n");
 				goto exitCheck;
 			}
@@ -370,6 +410,7 @@ exitCheck:
 	free(stripe_buf);
 	free(stripes);
 	free(blocks);
+	free(blocks_page);
 	free(block_index_for_slot);
 	free(p);
 	free(q);



-- 

piergiorgio
