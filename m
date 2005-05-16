From: Luca Berra <bluca@comedia.it>
Subject: [PATCH] gcc4 build fix and manpage for mdassemble
Date: Mon, 16 May 2005 22:05:27 +0200
Message-ID: <20050516200527.GC8580@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="96YOpH+ONegL0A3E"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

patches for 1.11.0
first one fixes compiling with gcc4 which is quite picky about
signedness
second one adds a man page for mdassemble


Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-1.11.0-gcc4.patch"

--- mdadm-1.11.0/util.c.gcc4	2005-04-11 02:12:32.000000000 +0200
+++ mdadm-1.11.0/util.c	2005-05-16 21:38:19.000000000 +0200
@@ -38,7 +38,7 @@
  * If not exactly 32 hex digits are found, return 0
  * else return 1
  */
-int parse_uuid(char *str, int uuid[4])
+int parse_uuid(char *str, __u32 uuid[4])
 {
     int hit = 0; /* number of Hex digIT */
     int i;
@@ -140,7 +140,7 @@
 	}
 }
 
-int same_uuid(int a[4], int b[4])
+int same_uuid(__u32 a[4], __u32 b[4])
 {
     if (a[0]==b[0] &&
 	a[1]==b[1] &&
@@ -150,7 +150,7 @@
     return 0;
 }
 
-void uuid_from_super(int uuid[4], mdp_super_t *super)
+void uuid_from_super(__u32 uuid[4], mdp_super_t *super)
 {
     uuid[0] = super->set_uuid0;
     if (super->minor_version >= 90) {
@@ -173,7 +173,7 @@
      *  2 wrong uuid
      *  3 wrong other info
      */
-    int uuid1[4], uuid2[4];
+    __u32 uuid1[4], uuid2[4];
     if (second->md_magic != MD_SB_MAGIC)
 	return 1;
     if (first-> md_magic != MD_SB_MAGIC) {
@@ -329,8 +329,8 @@
 		return 0;
 	if (read(fd, sb, 1024) != 1024)
 		return 0;
-	if (strncmp(sb+52, "ReIsErFs",8)!=0 &&
-	    strncmp(sb+52, "ReIsEr2Fs",9)!=0)
+	if (strncmp((char *) sb+52, "ReIsErFs",8)!=0 &&
+	    strncmp((char *) sb+52, "ReIsEr2Fs",9)!=0)
 		return 0;
 	fprintf(stderr, Name ": %s appears to contain a reiserfs file system\n",name);
 	size = sb[0]|(sb[1]|(sb[2]|sb[3]<<8)<<8)<<8;
@@ -512,7 +512,7 @@
 	unsigned long long newcsum = 0;
 	unsigned long csum;
 	int i;
-	unsigned int *superc = (int*) super;
+	unsigned int *superc = (unsigned int*) super;
 	super->sb_csum = 0;
 
 	for(i=0; i<MD_SB_BYTES/4; i++)
--- mdadm-1.11.0/mdadm.h.gcc4	2005-04-11 02:12:32.000000000 +0200
+++ mdadm-1.11.0/mdadm.h	2005-05-16 21:37:35.000000000 +0200
@@ -194,7 +194,7 @@
 
 extern int md_get_version(int fd);
 extern int get_linux_version(void);
-extern int parse_uuid(char *str, int uuid[4]);
+extern int parse_uuid(char *str, __u32 uuid[4]);
 extern int check_ext2(int fd, char *name);
 extern int check_reiser(int fd, char *name);
 extern int check_raid(int fd, char *name);
@@ -212,8 +212,8 @@
 extern void free_line(char *line);
 extern int match_oneof(char *devices, char *devname);
 extern int load_super(int fd, mdp_super_t *super);
-extern void uuid_from_super(int uuid[4], mdp_super_t *super);
-extern int same_uuid(int a[4], int b[4]);
+extern void uuid_from_super(__u32 uuid[4], mdp_super_t *super);
+extern int same_uuid(__u32 a[4], __u32 b[4]);
 extern int compare_super(mdp_super_t *first, mdp_super_t *second);
 extern unsigned long calc_sb_csum(mdp_super_t *super);
 extern int store_super(int fd, mdp_super_t *super);
--- mdadm-1.11.0/Assemble.c.gcc4	2005-04-11 02:12:32.000000000 +0200
+++ mdadm-1.11.0/Assemble.c	2005-05-16 21:38:36.000000000 +0200
@@ -178,7 +178,7 @@
 
 	while ( devlist) {
 		char *devname;
-		int this_uuid[4];
+		__u32 this_uuid[4];
 		int dfd;
 		struct stat stb;
 		int havesuper=0;

--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-1.11.0-mdassemble-man.patch"

--- mdadm-1.11.0/mdassemble.8.mdassembleman	2005-05-16 21:41:08.000000000 +0200
+++ mdadm-1.11.0/mdassemble.8	2005-05-16 21:01:19.000000000 +0200
@@ -0,0 +1,59 @@
+.\" -*- nroff -*-
+.TH MDASSEMBLE 8 "" v1.11.0
+.SH NAME
+mdassemble \- assemble MD devices
+.I aka
+Linux Software Raid.
+
+.SH SYNOPSIS
+
+.BI mdassemble
+
+.SH DESCRIPTION 
+.B mdassemble
+is a tiny program that can be used to assemble MD devices inside an
+initial ramdisk (initrd) or initramfs, it is meant to replace the in-kernel
+automatic raid detection and activation.
+It can be built statically and linked against lightweight libc alternatives, like
+.B dietlibc,
+.B klibc
+or
+.B uClibc.
+
+.SH USAGE
+Invoking
+.B mdassemble
+has the same effect as invoking
+.B mdadm --assemble --scan.
+
+.SH OPTIONS
+
+There are no options to
+.B mdassemble.
+
+.SH FILES
+
+.SS /etc/mdadm.conf
+
+The config file lists which devices may be scanned to see if
+they contain MD super block, and gives identifying information
+(e.g. UUID) about known MD arrays.  See
+.BR mdadm.conf (5)
+for more details.
+
+.B mdassemble
+supports all configuration parameters defined in
+.B mdadm.conf
+with the exception of
+.B auto=
+which is supported only if mdadm was built with the 
+.B -DMDASSEMBLE_AUTO
+define.
+
+.SH SEE ALSO
+.PP
+.BR mdadm (8),
+.BR mdadm.conf (5),
+.BR md (4).
+.PP
+.BR diet (1).
--- mdadm-1.11.0/Makefile.mdassembleman	2005-04-11 02:12:32.000000000 +0200
+++ mdadm-1.11.0/Makefile	2005-05-16 21:40:56.000000000 +0200
@@ -67,7 +67,7 @@
 ASSEMBLE_FLAGS = -DMDASSEMBLE_AUTO
 endif
 
-all : mdadm mdadm.man md.man mdadm.conf.man
+all : mdadm mdadm.man md.man mdadm.conf.man mdassemble.man
 
 everything: all mdadm.static mdadm.tcc mdadm.uclibc
 
@@ -113,6 +113,9 @@
 mdadm.conf.man : mdadm.conf.5
 	nroff -man mdadm.conf.5 > mdadm.conf.man
 
+mdassemble.man : mdassemble.8
+	nroff -man mdassemble.8 > mdassemble.man
+
 $(OBJS) : mdadm.h
 
 install : mdadm mdadm.8 md.4 mdadm.conf.5

--96YOpH+ONegL0A3E--
