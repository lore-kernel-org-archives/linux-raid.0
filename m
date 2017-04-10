From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid6: Fix anomily when recovering a single device in
 RAID6.
Date: Mon, 10 Apr 2017 10:34:08 -0700
Message-ID: <20170410173408.qz35phxtzadcc44u@kernel.org>
References: <87r31adyuj.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r31adyuj.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Linux-RAID <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Mon, Apr 03, 2017 at 12:11:32PM +1000, Neil Brown wrote:
> 
> When recoverying a single missing/failed device in a RAID6,
> those stripes where the Q block is on the missing device are
> handled a bit differently.  In these cases it is easy to
> check that the P block is correct, so we do.  This results
> in the P block be destroy.  Consequently the P block needs
> to be read a second time in order to compute Q.  This causes
> lots of seeks and hurts performance.
> 
> It shouldn't be necessary to re-read P as it can be computed
> from the DATA.  But we only compute blocks on missing
> devices, since c337869d9501 ("md: do not compute parity
> unless it is on a failed drive").
> 
> So relax the change made in that commit to allow computing
> of the P block in a RAID6 which it is the only missing that
> block.
> 
> This makes RAID6 recovery run much faster as the disk just
> "before" the recovering device is no longer seeking
> back-and-forth.
> 
> Reported-by-tested-by: Brad Campbell <lists2009@fnarfbargle.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: NeilBrown <neilb@suse.com>

Applied, thanks, very interesting analysis!

> ---
>  drivers/md/raid5.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c523fd69a7bc..aeb2e236a247 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3617,9 +3617,20 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
>  		BUG_ON(test_bit(R5_Wantcompute, &dev->flags));
>  		BUG_ON(test_bit(R5_Wantread, &dev->flags));
>  		BUG_ON(sh->batch_head);
> +
> +		/*
> +		 * In the raid6 case if the only non-uptodate disk is P
> +		 * then we already trusted P to compute the other failed
> +		 * drives. It is safe to compute rather than re-read P.
> +		 * In other cases we only compute blocks from failed
> +		 * devices, otherwise check/repair might fail to detect
> +		 * a real inconsistency.
> +		 */
> +
>  		if ((s->uptodate == disks - 1) &&
> +		    ((sh->qd_idx >= 0 && sh->pd_idx == disk_idx) ||
>  		    (s->failed && (disk_idx == s->failed_num[0] ||
> -				   disk_idx == s->failed_num[1]))) {
> +				   disk_idx == s->failed_num[1])))) {
>  			/* have disk failed, and we're requested to fetch it;
>  			 * do compute it
>  			 */
> -- 
> 2.12.0
> 


