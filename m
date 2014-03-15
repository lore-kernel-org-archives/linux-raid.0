From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [PATCH] raid6check.c: move autorepair code to separate function
Date: Sat, 15 Mar 2014 17:56:22 +0100
Message-ID: <20140315165622.GA21514@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch cleans up a bit the code by moving
the autorepair part into a separate function.

Signed off: piergiorgio.sartor@nexgo.de
diff -uNpr a/raid6check.c b/raid6check.c
--- a/raid6check.c	2014-03-15 17:52:00.199639092 +0100
+++ b/raid6check.c	2014-03-15 17:50:57.920815973 +0100
@@ -156,6 +156,64 @@ int unlock_all_stripes(struct mdinfo *in
 	return rv * 256;
 }
 
+/* Autorepair */
+int autorepair(int *disk, int diskP, int diskQ, unsigned long long start, int chunk_size,
+		char *name[], int raid_disks, int data_disks, char **blocks_page,
+		char **blocks, uint8_t *p, char **stripes, int *block_index_for_slot,
+		int *source, unsigned long long *offsets)
+{
+	int i, j;
+	int pages_to_write_count = 0;
+	int page_to_write[chunk_size >> CHECK_PAGE_BITS];
+	for(j = 0; j < (chunk_size >> CHECK_PAGE_BITS); j++) {
+		if (disk[j] >= 0) {
+			printf("Auto-repairing slot %d (%s)\n", disk[j], name[disk[j]]);
+			pages_to_write_count++;
+			page_to_write[j] = 1;
+			for(i = 0; i < raid_disks; i++) {
+				blocks_page[i] = blocks[i] + j * CHECK_PAGE_SIZE;
+			}
+			if (disk[j] == diskQ) {
+				qsyndrome(p, (uint8_t*)stripes[diskQ] + j * CHECK_PAGE_SIZE, (uint8_t**)blocks_page, data_disks, CHECK_PAGE_SIZE);
+			}
+			else {
+				char *all_but_failed_blocks[data_disks];
+				int failed_block_index = block_index_for_slot[disk[j]];
+				for(i = 0; i < data_disks; i++) {
+					if (failed_block_index == i) {
+						all_but_failed_blocks[i] = stripes[diskP] + j * CHECK_PAGE_SIZE;
+					}
+					else {
+						all_but_failed_blocks[i] = blocks_page[i];
+					}
+				}
+				xor_blocks(stripes[disk[j]] + j * CHECK_PAGE_SIZE,
+				all_but_failed_blocks, data_disks, CHECK_PAGE_SIZE);
+			}
+		}
+		else {
+			page_to_write[j] = 0;
+		}
+	}
+
+	if(pages_to_write_count > 0) {
+		int write_res = 0;
+		for(j = 0; j < (chunk_size >> CHECK_PAGE_BITS); j++) {
+			if(page_to_write[j] == 1) {
+				lseek64(source[disk[j]], offsets[disk[j]] + start * chunk_size + j * CHECK_PAGE_SIZE, SEEK_SET);
+				write_res += write(source[disk[j]], stripes[disk[j]] + j * CHECK_PAGE_SIZE, CHECK_PAGE_SIZE);
+			}
+		}
+
+		if (write_res != (CHECK_PAGE_SIZE * pages_to_write_count)) {
+			fprintf(stderr, "Failed to write a full chunk.\n");
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
 int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 		  int raid_disks, int chunk_size, int level, int layout,
 		  unsigned long long start, unsigned long long length, char *name[],
@@ -243,55 +301,13 @@ int check_stripes(struct mdinfo *info, i
 		}
 
 		if(repair == AUTO_REPAIR) {
-			int pages_to_write_count = 0;
-			int page_to_write[chunk_size >> CHECK_PAGE_BITS];
-			for(j = 0; j < (chunk_size >> CHECK_PAGE_BITS); j++) {
-				if (disk[j] >= 0) {
-					printf("Auto-repairing slot %d (%s)\n", disk[j], name[disk[j]]);
-					pages_to_write_count++;
-					page_to_write[j] = 1;
-					for(i = 0; i < raid_disks; i++) {
-						blocks_page[i] = blocks[i] + j * CHECK_PAGE_SIZE;
-					}
-					if (disk[j] == diskQ) {
-						qsyndrome(p, (uint8_t*)stripes[diskQ] + j * CHECK_PAGE_SIZE, (uint8_t**)blocks_page, data_disks, CHECK_PAGE_SIZE);
-					}
-					else {
-						char *all_but_failed_blocks[data_disks];
-						int failed_block_index = block_index_for_slot[disk[j]];
-						for (i = 0; i < data_disks; i++) {
-							if (failed_block_index == i) {
-								all_but_failed_blocks[i] = stripes[diskP] + j * CHECK_PAGE_SIZE;
-							}
-							else {
-								all_but_failed_blocks[i] = blocks_page[i];
-							}
-						}
-						xor_blocks(stripes[disk[j]] + j * CHECK_PAGE_SIZE,
-						all_but_failed_blocks, data_disks, CHECK_PAGE_SIZE);
-					}
-				}
-				else {
-					page_to_write[j] = 0;
-				}
-			}
-
-			if(pages_to_write_count > 0) {
-
-				int write_res = 0;
-				for(j = 0; j < (chunk_size >> CHECK_PAGE_BITS); j++) {
-					if(page_to_write[j] == 1) {
-						lseek64(source[disk[j]], offsets[disk[j]] + start * chunk_size + j * CHECK_PAGE_SIZE, SEEK_SET);
-						write_res += write(source[disk[j]], stripes[disk[j]] + j * CHECK_PAGE_SIZE, CHECK_PAGE_SIZE);
-					}
-				}
-
-				if (write_res != (CHECK_PAGE_SIZE * pages_to_write_count)) {
-					fprintf(stderr, "Failed to write a full chunk.\n");
-					unlock_all_stripes(info, sig);
-					err = -1;
-					goto exitCheck;
-				}
+			err = autorepair(disk, diskP, diskQ, start, chunk_size,
+					name, raid_disks, data_disks, blocks_page,
+					blocks, p, stripes, block_index_for_slot,
+					source, offsets);
+			if(err != 0) {
+				unlock_all_stripes(info, sig);
+				goto exitCheck;
 			}
 		}
 

-- 

piergiorgio
