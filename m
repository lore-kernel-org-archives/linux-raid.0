From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/8] Do not restart reshape if it is started already
Date: Tue, 27 Sep 2011 14:04:57 +0200
Message-ID: <20110927120457.4890.53328.stgit@gklab-128-013.igk.intel.com>
References: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When reshape was invoked during initrd start-up stage array is pushed
in to reshape state already, so read only state cannot be set again during
reshape continuation. Set previously reshape state has to be reused
during reshape continuation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 768fc86..d9c2817 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3773,11 +3773,17 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 {
 	char buf[40];
 	char *container = NULL;
-	int err;
+	int err = 0;
 
-	err = sysfs_set_str(info, NULL, "array_state", "readonly");
+	/* set read only array state when there is no reshape
+	 * in progress already
+	 */
+	if ((sysfs_get_str(info, NULL, "sync_action", buf, 40) != 8) &&
+	    (strncmp(buf, "reshape", 7) != 0))
+		err = sysfs_set_str(info, NULL, "array_state", "readonly");
 	if (err)
 		return err;
+
 	if (st->ss->external) {
 		fmt_devname(buf, st->container_dev);
 		container = buf;

