From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 22/31] Finalize reshape after adding disks to array
Date: Tue, 9 Nov 2010 17:01:21 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CAA6@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

When reshape is finished monitor, has to finalize reshape in metadata.
To do this set_array_state() should be called.
This finishes migration and stores metadata on disks.

reshape_delta_disks is set to not active value.
This finishes reshape flow in mdmon.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/monitor.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/mdadm/mdadm/monitor.c b/mdadm/mdadm/monitor.c index e51bf7f..70bd57e 100644
--- a/mdadm/mdadm/monitor.c
+++ b/mdadm/mdadm/monitor.c
@@ -260,6 +260,23 @@ static int read_and_act(struct active_array *a)
 		}
 	}
 
+	if (!deactivate) {
+		/* finalize reshape detection
+		 */
+		if ((a->curr_action != reshape) &&
+		    (a->prev_action == reshape)) {
+			/* set zero to allow for future rebuilds
+			 */
+			a->reshape_delta_disks = RESHAPE_NOT_ACTIVE;
+
+			/* A reshape has finished.
+			 * Some disks may be in sync now.
+			 */
+			a->container->ss->set_array_state(a, a->curr_state <= clean);
+			check_degraded = 1;
+		}
+	}
+
 	/* Check for failures and if found:
 	 * 1/ Record the failure in the metadata and unblock the device.
 	 *    FIXME update the kernel to stop notifying on failed drives when

