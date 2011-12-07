From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 7/9] imsm: FIX: Finish rebuild and initialization when missing
	drive is handled
Date: Wed, 07 Dec 2011 13:58:30 +0100
Message-ID: <20111207125830.25279.30709.stgit@gklab-128-013.igk.intel.com>
References: <20111207125549.25279.43741.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111207125549.25279.43741.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When missing device is handled for rebuild or initialization
end_migration() should be called to merge ords in case additional
degradation.

I've removed this call to end_migration() as it was called
for migration also.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index de07f66..9689fdd 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6192,6 +6192,17 @@ static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
 		return;
 
 	dprintf("imsm: mark missing\n");
+	/* end process for initialization and rebuild only
+	 */
+	if (is_gen_migration(dev) == 0) {
+		__u8 map_state;
+		int failed;
+
+		failed = imsm_count_failed(super, dev, MAP_0);
+		map_state = imsm_check_degraded(super, dev, failed, MAP_0);
+
+		end_migration(dev, super, map_state);
+	}
 	for (dl = super->missing; dl; dl = dl->next)
 		mark_missing(dev, &dl->disk, dl->index);
 	super->updates_pending++;

