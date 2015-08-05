From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 7/9] raid5: don't allow resize/reshape with cache(log)
 support
Date: Wed, 5 Aug 2015 14:13:51 +1000
Message-ID: <20150805141351.126bb888@noble>
References: <cover.1438215986.git.shli@fb.com>
	<7986246dabd1722b2ea9461da91651509049c2a6.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7986246dabd1722b2ea9461da91651509049c2a6.1438215986.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, 29 Jul 2015 17:38:47 -0700 Shaohua Li <shli@fb.com> wrote:

> If cache(log) support is enabled, don't allow resize/reshape in current
> stage. In the future, we can flush all data from cache(log) to raid
> before resize/reshape and then allow resize/reshape.

Just to be on the safe side, you could probably add code to refuse to
start an array that is in the middle of a reshape and also have a log
configured.

I think it makes sense to plan ahead a little and make sure we can
handle a cache on a reshaping array properly.

If the log metadata block includes a before/after flag for each stripe,
which recorded whether the stripe was "before" or "after"
reshape_position when it was written, then when recovering the log we
can check if the given addresses are still on that side.  If they are,
just recover using the appropriate geometry info from the superblock.
If not, then reshape has passed over that stripe and it must now be
fully up-to-date on the RAID so the data in the log can be discarded.

There may be some details I missed, but I think it is worth thinking
through properly.  I don't expect the code to handle this straight
away, but we need a clear plan to be sure there is sufficient
information stored in the log.

Thanks,
NeilBrown

> 
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 59f9312..b694d06 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7184,6 +7184,10 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
>  	 * worth it.
>  	 */
>  	sector_t newsize;
> +	struct r5conf *conf = mddev->private;
> +
> +	if (conf->log)
> +		return -EINVAL;
>  	sectors &= ~((sector_t)mddev->chunk_sectors - 1);
>  	newsize = raid5_size(mddev, sectors, mddev->raid_disks);
>  	if (mddev->external_size &&
> @@ -7235,6 +7239,8 @@ static int check_reshape(struct mddev *mddev)
>  {
>  	struct r5conf *conf = mddev->private;
>  
> +	if (conf->log)
> +		return -EINVAL;
>  	if (mddev->delta_disks == 0 &&
>  	    mddev->new_layout == mddev->layout &&
>  	    mddev->new_chunk_sectors == mddev->chunk_sectors)

