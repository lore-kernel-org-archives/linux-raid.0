From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: 2.6.25.6 raid5 resync oops
Date: Wed, 09 Jul 2008 21:54:57 -0700
Message-ID: <1215665697.7848.15.camel@dwillia2-linux.ch.intel.com>
References: <200807092019.20090.arekm@maven.pl>
	 <18549.24814.313777.410346@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18549.24814.313777.410346@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2008-07-09 at 18:07 -0700, Neil Brown wrote:
> Dan:  I think this is your code.  In
>   __handle_issuing_new_read_requests5
> the
>                 } else if ((s->uptodate < disks - 1) &&
>                         test_bit(R5_Insync, &dev->flags)) {
> 
> looks wrong.  We at least want a test on s->syncing in there, maybe:
>                 } else if (((s->uptodate < disks - 1) || s->syncing)
> &&
>                         test_bit(R5_Insync, &dev->flags)) {
> 
> and given that we only compute blocks when a device is failed, (see 15
> lines earlier) I think we probably just want
>                 } else if (test_bit(R5_Insync, &dev->flags)) {
> 
> I notice that is was it in linux-next (though the functions are
> renamed - it is fetch_block5 there).

Yes, I had realized it was obsolete... missed that it was buggy.
> 
> I wonder if there is still time for 2.6.26 .. probably not.  It'll be
> released immediately after lwn.net release their weekly edition :-)

Here is a patch against latest mainline.

---snip--->
md: ensure all blocks are uptodate or locked when syncing

From: Dan Williams <dan.j.williams@intel.com>

Remove the dubious attempt to prefer 'compute' over 'read'.  Not only is it
wrong given commit c337869d (md: do not compute parity unless it is on a failed
drive), but it can trigger a BUG_ON in handle_parity_checks5().

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 54c8ee2..3b27df5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2017,12 +2017,7 @@ static int __handle_issuing_new_read_requests5(struct stripe_head *sh,
 			 */
 			s->uptodate++;
 			return 0; /* uptodate + compute == disks */
-		} else if ((s->uptodate < disks - 1) &&
-			test_bit(R5_Insync, &dev->flags)) {
-			/* Note: we hold off compute operations while checks are
-			 * in flight, but we still prefer 'compute' over 'read'
-			 * hence we only read if (uptodate < * disks-1)
-			 */
+		} else if (test_bit(R5_Insync, &dev->flags)) {
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantread, &dev->flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))


