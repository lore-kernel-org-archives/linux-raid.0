From: David Greaves <david@dgreaves.com>
Subject: Re: [PATCH md ] Fix BUG in raid5 resync code.
Date: Fri, 04 Jun 2004 08:10:59 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C02083.9050202@dgreaves.com>
References: <20040604165208.8646.patches@notabene> <E1BW8c2-0002Fs-EL@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1BW8c2-0002Fs-EL@notabene.cse.unsw.edu.au>
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

Given I'm about to resync about 400Gb of data I'd like to check this 
before blindly storming ahead... :)

Would the following be the correct patch against 2.6.6?

--- drivers/md/raid5.c~ 2004-05-30 18:38:49.000000000 +0100
+++ drivers/md/raid5.c  2004-06-04 09:06:12.000000000 +0100
@@ -1037,7 +1037,7 @@
         * parity, or to satisfy requests
         * or to load a block that is being partially written.
         */
-       if (to_read || non_overwrite || (syncing && (uptodate+failed < 
disks))) {
+       if (to_read || non_overwrite || (syncing && (uptodate < disks))) {
                for (i=disks; i--;) {
                        dev = &sh->dev[i];
                        if (!test_bit(R5_LOCKED, &dev->flags) && 
!test_bit(R5_UPTODATE, &dev->flags) &&
c


Thanks

David

NeilBrown wrote:

>Hi Marcelo,
> This patch fixes a long standing bug in raid5, that is fairly hard to hit.
>
> As the comment below says, the if() condition on the for loop is there to 
>optimised out the loop if it is known that it isn't needed, so making the test 
>broader (as this patch does) cannot possibly hurt in correctness.
>Please include this in an upcoming release.
>Thanks,
>NeilBrown
>
>(patch against 2.4.27-pre5)
>
>### Comments for Changeset
>
>
>This condition on this loop is primarily to avoid the loop
>if it doesn't appear to be needed.  However it optimises
>a little too much and there is a case where it skips the
>loop when it is really needed.  This patch fixes it.
>
>
>Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>
>
>### Diffstat output
> ./drivers/md/raid5.c |    2 +-
> 1 files changed, 1 insertion(+), 1 deletion(-)
>
>diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
>--- ./drivers/md/raid5.c~current~	2004-06-04 16:50:34.000000000 +1000
>+++ ./drivers/md/raid5.c	2004-06-04 16:51:06.000000000 +1000
>@@ -950,7 +950,7 @@ static void handle_stripe(struct stripe_
> 	/* Now we might consider reading some blocks, either to check/generate
> 	 * parity, or to satisfy requests
> 	 */
>-	if (to_read || (syncing && (uptodate+failed < disks))) {
>+	if (to_read || (syncing && (uptodate < disks))) {
> 		for (i=disks; i--;) {
> 			bh = sh->bh_cache[i];
> 			if (!buffer_locked(bh) && !buffer_uptodate(bh) &&
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

