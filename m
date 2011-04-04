From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [PATCH] RAID-6 check standalone code cleanup
Date: Mon, 4 Apr 2011 19:52:42 +0200
Message-ID: <20110404175242.GA3411@lazy.lzy>
References: <20110221204551.GA15675@lazy.lzy>
 <20110321140244.2314b4b4@notabene.brown>
 <20110321104007.GA15379@lazy.lzy>
 <20110321220457.29d52f5c@notabene.brown>
 <20110321115440.GA15635@lazy.lzy>
 <20110322095905.737fb1d5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110322095905.737fb1d5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

please find below a second patch to "raid6check.c".
This applies on top of the previous one.

Major change is code cleanup and simplification.
Furthermore, a better error handling and a couple
of bug fixes.
Last but not least, the command line parameters are
changed from "bytes" to "stripes", which is more
convenient, I guess.

If you prefer, I can send a single patch, including
in one shot the last one and this one.

Thanks,

bye,

pg

--- cut here ---

diff -uNr a/raid6check.c b/raid6check.c
--- a/raid6check.c	2011-03-31 20:44:45.820258613 +0200
+++ b/raid6check.c	2011-04-04 19:44:52.539745305 +0200
@@ -114,9 +114,20 @@
 	int i;
 	int diskP, diskQ;
 	int data_disks = raid_disks - 2;
+	int err = 0;
 
 	extern int tables_ready;
 
+	if((stripe_buf == NULL) ||
+	   (stripes == NULL) ||
+	   (blocks == NULL) ||
+	   (p == NULL) ||
+	   (q == NULL) ||
+	   (results == NULL)) {
+		err = 1;
+		goto exitCheck;
+	}
+
 	if (!tables_ready)
 		make_tables();
 
@@ -126,49 +137,47 @@
 	while (length > 0) {
 		int disk;
 
+		printf("pos --> %llu\n", start);
+
 		for (i = 0 ; i < raid_disks ; i++) {
-			lseek64(source[i], offsets[i]+start, 0);
+			lseek64(source[i], offsets[i] + start * chunk_size, 0);
 			read(source[i], stripes[i], chunk_size);
 		}
 		for (i = 0 ; i < data_disks ; i++) {
-			int disk = geo_map(i, start/chunk_size, raid_disks,
-					   level, layout);
+			int disk = geo_map(i, start, raid_disks, level, layout);
 			blocks[i] = stripes[disk];
 			printf("%d->%d\n", i, disk);
 		}
 
 		qsyndrome(p, q, (uint8_t**)blocks, data_disks, chunk_size);
-		diskP = geo_map(-1, start/chunk_size, raid_disks,
-				level, layout);
+		diskP = geo_map(-1, start, raid_disks, level, layout);
 		if (memcmp(p, stripes[diskP], chunk_size) != 0) {
-			printf("P(%d) wrong at %llu\n", diskP,
-			       start / chunk_size);
+			printf("P(%d) wrong at %llu\n", diskP, start);
 		}
-		diskQ = geo_map(-2, start/chunk_size, raid_disks,
-				level, layout);
+		diskQ = geo_map(-2, start, raid_disks, level, layout);
 		if (memcmp(q, stripes[diskQ], chunk_size) != 0) {
-			printf("Q(%d) wrong at %llu\n", diskQ,
-			       start / chunk_size);
+			printf("Q(%d) wrong at %llu\n", diskQ, start);
 		}
-		raid6_collect(chunk_size, p, q,
-			      stripes[diskP], stripes[diskQ], results);
+		raid6_collect(chunk_size, p, q, stripes[diskP], stripes[diskQ], results);
 		disk = raid6_stats(results, raid_disks, chunk_size);
 
 		if(disk >= -2) {
-			disk = geo_map(disk, start/chunk_size, raid_disks,
-				       level, layout);
+			disk = geo_map(disk, start, raid_disks, level, layout);
 		}
 		if(disk >= 0) {
-			printf("Possible failed disk slot: %d --> %s\n", disk, name[disk]);
+			printf("Error detected at %llu: possible failed disk slot: %d --> %s\n",
+				start, disk, name[disk]);
 		}
 		if(disk == -65535) {
-			printf("Failure detected, but disk unknown\n");
+			printf("Error detected at %llu: disk slot unknown\n", start);
 		}
 
-		length -= chunk_size;
-		start += chunk_size;
+		length--;
+		start++;
 	}
 
+exitCheck:
+
 	free(stripe_buf);
 	free(stripes);
 	free(blocks);
@@ -176,7 +185,7 @@
 	free(q);
 	free(results);
 
-	return 0;
+	return err;
 }
 
 unsigned long long getnum(char *str, char **err)
