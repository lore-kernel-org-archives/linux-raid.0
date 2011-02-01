From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/8] FIX: Last checkpoint is not set
Date: Tue, 01 Feb 2011 14:49:04 +0100
Message-ID: <20110201134904.13398.16105.stgit@gklab-128-013.igk.intel.com>
References: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When reshape is finished monitor has to set last checkpoint
to the array end to allow metatdata for reshape finalization.
Metadata has to know if reshape is finished or it is broken
On reshape finish metadata finalization is required.
When reshape is broken, metadata must remain as is to allow
for reshape restart from checkpoint.

This can be resolved based on reshape_position sysfs entry.
When it is equal to 'none', it means that md finishes work.
In such situation move checkpoint to the end of array.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 monitor.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index 8d33a5d..7aa0d91 100644
--- a/monitor.c
+++ b/monitor.c
@@ -366,6 +366,24 @@ static int read_and_act(struct active_array *a)
 		 */
 		if (sync_completed != 0)
 			a->last_checkpoint = sync_completed;
+		/* we have to make difference
+		 * becaurse of reshape finish reason.
+		 * if array reshape is really finished:
+		 *        set check point to the end, this allows
+		 *        set_array_state() to finalize reshape in metadata
+		 * if reshape if broken: do not set checkpoint to the end
+		 *        this allows for reshape restart from checkpoint
+		 */
+		if ((a->curr_action != reshape) &&
+		    (a->prev_action == reshape)) {
+			char buf[PATH_MAX];
+			if ((sysfs_get_str(&a->info, NULL,
+					  "reshape_position",
+					  buf,
+					  sizeof(buf)) >= 0) &&
+			     strncmp(buf, "none", 4) == 0)
+				a->last_checkpoint = a->info.component_size;
+		}
 		a->container->ss->set_array_state(a, a->curr_state <= clean);
 		a->last_checkpoint = sync_completed;
 	}

