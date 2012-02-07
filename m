From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 02/12] imsm: FIX: No new missing disks are allowed during
	general migration
Date: Tue, 07 Feb 2012 15:03:11 +0100
Message-ID: <20120207140311.20627.70701.stgit@gklab-128-013.igk.intel.com>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

When during incremental assembly general migration is in progress,
starting degraded array causes that no more disks (even present)
can be added later as array is already started.

Request all previously present disks during general migration for assembly.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index eba11d6..17034bb 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2683,7 +2683,17 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 			enough = 0;
 		else /* we're normal, or already degraded */
 			enough = 1;
-
+		if (is_gen_migration(dev) && missing) {
+			/* during general migration we need all disks
+			 * that process is running on.
+			 * No new missing disk is allowed.
+			 */
+			max_enough = -1;
+			enough = -1;
+			/* no more checks necessary
+			 */
+			break;
+		}
 		/* in the missing/failed disk case check to see
 		 * if at least one array is runnable
 		 */

