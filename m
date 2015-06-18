From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v3 5/8] md: don't allow resize/reshape with cache
 support
Date: Thu, 18 Jun 2015 11:16:17 +1000
Message-ID: <20150618111617.784b0b54@home.neil.brown.name>
References: <cover.1433356864.git.shli@fb.com>
	<818a40768c716d0d553d55a7cc7b382ebcd7d036.1433356864.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <818a40768c716d0d553d55a7cc7b382ebcd7d036.1433356864.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, 3 Jun 2015 15:48:40 -0700
Shaohua Li <shli@fb.com> wrote:

> If cache support is enabled, don't allow resize/reshape in current
> stage. In the future, we can flush all data from cache to raid before
> resize/reshape and then allow resize/reshape.
> 
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 26561d8..29f49c7 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7207,6 +7207,10 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
>  	 * worth it.
>  	 */
>  	sector_t newsize;
> +	struct r5conf *conf = mddev->private;
> +
> +	if (conf->cache)
> +		return -EINVAL;
>  	sectors &= ~((sector_t)mddev->chunk_sectors - 1);
>  	newsize = raid5_size(mddev, sectors, mddev->raid_disks);
>  	if (mddev->external_size &&
> @@ -7258,6 +7262,8 @@ static int check_reshape(struct mddev *mddev)
>  {
>  	struct r5conf *conf = mddev->private;
>  
> +	if (conf->cache)
> +		return -EINVAL;
>  	if (mddev->delta_disks == 0 &&
>  	    mddev->new_layout == mddev->layout &&
>  	    mddev->new_chunk_sectors == mddev->chunk_sectors)

This patch should come before that patch which enables caches - the
could should be correct at each point in the series.

NeilBrown
