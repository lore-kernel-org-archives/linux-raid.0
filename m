From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 1:1]: mdadm. add raid0 grow support
Date: Wed, 17 Jun 2009 02:14:52 +0300
Message-ID: <1245194092.7257.1.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

add grow functionality for raid0
on top of commit c8b4de0cccfba18818416f62687e4094a5b83922
I do not consider this code my master piece, but it does
the trick.

 Grow.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

Signed-Off-By:raziebe@gmail.com
---
diff --git a/Grow.c b/Grow.c
index f9e6804..7cdb9d1 100644
--- a/Grow.c
+++ b/Grow.c
@@ -483,7 +483,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 
 	case 1: /* raid_disks and size can each be changed.  They are independant */
 
-		if (level != UnSet && level != 1) {
+		if (level != UnSet && level >2) {
 			fprintf(stderr, Name ": %s: Cannot change RAID level of a RAID1 array.\n",
 				devname);
 			return 1;
@@ -515,7 +515,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			}
 		}
 		return 0;
-
+	case 0:
 	case 4:
 	case 5:
 	case 6:
@@ -588,10 +588,14 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		if (chunksize) nchunk = chunksize;
 		if (layout != UnSet) nlayout = layout;
 		if (raid_disks) ndisks = raid_disks;
-
-		odata = odisks-1;
+		
+		odata = odisks;
+		if (array.level != 0)
+			odata = odisks-1;
 		if (olevel == 6) odata--; /* number of data disks */
-		ndata = ndisks-1;
+		ndata = ndisks;
+		if (array.level != 0)
+			ndata = ndisks - 1;
 		if (nlevel == 6) ndata--;
 
 		if (ndata < odata) {
@@ -617,17 +621,19 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		}
 		fprintf(stderr, Name ": Need to backup %lluK of critical "
 			"section..\n", last_block/2);
-
-		sra = sysfs_read(fd, 0,
-				 GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE|
-				 GET_CACHE);
+		{
+		int read_flags = GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE;
+		if ( array.level != 0)
+			read_flags |= GET_CACHE;
+		sra = sysfs_read(fd, 0, read_flags);
+		}
 		if (!sra) {
 			fprintf(stderr, Name ": %s: Cannot get array details from sysfs\n",
 				devname);
 			return 1;
 		}
 
-		if (last_block >= sra->component_size/2) {
+		if (array.level !=0 && last_block >= sra->component_size/2) {
 			fprintf(stderr, Name ": %s: Something wrong - reshape aborted\n",
 				devname);
 			return 1;
@@ -641,6 +647,8 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		nrdisks = array.nr_disks + sra->array.spare_disks;
 		/* Now we need to open all these devices so we can read/write.
 		 */
+		if (array.level == 0)
+			goto set_array_info;
 		fdlist = malloc((1+nrdisks) * sizeof(int));
 		offsets = malloc((1+nrdisks) * sizeof(offsets[0]));
 		if (!fdlist || !offsets) {
@@ -740,6 +748,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				goto abort;
 			}
 		}
+set_array_info:
 		array.level = nlevel;
 		array.raid_disks = ndisks;
 		array.chunk_size = nchunk;
@@ -764,7 +773,10 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			goto abort;
 		}
 		ok: ;
-
+		if (array.level == 0){
+			fprintf(stderr,"raid0 started reshape\n");
+			return 0;
+		}
 		/* suspend the relevant region */
 		sysfs_set_num(sra, NULL, "suspend_hi", 0); /* just in case */
 		if (sysfs_set_num(sra, NULL, "suspend_lo", 0) < 0 ||


