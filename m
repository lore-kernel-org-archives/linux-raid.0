From: David Greaves <david@dgreaves.com>
Subject: [patch] Add more info to --detail
Date: Fri, 04 Jun 2004 16:13:19 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C0918F.2010306@dgreaves.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050603030105020804040601"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------050603030105020804040601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello Neil

I've modded mdadm's ouptut (see below for example)

* adds a blank line after 'Raid Devices' disks to visually show those in 
the array and those not (sounds trivial but actually helped me 
understand the output a lot better)
* parses /proc/mdstat and indicates which disk is rebuilding

It would be nicer if the GET_DISK_INFO ioctl could return more info into 
but I have no real idea how to approach this. What are the issues about 
adding to the ioctl interface?
(just been looking through md.c to find out what info is there though... 
and there's a lot to tell userland)

Anyway sample output:

/dev/md0:
        Version : 00.90.01
  Creation Time : Fri Jun  4 13:03:09 2004
     Raid Level : raid5
     Array Size : 2939520 (2.80 GiB 3.01 GB)
    Device Size : 979840 (956.88 MiB 1003.36 MB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Jun  4 15:44:47 2004
          State : clean, degraded, recovering
 Active Devices : 3
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

 Rebuild Status : 2% complete

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       0        0       -1      removed
       3       8        2        3      active sync   /dev/sda2

       4       8       34        2      rebuilding spare   /dev/sdc2
       5       8       33       -1      faulty   /dev/sdc1
           UUID : f06ab9bd:c29b9f86:12b668e4:84c7333b
         Events : 0.6390

Here's the patch, I'm no C expert so you'll want to double check :)
(I'd appreciate any feedback too)

David



--------------050603030105020804040601
Content-Type: text/plain;
 name="output.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="output.patch"

diff -u mdadm-1.6.0-orig/Detail.c mdadm-1.6.0-dg/Detail.c
--- mdadm-1.6.0-orig/Detail.c	2004-06-04 07:18:47.000000000 +0100
+++ mdadm-1.6.0-dg/Detail.c	2004-06-04 15:38:11.000000000 +0100
@@ -47,6 +47,8 @@
 	char *devices = NULL;
 	int spares = 0;
 	struct stat stb;
+	struct mdstat_ent *ms;
+	struct mdstat_ent *e;
 
 	mdp_super_t super;
 	int have_super = 0;
@@ -85,13 +87,12 @@
 	rv = 0;
 	/* Ok, we have some info to print... */
 	c = map_num(pers, array.level);
+	ms = mdstat_read(0);
 	if (brief) 
 		printf("ARRAY %s level=%s num-devices=%d", dev, c?c:"-unknown-",array.raid_disks );
 	else {
 		unsigned long array_size;
 		unsigned long long larray_size;
-		struct mdstat_ent *ms = mdstat_read(0);
-		struct mdstat_ent *e;
 		int devnum = array.md_minor;
 		if (MAJOR(stb.st_rdev) != MD_MAJOR)
 			devnum = -1 - devnum;
@@ -109,7 +110,7 @@
 				larray_size <<= 9;
 			}
 		
-		else larray_size = 0;
+			else larray_size = 0;
 
 		printf("%s:\n", dev);
 		printf("        Version : %02d.%02d.%02d\n",
@@ -158,12 +159,12 @@
 
 		if (e && e->percent >= 0)
 			printf(" Rebuild Status : %d%% complete\n\n", e->percent);
-		free_mdstat(ms);
 
 		printf("    Number   Major   Minor   RaidDevice State\n");
 	}
 	for (d= 0; d<MD_SB_DISKS; d++) {
 		mdu_disk_info_t disk;
+		struct mdstat_ent_devinfo *msdi;
 		char *dv;
 		disk.number = d;
 		if (ioctl(fd, GET_DISK_INFO, &disk) < 0) {
@@ -177,13 +178,24 @@
 		    disk.minor == 0)
 			continue;
 		if (!brief) {
+			if (disk.number == array.raid_disks) printf("\n");
 			printf("   %5d   %5d    %5d    %5d     ", 
 			       disk.number, disk.major, disk.minor, disk.raid_disk);
 			if (disk.state & (1<<MD_DISK_FAULTY)) printf(" faulty");
 			if (disk.state & (1<<MD_DISK_ACTIVE)) printf(" active");
 			if (disk.state & (1<<MD_DISK_SYNC)) printf(" sync");
 			if (disk.state & (1<<MD_DISK_REMOVED)) printf(" removed");
-			if (disk.state == 0) { printf(" spare"); spares++; }
+			/*			if (disk.state == 0) { printf(" spare"); spares++; } */
+			if (disk.state == 0) {
+				spares++;
+				if (e && e->percent >= 0)
+					/* a disk is rebuilding */
+					/* look through mdstat response and see if it's me*/
+					for (msdi=ms->devinfo;msdi;msdi=msdi->next)
+						if (msdi->arr_pos == disk.number)
+							printf(" rebuilding");
+				printf(" spare");
+			}
 		}
 		if (test && d < array.raid_disks && disk.state & (1<<MD_DISK_FAULTY)) {
 			if ((rv & 1) && (array.level ==4 || array.level == 5))
@@ -214,6 +226,8 @@
 		}
 		if (!brief) printf("\n");
 	}
+	free_mdstat(ms);
+
 	if (spares && brief) printf(" spares=%d", spares);
 	if (have_super) {
 		if (brief) printf(" UUID=");

diff -u mdadm-1.6.0-orig/md_p.h mdadm-1.6.0-dg/md_p.h
--- mdadm-1.6.0-orig/md_p.h	2003-02-10 02:36:35.000000000 +0000
+++ mdadm-1.6.0-dg/md_p.h	2004-06-04 11:46:33.000000000 +0100
@@ -77,7 +77,7 @@
 #define MD_DISK_FAULTY		0 /* disk is faulty / operational */
 #define MD_DISK_ACTIVE		1 /* disk is running or spare disk */
 #define MD_DISK_SYNC		2 /* disk is in sync with the raid set */
-#define MD_DISK_REMOVED		3 /* disk is in sync with the raid set */
+#define MD_DISK_REMOVED		3 /* disk is out / in the raid set */
 
 typedef struct mdp_device_descriptor_s {
 	__u32 number;		/* 0 Device number in the entire set	      */
diff -u mdadm-1.6.0-orig/mdadm.h mdadm-1.6.0-dg/mdadm.h
--- mdadm-1.6.0-orig/mdadm.h	2004-06-04 07:18:47.000000000 +0100
+++ mdadm-1.6.0-dg/mdadm.h	2004-06-04 13:41:51.000000000 +0100
@@ -129,8 +129,15 @@
 } mapping_t;
 
 
+struct mdstat_ent_devinfo {
+	char		*name;   /* eg hdd, sda1 */
+	int		arr_pos; /* 0->arr_disks means active, higher is spare */
+	struct mdstat_ent_devinfo *next;
+};
+
 struct mdstat_ent {
 	char		*dev;
+	struct mdstat_ent_devinfo *devinfo;
 	int		devnum;
 	int		active;
 	char		*level;
diff -u mdadm-1.6.0-orig/mdstat.c mdadm-1.6.0-dg/mdstat.c
--- mdadm-1.6.0-orig/mdstat.c	2004-06-04 07:18:46.000000000 +0100
+++ mdadm-1.6.0-dg/mdstat.c	2004-06-04 14:45:27.000000000 +0100
@@ -94,6 +94,16 @@
 		if (ms->dev) free(ms->dev);
 		if (ms->level) free(ms->level);
 		if (ms->pattern) free(ms->pattern);
+		if (ms->devinfo) {
+		  struct mdstat_ent_devinfo *msed = ms->devinfo;
+		  while(msed) {
+		    struct mdstat_ent_devinfo *t2;
+		    free(msed->name);
+		    t2 = msed;
+		    msed=msed->next;
+		    free(t2);
+		  }
+		}
 		t = ms;
 		ms = ms->next;
 		free(t);
@@ -105,6 +115,8 @@
 {
 	FILE *f;
 	struct mdstat_ent *all, **end;
+	struct mdstat_ent_devinfo **end_ed;
+
 	char *line;
 
 	if (hold && mdstat_fd != -1) {
@@ -157,9 +169,11 @@
 		ent->dev = strdup(line);
 		ent->devnum = devnum;
 		
+		ent->devinfo=NULL;
+		end_ed = &ent->devinfo;
 		for (w=dl_next(line); w!= line ; w=dl_next(w)) {
 			int l = strlen(w);
-			char *eq;
+			char *cpos;
 			if (strcmp(w, "active")==0)
 				ent->active = 1;
 			else if (strcmp(w, "inactive")==0)
@@ -168,7 +182,30 @@
 				 ent->level == NULL &&
 				 w[0] != '(' /*readonly*/)
 				ent->level = strdup(w);
-			else if (!ent->pattern &&
+			else if (ent->active >=0 &&
+				 ent->level &&
+				 /* dev[%d] only, not dev[%d](F) or [UUU] or [1/4] */
+				 /* ie only disks in the array */
+				 w[l-1] == ']' && w[0] != '[' && 
+				 (cpos=strchr(w, '[')) != NULL ) {
+				struct mdstat_ent_devinfo *new_ed;
+				/* fprintf(stderr, "found %s\n", w); */
+				new_ed = malloc(sizeof(*new_ed));
+				if (!new_ed) {
+				  fprintf(stderr, Name ": malloc failed reading /proc/mdstat.\n");
+				  free_line(line);
+				  free_mdstat(ent);
+				  break;
+				}
+				new_ed->name=strdup(w); /* no strndup() */
+				cpos = strchr(new_ed->name, '[');
+				if (cpos) *cpos = '\0';
+				new_ed->arr_pos=atoi(cpos+1);
+				/* fprintf(stderr, "found /dev/%s @ pos=%d\n", new_ed->name,new_ed->arr_pos); */
+				new_ed->next=NULL;
+				*end_ed = new_ed;
+				end_ed = &new_ed->next;
+			} else if (!ent->pattern &&
 				 w[0] == '[' &&
 				 (w[1] == 'U' || w[1] == '_')) {
 				ent->pattern = strdup(w+1);
@@ -177,8 +214,8 @@
 			} else if (ent->percent == -1 &&
 				   strncmp(w, "re", 2)== 0 &&
 				   w[l-1] == '%' &&
-				   (eq=strchr(w, '=')) != NULL ) {
-				ent->percent = atoi(eq+1);
+				   (cpos=strchr(w, '=')) != NULL ) {
+				ent->percent = atoi(cpos+1);
 			} else if (ent->percent == -1 &&
 				   w[0] >= '0' && 
 				   w[0] <= '9' &&

--------------050603030105020804040601--
