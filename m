From: Xiao Ni <xni@redhat.com>
Subject: [mdadm PATCH 1/1] Fix a build error
Date: Wed, 20 Sep 2017 11:48:28 +0800
Message-ID: <1505879308-6077-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jsorensen@fb.com, ncroxon@redhat.com, pmenzel@molgen.mpg.de, antlists@youngman.org.uk
List-Id: linux-raid.ids

On the s390 platform the build fails with the error below.
Manage.c: In function 'Manage_subdevs':
Manage.c:1502:5: error: passing argument 3 of 'fstat_is_blkdev' from incompatible pointer type [-Werror]
     fstat_is_blkdev(tfd, dv->devname, &rdev);
     ^
In file included from Manage.c:25:0:
mdadm.h:1446:12: note: expected 'dev_t *' but argument is of type 'long unsigned int *'

It was introduced by commit 0a6bff09 (mdadm/util: unify fstat
checking blkdev into function). It needs to pass a type 'dev_t'
argument to fstat_is_blkdev, but it passes a type 'unsigned
long' argument. So use a temporary variable to fix this.

Signed-off-by: Xiao Ni <xni@redhat.com>
Suggested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Suggested-by: Wols Lists <antlists@youngman.org.uk>
---
 Manage.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Manage.c b/Manage.c
index 871d342..6de1fc2 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1497,13 +1497,14 @@ int Manage_subdevs(char *devname, int fd,
 			 */
 			rdev = makedev(mj, mn);
 		} else {
+			dev_t device_id;
 			tfd = dev_open(dv->devname, O_RDONLY);
 			if (tfd >= 0) {
-				fstat_is_blkdev(tfd, dv->devname, &rdev);
+				fstat_is_blkdev(tfd, dv->devname, &device_id);
 				close(tfd);
 			} else {
 				int open_err = errno;
-				if (!stat_is_blkdev(dv->devname, &rdev)) {
+				if (!stat_is_blkdev(dv->devname, &device_id)) {
 					if (dv->disposition == 'M')
 						/* non-fatal. Also improbable */
 						continue;
@@ -1523,6 +1524,7 @@ int Manage_subdevs(char *devname, int fd,
 					goto abort;
 				}
 			}
+			rdev = (unsigned long)device_id;
 		}
 		switch(dv->disposition){
 		default:
-- 
2.7.4

