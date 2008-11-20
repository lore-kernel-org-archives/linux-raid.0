From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md_print_devices: use le{32,64}_to_cpu to access data correctly
Date: Thu, 20 Nov 2008 22:50:52 +1100
Message-ID: <18725.20252.24921.39204@notabene.brown>
References: <1227179997-6394-1-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: message from crquan@gmail.com on Thursday November 20
Sender: linux-next-owner@vger.kernel.org
To: crquan@gmail.com
Cc: linux-raid@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, wshen_gfkd@163.com
List-Id: linux-raid.ids

On Thursday November 20, crquan@gmail.com wrote:
> From: Cheng Renquan <crquan@gmail.com>
> 
> The previous direct accessing have endian problems,
> Sorry for that lacking of thoughtful consideration.
> 
> At the same time define a MASK value to get the seconds
> value of time conveniently.

Thanks.
I have merged this with the previous patch and also made the change
Stephen mentioned about casting 64bit values to (unsigned long long).
This has now been pushed out to for-next.

Where we print a 64bit value I changed the format string from %L
to %ll because that is what is used elsewhere in md.c, and consistency
is good.  
On some architectures, a 64bit value is an "unsigned long", on others
it is "unsigned long long".  So we cannot always print such a value
with %llx.
So I added a cast: (unsigned long long) to each 64 bit value that was
being passed to printk.

Thanks,
NeilBrown

> 
> Signed-off-by: Cheng Renquan <crquan@gmail.com>
> ---
> This patch can be applied on git://neil.brown.name/md for-next branch.
> 
>  drivers/md/md.c           |   38 +++++++++++++++++++++++---------------
>  include/linux/raid/md_p.h |    2 ++
>  2 files changed, 25 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ffc63be..058cf34 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1664,37 +1664,45 @@ static void print_sb_1(struct mdp_superblock_1 *sb)
>  	__u8 *uuid;
>  
>  	uuid = sb->set_uuid;
> -	printk(KERN_INFO "md:  SB: (V:%d) (F:%x) Array-ID:<%02x%02x%02x%02x"
> +	printk(KERN_INFO "md:  SB: (V:%u) (F:0x%08x) Array-ID:<%02x%02x%02x%02x"
>  			":%02x%02x:%02x%02x:%02x%02x:%02x%02x%02x%02x%02x%02x>\n"
>  	       KERN_INFO "md:    Name: \"%s\" CT:%Lu\n",
> -		sb->major_version, sb->feature_map,
> +		le32_to_cpu(sb->major_version),
> +		le32_to_cpu(sb->feature_map),
>  		uuid[0], uuid[1], uuid[2], uuid[3],
>  		uuid[4], uuid[5], uuid[6], uuid[7],
>  		uuid[8], uuid[9], uuid[10], uuid[11],
>  		uuid[12], uuid[13], uuid[14], uuid[15],
>  		sb->set_name,
> -		sb->ctime & 0xffffffffffLL);
> +		le64_to_cpu(sb->ctime) & MD_SUPERBLOCK_1_TIME_SEC_MASK);
>  
>  	uuid = sb->device_uuid;
> -	printk(KERN_INFO "md:       L%d SZ%Ld RD:%d LO:%d CS:%d DO:%Ld DS:%Ld SO:%Ld"
> -			" RO:%Ld\n"
> +	printk(KERN_INFO "md:       L%u SZ%Lu RD:%u LO:%u CS:%u DO:%Lu DS:%Lu SO:%Lu"
> +			" RO:%Lu\n"
>  	       KERN_INFO "md:     Dev:%08x UUID: %02x%02x%02x%02x:%02x%02x:%02x%02x:%02x%02x"
>  			":%02x%02x%02x%02x%02x%02x\n"
> -	       KERN_INFO "md:       (F:%d) UT:%Lu Events:%Ld ResyncOffset:%Ld CSUM:%08x\n"
> -	       KERN_INFO "md:         (MaxDev:%d) \n",
> -		sb->level, sb->size, sb->raid_disks,
> -		sb->layout, sb->chunksize,
> -		sb->data_offset, sb->data_size,
> -		sb->super_offset, sb->recovery_offset,
> -		sb->dev_number,
> +	       KERN_INFO "md:       (F:0x%08x) UT:%Lu Events:%Lu ResyncOffset:%Lu CSUM:0x%08x\n"
> +	       KERN_INFO "md:         (MaxDev:%u) \n",
> +		le32_to_cpu(sb->level),
> +		le64_to_cpu(sb->size),
> +		le32_to_cpu(sb->raid_disks),
> +		le32_to_cpu(sb->layout),
> +		le32_to_cpu(sb->chunksize),
> +		le64_to_cpu(sb->data_offset),
> +		le64_to_cpu(sb->data_size),
> +		le64_to_cpu(sb->super_offset),
> +		le64_to_cpu(sb->recovery_offset),
> +		le32_to_cpu(sb->dev_number),
>  		uuid[0], uuid[1], uuid[2], uuid[3],
>  		uuid[4], uuid[5], uuid[6], uuid[7],
>  		uuid[8], uuid[9], uuid[10], uuid[11],
>  		uuid[12], uuid[13], uuid[14], uuid[15],
>  		sb->devflags,
> -		sb->utime, sb->events,
> -		sb->resync_offset,
> -		sb->sb_csum, sb->max_dev
> +		le64_to_cpu(sb->utime) & MD_SUPERBLOCK_1_TIME_SEC_MASK,
> +		le64_to_cpu(sb->events),
> +		le64_to_cpu(sb->resync_offset),
> +		le32_to_cpu(sb->sb_csum),
> +		le32_to_cpu(sb->max_dev)
>  		);
>  }
>  
> diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
> index 8b4de4a..269e147 100644
> --- a/include/linux/raid/md_p.h
> +++ b/include/linux/raid/md_p.h
> @@ -194,6 +194,8 @@ static inline __u64 md_event(mdp_super_t *sb) {
>  	return (ev<<32)| sb->events_lo;
>  }
>  
> +#define MD_SUPERBLOCK_1_TIME_SEC_MASK ((1UL<<40) - 1)
> +
>  /*
>   * The version-1 superblock :
>   * All numeric fields are little-endian.
> -- 
> 1.6.0.4.757.g6d002.dirty
> 
> Cheng Renquan, Shenzhen, China
