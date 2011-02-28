From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/5] FIX: Set readonly state in Grow_continue() when necessary
Date: Mon, 28 Feb 2011 16:07:19 +0100
Message-ID: <20110228150719.14670.18160.stgit@gklab-128-013.igk.intel.com>
References: <20110228145815.14670.56597.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110228145815.14670.56597.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When assembling array using assemble_container_content() for external
metadata case, array is in 'readonly' state already.
There is not necessary to duplicate this operation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Grow.c b/Grow.c
index cb52cc5..e321a39 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3325,11 +3325,13 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 {
 	char buf[40];
 	char *container = NULL;
-	int err = sysfs_set_str(info, NULL, "array_state", "readonly");
-	if (err)
-		return err;
+	int err;
 
-	if (st->ss->external) {
+	if (!st->ss->external) {
+		err = sysfs_set_str(info, NULL, "array_state", "readonly");
+		if (err)
+			return err;
+	} else {
 		fmt_devname(buf, st->container_dev);
 		container = buf;
 	}

