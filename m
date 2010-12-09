From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 19/29] Detect level change
Date: Thu, 09 Dec 2010 16:21:18 +0100
Message-ID: <20101209152118.26876.82391.stgit@gklab-170-024.igk.intel.com>
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

For level migration support it is necessary to allow mdmon to react for level changes.
It has to have ability to change configuration of active array,
and for array level change to raid0 finish array monitoring.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c |   12 +++++++++++-
 monitor.c   |    2 +-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/managemon.c b/managemon.c
index 0c84e6d..1774299 100644
--- a/managemon.c
+++ b/managemon.c
@@ -450,7 +450,17 @@ static void manage_member(struct mdstat_ent *mdstat,
 	else
 		frozen = 1; /* can't read metadata_version assume the worst */
 
-
+	if (mdstat->level) {
+		int level = map_name(pers, mdstat->level);
+		if (a->info.array.level != level && level >= 0) {
+			newa = duplicate_aa(a);
+			if (newa) {
+				newa->info.array.level = level;
+				replace_array(a->container, a, newa);
+				a = newa;
+			}
+		}
+	}
 
 	if ((a->reshape_state != reshape_not_active) &&
 	    (a->reshape_state != reshape_in_progress)) {
diff --git a/monitor.c b/monitor.c
index bbfe3d2..50dada4 100644
--- a/monitor.c
+++ b/monitor.c
@@ -513,7 +513,7 @@ static int wait_and_act(struct supertype *container, int nowait)
 		/* once an array has been deactivated we want to
 		 * ask the manager to discard it.
 		 */
-		if (!a->container) {
+		if (!a->container || (a->info.array.level == 0)) {
 			if (discard_this) {
 				ap = &(*ap)->next;
 				continue;

