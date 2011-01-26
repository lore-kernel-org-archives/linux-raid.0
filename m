From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/7] imsm: FIX: do not allow for container operation for the
	same disks number
Date: Wed, 26 Jan 2011 16:03:33 +0100
Message-ID: <20110126150333.20454.17725.stgit@gklab-128-013.igk.intel.com>
References: <20110126145632.20454.20432.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110126145632.20454.20432.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

imsm_reshape_super() currently allows for expansion when requested
raid_disks number is the same as current.
This is wrong. Existing in code condition is too weak.
We should allow for expansion when new disks_number is greater
than current only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 4e96196..5a8886d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6747,7 +6747,7 @@ static int imsm_reshape_is_allowed_on_container(struct supertype *st,
 		dprintf("imsm: checking device_num: %i\n",
 			member->container_member);
 
-		if (geo->raid_disks < member->array.raid_disks) {
+		if (geo->raid_disks <= member->array.raid_disks) {
 			/* we work on container for Online Capacity Expansion
 			 * only so raid_disks has to grow
 			 */

