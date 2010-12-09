From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 12/29] Finalize reshape after adding disks to array
Date: Thu, 09 Dec 2010 16:20:20 +0100
Message-ID: <20101209152020.26876.53740.stgit@gklab-170-024.igk.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
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

 monitor.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index 5298fa1..6191886 100644
--- a/monitor.c
+++ b/monitor.c
@@ -305,6 +305,21 @@ static int read_and_act(struct active_array *a)
 		}
 	}
 
+	/* finalize reshape detection
+	 */
+	if ((a->curr_action != reshape) &&
+	    (a->prev_action == reshape)) {
+		/* set reshape_not_active
+		 * to allow for future rebuilds
+		 */
+		a->reshape_state = reshape_not_active;
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

