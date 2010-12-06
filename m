From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/27] imsm: Block array state change during reshape
Date: Mon, 06 Dec 2010 14:21:24 +0100
Message-ID: <20101206132124.21125.93475.stgit@gklab-170-024.igk.intel.com>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Array state change is blocked due to reshape action in progress
metadata changes are during applying.

'1' is returned to indicate that array is clean

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 402cc30..c072753 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4780,6 +4780,16 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 	__u8 map_state = imsm_check_degraded(super, dev, failed);
 	__u32 blocks_per_unit;
 
+	if (a->reshape_state != reshape_not_active) {
+		/* array state change is blocked due to reshape action
+		 * metadata changes are during applying.
+		 *
+		 * '1' is returned to indicate that array is clean
+		 */
+		dprintf("imsm: imsm_set_array_state() called during reshape.\n");
+		return 1;
+	}
+
 	/* before we activate this array handle any missing disks */
 	if (consistent == 2)
 		handle_missing(super, dev);
@@ -5144,6 +5154,10 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 
 	dprintf("imsm: activate spare: inst=%d failed=%d (%d) level=%d\n",
 		inst, failed, a->info.array.raid_disks, a->info.array.level);
+
+	if (a->reshape_state != reshape_not_active)
+		return NULL;
+
 	if (imsm_check_degraded(super, dev, failed) != IMSM_T_STATE_DEGRADED)
 		return NULL;
 

