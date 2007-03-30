From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm: RUN_ARRAY failed: Cannot allocate memory
Date: Fri, 30 Mar 2007 12:37:25 -0400
Message-ID: <460D3CC5.10004@tmr.com>
References: <Pine.LNX.4.64.0703212139010.2224@filesrv1.baby-dragons.com>	<Pine.LNX.4.64.0703241216590.21973@filesrv1.baby-dragons.com> <17931.28833.443823.720207@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17931.28833.443823.720207@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, linux-raid maillist <linux-raid@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Saturday March 24, babydr@baby-dragons.com wrote:
>   
>>  	Hello Neil ,  I found the problem that caused the 'cannot allcate 
>> memory' ,  DON'T use '--bitmap=' .
>>  	But that said ,  Hmmmm ,  Shouldn't mdadm just stop & say ...
>>  	'md: bitmaps not supported for this level.'
>>  	Like it puts out into  dmesg .
>>
>>  	Also think this message in dmesg is interesting .
>>  	"raid0: bad disk number -1 - aborting!'
>>
>>  		Hth ,  JimL
>>     
>
> Yeah.... mdadm should be fixed too, but this kernel patch should make
> it behave a bit better.  I'll queue it for 2.6.22.
>   
Given the release cycle, this might fit 2.6.21-rc6 (is is a fix), or 
stable 2.6.21.1 if 21 comes out soon. In any case it could go in -mm for 
testing and to be sure it would be pushed at an appropriate time.
> Thanks,
> NeilBrown
>
>
> Move test for whether level supports bitmap to correct place.
>
> We need to check for internal-consistency of superblock in
> load_super.  validate_super is for inter-device consistency.
>
>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
>  ./drivers/md/md.c |   42 ++++++++++++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 16 deletions(-)
>
> diff .prev/drivers/md/md.c ./drivers/md/md.c
> --- .prev/drivers/md/md.c	2007-03-29 16:42:18.000000000 +1000
> +++ ./drivers/md/md.c	2007-03-29 16:49:26.000000000 +1000
> @@ -695,6 +695,17 @@ static int super_90_load(mdk_rdev_t *rde
>  	rdev->data_offset = 0;
>  	rdev->sb_size = MD_SB_BYTES;
>  
> +	if (sb->state & (1<<MD_SB_BITMAP_PRESENT)) {
> +		if (sb->level != 1 && sb->level != 4
> +		    && sb->level != 5 && sb->level != 6
> +		    && sb->level != 10) {
> +			/* FIXME use a better test */
> +			printk(KERN_WARNING
> +			       "md: bitmaps not supported for this level.\n");
> +			goto abort;
> +		}
> +	}
> +
>  	if (sb->level == LEVEL_MULTIPATH)
>  		rdev->desc_nr = -1;
>  	else
> @@ -793,16 +804,8 @@ static int super_90_validate(mddev_t *md
>  		mddev->max_disks = MD_SB_DISKS;
>  
>  		if (sb->state & (1<<MD_SB_BITMAP_PRESENT) &&
> -		    mddev->bitmap_file == NULL) {
> -			if (mddev->level != 1 && mddev->level != 4
> -			    && mddev->level != 5 && mddev->level != 6
> -			    && mddev->level != 10) {
> -				/* FIXME use a better test */
> -				printk(KERN_WARNING "md: bitmaps not supported for this level.\n");
> -				return -EINVAL;
> -			}
> +		    mddev->bitmap_file == NULL)
>  			mddev->bitmap_offset = mddev->default_bitmap_offset;
> -		}
>  
>  	} else if (mddev->pers == NULL) {
>  		/* Insist on good event counter while assembling */
> @@ -1059,6 +1062,18 @@ static int super_1_load(mdk_rdev_t *rdev
>  		       bdevname(rdev->bdev,b));
>  		return -EINVAL;
>  	}
> +	if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET)) {
> +		if (sb->level != cpu_to_le32(1) &&
> +		    sb->level != cpu_to_le32(4) &&
> +		    sb->level != cpu_to_le32(5) &&
> +		    sb->level != cpu_to_le32(6) &&
> +		    sb->level != cpu_to_le32(10)) {
> +			printk(KERN_WARNING
> +			       "md: bitmaps not supported for this level.\n");
> +			return -EINVAL;
> +		}
> +	}
> +
>  	rdev->preferred_minor = 0xffff;
>  	rdev->data_offset = le64_to_cpu(sb->data_offset);
>  	atomic_set(&rdev->corrected_errors, le32_to_cpu(sb->cnt_corrected_read));
> @@ -1142,14 +1157,9 @@ static int super_1_validate(mddev_t *mdd
>  		mddev->max_disks =  (4096-256)/2;
>  
>  		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) &&
> -		    mddev->bitmap_file == NULL ) {
> -			if (mddev->level != 1 && mddev->level != 5 && mddev->level != 6
> -			    && mddev->level != 10) {
> -				printk(KERN_WARNING "md: bitmaps not supported for this level.\n");
> -				return -EINVAL;
> -			}
> +		    mddev->bitmap_file == NULL )
>  			mddev->bitmap_offset = (__s32)le32_to_cpu(sb->bitmap_offset);
> -		}
> +
>  		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_RESHAPE_ACTIVE)) {
>  			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
>  			mddev->delta_disks = le32_to_cpu(sb->delta_disks);
>   
-- 

bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

