From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] Manage.c: Try to get EXCL access more times while stopping
 the array
Date: Wed, 03 Apr 2013 14:47:15 +0200
Message-ID: <20130403124715.23223.5137.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

If mdadm does not get EXCL access to the array, it should try again
after a while, because there still can be (for example)
a process of mdmon that is finishing aborting reshape.
If this fails couple of times, mdadm should stop
trying, print an error and abort stopping the array.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 Manage.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Manage.c b/Manage.c
index 6267c0c..23e7c85 100644
--- a/Manage.c
+++ b/Manage.c
@@ -222,7 +222,14 @@ int Manage_runstop(char *devname, int fd, int runstop,
 		 * to stop is probably a bad idea.
 		 */
 		close(fd);
-		fd = open(devname, O_RDONLY|O_EXCL);
+		count = 5;
+		while (((fd = open(devname, O_RDONLY|O_EXCL)) < 0 ||
+				strcmp(fd2devnm(fd), devnm) != 0) && count) {
+			if (fd >= 0)
+				close(fd);
+			usleep(200000);
+			count--;
+		}
 		if (fd < 0 || strcmp(fd2devnm(fd), devnm) != 0) {
 			if (fd >= 0)
 				close(fd);

