From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md ] Fix BUG in raid6 resync code.
Date: Mon, 07 Jun 2004 13:39:52 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BXAzI-0006I7-Oc@notabene.cse.unsw.edu.au>
References: <20040607133613.19974.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This condtion on this loop is primarily to avoid the loop
if it doesn't appear to be needed.  However it optimises
a little too much and there is a case where it skips the
loop when it is really needed.  This patch fixes it.

This is the raid6 version of the recent raid5 resync bugfix.


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid6main.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-06-04 16:36:24.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-06-07 13:35:02.000000000 +1000
@@ -1157,7 +1157,7 @@ static void handle_stripe(struct stripe_
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
 	 */
-	if (to_read || non_overwrite || (syncing && (uptodate+failed < disks))) {
+	if (to_read || non_overwrite || (syncing && (uptodate < disks))) {
 		for (i=disks; i--;) {
 			dev = &sh->dev[i];
 			if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
