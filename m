From: Luca Berra <bluca@comedia.it>
Subject: Re: ANNOUNCE: mdadm 1.8.1 - A tool for managing Soft RAID under Linux - DEVELOPMENT version
Date: Mon, 15 Nov 2004 23:48:52 +0100
Message-ID: <20041115224851.GD18023@percy.comedia.it>
References: <16778.61523.790174.893484@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="24zk1gE8NUlDmwG9"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16778.61523.790174.893484@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Fri, Nov 05, 2004 at 02:15:31PM +1100, Neil Brown wrote:
>
>
>I am pleased to announce the availability of 
>   mdadm version 1.8.1
i am pleased to respond with some patches to mdadm 1.8.1 :)

1) resurrect mdassemble
2) fix a nasty bug with uninitialized struct mddev_ident_s.

i would also like some comments on:
3) switch from lseek64 to _FILE_OFFSET_BITS=64 and plain lseek
but please don't apply it yet, it makes mdassemle work on 64bit
dietlibc, which does not have lseek64, but breaks it on 32bit dietlibc
(ftw fails).

regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-1.8.1-mdassemble-fix.patch"

diff -urN mdadm-1.8.1/mdadm.h mdadm-1.8.1.1/mdadm.h
--- mdadm-1.8.1/mdadm.h	2004-11-14 12:22:31.633374737 +0100
+++ mdadm-1.8.1.1/mdadm.h	2004-11-14 12:34:37.176005933 +0100
@@ -39,12 +39,6 @@
 #include	<stdio.h>
 #include	<errno.h>
 #include	<string.h>
-#ifdef __dietlibc__NONO
-int strncmp(const char *s1, const char *s2, size_t n) __THROW __pure__;
-char *strncpy(char *dest, const char *src, size_t n) __THROW;
-#include    <strings.h>
-#endif
-
 
 #include	<linux/kdev_t.h>
 /*#include	<linux/fs.h> */
diff -urN mdadm-1.8.1/mdassemble.c mdadm-1.8.1.1/mdassemble.c
--- mdadm-1.8.1/mdassemble.c	2004-11-05 03:53:56.000000000 +0100
+++ mdadm-1.8.1.1/mdassemble.c	2004-11-14 12:29:59.251085547 +0100
@@ -32,6 +32,20 @@
 #include "md_p.h"
 
 /* from readme.c */
+mapping_t r5layout[] = {
+	{ "left-asymmetric", 0},
+	{ "right-asymmetric", 1},
+	{ "left-symmetric", 2},
+	{ "right-symmetric", 3},
+
+	{ "default", 2},
+	{ "la", 0},
+	{ "ra", 1},
+	{ "ls", 2},
+	{ "rs", 3},
+	{ NULL, 0}
+};
+
 mapping_t pers[] = {
 	{ "linear", -1},
 	{ "raid0", 0},
@@ -50,6 +64,7 @@
 	{ "6", 6},
 	{ "raid10", 10},
 	{ "10", 10},
+	{ "faulty", -5},
 	{ NULL, 0}
 };
 

--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-1.8.1-memset.patch"

--- mdadm-1.8.1/mdadm.c.bluca	2004-11-14 19:44:26.000000000 +0100
+++ mdadm-1.8.1/mdadm.c	2004-11-14 19:44:31.747309097 +0100
@@ -80,11 +80,10 @@
 
 	int mdfd = -1;
 
-	ident.uuid_set=0;
+	memset(&ident,0,sizeof(struct mddev_ident_s));
 	ident.level = UnSet;
 	ident.raid_disks = UnSet;
 	ident.super_minor= UnSet;
-	ident.devices=0;
 
 	while ((option_index = -1) ,
 	       (opt=getopt_long(argc, argv,
--- mdadm-1.8.1/config.c.bluca	2004-11-02 06:11:06.000000000 +0100
+++ mdadm-1.8.1/config.c	2004-11-14 19:44:35.693660204 +0100
@@ -266,15 +266,11 @@
 	struct mddev_ident_s mis;
 	mddev_ident_t mi;
 
-	mis.uuid_set = 0;
+	memset(&mis,0,sizeof(struct mddev_ident_s));
 	mis.super_minor = UnSet;
 	mis.level = UnSet;
 	mis.raid_disks = UnSet;
 	mis.spare_disks = UnSet;
-	mis.devices = NULL;
-	mis.devname = NULL;
-	mis.spare_group = NULL;
-	mis.autof = 0;
 
 	for (w=dl_next(line); w!=line; w=dl_next(w)) {
 		if (w[0] == '/') {

--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-1.8.1-lseek64.patch"

diff -urN mdadm-1.8.1/mdadm.h mdadm-1.8.1.1/mdadm.h
--- mdadm-1.8.1/mdadm.h	2004-11-02 06:11:06.000000000 +0100
+++ mdadm-1.8.1.1/mdadm.h	2004-11-14 12:22:31.633374737 +0100
@@ -28,11 +28,8 @@
  */
 
 #define	__USE_LARGEFILE64
+#define	_FILE_OFFSET_BITS 64
 #include	<unistd.h>
-#ifndef __dietlibc__
-extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
-#endif
-
 #include	<sys/types.h>
 #include	<sys/stat.h>
 #include	<stdlib.h>
diff -urN mdadm-1.8.1/super0.c mdadm-1.8.1.1/super0.c
--- mdadm-1.8.1/super0.c	2004-11-03 07:10:12.000000000 +0100
+++ mdadm-1.8.1.1/super0.c	2004-11-14 12:25:51.365232725 +0100
@@ -409,7 +409,7 @@
 
 	offset *= 512;
 
-	if (lseek64(fd, offset, 0)< 0LL)
+	if (lseek(fd, offset, 0)< 0LL)
 		return 3;
 
 	if (write(fd, super, sizeof(*super)) != sizeof(*super))
@@ -518,7 +518,7 @@
 
 	ioctl(fd, BLKFLSBUF, 0); /* make sure we read current data */
 
-	if (lseek64(fd, offset, 0)< 0LL) {
+	if (lseek(fd, offset, 0)< 0LL) {
 		if (devname)
 			fprintf(stderr, Name ": Cannot seek to superblock on %s: %s\n",
 				devname, strerror(errno));
diff -urN mdadm-1.8.1/super1.c mdadm-1.8.1.1/super1.c
--- mdadm-1.8.1/super1.c	2004-11-05 04:07:37.000000000 +0100
+++ mdadm-1.8.1.1/super1.c	2004-11-14 12:26:12.448733642 +0100
@@ -446,7 +446,7 @@
     
 	sb_offset = __le64_to_cpu(sb->super_offset) << 9;
 
-	if (lseek64(fd, sb_offset, 0)< 0LL)
+	if (lseek(fd, sb_offset, 0)< 0LL)
 		return 3;
 
 	sbsize = sizeof(*sb) + 2 * __le32_to_cpu(sb->max_dev);
@@ -644,7 +644,7 @@
 	ioctl(fd, BLKFLSBUF, 0); /* make sure we read current data */
 
 
-	if (lseek64(fd, sb_offset << 9, 0)< 0LL) {
+	if (lseek(fd, sb_offset << 9, 0)< 0LL) {
 		if (devname)
 			fprintf(stderr, Name ": Cannot seek to superblock on %s: %s\n",
 				devname, strerror(errno));

--24zk1gE8NUlDmwG9--