@@ -193,29 +202,40 @@
 int main(int argc, char *argv[])
 {
 	/* md_device start length */
-	int *fds;
-	char *buf;
-	char **disk_name;
-	unsigned long long *offsets;
-	int raid_disks, chunk_size, layout;
+	int *fds = NULL;
+	char *buf = NULL;
+	char **disk_name = NULL;
+	unsigned long long *offsets = NULL;
+	int raid_disks = 0;
+	int chunk_size = 0;
+	int layout = -1;
 	int level = 6;
 	unsigned long long start, length;
 	int i;
 	int mdfd;
 	struct mdinfo *info, *comp;
         char *err = NULL;
-	const char prg[] = "raid6check";
-
-        if (argc < 3) {
-                fprintf(stderr, "Usage: %s md_device start length\n", prg);
-                exit(1);
+	int exit_err = 0;
+	int close_flag = 0;
+	char *prg = strrchr(argv[0], '/');
+
+	if (prg == NULL)
+		prg = argv[0];
+	else
+		prg++;
+
+        if (argc < 4) {
+                fprintf(stderr, "Usage: %s md_device start_stripe length_stripes\n", prg);
+                exit_err = 1;
+		goto exitHere;
         }
 
 	mdfd = open(argv[1], O_RDONLY);
 	if(mdfd < 0) {
 		perror(argv[1]);
 		fprintf(stderr,"%s: cannot open %s\n", prg, argv[1]);
-		exit(4);
+		exit_err = 2;
+		goto exitHere;
 	}
 
 	info  = sysfs_read(mdfd, -1,
@@ -230,19 +250,21 @@
 
 	if(info->array.level != level) {
 		fprintf(stderr, "%s: %s not a RAID-6\n", prg, argv[1]);
-		exit(5);
+		exit_err = 3;
+		goto exitHere;
 	}
 
 	printf("layout: %d\n", info->array.layout);
 	printf("disks: %d\n", info->array.raid_disks);
-	printf("component size: %llu\n", info->component_size*512);
+	printf("component size: %llu\n", info->component_size * 512);
+	printf("total stripes: %llu\n", (info->component_size * 512) / info->array.chunk_size);
 	printf("chunk size: %d\n", info->array.chunk_size);
 	printf("\n");
 
 	comp = info->devs;
 	for(i = 0; i < info->array.raid_disks; i++) {
 		printf("disk: %d - offset: %llu - size: %llu - name: %s - slot: %d\n",
-			i, comp->data_offset, comp->component_size*512,
+			i, comp->data_offset * 512, comp->component_size * 512,
 			map_dev(comp->disk.major, comp->disk.minor, 0),
 			comp->disk.raid_disk);
 
@@ -260,19 +282,39 @@
 
 	if (err) {
 		fprintf(stderr, "%s: Bad number: %s\n", prg, err);
-		exit(2);
+		exit_err = 4;
+		goto exitHere;
 	}
 
-	start = (start / chunk_size) * chunk_size;
+	if(start > ((info->component_size * 512) / chunk_size)) {
+		start = (info->component_size * 512) / chunk_size;
+		fprintf(stderr, "%s: start beyond disks size\n", prg);
+	}
 
-	if(length == 0) {
-		length = info->component_size * 512 - start;
+	if((length == 0) ||
+	   ((length + start) > ((info->component_size * 512) / chunk_size))) {
+		length = (info->component_size * 512) / chunk_size - start;
 	}
 
 	disk_name = malloc(raid_disks * sizeof(*disk_name));
 	fds = malloc(raid_disks * sizeof(*fds));
 	offsets = malloc(raid_disks * sizeof(*offsets));
+	buf = malloc(raid_disks * chunk_size);
+
+	if((disk_name == NULL) ||
+	   (fds == NULL) ||
+	   (offsets == NULL) ||
+	   (buf == NULL)) {
+		fprintf(stderr, "%s: allocation fail\n", prg);
+		exit_err = 5;
+		goto exitHere;
+	} 
+
 	memset(offsets, 0, raid_disks * sizeof(*offsets));
+	for(i=0; i<raid_disks; i++) {	
+		fds[i] = -1;
+	}
+	close_flag = 1;
 
 	comp = info->devs;
 	for (i=0; i<raid_disks; i++) {
@@ -283,21 +325,29 @@
 		if (fds[disk_slot] < 0) {
 			perror(disk_name[disk_slot]);
 			fprintf(stderr,"%s: cannot open %s\n", prg, disk_name[disk_slot]);
-			exit(3);
+			exit_err = 6;
+			goto exitHere;
 		}
 
 		comp = comp->next;
 	}
 
-	buf = malloc(raid_disks * chunk_size);
-
 	int rv = check_stripes(fds, offsets,
 			       raid_disks, chunk_size, level, layout,
 			       start, length, disk_name);
 	if (rv != 0) {
 		fprintf(stderr,
 			"%s: check_stripes returned %d\n", prg, rv);
-		exit(1);
+		exit_err = 7;
+		goto exitHere;
+	}
+
+exitHere:
+
+	if(close_flag == 1) {
+		for(i=0; i<raid_disks; i++) {
+			close(fds[i]);
+		}
 	}
 
 	free(disk_name);
@@ -305,8 +355,5 @@
 	free(offsets);
 	free(buf);
 
-	for(i=0; i<raid_disks; i++)
-		close(fds[i]);
-
-	exit(0);
+	exit(exit_err);
 }

--- cut here ---

-- 

piergiorgio
