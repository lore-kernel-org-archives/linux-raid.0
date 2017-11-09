From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 2/2] md: free unused memory after bitmap resize
Date: Thu, 9 Nov 2017 11:57:44 +0800
Message-ID: <936f1f54-9e16-fb1f-65cf-0a6bafda856e@suse.com>
References: <cover.1510144853.git.zkabelac@redhat.com>
 <ac40f62a52977843411704df04bf12f453345703.1510144853.git.zkabelac@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac40f62a52977843411704df04bf12f453345703.1510144853.git.zkabelac@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zdenek Kabelac <zkabelac@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 11/08/2017 08:44 PM, Zdenek Kabelac wrote:
> When bitmap is resized, the old kalloced chunks just are not released
> once the resized bitmap starts to use new space.
>
> This fixes in particular kmemleak reports like this one:
>
> unreferenced object 0xffff8f4311e9c000 (size 4096):
>    comm "lvm", pid 19333, jiffies 4295263268 (age 528.265s)
>    hex dump (first 32 bytes):
>      02 80 02 80 02 80 02 80 02 80 02 80 02 80 02 80  ................
>      02 80 02 80 02 80 02 80 02 80 02 80 02 80 02 80  ................
>    backtrace:
>      [<ffffffffa69471ca>] kmemleak_alloc+0x4a/0xa0
>      [<ffffffffa628c10e>] kmem_cache_alloc_trace+0x14e/0x2e0
>      [<ffffffffa676cfec>] bitmap_checkpage+0x7c/0x110
>      [<ffffffffa676d0c5>] bitmap_get_counter+0x45/0xd0
>      [<ffffffffa676d6b3>] bitmap_set_memory_bits+0x43/0xe0
>      [<ffffffffa676e41c>] bitmap_init_from_disk+0x23c/0x530
>      [<ffffffffa676f1ae>] bitmap_load+0xbe/0x160
>      [<ffffffffc04c47d3>] raid_preresume+0x203/0x2f0 [dm_raid]
>      [<ffffffffa677762f>] dm_table_resume_targets+0x4f/0xe0
>      [<ffffffffa6774b52>] dm_resume+0x122/0x140
>      [<ffffffffa6779b9f>] dev_suspend+0x18f/0x290
>      [<ffffffffa677a3a7>] ctl_ioctl+0x287/0x560
>      [<ffffffffa677a693>] dm_ctl_ioctl+0x13/0x20
>      [<ffffffffa62d6b46>] do_vfs_ioctl+0xa6/0x750
>      [<ffffffffa62d7269>] SyS_ioctl+0x79/0x90
>      [<ffffffffa6956d41>] entry_SYSCALL_64_fastpath+0x1f/0xc2
>
> Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
> ---
>   drivers/md/bitmap.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index d2121637b4ab..58ee21027709 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c

The bitmap.c is renamed to md-bitmap.c now.

> @@ -2152,6 +2152,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   				for (k = 0; k < page; k++) {
>   					kfree(new_bp[k].map);
>   				}
> +				kfree(new_bp);

Agreed.

>   
>   				/* restore some fields from old_counts */
>   				bitmap->counts.bp = old_counts.bp;
> @@ -2202,6 +2203,14 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   		block += old_blocks;
>   	}
>   
> +	if (bitmap->counts.bp != old_counts.bp) {
> +		unsigned long k;

Just nit-picking, maybe you can move belows to

> +		for (k = 0; k < old_counts.pages; k++)
> +			if (!old_counts.bp[k].hijacked)
> +				kfree(old_counts.bp[k].map);
> +		kfree(old_counts.bp);
> +	}
> +
>   	if (!init) {
>   		int i;

here and reuse the 'i'.

Thanks,
Guoqing
