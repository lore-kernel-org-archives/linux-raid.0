From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 27/27] FIX: Problem with removing array after takeover
Date: Mon, 06 Dec 2010 14:24:18 +0100
Message-ID: <20101206132418.21125.71826.stgit@gklab-170-024.igk.intel.com>
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

When array parameters are changed old array 'A' is going to be removed
and new array 'B' is going to be serviced. If array B is raid0 array (takeovered),
array 'A' will never be deleted and mdmon is not going to exit.
Scenario:
1. managemon creates array 'B' and inserts it to begin of active arrays list
2. managemon sets field B->replaces = A

3. monitor: finds that array 'B' is raid 0 array and removes it from list
   information about removing array 'A' from list is lost
   and array 'A' stays in list forever

To resolve this situation wait with removing array 'B' until array 'A' is not removed.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 monitor.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/monitor.c b/monitor.c
index 6385555..ff2da9a 100644
--- a/monitor.c
+++ b/monitor.c
@@ -509,10 +509,14 @@ static int wait_and_act(struct supertype *container, int nowait)
 
 	for (ap = aap ; *ap ;) {
 		a = *ap;
+
 		/* once an array has been deactivated we want to
 		 * ask the manager to discard it.
+		 * but to do this we have to wait until replaced
+		 * array is removed
 		 */
-		if (!a->container || (a->info.array.level == 0)) {
+		if ((!a->container || (a->info.array.level == 0)) &&
+		     !a->replaces) {
 			if (discard_this) {
 				ap = &(*ap)->next;
 				continue;

