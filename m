From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] Manage.c: Try to get EXCL access more times while stopping
 the array
Date: Wed, 10 Apr 2013 16:00:29 +0200
Message-ID: <20130410140029.19194.22973.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

If mdadm does not get EXCL access to the array
and it is managed by mdmon, it should flush monitor
and try again, because there still can be (for example)
a process that is finishing aborting reshape.
If this fails couple of times, mdadm should stop trying,
print an error and abort stopping the array.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 Manage.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Manage.c b/Manage.c
index 6267c0c..f557662 100644
--- a/Manage.c
+++ b/Manage.c
@@ -222,7 +222,15 @@ int Manage_runstop(char *devname, int fd, int runstop,
 		 * to stop is probably a bad idea.
 		 */
 		close(fd);
-		fd = open(devname, O_RDONLY|O_EXCL);
+		count = 10;
+		while (((fd = open(devname, O_RDONLY|O_EXCL)) < 0 ||
+				strcmp(fd2devnm(fd), devnm) != 0)
+				&& mdmon_running(devnm) && count) {
+				if (fd >= 0)
+					close(fd);
+				flush_mdmon(devnm);
+				count--;
+		}
 		if (fd < 0 || strcmp(fd2devnm(fd), devnm) != 0) {
 			if (fd >= 0)
 				close(fd);

