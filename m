From: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: [PATCH] debian: symlink mdmon pidfile into /run/sendsigs.omit.d
Date: Fri, 24 Aug 2012 11:57:27 +0200
Message-ID: <50375007.5070401@xs4all.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030004090700030400000708"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------030004090700030400000708
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Some daemons should not be killed when the system is shutting down. In 
debian this is achieved by putting a file with the pid of the daemon in 
it in /run/sendsigs.omit.d (or a symlink to its pidfile).

This patch lets mdmon automatically create a symlink in 
/run/sendsigs.omit.d to its pidfile.

See also debian bug 684708 at
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=684708  ,
where I submitted a previous version of this patch.

Comments welcome.

Thanks,

Mike.

--------------030004090700030400000708
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="debian-sendsigs-omit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="debian-sendsigs-omit.patch"

Index: mdadm-3.2.5/mdmon.c
===================================================================
--- mdadm-3.2.5.orig/mdmon.c	2012-08-13 09:46:43.205209547 +0000
+++ mdadm-3.2.5/mdmon.c	2012-08-24 09:44:45.472421616 +0000
@@ -142,6 +142,9 @@
 
 static int make_pidfile(char *devname)
 {
+#ifdef SENDSIGS_OMIT_DIR
+	char sendsigs_omit_path[100];
+#endif
 	char path[100];
 	char pid[10];
 	int fd;
@@ -160,6 +163,13 @@
 	close(fd);
 	if (n < 0)
 		return -errno;
+
+#ifdef SENDSIGS_OMIT_DIR
+	/* automatically symlink pidfile to sendsigs.omit.d/. ignore result. */
+	sprintf(sendsigs_omit_path, "%s/%s.pid", SENDSIGS_OMIT_DIR, devname);
+	symlink(path, sendsigs_omit_path);
+#endif
+
 	return 0;
 }
 
@@ -211,6 +221,11 @@
 	unlink(buf);
 	sprintf(buf, "%s/%s.sock", MDMON_DIR, devname);
 	unlink(buf);
+#ifdef SENDSIGS_OMIT_DIR
+	sprintf(buf, "%s/%s.pid", SENDSIGS_OMIT_DIR, devname);
+	unlink(buf);
+#endif
+
 }
 
 static int make_control_sock(char *devname)
Index: mdadm-3.2.5/mdadm.h
===================================================================
--- mdadm-3.2.5.orig/mdadm.h	2012-05-18 07:10:03.000000000 +0000
+++ mdadm-3.2.5/mdadm.h	2012-08-24 09:41:53.205479556 +0000
@@ -102,6 +102,16 @@
 #define FAILED_SLOTS_DIR "/run/mdadm/failed-slots"
 #endif /* FAILED_SLOTS */
 
+/* Debian has a sendsigs.omit.d directory where pidfiles are located
+ * of daemons that should not be killed when shutting down. We symlink
+ * the mdmon pidfiles into this directory.
+ */
+#ifdef DEBIAN
+#ifndef SENDSIGS_OMIT_DIR
+#define SENDSIGS_OMIT_DIR "/run/sendsigs.omit.d"
+#endif
+#endif
+
 #include	"md_u.h"
 #include	"md_p.h"
 #include	"bitmap.h"

--------------030004090700030400000708--
