From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 2 of 2] Fix jiffies handling in md.c
Date: Wed, 01 Dec 2004 11:49:58 +1100
Message-ID: <E1CZIgw-0002Ho-S0@notabene.cse.unsw.edu.au>
References: <20041201112426.2971.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Use time_after_eq instead of >=

From: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>
Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-12-01 11:24:00.000000000 +1100
+++ ./drivers/md/md.c	2004-12-01 11:24:00.000000000 +1100
@@ -3503,7 +3503,7 @@ static void md_do_sync(mddev_t *mddev)
 			break;
 
 	repeat:
-		if (jiffies >= mark[last_mark] + SYNC_MARK_STEP ) {
+		if (time_after_eq(jiffies, mark[last_mark] + SYNC_MARK_STEP )) {
 			/* step marks */
 			int next = (last_mark+1) % SYNC_MARKS;
 
