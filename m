From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] raid10: record correct address of bad block
Date: Wed, 17 Aug 2016 09:52:54 -0700
Message-ID: <20160817165254.GA35041@kernel.org>
References: <1470992633-8903-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470992633-8903-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

On Fri, Aug 12, 2016 at 11:03:53AM +0200, Tomasz Majchrzak wrote:
> For failed write request record block address on a device, not block
> address in an array.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  drivers/md/raid10.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index cfa96b5..d18b26d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2449,6 +2449,7 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
>  
>  	int block_sectors;
>  	sector_t sector;
> +	sector_t data_offset;
>  	int sectors;
>  	int sect_to_write = r10_bio->sectors;
>  	int ok = 1;
> @@ -2462,6 +2463,7 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
>  	sectors = ((r10_bio->sector + block_sectors)
>  		   & ~(sector_t)(block_sectors - 1))
>  		- sector;
> +	data_offset = choose_data_offset(r10_bio, rdev);
>  
>  	while (sect_to_write) {
>  		struct bio *wbio;
> @@ -2471,13 +2473,12 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
>  		wbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
>  		bio_trim(wbio, sector - bio->bi_iter.bi_sector, sectors);
>  		wbio->bi_iter.bi_sector = (r10_bio->devs[i].addr+
> -				   choose_data_offset(r10_bio, rdev) +
> -				   (sector - r10_bio->sector));
> +				   data_offset + (sector - r10_bio->sector));
>  		wbio->bi_bdev = rdev->bdev;
>  		if (submit_bio_wait(WRITE, wbio) < 0)
>  			/* Failure! */
> -			ok = rdev_set_badblocks(rdev, sector,
> -						sectors, 0)
> +			ok = rdev_set_badblocks(rdev, wbio->bi_iter.bi_sector -
> +						data_offset, sectors, 0)

bi_iter is immutable after submit_bio, so please not use it

Thanks,
Shaohua
