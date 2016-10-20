From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 3/3 v2] md: unblock array if bad blocks have been
 acknowledged
Date: Wed, 19 Oct 2016 22:28:18 -0700
Message-ID: <20161020052818.GA17974@kernel.org>
References: <1476799824-6498-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476799824-6498-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com, maksymilian.kunt@intel.com, mariusz.dabrowski@intel.com, axboe@kernel.dk, dan.j.williams@intel.com, linux-block@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 18, 2016 at 04:10:24PM +0200, Tomasz Majchrzak wrote:
> Once external metadata handler acknowledges all bad blocks (by writing
> to rdev 'bad_blocks' sysfs file), it requests to unblock the array.
> Check if all bad blocks are actually acknowledged as there might be a
> race if new bad blocks are notified at the same time. If all bad blocks
> are acknowledged, just unblock the array and continue. If not, ignore
> the request to unblock (do not fail an array). External metadata handler
> is expected to either process remaining bad blocks and try to unblock
> again or remove bad block support for a disk (which will cause disk to
> fail as in no-support case).
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  drivers/md/md.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index cc05236..ce585b7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2612,19 +2612,29 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>  		set_bit(Blocked, &rdev->flags);
>  		err = 0;
>  	} else if (cmd_match(buf, "-blocked")) {
> -		if (!test_bit(Faulty, &rdev->flags) &&
> +		int unblock = 1;
> +		int acked = !rdev->badblocks.unacked_exist;
> +
> +		if ((test_bit(ExternalBbl, &rdev->flags) &&
> +		     rdev->badblocks.changed))
> +			acked = check_if_badblocks_acked(&rdev->badblocks);
> +
> +		if (test_bit(ExternalBbl, &rdev->flags) && !acked) {
> +			unblock = 0;
> +		} else if (!test_bit(Faulty, &rdev->flags) &&

I missed one thing in last review. writing to bad_blocks sysfs file already
clears the BlockedBadBlocks bit and wakeup the thread sleeping at blocked_wait,
so the array can continue. Why do we need to fix state_store here?

Thanks,
Shaohua
