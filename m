From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [PATCH] raid6check.c: move manual repair code to separate function
Date: Sat, 15 Mar 2014 18:33:13 +0100
Message-ID: <20140315173312.GA23930@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch cleans up a bit the code by moving
the second repair mode, that is the manual
repair, to a separate function.

Signed off: piergiorgio.sartor@nexgo.de
diff -uNpr a/raid6check.c b/raid6check.c
--- a/raid6check.c	2014-03-15 17:56:49.962126767 +0100
+++ b/raid6check.c	2014-03-15 18:30:11.567317098 +0100
@@ -214,6 +214,111 @@ int autorepair(int *disk, int diskP, int
 	return 0;
 }
 
+/* Manual repair */
+int manual_repair(int diskP, int diskQ, int chunk_size, int raid_disks, int data_disks,
+		int failed_disk1, int failed_disk2, unsigned long long start, int *block_index_for_slot,
+		char *name[], char **stripes, char **blocks, uint8_t *p, struct mdinfo *info, sighandler_t *sig,
+		int *source, unsigned long long *offsets)
+{
+	int err = 0;
+	int i;
+	printf("Repairing stripe %llu\n", start);
+	printf("Assuming slots %d (%s) and %d (%s) are incorrect\n",
+		failed_disk1, name[failed_disk1],
+		failed_disk2, name[failed_disk2]);
+
+	if (failed_disk1 == diskQ || failed_disk2 == diskQ) {
+		char *all_but_failed_blocks[data_disks];
+		int failed_data_or_p;
+		int failed_block_index;
+
+		if (failed_disk1 == diskQ) {
+			failed_data_or_p = failed_disk2;
+		}
+		else {
+			failed_data_or_p = failed_disk1;
+		}
+		printf("Repairing D/P(%d) and Q\n", failed_data_or_p);
+		failed_block_index = block_index_for_slot[failed_data_or_p];
+		for (i = 0; i < data_disks; i++) {
+			if (failed_block_index == i) {
+				all_but_failed_blocks[i] = stripes[diskP];
+			}
+			else {
+				all_but_failed_blocks[i] = blocks[i];
+			}
+		}
+		xor_blocks(stripes[failed_data_or_p],
+			all_but_failed_blocks, data_disks, chunk_size);
+		qsyndrome(p, (uint8_t*)stripes[diskQ], (uint8_t**)blocks, data_disks, chunk_size);
+	}
+	else {
+		ensure_zero_has_size(chunk_size);
+		if (failed_disk1 == diskP || failed_disk2 == diskP) {
+			int failed_data, failed_block_index;
+			if (failed_disk1 == diskP) {
+				failed_data = failed_disk2;
+			}
+			else {
+				failed_data = failed_disk1;
+			}
+			failed_block_index = block_index_for_slot[failed_data];
+			printf("Repairing D(%d) and P\n", failed_data);
+			raid6_datap_recov(raid_disks, chunk_size, failed_block_index, (uint8_t**)blocks);
+		}
+		else {
+			printf("Repairing D and D\n");
+			int failed_block_index1 = block_index_for_slot[failed_disk1];
+			int failed_block_index2 = block_index_for_slot[failed_disk2];
+			if (failed_block_index1 > failed_block_index2) {
+				int t = failed_block_index1;
+				failed_block_index1 = failed_block_index2;
+				failed_block_index2 = t;
+			}
+			raid6_2data_recov(raid_disks, chunk_size, failed_block_index1, failed_block_index2, (uint8_t**)blocks);
+		}
+	}
+
+	err = lock_stripe(info, start, chunk_size, data_disks, sig);
+	if(err != 0) {
+		if (err != 2) {
+			return -1;
+		}
+		return -2;;
+	}
+
+	int write_res1, write_res2;
+	off64_t seek_res;
+
+	seek_res = lseek64(source[failed_disk1],
+				offsets[failed_disk1] + start * chunk_size, SEEK_SET);
+	if (seek_res < 0) {
+		fprintf(stderr, "lseek failed for failed_disk1\n");
+		return -1;
+	}
+	write_res1 = write(source[failed_disk1], stripes[failed_disk1], chunk_size);
+
+	seek_res = lseek64(source[failed_disk2],
+				offsets[failed_disk2] + start * chunk_size, SEEK_SET);
+	if (seek_res < 0) {
+		fprintf(stderr, "lseek failed for failed_disk1\n");
+		return -1;
+	}
+	write_res2 = write(source[failed_disk2], stripes[failed_disk2], chunk_size);
+
+	err = unlock_all_stripes(info, sig);
+	if(err != 0) {
+		return -2;
+	}
+
+	if (write_res1 != chunk_size || write_res2 != chunk_size) {
+		fprintf(stderr, "Failed to write a complete chunk.\n");
+		return -2;
+	}
+
+	return 0;
+}
+
 int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 		  int raid_disks, int chunk_size, int level, int layout,
 		  unsigned long long start, unsigned long long length, char *name[],
