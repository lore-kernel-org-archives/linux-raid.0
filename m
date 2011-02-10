From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/4] FIX: Get spares from external metadata
Date: Thu, 10 Feb 2011 14:56:26 +0100
Message-ID: <20110210135626.9276.57246.stgit@gklab-128-013.igk.intel.com>
References: <20110210134710.9276.91430.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110210134710.9276.91430.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

For external metadata cases, information about number of spares cannot
be get via ioctl GET_ARRAY_INFO for particular array
(as info variable is initialized by). In md this information is present
in container object not array one.
This causes need to get spare disks number from external metadata.

This information is required for reshape_array() function to decide
if spare disks number satisfy operation requirements.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 9ae2ecd..08fc258 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1573,6 +1573,19 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				       force, backup_file, quiet);
 		frozen = 0;
 	} else {
+		/* get spare devices from external metadata
+		 */
+		if (st->ss->external) {
+			struct mdinfo *info2;
+
+			info2 = st->ss->container_content(st, subarray);
+			if (info2) {
+				info.array.spare_disks =
+					info2->array.spare_disks;
+				sysfs_free(info2);
+			}
+		}
+
 		/* Impose these changes on a single array.  First
 		 * check that the metadata is OK with the change. */
 

