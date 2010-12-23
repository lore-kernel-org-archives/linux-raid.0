From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 2/5] Added test for array degradation for spare-same-slot
Date: Thu, 23 Dec 2010 17:03:06 +0100
Message-ID: <20101223160306.5562.84302.stgit@gklab-170-211.igk.intel.com>
References: <20101223155614.5562.4773.stgit@gklab-170-211.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101223155614.5562.4773.stgit@gklab-170-211.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

spare-same-slot allows re-adding of missing array member with disk
re-inserted into the same slot where previous member was plugged in.
If in the meantime another spare has been used for recovery, same slot
cookie should be ignored.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Incremental.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index ef719fa..137bd75 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -968,11 +968,13 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		 * arrays/containers that match 'target'.
 		 * If 'target' is set and 'bare' is true, we prefer the
 		 * array which matches 'target'.
+		 * target is considered only if we deal with degraded array
 		 */
 		if (target) {
 			if (strcmp(target->metadata, mp->metadata) == 0 &&
 			    memcmp(target->uuid, mp->uuid,
-				   sizeof(target->uuid)) == 0) {
+				   sizeof(target->uuid)) == 0 && 
+			    sra->array.failed_disks > 0) {
 				/* This is our target!! */
 				if (chosen)
 					sysfs_free(chosen);

