From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 02/10] FIX: Problem with removing array after takeover
Date: Thu, 02 Dec 2010 09:18:56 +0100
Message-ID: <20101202081856.4639.29114.stgit@gklab-170-024.igk.intel.com>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When array parameters are changed old array 'A' is going to be removed
and new array 'B' is going to be serviced. If array B is raid0 array (takeovered),
array 'A' will never be deleted and mdmon is not going to exit.
Scenario:
1. managemon creates array 'B' and inserts it to begin of active arrays list
2. managemon sets field B->replaces = A

3. monitor: finds that array 'B' is raid 0 array and removes it from list
   information about removing array 'A' from list is lost
   and array 'A' stays in list forever

To resolve this situation first try to remove replaced arrays and then proceed
regular array servicing.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 monitor.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index 59b4181..0fbe198 100644
--- a/monitor.c
+++ b/monitor.c
@@ -480,6 +480,22 @@ static int wait_and_act(struct supertype *container, int nowait)
 
 	for (ap = aap ; *ap ;) {
 		a = *ap;
+
+		/* Remove array that current array points to remove
+		 */
+		if (a->replaces && !discard_this) {
+			struct active_array **ap;
+			for (ap = &a->next; *ap && *ap != a->replaces;
+			     ap = & (*ap)->next)
+				;
+			if (*ap)
+				*ap = (*ap)->next;
+			discard_this = a->replaces;
+			a->replaces = NULL;
+			/* FIXME check if device->state_fd need to be cleared?*/
+			signal_manager();
+		}
+
 		/* once an array has been deactivated we want to
 		 * ask the manager to discard it.
 		 */

