From: mwilck@arcor.de
Subject: [PATCH] Monitor: don't set arrays dirty after transition to read-only
Date: Sat, 14 Sep 2013 23:24:07 +0200
Message-ID: <1379193847-402-1-git-send-email-mwilck@arcor.de>
References: <5234D221.8010607@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5234D221.8010607@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This patch reverts commit 4867e068. Setting arrays dirty after
transition from inactive to anything else causes unnecessary
meta data writes and may wreak trouble unnecessarily when
a disk was missing during assembly but the array was never
written to.

The reason for 4867e068 was a special situation during reshape
from RAID0 to RAID4. I ran all IMSM test cases with it reverted
and found no regressions, so I believe the reshape logic for
IMSM works fine in mdadm 3.3 also without this.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 monitor.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/monitor.c b/monitor.c
index 742aa19..3b57ed0 100644
--- a/monitor.c
+++ b/monitor.c
@@ -270,13 +270,6 @@ static int read_and_act(struct active_array *a)
 		a->info.resync_start
 		);
 
-	if (a->curr_state > inactive &&
-	    a->prev_state == inactive) {
-		/* array has been started
-		 * possible that container operation has to be completed
-		 */
-		a->container->ss->set_array_state(a, 0);
-	}
 	if ((a->curr_state == bad_word || a->curr_state <= inactive) &&
 	    a->prev_state > inactive) {
 		/* array has been stopped */
-- 
1.7.3.4
