From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 14/27] Add reshape progress updating
Date: Mon, 06 Dec 2010 14:22:35 +0100
Message-ID: <20101206132235.21125.5313.stgit@gklab-170-024.igk.intel.com>
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

Reshape progress is not updated in mdmon.
This patch adds reshape progress updating feature.

 Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c |    9 +++++++++
 mdmon.h     |    1 +
 monitor.c   |    3 +++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/managemon.c b/managemon.c
index a6e6880..5d81623 100644
--- a/managemon.c
+++ b/managemon.c
@@ -417,6 +417,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 			struct metadata_update *updates = NULL;
 			struct mdinfo *newdev = NULL;
 			struct mdinfo *d;
+			int delta_disks = a->reshape_delta_disks;
 
 			newdev = newa->container->ss->reshape_array(newa, reshape_in_progress, &updates);
 			if (newdev) {
@@ -451,6 +452,13 @@ static void manage_member(struct mdstat_ent *mdstat,
 					/* reshape executed
 					 */
 					dprintf("Reshape was started\n");
+					newa->new_data_disks = newa->info.array.raid_disks + delta_disks;
+					if (a->info.array.level == 4)
+						newa->new_data_disks--;
+					if (a->info.array.level == 5)
+						newa->new_data_disks--;
+					if (a->info.array.level == 6)
+						newa->new_data_disks--;
 					replace_array(a->container, a, newa);
 					a = newa;
 				} else {
@@ -591,6 +599,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 	new->container = container;
 
 	new->reshape_state = reshape_not_active;
+	new->new_data_disks = 0;
 
 	inst = to_subarray(mdstat, container->devname);
 
diff --git a/mdmon.h b/mdmon.h
index b869544..b922af4 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -48,6 +48,7 @@ struct active_array {
 
 	enum state_of_reshape reshape_state;
 	int reshape_delta_disks;
+	int new_data_disks;
 
 	int check_degraded; /* flag set by mon, read by manage */
 
diff --git a/monitor.c b/monitor.c
index 1e22444..207004c 100644
--- a/monitor.c
+++ b/monitor.c
@@ -305,6 +305,9 @@ static int read_and_act(struct active_array *a)
 		}
 	}
 
+	if (a->curr_action == reshape)
+		a->info.reshape_progress = a->info.resync_start * a->new_data_disks;
+
 	/* finalize reshape detection
 	 */
 	if ((a->curr_action != reshape) &&

