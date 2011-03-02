From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 5/9] FIX: Continue reshape in the background
Date: Wed, 02 Mar 2011 14:29:35 +0100
Message-ID: <20110302132935.24771.4330.stgit@gklab-128-013.igk.intel.com>
References: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

For external metadada, reshape will be continued in the background.
Reshape_array() makes fork itself, but for container operation support
we need a place to wait for reshape begin when current array reshape
time comes /reshapes has to be run in sequence/.
In such case Grow_continue() is responsible for unfreezing array
after return from reshape_array() function.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |    4 ++++
 Grow.c     |   26 ++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index ee5fcec..e31462d 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -703,6 +703,10 @@ int Assemble(struct supertype *st, char *mddev,
 			/* check if reshape of external metadata
 			 * is in progress
 			 * and it is need to be monitored by mdadm
+			 * ToDo:
+			 * For container operation this simple check:
+			 *     if (content->reshape_active)
+			 * has to be replaced by container operation check
 			 */
 			if (content->reshape_active)
 				err = Grow_continue(mdfd, st, content,
diff --git a/Grow.c b/Grow.c
index ee75352..5176425 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3332,6 +3332,7 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 	char buf[40];
 	char *container = NULL;
 	int err;
+	int forked = 0;
 
 	if (!st->ss->external) {
 		err = sysfs_set_str(info, NULL, "array_state", "readonly");
@@ -3340,9 +3341,30 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 	} else {
 		fmt_devname(buf, st->container_dev);
 		container = buf;
+		switch (fork()) {
+		case -1:
+			fprintf(stderr, Name ": Cannot run child to "
+				"monitor reshape: %s\n", strerror(errno));
+			return 1;
+		default:
+			return 0;
+		case 0:
+			dprintf(Name ": Continue bacground reshape "
+				"after assemblation\n");
+			forked = 1;
+			/* ToDo:
+			 *     Wait here during container operation,
+			 *     if this array has to be reshaped now
+			 */
+		}
 	}
-	return reshape_array(container, mdfd, "array", st, info, 1,
-			     backup_file, 0, 0, 1);
+
+	err = reshape_array(container, mdfd, "array", st, info, 1,
+			     backup_file, 0, forked, 1);
+	if (forked)
+		unblock_subarray(info, 0);
+
+	return err;
 }
 
 

