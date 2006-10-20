From: "Michael Labuschke" <michael@labuschke.de>
Subject: patches
Date: Fri, 20 Oct 2006 19:00:18 +0200
Message-ID: <20061020170016.C183895C422@futec-gmbh.de>
Mime-Version: 1.0
Content-Type: text/plain;
	name="mdadm-2.5.4-gcc_warnings-1.patch"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: attachment;
	filename="mdadm-2.5.4-gcc_warnings-1.patch"
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

diff -uNr mdadm-2.5.4.orig/mdopen.c mdadm-2.5.4/mdopen.c
--- mdadm-2.5.4.orig/mdopen.c	2006-08-11 10:00:03.000000000 +0200
+++ mdadm-2.5.4/mdopen.c	2006-10-20 18:39:25.000000000 +0200
@@ -44,7 +44,8 @@
 		strcpy(new+7, new+8);
 	else
 		new[7] = '_';
-	symlink(dev+5, new);
+	if(symlink(dev+5, new))
+	    perror("symlink");
 }
 
 
@@ -258,7 +259,8 @@
 
 			if (strncmp(dev, "/dev/md/", 8) == 0) {
 				if (mkdir("/dev/md",0700)==0) {
-					chown("/dev/md", ci->uid, ci->gid);
+					if (chown("/dev/md", ci->uid, ci->gid))
+					    perror("chown");
 					chmod("/dev/md", ci->mode| ((ci->mode>>2) & 0111));
 				}
 			}

