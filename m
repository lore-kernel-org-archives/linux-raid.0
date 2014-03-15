From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [PATCH] raid6check.c: lock the stripe until necessary
Date: Sat, 15 Mar 2014 16:37:52 +0100
Message-ID: <20140315153751.GA14938@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The stripe locking mechanism must be atomic between
the check and the, potential, autorepair.
For this reason, the autorepair code needs to be just
after the check and both parts (check and autorepair)
must be excuted under stripe lock.
Of course, the manual repair can operate as before.
This patch reorganize the code and provides the single,
atomic, stripe lock.
It should be confirmed that this new locking is not
too demanding.
In case it is, some other solutions will be required
(suggestions wellcome).

Signed off: piergiorgio.sartor@nexgo.de
diff -uNpr a/raid6check.c b/raid6check.c
--- a/raid6check.c	2014-02-01 22:18:26.657197036 +0100
+++ b/raid6check.c	2014-03-15 16:26:09.182924783 +0100
@@ -211,9 +211,6 @@ int check_stripes(struct mdinfo *info, i
 				goto exitCheck;
 			}
 		}
-		err = unlock_all_stripes(info, sig);
-		if(err != 0)
-			goto exitCheck;
 
 		for (i = 0 ; i < data_disks ; i++) {
 			int disk = geo_map(i, start, raid_disks, level, layout);
@@ -245,6 +242,64 @@ int check_stripes(struct mdinfo *info, i
 			}
 		}
 
+		if(repair == AUTO_REPAIR) {
+			int pages_to_write_count = 0;
+			int page_to_write[chunk_size >> CHECK_PAGE_BITS];
+			for(j = 0; j < (chunk_size >> CHECK_PAGE_BITS); j++) {
+				if (disk[j] >= 0) {
+					printf("Auto-repairing slot %d (%s)\n", disk[j], name[disk[j]]);
+					pages_to_write_count++;
+					page_to_write[j] = 1;
+					for(i = 0; i < raid_disks; i++) {
+						blocks_page[i] = blocks[i] + j * CHECK_PAGE_SIZE;
+					}
+					if (disk[j] == diskQ) {
+						qsyndrome(p, (uint8_t*)stripes[diskQ] + j * CHECK_PAGE_SIZE, (uint8_t**)blocks_page, data_disks, CHECK_PAGE_SIZE);
+					}
+					else {
+						char *all_but_failed_blocks[data_disks];
+						int failed_block_index = block_index_for_slot[disk[j]];
+						for (i = 0; i < data_disks; i++) {
+							if (failed_block_index == i) {
+								all_but_failed_blocks[i] = stripes[diskP] + j * CHECK_PAGE_SIZE;
+							}
+							else {
+								all_but_failed_blocks[i] = blocks_page[i];
+							}
+						}
+						xor_blocks(stripes[disk[j]] + j * CHECK_PAGE_SIZE,
+						all_but_failed_blocks, data_disks, CHECK_PAGE_SIZE);
+					}
+				}
+				else {
+					page_to_write[j] = 0;
+				}
+			}
+
+			if(pages_to_write_count > 0) {
+
+				int write_res = 0;
+				for(j = 0; j < (chunk_size >> CHECK_PAGE_BITS); j++) {
+					if(page_to_write[j] == 1) {
+						lseek64(source[disk[j]], offsets[disk[j]] + start * chunk_size + j * CHECK_PAGE_SIZE, SEEK_SET);
+						write_res += write(source[disk[j]], stripes[disk[j]] + j * CHECK_PAGE_SIZE, CHECK_PAGE_SIZE);
+					}
+				}
+
+				if (write_res != (CHECK_PAGE_SIZE * pages_to_write_count)) {
+					fprintf(stderr, "Failed to write a full chunk.\n");
+					unlock_all_stripes(info, sig);
+					err = -1;
+					goto exitCheck;
+				}
+			}
+		}
+
+		err = unlock_all_stripes(info, sig);
+		if(err != 0) {
+			goto exitCheck;
+		}
+
 		if(repair == MANUAL_REPAIR) {
 			printf("Repairing stripe %llu\n", start);
 			printf("Assuming slots %d (%s) and %d (%s) are incorrect\n",
@@ -335,61 +390,6 @@ int check_stripes(struct mdinfo *info, i
 
 		}
 
-		int pages_to_write_count = 0;
-		int page_to_write[chunk_size >> CHECK_PAGE_BITS];
-		for(j = 0; j < (chunk_size >> CHECK_PAGE_BITS); j++) {
-			if (disk[j] >= 0 && repair == AUTO_REPAIR) {
-				printf("Auto-repairing slot %d (%s)\n", disk[j], name[disk[j]]);
-				pages_to_write_count++;
-				page_to_write[j] = 1;
-				for(i = 0; i < raid_disks; i++) {
-					blocks_page[i] = blocks[i] + j * CHECK_PAGE_SIZE;
-				}
-				if (disk[j] == diskQ) {
-					qsyndrome(p, (uint8_t*)stripes[diskQ] + j * CHECK_PAGE_SIZE, (uint8_t**)blocks_page, data_disks, CHECK_PAGE_SIZE);
-				} else {
-					char *all_but_failed_blocks[data_disks];
-					int failed_block_index = block_index_for_slot[disk[j]];
-					for (i=0; i < data_disks; i++)
-						if (failed_block_index == i)
-							all_but_failed_blocks[i] = stripes[diskP] + j * CHECK_PAGE_SIZE;
-						else
-							all_but_failed_blocks[i] = blocks_page[i];
-					xor_blocks(stripes[disk[j]] + j * CHECK_PAGE_SIZE,
-					all_but_failed_blocks, data_disks, CHECK_PAGE_SIZE);
-				}
-			} else {
-				page_to_write[j] = 0;
-			}
-		}
-
-		if(pages_to_write_count > 0) {
-
-			err = lock_stripe(info, start, chunk_size, data_disks, sig);
-			if(err != 0) {
-				if (err != 2)
-					unlock_all_stripes(info, sig);
-				goto exitCheck;
-			}
-
-			int write_res = 0;
-			for(j = 0; j < (chunk_size >> CHECK_PAGE_BITS); j++) {
-				if(page_to_write[j] == 1) {
-					lseek64(source[disk[j]], offsets[disk[j]] + start * chunk_size + j * CHECK_PAGE_SIZE, 0);
-					write_res += write(source[disk[j]], stripes[disk[j]] + j * CHECK_PAGE_SIZE, CHECK_PAGE_SIZE);
-				}
-			}
-
-			err = unlock_all_stripes(info, sig);
-			if (err != 0 || write_res != (CHECK_PAGE_SIZE * pages_to_write_count))
-				goto exitCheck;
-
-			if (write_res != (CHECK_PAGE_SIZE * pages_to_write_count)) {
-				fprintf(stderr, "Failed to write a full chunk.\n");
-				goto exitCheck;
-			}
-		}
-
 		length--;
 		start++;
 	}

-- 

piergiorgio
