From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 18/34] Finalize reshape after adding disks to array
Date: Tue, 04 Jan 2011 15:38:00 +0100
Message-ID: <20110104143800.6697.78088.stgit@gklab-128-013.igk.intel.com>
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

When reshape is finished monitor, has to finalize reshape in metadata.
To do this set_array_state() should be called.
This finishes migration and stores metadata on disks.

reshape_delta_disks is set to not active value.
This finishes reshape flow in mdmon.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 monitor.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index 3962d9e..65fcba1 100644
--- a/monitor.c
+++ b/monitor.c
@@ -315,6 +315,17 @@ static int read_and_act(struct active_array *a)
 		 */
 		check_reshape = 1;
 
+	/* finalize reshape detection
+	 */
+	if ((a->curr_action != reshape) &&
+	    (a->prev_action == reshape)) {
+		/* A reshape has finished.
+		 * Some disks may be in sync now.
+		 */
+		a->container->ss->set_array_state(a, a->curr_state <= clean);
+		check_degraded = 1;
+	}
+
 	/* Check for failures and if found:
 	 * 1/ Record the failure in the metadata and unblock the device.
 	 *    FIXME update the kernel to stop notifying on failed drives when

