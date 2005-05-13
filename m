From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] raid1: set bi_idx after bio cloning
Date: Sat, 14 May 2005 09:08:10 +1000
Message-ID: <17029.13146.794856.708018@cse.unsw.edu.au>
References: <1116020307.6557.34.camel@langvan2.homenetwork>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Tran on Friday May 13
Sender: linux-raid-owner@vger.kernel.org
To: Mike Tran <mhtran@us.ibm.com>
Cc: axboe@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 13, mhtran@us.ibm.com wrote:
> Hi Neil et al,
> 
> The scenario:  Having LVM (striped) volumes on top of 2 raid1 devices
> The problem:   Corruption in building the scatter gather list for
> device driver (see /drivers/block/blk_rq_map_sg() function)
> 
> In DM code, a bio sometimes can be split into several
> clones and the clones' bi_idx is set accordingly by DM.  MD raid1 also
> clones bio but does not adjust bi_idx. The problem can be fixed in
> either __bio_clone() or the caller of bio_clone().  I chose to fix
> raid1.

Presumably the same fix would be needed in the "write" path and all in
the read-retry path in raid1d?

Why not just put it in __bio_clone, which would be one change instead
of (atleast) 3?

NeilBrown

> 
> --- linux-2.6.12-rc4-orig/drivers/md/raid1.c    2005-05-10 13:35:06.000000000-0500
> +++ linux-2.6.12-rc4-patch/drivers/md/raid1.c   2005-05-13 15:41:43.000000000-0500
> @@ -577,6 +577,7 @@
> 
>                 r1_bio->bios[rdisk] = read_bio;
> 
> +               read_bio->bi_idx = bio->bi_idx;
>                 read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
>                 read_bio->bi_bdev = mirror->rdev->bdev;
>                 read_bio->bi_end_io = raid1_end_read_request;
> 
> --
> Regards,
> Mike T.
> 
