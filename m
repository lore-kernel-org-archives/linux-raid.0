From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 29/34] Detect level change
Date: Tue, 04 Jan 2011 15:39:27 +0100
Message-ID: <20110104143926.6697.37287.stgit@gklab-128-013.igk.intel.com>
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

For level migration support it is necessary to allow mdmon to react for level changes.
It has to have ability to change configuration of active array,
and for array level change to raid0 finish array monitoring.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c |   12 ++++++++++++
 monitor.c   |    2 +-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/managemon.c b/managemon.c
index 9cb8049..269d06e 100644
--- a/managemon.c
+++ b/managemon.c
@@ -448,6 +448,18 @@ static void manage_member(struct mdstat_ent *mdstat,
 	else
 		frozen = 1; /* can't read metadata_version assume the worst */
 
+	if (mdstat->level) {
+		int level = map_name(pers, mdstat->level);
+		if (a->info.array.level != level && level >= 0) {
+			struct active_array *newa = duplicate_aa(a);
+			if (newa) {
+				newa->info.array.level = level;
+				replace_array(a->container, a, newa);
+				a = newa;
+			}
+		}
+	}
+
 	if (a->check_degraded && !frozen) {
 		struct metadata_update *updates = NULL;
 		struct mdinfo *newdev = NULL;
diff --git a/monitor.c b/monitor.c
index 65fcba1..937cc6b 100644
--- a/monitor.c
+++ b/monitor.c
@@ -517,7 +517,7 @@ static int wait_and_act(struct supertype *container, int nowait)
 		/* once an array has been deactivated we want to
 		 * ask the manager to discard it.
 		 */
-		if (!a->container) {
+		if (!a->container || (a->info.array.level == 0)) {
 			if (discard_this) {
 				ap = &(*ap)->next;
 				continue;

