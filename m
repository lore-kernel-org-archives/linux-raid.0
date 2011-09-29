From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/3] Move code to check_mdmon_version() function
Date: Thu, 29 Sep 2011 17:53:36 +0200
Message-ID: <20110929155336.22854.2583.stgit@gklab-128-013.igk.intel.com>
References: <20110929154756.22854.13187.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929154756.22854.13187.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Move code to function for code reuse.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 msg.c |   59 ++++++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/msg.c b/msg.c
index a10c930..98d6d13 100644
--- a/msg.c
+++ b/msg.c
@@ -281,6 +281,40 @@ int block_subarray(struct mdinfo *sra)
 
 	return rc;
 }
+
+/* check mdmon version if it supports
+ * array blocking mechanism
+ */
+int check_mdmon_version(char *container)
+{
+	char *version = NULL;
+	int devnum = devname2devnum(container);
+
+	if (!mdmon_running(devnum)) {
+		/* if mdmon is not active we assume that any instance that is
+		 * later started will match the current mdadm version, if this
+		 * assumption is violated we may inadvertantly rebuild an array
+		 * that was meant for reshape, or start rebuild on a spare that
+		 * was to be moved to another container
+		 */
+		/* pass */;
+	} else {
+		int ver;
+
+		version = ping_monitor_version(container);
+		ver = version ? mdadm_version(version) : -1;
+		free(version);
+		if (ver < 3002000) {
+			fprintf(stderr, Name
+				": mdmon instance for %s cannot be disabled\n",
+				container);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * block_monitor - prevent mdmon spare assignment
  * @container - container to block
@@ -302,34 +336,13 @@ int block_subarray(struct mdinfo *sra)
  */
 int block_monitor(char *container, const int freeze)
 {
-	int devnum = devname2devnum(container);
 	struct mdstat_ent *ent, *e, *e2;
 	struct mdinfo *sra = NULL;
-	char *version = NULL;
 	char buf[64];
 	int rv = 0;
 
-	if (!mdmon_running(devnum)) {
-		/* if mdmon is not active we assume that any instance that is
-		 * later started will match the current mdadm version, if this
-		 * assumption is violated we may inadvertantly rebuild an array
-		 * that was meant for reshape, or start rebuild on a spare that
-		 * was to be moved to another container
-		 */
-		/* pass */;
-	} else {
-		int ver;
-
-		version = ping_monitor_version(container);
-		ver = version ? mdadm_version(version) : -1;
-		free(version);
-		if (ver < 3002000) {
-			fprintf(stderr, Name
-				": mdmon instance for %s cannot be disabled\n",
-				container);
-			return -1;
-		}
-	}
+	if (check_mdmon_version(container))
+		return -1;
 
 	ent = mdstat_read(0, 0);
 	if (!ent) {

