From: Evan Felix <evan.felix@pnl.gov>
Subject: Re: [PATCH] Linux Raid5/6 abover 2 Terabytes
Date: Mon, 12 Apr 2004 08:53:54 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1081785234.22588.5.camel@e-linux>
References: <249C1CB246997C48BB74963CCD361C1B02376A60@pnlmse28.pnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <249C1CB246997C48BB74963CCD361C1B02376A60@pnlmse28.pnl.gov>
To: linux-raid <linux-raid@vger.kernel.org>
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Niel, did you push this patch to the kernel guys for inclusion in the
next 2.6 kernel?

Also by way of status i've built a 5.7Tb SATA array (level 5/6) with
this change in the kernel.

so that pushes us to about 4 Arrays now..

Evan

On Tue, 2004-04-06 at 14:00, Felix, Evan J wrote:
> Here is a patch that fixes a major issue in the raid5/6 code.  It
> seems
> that the code:
> 
> logical_sector = bi->bi_sector & ~(STRIPE_SECTORS-1);
> (sector_t)     = (sector_t)    & (constant)
> 
> that the right side of the & does not get extended correctly when the
> constant is promoted to the sector_t type.  I have CONFIG_LBD turned
> on
> so sector_t should be 64bits wide.  This fails to properly mask the
> value of 4294967296 (2TB/512) to 4294967296.  in my case it was coming
> out 0.  this cause the loop following this code to read from 0 to
> 4294967296 blocks so it could write one character.
> 
> As you might imagine this makes a format of a 3.5TB filesystem take a
> very long time.
> 
> Here is the patch:
> Binary files linux-2.6.5/drivers/md/mktables and
> linux-2.6.5fixraid/drivers/md/mktables differ
> diff -urN -X /home/efelix/.cvsignore linux-2.6.5/drivers/md/raid5.c
> linux-2.6.5fixraid/drivers/md/raid5.c
> --- linux-2.6.5/drivers/md/raid5.c      2004-04-04 03:36:26.000000000
> +0000
> +++ linux-2.6.5fixraid/drivers/md/raid5.c       2004-04-06
> 18:26:05.000000000
> +0000
> @@ -1334,8 +1334,9 @@
>                 disk_stat_add(mddev->gendisk, read_sectors,
> bio_sectors(bi));
>         }
> 
> -       logical_sector = bi->bi_sector & ~(STRIPE_SECTORS-1);
> +       logical_sector = bi->bi_sector &
> ~((sector_t)STRIPE_SECTORS-1);
>         last_sector = bi->bi_sector + (bi->bi_size>>9);
> +       PRINTK("Bio: %Lu logical %Lu   last
> %Lu\n",bi->bi_sector,logical_sector,last_sector);
>  
>         bi->bi_next = NULL;
>         bi->bi_phys_segments = 1;       /* over-loaded to count active
> stripes */
> diff -urN -X /home/efelix/.cvsignore
> linux-2.6.5/drivers/md/raid6main.c
> linux-2.6.5fixraid/drivers/md/raid6main.c
> --- linux-2.6.5/drivers/md/raid6main.c  2004-04-04 03:36:14.000000000
> +0000
> +++ linux-2.6.5fixraid/drivers/md/raid6main.c   2004-04-06
> 18:31:30.000000000 +0000
> @@ -1496,7 +1496,7 @@
>                 disk_stat_add(mddev->gendisk, read_sectors,
> bio_sectors(bi));
>         }
>  
> -       logical_sector = bi->bi_sector & ~(STRIPE_SECTORS-1);
> +       logical_sector = bi->bi_sector &
> ~((sector_t)STRIPE_SECTORS-1);
>         last_sector = bi->bi_sector + (bi->bi_size>>9);
>  
>         bi->bi_next = NULL;
> 
> 
> I have tested this on at least 2 arrays, with ext2 and some long dd's
> 
> Evan
> -- 
> -------------------------
> Evan Felix
> Administrator of Supercomputer #5 in Top 500, Nov 2003
> Environmental Molecular Sciences Laboratory
> Pacific Northwest National Laboratory
> Operated for the U.S. DOE by Battelle
> 
