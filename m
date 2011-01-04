From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 28/34] Take in mind takeover during disk add
Date: Tue, 04 Jan 2011 15:39:19 +0100
Message-ID: <20110104143919.6697.35990.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Reduce disk number of added disks if disk number was increased by takeover.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/Grow.c b/Grow.c
index 0b151f1..3814579 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1694,10 +1694,12 @@ static int reshape_array(char *container, int fd, char *devname,
 			st->ss->container_content(st, subarray);
 		struct mdinfo *d;
 
-		if (info2)
+		if (info2) {
+			int before_raid_disks = reshape.before.raid_disks;
+			if (orig_level == 0)
+				before_raid_disks--;
 			for (d = info2->devs; d; d = d->next) {
-				if (d->disk.raid_disk >=
-				    reshape.before.raid_disks) {
+				if (d->disk.raid_disk >= before_raid_disks) {
 					/* This is a spare that wants to
 					 * be part of the array.
 					 */
@@ -1705,7 +1707,8 @@ static int reshape_array(char *container, int fd, char *devname,
 					add_disk(fd, st, info2, d);
 				}
 			}
-		sysfs_free(info2);
+			sysfs_free(info2);
+		}
 	}
 
 	if (reshape.blocks == 0) {

