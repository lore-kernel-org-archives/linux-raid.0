From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md ] Fix BUG in raid5 resync code.
Date: Fri, 04 Jun 2004 16:55:34 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BW8c2-0002Fs-EL@notabene.cse.unsw.edu.au>
References: <20040604165208.8646.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Marcelo,
 This patch fixes a long standing bug in raid5, that is fairly hard to hit.

 As the comment below says, the if() condition on the for loop is there to 
optimised out the loop if it is known that it isn't needed, so making the test 
broader (as this patch does) cannot possibly hurt in correctness.
Please include this in an upcoming release.
Thanks,
NeilBrown

(patch against 2.4.27-pre5)

### Comments for Changeset


This condition on this loop is primarily to avoid the loop
if it doesn't appear to be needed.  However it optimises
a little too much and there is a case where it skips the
loop when it is really needed.  This patch fixes it.


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-06-04 16:50:34.000000000 +1000
+++ ./drivers/md/raid5.c	2004-06-04 16:51:06.000000000 +1000
@@ -950,7 +950,7 @@ static void handle_stripe(struct stripe_
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
 	 */
-	if (to_read || (syncing && (uptodate+failed < disks))) {
+	if (to_read || (syncing && (uptodate < disks))) {
 		for (i=disks; i--;) {
 			bh = sh->bh_cache[i];
 			if (!buffer_locked(bh) && !buffer_uptodate(bh) &&