@@ -317,93 +422,14 @@ int check_stripes(struct mdinfo *info, i
 		}
 
 		if(repair == MANUAL_REPAIR) {
-			printf("Repairing stripe %llu\n", start);
-			printf("Assuming slots %d (%s) and %d (%s) are incorrect\n",
-			       failed_disk1, name[failed_disk1],
-			       failed_disk2, name[failed_disk2]);
-
-			if (failed_disk1 == diskQ || failed_disk2 == diskQ) {
-				char *all_but_failed_blocks[data_disks];
-				int failed_data_or_p;
-				int failed_block_index;
-
-				if (failed_disk1 == diskQ)
-					failed_data_or_p = failed_disk2;
-				else
-					failed_data_or_p = failed_disk1;
-				printf("Repairing D/P(%d) and Q\n", failed_data_or_p);
-				failed_block_index = block_index_for_slot[failed_data_or_p];
-				for (i=0; i < data_disks; i++)
-					if (failed_block_index == i)
-						all_but_failed_blocks[i] = stripes[diskP];
-					else
-						all_but_failed_blocks[i] = blocks[i];
-				xor_blocks(stripes[failed_data_or_p],
-					all_but_failed_blocks, data_disks, chunk_size);
-				qsyndrome(p, (uint8_t*)stripes[diskQ], (uint8_t**)blocks, data_disks, chunk_size);
-			} else {
-				ensure_zero_has_size(chunk_size);
-				if (failed_disk1 == diskP || failed_disk2 == diskP) {
-					int failed_data, failed_block_index;
-					if (failed_disk1 == diskP)
-						failed_data = failed_disk2;
-					else
-						failed_data = failed_disk1;
-					failed_block_index = block_index_for_slot[failed_data];
-					printf("Repairing D(%d) and P\n", failed_data);
-					raid6_datap_recov(raid_disks, chunk_size, failed_block_index, (uint8_t**)blocks);
-				} else {
-					printf("Repairing D and D\n");
-					int failed_block_index1 = block_index_for_slot[failed_disk1];
-					int failed_block_index2 = block_index_for_slot[failed_disk2];
-					if (failed_block_index1 > failed_block_index2) {
-						int t = failed_block_index1;
-						failed_block_index1 = failed_block_index2;
-						failed_block_index2 = t;
-					}
-					raid6_2data_recov(raid_disks, chunk_size, failed_block_index1, failed_block_index2, (uint8_t**)blocks);
-				}
-			}
-
-			err = lock_stripe(info, start, chunk_size, data_disks, sig);
-			if(err != 0) {
-				if (err != 2)
-					unlock_all_stripes(info, sig);
-				goto exitCheck;
-			}
-
-			int write_res1, write_res2;
-			off64_t seek_res;
-
-			seek_res = lseek64(source[failed_disk1],
-					   offsets[failed_disk1] + start * chunk_size, SEEK_SET);
-			if (seek_res < 0) {
-				fprintf(stderr, "lseek failed for failed_disk1\n");
-				unlock_all_stripes(info, sig);
-				err = -1;
-				goto exitCheck;
-			}
-			write_res1 = write(source[failed_disk1], stripes[failed_disk1], chunk_size);
-
-			seek_res = lseek64(source[failed_disk2],
-					   offsets[failed_disk2] + start * chunk_size, SEEK_SET);
-			if (seek_res < 0) {
-				fprintf(stderr, "lseek failed for failed_disk1\n");
+			err = manual_repair(diskP, diskQ, chunk_size, raid_disks, data_disks,
+					failed_disk1, failed_disk2, start, block_index_for_slot,
+					name, stripes, blocks, p, info, sig,
+					source, offsets);
+			if(err == -1) {
 				unlock_all_stripes(info, sig);
-				err = -1;
 				goto exitCheck;
 			}
-			write_res2 = write(source[failed_disk2], stripes[failed_disk2], chunk_size);
-
-			err = unlock_all_stripes(info, sig);
-			if(err != 0)
-				goto exitCheck;
-
-			if (write_res1 != chunk_size || write_res2 != chunk_size) {
-				fprintf(stderr, "Failed to write a complete chunk.\n");
-				goto exitCheck;
-			}
-
 		}
 
 		length--;

-- 

piergiorgio
