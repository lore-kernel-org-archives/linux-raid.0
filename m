From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 08/14] Check if reshape can be restarted
Date: Fri, 16 Sep 2011 13:54:48 +0200
Message-ID: <20110916115448.5201.56575.stgit@gklab-128-013.igk.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

When reshape was invoked during initramfs start-up stage
array is pushed in to reshape state already, so read only
state cannot be set again. To verify if reshape continuation should
be allowed sync_action sysfs key is tested and number of existing mdadm
instances is checked again.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 4d2c361..b331287 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3714,8 +3714,23 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 	int err;
 
 	err = sysfs_set_str(info, NULL, "array_state", "readonly");
-	if (err)
-		return err;
+	if (err) {
+		/* check if array is set in to reshape stare,
+		 * and current mdadm instance is the only one
+		 */
+		if ((sysfs_get_str(info, NULL, "sync_action",
+				   buf, 40) == 8) &&
+		    (count_mdadms() == 1)) {
+			dprintf("Warning: Grow_continue() cannot set array in"
+				"to read only state [sync_action is %s].",
+				buf);
+			if (strncmp(buf, "reshape", 7))
+				return err;
+			dprintf("Allow to continue.\n");
+		} else
+			return err;
+	}
+
 	if (st->ss->external) {
 		fmt_devname(buf, st->container_dev);
 		container = buf;

