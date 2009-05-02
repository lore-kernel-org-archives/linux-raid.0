From: raz ben yehuda <raziebe@013.net>
Subject: Subject: [002/002 ] raid0 reshape. mdadm
Date: Sun, 03 May 2009 00:46:10 +0300
Message-ID: <1241300770.5607.37.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm to support grow
 Grow.c |   49 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 14 deletions(-)
Signed-of-By : Neil Brown neilb@suse.de
---
--- /home/razb/downloads/mdadm-2.6/Grow.c	2009-05-03 00:21:59.000000000 +0300
+++ mdadm-2.6/Grow.c	2009-05-03 00:22:52.000000000 +0300
@@ -483,7 +483,7 @@
 
 	case 1: /* raid_disks and size can each be changed.  They are independant */
 
-		if (level != UnSet && level != 1) {
+		if (level != UnSet && level > 2) {
 			fprintf(stderr, Name ": %s: Cannot change RAID level of a RAID1 array.\n",
 				devname);
 			return 1;
@@ -505,6 +505,8 @@
 					devname, strerror(errno));
 				return 1;
 			}
+			fprintf(stderr, Name ": Set raid-devices for %s: OK\n",
+					devname);
 		}
 		if (size >= 0) {
 			array.size = size;
@@ -516,6 +518,7 @@
 		}
 		return 0;
 
+	case 0:
 	case 4:
 	case 5:
 	case 6:
@@ -589,9 +592,13 @@
 		if (layout != UnSet) nlayout = layout;
 		if (raid_disks) ndisks = raid_disks;
 
-		odata = odisks-1;
+		odata = odisks;
+		if (array.level != 0)
+			odata = odisks-1;
 		if (olevel == 6) odata--; /* number of data disks */
-		ndata = ndisks-1;
+		ndata = ndisks;
+		if (array.level != 0)
+			ndata = ndisks-1;
 		if (nlevel == 6) ndata--;
 
 		if (ndata < odata) {
@@ -616,18 +623,21 @@
 			ostripe = last_block / odata / (ochunk/512) * (ochunk/512);
 		}
 		printf("mdadm: Need to backup %lluK of critical section..\n", last_block/2);
-
-		sra = sysfs_read(fd, 0,
-				 GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE|
-				 GET_CACHE);
+		{
+		int read_flags = GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE;
+		if (array.level != 0)
+			read_flags |= GET_CACHE;
+			sra = sysfs_read(fd, 0, read_flags);
+		}
 		if (!sra) {
 			fprintf(stderr, Name ": %s: Cannot get array details from sysfs\n",
 				devname);
 			return 1;
 		}
 
-		if (last_block >= sra->component_size/2) {
-			fprintf(stderr, Name ": %s: Something wrong - reshape aborted\n",
+		if (array.level != 0 &&  last_block >= sra->component_size/2) {
+			fprintf(stderr, Name
+			": %s: Something wrong - reshape aborted\n",
 				devname);
 			return 1;
 		}
@@ -640,6 +650,8 @@
 		nrdisks = array.nr_disks + sra->spares;
 		/* Now we need to open all these devices so we can read/write.
 		 */
+		if (array.level == 0)
+			goto set_array_info;
 		fdlist = malloc((1+nrdisks) * sizeof(int));
 		offsets = malloc((1+nrdisks) * sizeof(offsets[0]));
 		if (!fdlist || !offsets) {
@@ -682,7 +694,8 @@
 			}
 		spares = sra->spares;
 		if (backup_file) {
-			fdlist[d] = open(backup_file, O_RDWR|O_CREAT|O_EXCL, 0600);
+			fdlist[d] =
+				open(backup_file, O_RDWR|O_CREAT|O_EXCL, 0600);
 			if (fdlist[d] < 0) {
 				fprintf(stderr, Name ": %s: cannot create backup file %s: %s\n",
 					devname, backup_file, strerror(errno));
@@ -720,8 +733,13 @@
 			if (i==d-1 && backup_file) {
 				/* This is the backup file */
 				offsets[i] = 8;
-			} else
-				offsets[i] += sra->component_size - last_block - 8;
+			} else {
+			  if (array.level != 0)
+				offsets[i] += sra->component_size
+					 - last_block - 8;
+				else
+					offsets[i] += 8;
+			}
 			if (lseek64(fdlist[i], (offsets[i]<<9) - 4096, 0)
 			    != (offsets[i]<<9) - 4096) {
 				fprintf(stderr, Name ": could not seek...\n");
@@ -736,6 +754,7 @@
 				goto abort;
 			}
 		}
+set_array_info:
 		array.level = nlevel;
 		array.raid_disks = ndisks;
 		array.chunk_size = nchunk;
@@ -760,7 +779,10 @@
 			goto abort;
 		}
 		ok: ;
-
+		if (array.level == 0) {
+			fprintf(stderr, "raid0 started reshape\n");
+			return 0;
+		}
 		/* suspend the relevant region */
 		sysfs_set_num(sra, NULL, "suspend_hi", 0); /* just in case */
 		if (sysfs_set_num(sra, NULL, "suspend_lo", 0) < 0 ||
@@ -839,7 +861,6 @@
 	}
 	return 0;
 
-
  abort_resume:
 	sysfs_set_num(sra, NULL, "suspend_lo", last_block);
  abort:



