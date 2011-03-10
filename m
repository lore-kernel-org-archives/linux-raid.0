From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: Last checkpoint is not initialized on reshape restart
Date: Thu, 10 Mar 2011 15:05:54 +0100
Message-ID: <20110310140554.11333.28521.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When reshape is restarted and active array in mdmon is being initialized,
mdmon has to know last checkpoint, otherwise reshape will be restarted
form '0' position.
mdadm when reshaped array is assembled stores reshape_position in sysfs
and runs mdmon. Initialize last_checkpoint in active array structure
to value present in sysfs for reshaped array start.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/managemon.c b/managemon.c
index 6001f6a..1362a0e 100644
--- a/managemon.c
+++ b/managemon.c
@@ -596,6 +596,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 	char *inst;
 	int i;
 	int failed = 0;
+	char buf[40];
 
 	/* check if array is ready to be monitored */
 	if (!mdstat->active)
@@ -657,6 +658,20 @@ static void manage_new(struct mdstat_ent *mdstat,
 	dprintf("%s: inst: %d action: %d state: %d\n", __func__, atoi(inst),
 		new->action_fd, new->info.state_fd);
 
+	/* reshape_position is set by mdadm in sysfs
+	 * read this information for new arrays only (empty victim)
+	 */
+	if ((victim == NULL) &&
+	    (sysfs_get_str(mdi, NULL, "sync_action", buf, 40) > 0) &&
+	    (strncmp(buf, "reshape", 7) == 0)) {
+		if (sysfs_get_ll(mdi, NULL, "reshape_position",
+			&new->last_checkpoint) != 0)
+			new->last_checkpoint = 0;
+		dprintf("mdmon: New monitored array is under reshape.\n"
+			"       Last checkpoint is: %llu\n",
+			new->last_checkpoint);
+	}
+
 	sysfs_free(mdi);
 
 	/* if everything checks out tell the metadata handler we want to

