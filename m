From: wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>
Subject: mdadm: using ioctl to set disk faulty instead of sysfs
Date: Tue, 21 Nov 2017 21:09:46 +0800
Message-ID: <33BB30F4-F2A1-437B-ABFE-6A03E9563F01@mails.ucas.ac.cn>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I have a suggest about mdadm to set disk faulty. Since commit 1ca69c4bc4b1ef
(md: avoid taking the mutex on some ioctls) removes lock when set disk faulty,
so we'd better using ioctl(SET_DISK_FAULTY) to set disk faulty, instead of 
echo faulty > /sys/block/<md>/md/dev-<disk>/state, because caller of state's
handler would lock mddev. Like following:

Index: mdadm-4.0/Manage.c
===================================================================
--- mdadm-4.0.orig/Manage.c
+++ mdadm-4.0/Manage.c
@@ -1662,9 +1662,7 @@ int Manage_subdevs(char *devname, int fd
 
 		case 'f': /* set faulty */
 			/* FIXME check current member */
-			if ((sysfd >= 0 && write(sysfd, "faulty", 6) != 6) ||
-			    (sysfd < 0 && ioctl(fd, SET_DISK_FAULTY,
-						rdev))) {
+			if (ioctl(fd, SET_DISK_FAULTY, rdev)) {
 				if (errno == EBUSY)
 					busy = 1;
 				pr_err("set device faulty failed for %s:  %s\n",

