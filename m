From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 15/27] WORKAROUND: md reports idle state during reshape start
Date: Mon, 06 Dec 2010 14:22:43 +0100
Message-ID: <20101206132243.21125.22898.stgit@gklab-170-024.igk.intel.com>
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

md reports reshape->idle->reshape states transition on reshape start, so reshape finalization is wrongly indicated.
Finalize reshape when we have any progress only,
When reshape is really started, idle state causes reshape finalization as usually.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 monitor.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/monitor.c b/monitor.c
index 207004c..5837b34 100644
--- a/monitor.c
+++ b/monitor.c
@@ -311,7 +311,8 @@ static int read_and_act(struct active_array *a)
 	/* finalize reshape detection
 	 */
 	if ((a->curr_action != reshape) &&
-	    (a->prev_action == reshape)) {
+	    (a->prev_action == reshape) &&
+	    (a->info.reshape_progress > 2)) {
 		/* set reshape_not_active
 		 * to allow for future rebuilds
 		 */

