From: Luca Berra <bluca@comedia.it>
Subject: Re: ANNOUNCE: mdadm 2.5.4 - A tool for managing Soft RAID under Linux
Date: Fri, 13 Oct 2006 20:14:31 +0200
Message-ID: <20061013181430.GA7549@percy.comedia.it>
References: <17710.55975.316262.98110@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17710.55975.316262.98110@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Fri, Oct 13, 2006 at 10:15:35AM +1000, Neil Brown wrote:
>
>I am pleased to announce the availability of
>   mdadm version 2.5.4

it looks like you did not include the patches i posted against 2.5.3



-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.5.3-active.patch"

* Sat Aug 19 2006 Luca Berra <bluca@vodka.it>
- do not fail when autoassembling everything and some md are already active

--- mdadm-2.5.3/mdadm.c	2006-08-19 17:00:51.000000000 +0200
+++ mdadm-2.5.3/mdadm.c	2006-08-19 16:30:16.000000000 +0200
@@ -1020,7 +1020,7 @@
 				}
 				if (ioctl(mdfd, GET_ARRAY_INFO, &array)>=0)
 					/* already assembled, skip */
-					;
+					cnt++;
 				else {
 					rv |= Assemble(ss, array_list->devname, mdfd,
 						       array_list,
--- mdadm-2.5.3/mdopen.c	2006-06-26 07:11:00.000000000 +0200
+++ mdadm-2.5.3/mdopen.c	2006-08-19 17:03:24.000000000 +0200
@@ -166,10 +166,7 @@
 			}
 			if (ioctl(mdfd, GET_ARRAY_INFO, &array)==0) {
 				/* already active */
-				close(mdfd);
-				fprintf(stderr, Name ": %s is already active.\n",
-					dev);
-				return -1;
+				return mdfd;
 			} else {
 				if (major != MD_MAJOR && parts > 0)
 					make_parts(dev, parts);

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.5.3-mdassemble.patch"

--- mdadm-2.5.3/mdassemble.c.close	2006-06-26 07:11:00.000000000 +0200
+++ mdadm-2.5.3/mdassemble.c	2006-09-13 17:23:15.000000000 +0200
@@ -91,13 +91,14 @@
 				rv |= 1;
 				continue;
 			}
-			if (ioctl(mdfd, GET_ARRAY_INFO, &array)>=0)
-				/* already assembled, skip */
-				continue;
-			rv |= Assemble(array_list->st, array_list->devname, mdfd,
-					   array_list,
-					   NULL, NULL,
+			if (ioctl(mdfd, GET_ARRAY_INFO, &array) < 0) {
+				rv |= Assemble(array_list->st, array_list->devname, mdfd,
+					   array_list, NULL, NULL,
 					   readonly, runstop, NULL, NULL, verbose, force);
+			} else {
+				rv |= Manage_ro(array_list->devname, mdfd, -1); /* make it readwrite */
+			}
+			close(mdfd);
 		}
 	return rv;
 }
--- mdadm-2.5.3/Makefile.close	2006-06-20 02:01:17.000000000 +0200
+++ mdadm-2.5.3/Makefile	2006-09-13 17:54:36.000000000 +0200
@@ -76,7 +76,7 @@
 STATICSRC = pwgr.c
 STATICOBJS = pwgr.o
 
-ASSEMBLE_SRCS := mdassemble.c Assemble.c config.c dlink.c util.c super0.c super1.c sha1.c
+ASSEMBLE_SRCS := mdassemble.c Assemble.c Manage.c config.c dlink.c util.c super0.c super1.c sha1.c
 ASSEMBLE_FLAGS:= $(CFLAGS) -DMDASSEMBLE
 ifdef MDASSEMBLE_AUTO
 ASSEMBLE_SRCS += mdopen.c mdstat.c
--- mdadm-2.5.3/Manage.c.close	2006-06-26 04:26:07.000000000 +0200
+++ mdadm-2.5.3/Manage.c	2006-09-13 17:25:31.000000000 +0200
@@ -72,6 +72,8 @@
 	return 0;			
 }
 
+#ifndef MDASSEMBLE
+
 int Manage_runstop(char *devname, int fd, int runstop, int quiet)
 {
 	/* Run or stop the array. array must already be configured
@@ -393,3 +395,5 @@
 	return 0;
 	
 }
+
+#endif /* MDASSEMBLE */
--- mdadm-2.5.3/util.c.close	2006-09-13 17:29:19.000000000 +0200
+++ mdadm-2.5.3/util.c	2006-09-13 18:08:56.000000000 +0200
@@ -189,6 +189,7 @@
 	}
 }
 
+#ifndef MDASSEMBLE
 int check_ext2(int fd, char *name)
 {
 	/*
@@ -286,6 +287,7 @@
 	fprintf(stderr, Name ": assuming 'no'\n");
 	return 0;
 }
+#endif /* MDASSEMBLE */
 
 char *map_num(mapping_t *map, int num)
 {
@@ -307,7 +309,6 @@
 	return UnSet;
 }
 
-
 int is_standard(char *dev, int *nump)
 {
 	/* tests if dev is a "standard" md dev name.
@@ -482,6 +483,7 @@
 	return csum;
 }
 
+#ifndef MDASSEMBLE
 char *human_size(long long bytes)
 {
 	static char buf[30];
@@ -534,7 +536,9 @@
 			);
 	return buf;
 }
+#endif /* MDASSEMBLE */
 
+#if !defined(MDASSEMBLE) || defined(MDASSEMBLE) && defined(MDASSEMBLE_AUTO)
 int get_mdp_major(void)
 {
 static int mdp_major = -1;
@@ -618,6 +622,7 @@
 	if (strncmp(name, "/dev/.tmp.md", 12)==0)
 		unlink(name);
 }
+#endif /* !defined(MDASSEMBLE) || defined(MDASSEMBLE) && defined(MDASSEMBLE_AUTO) */
 
 int dev_open(char *dev, int flags)
 {
--- mdadm-2.5.3/mdassemble.8.close	2006-08-07 03:33:56.000000000 +0200
+++ mdadm-2.5.3/mdassemble.8	2006-09-13 18:25:41.000000000 +0200
@@ -25,6 +25,13 @@
 .B mdassemble
 has the same effect as invoking
 .B mdadm --assemble --scan.
+.PP
+Invoking
+.B mdassemble
+a second time will make all defined arrays readwrite, this is useful if
+using the
+.B start_ro
+module parameter.
 
 .SH OPTIONS
 
@@ -54,6 +61,5 @@
 .PP
 .BR mdadm (8),
 .BR mdadm.conf (5),
-.BR md (4).
-.PP
+.BR md (4),
 .BR diet (1).

--YiEDa0DAkWCtVeE4--
