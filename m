From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH] missing close in mdassemble
Date: Fri, 15 Sep 2006 08:56:58 +0200
Message-ID: <20060915065658.GE25819@percy.comedia.it>
References: <20060913145743.GH32581@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060913145743.GH32581@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Wed, Sep 13, 2006 at 04:57:43PM +0200, Luca Berra wrote:
>attached, please apply
>without this mdassemble cannot activate stacked arrays, i wonder how i
>managed to miss it :(
>
Another patch which obsoletes the previous one
this will make mdassemble, if run a second time, try to make
arrays read-write. Useful if one starts arrays readonly as described in
README.initramfs, after resume fails.

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--YZ5djTAD1cGYuMQK
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

--YZ5djTAD1cGYuMQK--
