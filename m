From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/5] md: Turn rdev->sb_offset into a sector-based quantity.
Date: Fri, 11 Jul 2008 21:15:17 +1000
Message-ID: <18551.16581.929399.413701@notabene.brown>
References: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
	<1215681338-32365-5-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Thursday July 10
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 10, maan@systemlinux.org wrote:
> Rename it to sb_start to make sure all users have been converted.

Good idea.

> @@ -1047,22 +1045,21 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
>  	 */
>  	switch(minor_version) {
>  	case 0:
> -		sb_offset = rdev->bdev->bd_inode->i_size >> 9;
> -		sb_offset -= 8*2;
> -		sb_offset &= ~(sector_t)(4*2-1);
> +		sb_start = rdev->bdev->bd_inode->i_size >> 9;
> +		sb_start -= 8*2;
> +		sb_start &= ~(sector_t)(4*2-1);
>  		/* convert from sectors to K */
> -		sb_offset /= 2;
>  		break;

That "convert.." comment can go.

>  
>  	if (minor_version
> -	    && rdev->data_offset < sb_offset + (rdev->sb_size/512))
> +	    && rdev->data_offset < sb_start / 2 + (rdev->sb_size/512))
>  		return -EINVAL;

That doesn't look right.
  rdev->data_offset is in sectors.
  rdev->sb_size/512 is in sectors.
  sb_offset is in K.
We had a bug there.  Better fix it by dropping the "/ 2".

> @@ -3431,16 +3428,16 @@ static int do_md_run(mddev_t * mddev)
>  		 * We don't want the data to overlap the metadata,
>  		 * Internal Bitmap issues has handled elsewhere.
>  		 */
> -		if (rdev->data_offset < rdev->sb_offset) {
> +		if (rdev->data_offset < rdev->sb_start / 2) {

And another bug.  We don't want the "/ 2".  data_offset was always
sectors, and now sb_offset is too.
That's two bugs we've found by doing this conversion - thanks!


NeilBrown
