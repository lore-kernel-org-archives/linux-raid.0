From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/4] imsm: FIX: Disable automatic metadata rollback for broken
	reshape
Date: Thu, 09 Jun 2011 18:29:39 +0200
Message-ID: <20110609162939.690.44058.stgit@gklab-128-013.igk.intel.com>
References: <20110609162050.690.87261.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110609162050.690.87261.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

mdmon cannot rollback metadata changes automatically.
It can break reshape process in the way that in case of reshape break
user will not be able to deal with broken reshape due to lack of information
about reshape geometry.

mdadm (process that invokes reshape) doesn't make any rollback to allow
for user action. mdmon should not do this either unless it knows for sure
it is save. such knowledge is not available for automatic rollback.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 8bfe40a..5e8b834 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5865,14 +5865,17 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		} else {
 			if (a->last_checkpoint == 0 && a->prev_action == reshape) {
 				/* for some reason we aborted the reshape.
-				 * Better clean up
-				 */
+				 *
+				 * disable automatic metadata rollback
+				 * user action is required to recover process
+				 *
 				struct imsm_map *map2 = get_imsm_map(dev, 1);
 				dev->vol.migr_state = 0;
 				dev->vol.migr_type = 0;
 				dev->vol.curr_migr_unit = 0;
 				memcpy(map, map2, sizeof_imsm_map(map2));
 				super->updates_pending++;
+				*/
 			}
 			if (a->last_checkpoint >= a->info.component_size) {
 				unsigned long long array_blocks;

