From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 2/8] md/raid5: Ensure a batch member is not handled
 prematurely.
Date: Fri, 22 May 2015 16:44:02 -0700
Message-ID: <20150522234402.GA86128@kernel.org>
References: <20150522052802.2117.40527.stgit@notabene.brown>
 <20150522053058.2117.29026.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150522053058.2117.29026.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 22, 2015 at 03:30:58PM +1000, NeilBrown wrote:
> If a stripe is a member of a batch, but not the head, it must
> not be handled separately from the rest of the batch.
> 
> 'clear_batch_ready()' handles this requirement to some
> extent but not completely.  If a member is passed to handle_stripe()
> a second time it returns '0' indicating the stripe can be handled,
> which is wrong.
> So add an extra test.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  drivers/md/raid5.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c3ccefbd4fe7..9a803b735848 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4192,9 +4192,13 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
>  
>  static int clear_batch_ready(struct stripe_head *sh)
>  {
> +	/* Return '1' if this is a member of batch, or
> +	 * '0' if it is a lone stripe or a head which can now be
> +	 * handled.
> +	 */
>  	struct stripe_head *tmp;
>  	if (!test_and_clear_bit(STRIPE_BATCH_READY, &sh->state))
> -		return 0;
> +		return (sh->batch_head && sh->batch_head != sh);
>  	spin_lock(&sh->stripe_lock);
>  	if (!sh->batch_head) {
>  		spin_unlock(&sh->stripe_lock);

which case can this happen in?

Patches look good. But I'm not in Fusionio any more, so can't check the
performance in big raid array with fast flash cards. I'm doing some tests here.
I hit a warning in break_stripe_batch_list, STRIPE_BIT_DELAY is set in the
stripe state. I'm checking the reason, but if you have thoughts I can try
immediately, please let me know.

Thanks,
Shaohua
