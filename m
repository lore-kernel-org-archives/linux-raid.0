From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/9] imsm: FIX: Do not allow spare activation during rebuild
Date: Wed, 07 Dec 2011 13:58:07 +0100
Message-ID: <20111207125807.25279.79685.stgit@gklab-128-013.igk.intel.com>
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

Do not allow for spare device activation while rebuild is in progress,
when additional degradation occur.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index c6509af..973b22f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6784,6 +6784,14 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 	if (imsm_reshape_blocks_arrays_changes(super))
 			return NULL;
 
+	/* Cannot activate another spare if rebuild is in progress already
+	 */
+	if (is_rebuilding(dev)) {
+		dprintf("imsm: No spare activation allowed. "
+			"Rebuild in progress already.\n");
+		return NULL;
+	}
+
 	if (a->info.array.level == 4)
 		/* No repair for takeovered array
 		 * imsm doesn't support raid4

