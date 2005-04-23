From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: [PATCH] secure write for RAID1
Date: Sat, 23 Apr 2005 22:48:01 +0200
Message-ID: <1toqj2-sjd.ln1@news.it.uc3m.es>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch (completely untested of course - what, me?) makes RAID1 write
to all components of a raid-1 array, else return error to the write
attempt, when one component cannot be written.

The patch compiles. That's all I claim at the moment, as I haven't had
a chance to test it in anger.

I've had to patch mdadm too, in order to supply control. If sysctl (or
sysfs, or whatever) were extended, that would not have been neccessary.

FIrst add a "policy" field to the info structs in a couple of kernel
headers. Define "strict" as the only extra policy so far.

(It's OK to let an mdadm which thinks that the struct has been extended,
interact with a kernel in which it has not been extended, as the kernel
won't read more than its own.  Mdadm might be confused on read, but the
effect of mdadm's confusion, if any, on the kernel will be nil).

--- linux-2.6.8.1/include/linux/raid/md_u.h.pre-secure-write	Sat Aug 14 12:56:00 2004
+++ linux-2.6.8.1/include/linux/raid/md_u.h	Sat Apr 23 18:47:20 2005
@@ -80,6 +80,12 @@
 	 */
 	int layout;		/*  0 the array's physical layout	      */
 	int chunk_size;	/*  1 chunk size in bytes		      */
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+#  ifndef MD_POLICY_STRICT
+#    define MD_POLICY_STRICT        0x01
+#  endif /* MD_POLICY_STRICT */
+        int policy;		/*  2 array behavior modulation 	      */
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 
 } mdu_array_info_t;
 
--- linux-2.6.8.1/include/linux/raid/md_k.h.pre-secure-write	Sat Apr 23 20:50:27 2005
+++ linux-2.6.8.1/include/linux/raid/md_k.h	Sat Apr 23 18:48:22 2005
@@ -254,6 +254,12 @@
 	request_queue_t			*queue;	/* for plugging ... */
 
 	struct list_head		all_mddevs;
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+#  ifndef MD_POLICY_STRICT
+#    define MD_POLICY_STRICT	0x01
+#  endif /* MD_POLICY_STRICT */
+        int policy;
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 };
 
 

That was the info struct and the mddev struct, as I recall. Now for the
business ... in the raid1 driver, in raid1_end_write_request, change
the code so that it only sets Uptodate on the master bio on the last
successful write (and if the array is not degraded), not on the first
successful write.



--- linux-2.6.8.1/drivers/md/raid1.c.pre-secure-write	Wed Mar 30 02:10:16 2005
+++ linux-2.6.8.1/drivers/md/raid1.c	Sat Apr 23 18:44:37 2005
@@ -451,25 +451,34 @@
 	if (!uptodate)
 		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
 	else
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+		/* Set R1BIO_Uptodate on master only when all writes OK */
+            	if (!(r1_bio->mddev->policy & MD_POLICY_STRICT))
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that
 		 * we will return a good error code for to the higher
 		 * levels even if IO on some other mirrored buffer fails.
 		 *
 		 * The 'master' represents the composite IO operation to
 		 * user-side. So if something waits for IO, then it will
 		 * wait for the 'master' bio.
 		 */
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 
 	update_head_pos(mirror, r1_bio);
 
 	/*
 	 *
 	 * Let's see if all mirrored write operations have finished
 	 * already.
 	 */
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+		if (r1_bio->mddev->degraded <= 0 &&
+            	    (r1_bio->mddev->policy & MD_POLICY_STRICT))
+			set_bit(R1BIO_Uptodate, &r1_bio->state);
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 		md_write_end(r1_bio->mddev);
 		raid_end_bio_io(r1_bio);
 	}

I hope the "degraded" count is accurate. I assume it's incremented on
each write failure. If it isn't, we'll need a counter of the successful
writes per bio (as well as the present "write attempts made so far").

Now here's a kernel config option for this:


--- linux-2.6.8.1/drivers/md/Kconfig.pre-secure-write	Sun Jan 16 13:28:21 2005
+++ linux-2.6.8.1/drivers/md/Kconfig	Thu Apr  7 09:25:55 2005
@@ -108,6 +108,21 @@
 
           If unsure, say N.
 
