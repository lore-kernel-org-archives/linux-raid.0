From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 18/22] md: use little endian bit operations
Date: Mon, 18 Oct 2010 13:41:27 +1100
Message-ID: <20101018134127.5d1264fb@notabene>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
	<1287135981-17604-19-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1287135981-17604-19-git-send-email-akinobu.mita@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 15 Oct 2010 18:46:17 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> As a preparation for removing ext2 non-atomic bit operations from
> asm/bitops.h. This converts ext2 non-atomic bit operations to
> little endian bit operations.

Looks good, thanks.

Acked-by: NeilBrown <neilb@suse.de>

NeilBrown

> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: linux-raid@vger.kernel.org
> ---
>  drivers/md/bitmap.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index e4fb58d..2a37051 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -850,7 +850,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
>  		if (bitmap->flags & BITMAP_HOSTENDIAN)
>  			set_bit(bit, kaddr);
>  		else
> -			ext2_set_bit(bit, kaddr);
> +			__test_and_set_le_bit(bit, kaddr);
>  		kunmap_atomic(kaddr, KM_USER0);
>  		PRINTK("set file bit %lu page %lu\n", bit, page->index);
>  	}
> @@ -1046,7 +1046,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
>  		if (bitmap->flags & BITMAP_HOSTENDIAN)
>  			b = test_bit(bit, paddr);
>  		else
> -			b = ext2_test_bit(bit, paddr);
> +			b = test_le_bit(bit, paddr);
>  		kunmap_atomic(paddr, KM_USER0);
>  		if (b) {
>  			/* if the disk bit is set, set the memory bit */
> @@ -1222,7 +1222,7 @@ void bitmap_daemon_work(mddev_t *mddev)
>  						clear_bit(file_page_offset(bitmap, j),
>  							  paddr);
>  					else
> -						ext2_clear_bit(file_page_offset(bitmap, j),
> +						__test_and_clear_le_bit(file_page_offset(bitmap, j),
>  							       paddr);
>  					kunmap_atomic(paddr, KM_USER0);
>  				} else
