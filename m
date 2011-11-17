From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: [PATCH] mdadm trivial: Print more detailed error messages on re-add failure
Date: Thu, 17 Nov 2011 16:47:34 +0200
Message-ID: <CAGRgLy4sj348bUtmszf0dRUsLa+ocbzCzdirFkeE5nAdNR=Q8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Neil,
I realize this patch is very trivial, but I want also to see how this
process of submitting patches works.
I produced this patch on top of commit
945f0fcd0179210ae5b72006c3621a73cc6e9205 (Release mdadm-3.1.5). Do I
need to merge it on top of the latest commit and re-submit?

From 3ab91e5cac373af9c177c2cf129a259a50e936ae Mon Sep 17 00:00:00 2001
From: Alex Lyakas <alex@zadarastorage.com>
Date: Thu, 17 Nov 2011 16:39:27 +0200
Subject: [PATCH] Print more detailed error messages on re-add failure.

---
 Manage.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)
 mode change 100644 => 100755 Manage.c

diff --git a/Manage.c b/Manage.c
old mode 100644
new mode 100755
index 3502175..fc635f7
--- a/Manage.c
+++ b/Manage.c
@@ -707,10 +707,21 @@ int Manage_subdevs(char *devname, int fd,
 						 * make sure kernel will accept it though.
 						 */
 						disc.number = mdi.disk.number;
-						if (ioctl(fd, GET_DISK_INFO, &disc) != 0
-						    || disc.major != 0 || disc.minor != 0
-						    || !enough_fd(fd))
+						if (ioctl(fd, GET_DISK_INFO, &disc) != 0) {
+							fprintf(stderr, Name ": GET_DISK_INFO failed for %s: %s\n",
+								    devname, strerror(errno));
 							goto skip_re_add;
+						}
+						if (disc.major != 0 || disc.minor != 0) {
+							fprintf(stderr, Name ": descriptor index of %s(%d) is already
occupied\n",
+								    add_dev, mdi.disk.number);
+							goto skip_re_add;
+						}
+						if (!enough_fd(fd)) {
+							fprintf(stderr, Name ": %s is FAILED, cannot re-add in this
state\n", devname);
+							goto skip_re_add;
+						}
+
 						disc.major = major(stb.st_rdev);
 						disc.minor = minor(stb.st_rdev);
 						disc.number = mdi.disk.number;
@@ -738,8 +749,14 @@ int Manage_subdevs(char *devname, int fd,
 								continue;
 							return 1;
 						}
+						fprintf(stderr, Name ": add new device failed for %s: %s\n",
+							add_dev, strerror(errno));
+
 					skip_re_add:
 						re_add_failed = 1;
+					} else {
+						fprintf(stderr,
+							Name ": %s is in wrong state or has wrong array UUID; cannot
re-add\n", add_dev);
 					}
 				}
 				if (add_dev != dv->devname) {
-- 
1.7.4.1
