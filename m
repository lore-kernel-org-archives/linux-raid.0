From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] Remove: container should wait for an array to release a drive
Date: Mon, 18 Jul 2016 14:11:30 +0200
Message-ID: <1468843890-30425-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

A 'faulty' drive is being removed from a container after it has been
released by an array, however there is a race there. The drive is
released asynchronously by a monitor but sometimes it doesn't happen
before container checks it. It results in a container refusing to remove
a drive as it still seems to be a part of some array.

It seems 'ping_monitor' could be a solution here to assure monitor has
had a chance to process the events, however it doesn't resolve the
problem - sometimes an array has to request a release of the drive few
times (as the array is busy) and single 'ping_monitor' call is not
sufficient. As there is no way to query monitor progress, it forces us
to retry a check several times before an error is returned.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 Manage.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/Manage.c b/Manage.c
index e2e88b8..7f8eb88 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1125,19 +1125,31 @@ int Manage_remove(struct supertype *tst, int fd, struct mddev_dev *dv,
 		 */
 		if (rdev == 0)
 			ret = -1;
-		else
-			ret = sysfs_unique_holder(devnm, rdev);
-		if (ret == 0) {
-			pr_err("%s is not a member, cannot remove.\n",
-			       dv->devname);
-			close(lfd);
-			return -1;
-		}
-		if (ret >= 2) {
-			pr_err("%s is still in use, cannot remove.\n",
-			       dv->devname);
-			close(lfd);
-			return -1;
+		else {
+			/* The drive has already been set to 'faulty', however monitor might
+			 * not have had time to process it and the drive might still have
+			 * an entry in the 'holders' directory. Try a few times to avoid
+			 * a false error */
+			int count = 20;
+			do {
+				ret = sysfs_unique_holder(devnm, rdev);
+				if (ret < 2)
+					break;
+				usleep(100000);
+			} while (--count > 0);
+
+			if (ret == 0) {
+				pr_err("%s is not a member, cannot remove.\n",
+					dv->devname);
+				close(lfd);
+				return -1;
+			}
+			if (ret >= 2) {
+				pr_err("%s is still in use, cannot remove.\n",
+					dv->devname);
+				close(lfd);
+				return -1;
+			}
 		}
 	}
 	/* FIXME check that it is a current member */
-- 
1.8.3.1

