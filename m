From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/6] md: convert conf->chunk_size and conf->prev_chunk to sectors.
Date: Tue, 26 May 2009 09:14:25 +1000
Message-ID: <18971.9809.796788.886556@notabene.brown>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
	<1243243657-21855-5-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Monday May 25
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 25, maan@systemlinux.org wrote:
> This kills some more shifts.
> 

> @@ -3916,9 +3915,9 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
>  		raid5_compute_sector(conf, stripe_addr*(new_data_disks),
>  				     1, &dd_idx, NULL);
>  	last_sector =
> -		raid5_compute_sector(conf, ((stripe_addr+conf->chunk_size/512)
> -					    *(new_data_disks) - 1),
> -				     1, &dd_idx, NULL);
> +		raid5_compute_sector(conf, (stripe_addr + conf->chunk_sectors)
> +					   * new_data_disks - 1,
> +					   1, &dd_idx, NULL);

FYI, the () that you removed there were present for a reason.  They
help emacs C-mode to get the indenting right.
Without them, the indent function make it look like
> +		raid5_compute_sector(conf, (stripe_addr + conf->chunk_sectors)
> +				     * new_data_disks - 1,
> +				     1, &dd_idx, NULL);

With them I get
		raid5_compute_sector(conf, ((stripe_addr + conf->chunk_sectors)
					    * new_data_disks - 1),
				     1, &dd_idx, NULL);

which is "correct".

> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 1a25c9e..f2e1259 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -334,7 +334,8 @@ struct raid5_private_data {
>  	struct hlist_head	*stripe_hashtbl;
>  	mddev_t			*mddev;
>  	struct disk_info	*spare;
> -	int			chunk_size, level, algorithm;
> +	sector_t		chunk_sectors;
> +	int			level, algorithm;
>  	int			max_degraded;
>  	int			raid_disks;
>  	int			max_nr_stripes;
> @@ -350,7 +351,8 @@ struct raid5_private_data {
>  	 */
>  	sector_t		reshape_safe;
>  	int			previous_raid_disks;
> -	int			prev_chunk, prev_algo;
> +	sector_t		prev_chunk_sectors;
> +	int			prev_algo;
>  	short			generation; /* increments with every reshape */
>  	unsigned long		reshape_checkpoint; /* Time we last updated
>  						     * metadata */

I restored these to 'int' too.

Thanks!

NeilBrown