+config MD_RAID1_SECURE_WRITE
+        bool "Strict policy on writes for RAID1 (EXPERIMENTAL)"
+        depends on BLK_DEV_MD && EXPERIMENTAL && MD_RAID1
+        ---help---
+          This option makes RAID1 insist on writing all disks
+          successfully or else report an error back to the user.  This
+          avoids some difficult to deal with disaster situations in
+          which several disks survive but with different data, at the
+          cost of lesser robustness in everyday operation.  For the
+          paranoid more concerned with secure data replication than
+          real-time survival.  This is like the Musketeers' "all for one
+          and one for all".
+
+          If unsure, say N.
+
 config MD_RAID5
 	tristate "RAID-4/RAID-5 mode"
 	depends on BLK_DEV_MD

Here's the change to the md driver that allows "policy" to be set on
an array.

--- linux-2.6.8.1/drivers/md/md.c.pre-secure-write	Sat Apr 23 20:49:04 2005
+++ linux-2.6.8.1/drivers/md/md.c	Thu Apr  7 11:00:46 2005
@@ -2691,6 +2691,9 @@
 	/* Check there is only one change */
 	if (mddev->size != info->size) cnt++;
 	if (mddev->raid_disks != info->raid_disks) cnt++;
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+	if (mddev->policy != info->policy) cnt++;
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 	if (cnt == 0) return 0;
 	if (cnt > 1) return -EINVAL;
 
@@ -2759,6 +2762,11 @@
 			}
 		}
 	}
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+	if (mddev->policy != info->policy){
+            mddev->policy = info->policy;
+        }
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 	md_update_sb(mddev);
 	return rv;
 }


No for the changes to the mdadm (1.11.0) code that let one use

   mdadm --manage --policy=strict /dev/md0

one should be able to turn it off with

   mdadm --manage --policy=nonstrict /dev/md0

I believe.

I added the code that does the business to the Manage.c  code, as a
separate subroutine. The compile flag is set in mdadm.h.


diff -u -r mdadm-1.11.0.orig/Manage.c mdadm-1.11.0/Manage.c
--- mdadm-1.11.0.orig/Manage.c	Mon Apr 11 02:14:48 2005
+++ mdadm-1.11.0/Manage.c	Sat Apr 23 20:06:17 2005
@@ -271,3 +271,43 @@
 	return 0;
 	
 }
+
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+int Manage_policy(char *devname, int fd, int policy)
+{
+	mdu_array_info_t info;
+        int i;
+
+	if (ioctl(fd, GET_ARRAY_INFO, &info) != 0) {
+		fprintf(stderr, Name ": Cannot get array information for %s: %s\n",
+			devname, strerror(errno));
+		return 1;
+	}
+	info.policy = policy;
+	printf("policy set to");
+        if (policy) {
+                while ((i = ffs(policy)) != 0) {
+                        printf(" ");
+                        switch (1 << (i - 1)) {
+                        case MD_POLICY_STRICT:
+	                        printf("strict");
+                                break;
+                        default:
+	                        printf("unknown (bit %d)", i - 1);
+                                break;
+                        }
+                        policy &= ~(1 << (i - 1));
+                }
+        } else {
+                printf("none");
+        }
+	printf("\n");
+	if (ioctl(fd, SET_ARRAY_INFO, &info) != 0) {
+		fprintf(stderr, Name ": Cannot set policy for %s: %s\n",
+			devname, strerror(errno));
+		return 1;
+	}
+	return 0;
+}
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
+

Here's the changes for the getopt() call and the help printout, in
Readme.c.


diff -u -r mdadm-1.11.0.orig/ReadMe.c mdadm-1.11.0/ReadMe.c
--- mdadm-1.11.0.orig/ReadMe.c	Mon Apr 11 02:20:06 2005
+++ mdadm-1.11.0/ReadMe.c	Sat Apr 23 20:12:54 2005
@@ -90,7 +90,11 @@
  *     At the time if writing, there is only minimal support.
  */
 
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+char short_options[]="-ABCDEFGQhVvbc:i:l:p:m:n:x:u:c:d:z:U:P:sa::rfRSow1t";
+#else
 char short_options[]="-ABCDEFGQhVvbc:i:l:p:m:n:x:u:c:d:z:U:sa::rfRSow1t";
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 struct option long_options[] = {
     {"manage",    0, 0, '@'},
     {"misc",      0, 0, '#'},
@@ -143,6 +143,9 @@
     {"stop",      0, 0, 'S'},
     {"readonly",  0, 0, 'o'},
     {"readwrite", 0, 0, 'w'},
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+    {"policy",    1, 0, 'P'},
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 
     /* For Detail/Examine */
     {"brief",	  0, 0, 'b'},
@@ -376,6 +379,9 @@
 "  --stop        -S   : deactivate array, releasing all resources\n"
 "  --readonly    -o   : mark array as readonly\n"
 "  --readwrite   -w   : mark array as readwrite\n"
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+"  --policy=     -P   : policy for array\n"
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 ;
 
 char Help_misc[] =
diff -u -r mdadm-1.11.0.orig/md_u.h mdadm-1.11.0/md_u.h
--- mdadm-1.11.0.orig/md_u.h	Mon Apr 11 02:12:32 2005
+++ mdadm-1.11.0/md_u.h	Sat Apr 23 19:53:51 2005
@@ -78,7 +79,13 @@
 	 * Personality information
 	 */
 	int layout;		/*  0 the array's physical layout	      */
-	int chunk_size;	/*  1 chunk size in bytes		      */
+	int chunk_size;		/*  1 chunk size in bytes		      */
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+#  ifndef MD_POLICY_STRICT
+#    define MD_POLICY_STRICT 0x01
+#  endif /* MD_POLICY_STRICT */
+        int policy;             /*  2 array behavior modulation               */
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 
 } mdu_array_info_t;
 

