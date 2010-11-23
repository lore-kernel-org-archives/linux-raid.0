From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 12/21] WORKAROUND: md reports idle state during reshape start
Date: Tue, 23 Nov 2010 13:41:16 +0100
Message-ID: <20101123124116.17770.77213.stgit@gklab-170-024.igk.intel.com>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

md reports reshape->idle->reshape states transition on reshape start, so reshape finalization is wrongly indicated.
Finalize reshape when we have any progress only,
When reshape is really started, idle state causes reshape finalization as usually.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/monitor.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mdadm/mdadm/monitor.c b/mdadm/mdadm/monitor.c
index f8ddba7..4cd634d 100644
--- a/mdadm/mdadm/monitor.c
+++ b/mdadm/mdadm/monitor.c
@@ -332,7 +332,8 @@ static int read_and_act(struct active_array *a)
 		/* finalize reshape detection
 		 */
 		if ((a->curr_action != reshape) &&
-		    (a->prev_action == reshape)) {
+		    (a->prev_action == reshape) &&
+		    (a->info.reshape_progress > 2)) {
 			/* set zero to allow for future rebuilds
 			 */
 			a->reshape_delta_disks = RESHAPE_NOT_ACTIVE;

