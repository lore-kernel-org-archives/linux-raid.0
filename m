From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 14/29] WORKAROUND: md reports idle state during reshape start
Date: Thu, 09 Dec 2010 16:20:36 +0100
Message-ID: <20101209152036.26876.23154.stgit@gklab-170-024.igk.intel.com>
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

md reports reshape->idle->reshape states transition on reshape start, so reshape finalization is wrongly indicated.
Finalize reshape when we have any progress only,
When reshape is really started, idle state causes reshape finalization as usually.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 monitor.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/monitor.c b/monitor.c
index b5cd3c6..bbfe3d2 100644
--- a/monitor.c
+++ b/monitor.c
@@ -312,7 +312,8 @@ static int read_and_act(struct active_array *a)
 	/* finalize reshape detection
 	 */
 	if ((a->curr_action != reshape) &&
-	    (a->prev_action == reshape)) {
+	    (a->prev_action == reshape) &&
+	    (a->info.reshape_progress > 2)) {
 		/* set reshape_not_active
 		 * to allow for future rebuilds
 		 */

