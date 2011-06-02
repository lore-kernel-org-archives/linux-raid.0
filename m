From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 15/22] imsm: Disable checkpoint updating by mdmon for general
	migration
Date: Thu, 02 Jun 2011 16:50:16 +0200
Message-ID: <20110602145016.27355.55829.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

imsm contains 2 check-pointing mechanism. One (per array) is used for
initialization and rebuild and second (per container) is used for general
migration (reshape). First is controlled by mdmon, second by mdadm.
To avoid conflicts disable mdmon checkpoints updating for general
migration.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 8ebc1e4..77d6167 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5857,6 +5857,12 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 	}
 
 mark_checkpoint:
+	/* skip checkpointing for general migration,
+	 * it is controlled in mdadm
+	 */
+	if (is_gen_migration(dev))
+		goto skip_mark_checkpoint;
+
 	/* check if we can update curr_migr_unit from resync_start, recovery_start */
 	blocks_per_unit = blocks_per_migr_unit(super, dev);
 	if (blocks_per_unit) {
@@ -5878,6 +5884,7 @@ mark_checkpoint:
 		}
 	}
 
+skip_mark_checkpoint:
 	/* mark dirty / clean */
 	if (dev->vol.dirty != !consistent) {
 		dprintf("imsm: mark '%s'\n", consistent ? "clean" : "dirty");

