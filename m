From: Xiao Ni <xni@redhat.com>
Subject: [mdadm PATCH 1/1] Fix a building error
Date: Tue, 19 Sep 2017 18:14:41 +0800
Message-ID: <1505816081-7887-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: zlliu@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In s390 platform, it gives a building error:
Manage.c: In function 'Manage_subdevs':
Manage.c:1502:5: error: passing argument 3 of 'fstat_is_blkdev' from incompatible pointer type [-Werror]
     fstat_is_blkdev(tfd, dv->devname, &rdev);
     ^
In file included from Manage.c:25:0:
mdadm.h:1446:12: note: expected 'dev_t *' but argument is of type 'long unsigned int *'

It was introduced by 0a6bff09 and add a temp variable to fix this.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Manage.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Manage.c b/Manage.c
index 871d342..fbb07ce 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1497,13 +1497,14 @@ int Manage_subdevs(char *devname, int fd,
 			 */
 			rdev = makedev(mj, mn);
 		} else {
+			dev_t rdev_tmp;
 			tfd = dev_open(dv->devname, O_RDONLY);
 			if (tfd >= 0) {
-				fstat_is_blkdev(tfd, dv->devname, &rdev);
+				fstat_is_blkdev(tfd, dv->devname, &rdev_tmp);
 				close(tfd);
 			} else {
 				int open_err = errno;
-				if (!stat_is_blkdev(dv->devname, &rdev)) {
+				if (!stat_is_blkdev(dv->devname, &rdev_tmp)) {
 					if (dv->disposition == 'M')
 						/* non-fatal. Also improbable */
 						continue;
@@ -1523,6 +1524,7 @@ int Manage_subdevs(char *devname, int fd,
 					goto abort;
 				}
 			}
+			rdev = (unsigned long)rdev_tmp;
 		}
 		switch(dv->disposition){
 		default:
-- 
2.7.4

