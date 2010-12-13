From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 02/16] WORKAROUND: md reports idle state during reshape start
	- Remove
Date: Mon, 13 Dec 2010 15:45:04 +0100
Message-ID: <20101213144504.4384.60937.stgit@gklab-170-024.igk.intel.com>
References: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Remove previously inserted workaround.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 monitor.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/monitor.c b/monitor.c
index 0961636..cab558c 100644
--- a/monitor.c
+++ b/monitor.c
@@ -312,8 +312,7 @@ static int read_and_act(struct active_array *a)
 	/* finalize reshape detection
 	 */
 	if ((a->curr_action != reshape) &&
-	    (a->prev_action == reshape) &&
-	    (a->info.reshape_progress > 2)) {
+	    (a->prev_action == reshape)) {
 		/* set reshape_not_active
 		 * to allow for future rebuilds
 		 */