The main() routine in mdadm.c has to look for the extra option:


diff -u -r mdadm-1.11.0.orig/mdadm.c mdadm-1.11.0/mdadm.c
--- mdadm-1.11.0.orig/mdadm.c	Mon Apr 11 02:12:32 2005
+++ mdadm-1.11.0/mdadm.c	Sat Apr 23 20:15:46 2005
@@ -56,6 +55,9 @@
 	char devmode = 0;
 	int runstop = 0;
 	int readonly = 0;
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+	int policy = 0, set_policy = 0;
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 	int SparcAdjust = 0;
 	mddev_dev_t devlist = NULL;
 	mddev_dev_t *devlistend = & devlist;
@@ -623,6 +625,20 @@
 			}
 			readonly = 1;
 			continue;
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+		case O(MANAGE,'P'):
+			if (strcmp(optarg, "strict")==0) {
+			        policy |= MD_POLICY_STRICT;
+                        } else if (strcmp(optarg, "nonstrict")==0) {
+			        policy &= ~MD_POLICY_STRICT;
+                        } else {
+				fprintf(stderr, Name ": Unknown policy %s\n",
+                                        optarg);
+				exit(2);
+			}
+                        set_policy = 1;
+			continue;
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 		case O(MANAGE,'w'):
 			if (readonly > 0) {
 				fprintf(stderr, Name ": Cannot have both readwrite and readonly.\n");
@@ -711,7 +727,7 @@
 	rv = 0;
 	switch(mode) {
 	case MANAGE:
-		/* readonly, add/remove, readwrite, runstop */
+		/* readonly, add/remove, readwrite, runstop, policy */
 		if (readonly>0)
 			rv = Manage_ro(devlist->devname, mdfd, readonly);
 		if (!rv && devs_found>1)
@@ -721,6 +737,10 @@
 			rv = Manage_ro(devlist->devname, mdfd, readonly);
 		if (!rv && runstop)
 			rv = Manage_runstop(devlist->devname, mdfd, runstop);
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+		if (!rv && set_policy)
+			rv = Manage_policy(devlist->devname, mdfd, policy);
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 		break;
 	case ASSEMBLE:
 		if (devs_found == 1 && ident.uuid_set == 0 &&


Here's the compile option being set in mdadm.h.


diff -u -r mdadm-1.11.0.orig/mdadm.h mdadm-1.11.0/mdadm.h
--- mdadm-1.11.0.orig/mdadm.h	Mon Apr 11 02:12:32 2005
+++ mdadm-1.11.0/mdadm.h	Sat Apr 23 19:56:54 2005
@@ -33,6 +33,8 @@
 extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #endif
 
+#define CONFIG_MD_RAID1_SECURE_WRITE 1
+
 #include	<sys/types.h>
 #include	<sys/stat.h>
 #include	<stdlib.h>
@@ -161,6 +163,9 @@
 extern int Manage_reconfig(char *devname, int fd, int layout);
 extern int Manage_subdevs(char *devname, int fd,
 			  mddev_dev_t devlist);
+#ifdef CONFIG_MD_RAID1_SECURE_WRITE
+extern int Manage_policy(char *devname, int fd, int policy);
+#endif /* CONFIG_MD_RAID1_SECURE_WRITE */
 extern int Grow_Add_device(char *devname, int fd, char *newdev);
 
 
and I also had to declare the extra routine used.

That's it.

Peter

