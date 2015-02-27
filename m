From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] IncRemove: Set "auto-read" only after successful excl open.
Date: Fri, 27 Feb 2015 15:47:54 +0100
Message-ID: <20150227144754.9507.71855.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

"mdadm -If" - triggered from udev rules when disk is removed from OS -
tries to set array in auto-read-only mode. This can interrupt rebuild
process which is started automatically, e.g. if array is mounted and
spare disk is available (I/O error is detected faster than removing
failed disk by mdadm).
This patch prevents "mdadm -If" from setting array into "auto-read-only",
by requiring exclusive open to succeed.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 Incremental.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 87d9114..b12f144 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1712,12 +1712,16 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 		return 1;
 	}
 	sysfs_init(&mdi, -1, ent->devnm);
-	if (sysfs_get_str(&mdi, NULL, "array_state",
-			  buf, sizeof(buf)) > 0) {
-		if (strncmp(buf, "active", 6) == 0 ||
-		    strncmp(buf, "clean", 5) == 0)
-			sysfs_set_str(&mdi, NULL,
-				      "array_state", "read-auto");
+	mdfd = open_dev_excl(ent->devnm);
+	if (mdfd > 0) {
+		close(mdfd);
+		if (sysfs_get_str(&mdi, NULL, "array_state",
+				  buf, sizeof(buf)) > 0) {
+			if (strncmp(buf, "active", 6) == 0 ||
+			    strncmp(buf, "clean", 5) == 0)
+				sysfs_set_str(&mdi, NULL,
+					      "array_state", "read-auto");
+		}
 	}
 	mdfd = open_dev(ent->devnm);
 	if (mdfd < 0) {

