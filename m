From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 02/27] Add state_of_reshape for external metadata
Date: Mon, 06 Dec 2010 14:21:01 +0100
Message-ID: <20101206132100.21125.68010.stgit@gklab-170-024.igk.intel.com>
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

During reshape we have to know what is present reshape state:
reshape_not_active: reshape is not started, array is in other state than reshape
reshape_is_starting: reshape is about to start, provably metadata is updated,
                     array in md can be in reshape state.
                     In this state mdmon should not allow for array rebuilds
                     as reconfiguration is in progress.
                     When everything goes fine the next state should be reshape_in_progress
                     In error case reshape_cancel_request should be reached.
reshape_in_progress: md is in reshape state and reshape is in progress
                     when reshape ends state_of_reshape will return to reshape_not_active
reshape_cancel_request: reshape canceling request is issued in error case.
                        during this state metadata rollback should occurs.
                        From this state state_of_reshape should go to reshape_not_active state

reshape_delta_disks field should contain valid value in reshape_in_progress state
and tells how many disks are added to array.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c |    2 ++
 mdmon.h     |    4 ++++
 monitor.c   |   12 +++++++++++-
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/managemon.c b/managemon.c
index ebd9b73..945b173 100644
--- a/managemon.c
+++ b/managemon.c
@@ -521,6 +521,8 @@ static void manage_new(struct mdstat_ent *mdstat,
 
 	new->container = container;
 
+	new->reshape_state = reshape_not_active;
+
 	inst = to_subarray(mdstat, container->devname);
 
 	new->info.array = mdi->array;
diff --git a/mdmon.h b/mdmon.h
index 5c51566..b869544 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -23,6 +23,7 @@ enum array_state { clear, inactive, suspended, readonly, read_auto,
 
 enum sync_action { idle, reshape, resync, recover, check, repair, bad_action };
 
+enum state_of_reshape { reshape_not_active, reshape_is_starting, reshape_in_progress, reshape_cancel_request };
 
 struct active_array {
 	struct mdinfo info;
@@ -45,6 +46,9 @@ struct active_array {
 	enum array_state prev_state, curr_state, next_state;
 	enum sync_action prev_action, curr_action, next_action;
 
+	enum state_of_reshape reshape_state;
+	int reshape_delta_disks;
+
 	int check_degraded; /* flag set by mon, read by manage */
 
 	int devnum;
diff --git a/monitor.c b/monitor.c
index 59b4181..986fdb0 100644
--- a/monitor.c
+++ b/monitor.c
@@ -399,8 +399,18 @@ static int read_and_act(struct active_array *a)
 		signal_manager();
 	}
 
-	if (deactivate)
+	if (deactivate) {
 		a->container = NULL;
+		/* break reshape also
+		 */
+		if (a->reshape_state !=  reshape_in_progress)
+			a->reshape_state = reshape_not_active;
+	}
+
+	/* signal manager when reshape is in reshape_is_starting state
+	 */
+	if (a->reshape_state == reshape_is_starting)
+		signal_manager();
 
 	return dirty;
 }

