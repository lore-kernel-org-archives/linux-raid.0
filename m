From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] fix: correct extending size of raid0 array
Date: Fri, 20 Apr 2012 11:00:25 +0200
Message-ID: <20120420090025.32107.93930.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Setting "sync_action" to "idle" while extending size of raid0 array
is racy and sometimes fails.
"sync_action" should be set to "frozen" instead.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 389992e..b4b9ff2 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1749,7 +1749,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			/* do not recync non-existing parity,
 			 * we will drop it anyway
 			 */
-			sysfs_set_str(sra, NULL, "sync_action", "idle");
+			sysfs_set_str(sra, NULL, "sync_action", "frozen");
 			/* go back to raid0, drop parity disk
 			 */
 			sysfs_set_str(sra, NULL, "level", "raid0");

