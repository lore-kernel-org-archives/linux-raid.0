From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 007 of 13] md: Core of raid5 resize process
Date: Thu, 16 Mar 2006 22:03:22 -0800
Message-ID: <20060316220322.0cfa80bf.akpm@osdl.org>
References: <20060317154017.15880.patches@notabene>
	<1060317044755.16096@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060317044755.16096@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> @@ -4539,7 +4543,9 @@ static void md_do_sync(mddev_t *mddev)
>   		 */
>   		max_sectors = mddev->resync_max_sectors;
>   		mddev->resync_mismatches = 0;
>  -	} else
>  +	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
>  +		max_sectors = mddev->size << 1;
>  +	else
>   		/* recovery follows the physical size of devices */
>   		max_sectors = mddev->size << 1;
>   

This change is a no-op.   Intentional?
