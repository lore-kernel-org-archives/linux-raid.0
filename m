From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 006 of 13] md: Infrastructure to allow normal IO to
 continue while array is expanding.
Date: Thu, 16 Mar 2006 22:01:37 -0800
Message-ID: <20060316220137.5820ab09.akpm@osdl.org>
References: <20060317154017.15880.patches@notabene>
	<1060317044750.16084@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060317044750.16084@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
>  -	retry:
>   		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
>  -		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
>  +		sh = get_active_stripe(conf, new_sector, disks, pd_idx, (bi->bi_rw&RWA_MASK));
>   		if (sh) {
>  -			if (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
>  -				/* Add failed due to overlap.  Flush everything
>  +			if (unlikely(conf->expand_progress != MaxSector)) {
>  +				/* expansion might have moved on while waiting for a
>  +				 * stripe, so we much do the range check again.
>  +				 */
>  +				int must_retry = 0;
>  +				spin_lock_irq(&conf->device_lock);
>  +				if (logical_sector <  conf->expand_progress &&
>  +				    disks == conf->previous_raid_disks)
>  +					/* mismatch, need to try again */
>  +					must_retry = 1;
>  +				spin_unlock_irq(&conf->device_lock);
>  +				if (must_retry) {
>  +					release_stripe(sh);
>  +					goto retry;
>  +				}
>  +			}

The locking in here looks strange.  We take the lock, do some arithmetic
and some tests and then drop the lock again.  Is it not possible that the
result of those tests now becomes invalid?

