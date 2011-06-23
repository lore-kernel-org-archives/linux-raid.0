From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm --detail was incorrect for shrinking reshapes
Date: Thu, 23 Jun 2011 11:47:55 +1000
Message-ID: <20110623114755.5674ac60@notabene.brown>
References: <1308586015.10185.11@hogo>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308586015.10185.11@hogo>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 20 Jun 2011 09:06:55 -0700 Andrew Burgess <aab@cichlid.com> wrote:

> Since info->delta_disks is signed it doesn't need to be special-cased.
> 
> This allowed my 9->8 reshape to display correctly instead of as 8->7
> 
> (the "This is pretty boring" context is apparently the universe's
> opinion of my first patch!)
> 
> 
> mdadm> git diff
> diff --git a/Detail.c b/Detail.c
> index 375189d..40806cf 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -430,12 +430,9 @@ This is pretty boring
>   			printf("  Reshape pos'n : %llu%s\n", (unsigned  
> long long) info->reshape_progress<<9,
>   			       human_size((unsigned long  
> long)info->reshape_progress<<9));
>   #endif
> -			if (info->delta_disks > 0)
> +			if (info->delta_disks != 0)
>   				printf("  Delta Devices : %d,  
> (%d->%d)\n",
>   				       info->delta_disks,  
> array.raid_disks - info->delta_disks, array.raid_disks);
> -			if (info->delta_disks < 0)
> -				printf("  Delta Devices : %d,  
> (%d->%d)\n",
> -				       info->delta_disks,  
> array.raid_disks, array.raid_disks + info->delta_disks);
>   			if (info->new_level != array.level) {
>   				char *c = map_num(pers,  
> info->new_level);
>   				printf("      New Level : %s\n",  
> c?c:"-unknown-");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Thanks.

BTW "format=flowed" doesn't really work for patches.. Fortunately it was
small enough that I could just apply it by hand.

I had originally planned that "raid_disk" should always be the maximum of the
"before" and "after" number of devices in the array - so that it needed
exactly "raid_disks" devices to be non-degraded etc.  It seems that didn't
really work out but I never fixed this code to reflect reality.

Thanks for the patch, it is applied now.

NeilBrown

