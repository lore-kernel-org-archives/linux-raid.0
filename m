From: Marcelo Tosatti <marcelo@conectiva.com.br>
Subject: Re: [PATCH] md - 2 of 3 - Add BLKSSZGET ioctl for md driver
Date: Wed, 18 Jun 2003 20:23:45 -0300 (BRT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55L.0306182023150.25830@freak.distro.conectiva>
References: <E19SQog-0000Vl-00@notabene>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E19SQog-0000Vl-00@notabene>
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil,

This one doesnt apply cleanly against my tree.

On Wed, 18 Jun 2003, NeilBrown wrote:

> ### Comments for ChangeSet
>
> From: Nathan Scott <nathans@sgi.com>
>
>
>  ----------- Diffstat output ------------
>  ./drivers/md/md.c |    1 +
>  1 files changed, 1 insertion(+)
>
> diff ./drivers/md/md.c~current~ ./drivers/md/md.c
> --- ./drivers/md/md.c~current~	2003-06-18 10:02:57.000000000 +1000
> +++ ./drivers/md/md.c	2003-06-18 10:03:43.000000000 +1000
> @@ -2623,6 +2623,7 @@ static int md_ioctl(struct inode *inode,
>  		case BLKRAGET:
>  		case BLKRASET:
>  		case BLKFLSBUF:
> +		case BLKSSZGET:
>  		case BLKBSZGET:
>  		case BLKBSZSET:
>  			err = blk_ioctl (dev, cmd, arg);
>
