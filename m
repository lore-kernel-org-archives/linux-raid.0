From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 7/8] md: update_size(): Remove useless variable "fit".
Date: Wed, 9 Jul 2008 09:08:09 +1000
Message-ID: <18547.62297.913913.977355@notabene.brown>
References: <20080708155541.GS23944@skl-net.de>
	<S1756174AbYGHQdn/20080708163344Z+61@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Saturday April 5
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 5, maan@systemlinux.org wrote:
> 
> Signed-off-by: Andre Noll <maan@systemlinux.org>
> ---
>  drivers/md/md.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3f22ec7..98a024c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4459,7 +4459,6 @@ static int update_size(mddev_t *mddev, unsigned long size)
>  	mdk_rdev_t * rdev;
>  	int rv;
>  	struct list_head *tmp;
> -	int fit = (size == 0);
>  
>  	if (mddev->pers->resize == NULL)
>  		return -EINVAL;
> @@ -4479,7 +4478,7 @@ static int update_size(mddev_t *mddev, unsigned long size)
>  		sector_t avail;
>  		avail = rdev->size * 2;
>  
> -		if (fit && (size == 0 || size > avail/2))
> +		if (size == 0 || size > avail/2)
>  			size = avail/2;
>  		if (avail < ((sector_t)size << 1))
>  			return -ENOSPC;

This is wrong.
The old code tested for "size == 0" once outside a loop.
The new code does the test inside a loop which potentially changes
size.  So after the first time through the loop, it is doing a
different test.
Thus patch 8/8 isn't appropriate either.

If you are keen to do some more tidying up, I would really love it if
all internal values that are currently stored as 'K' would instead be
stored as sectors.
So for example with update_size, we could make the value that is
passed in be a number of sectors, get rid of those divisions.
Then if we change rdev->size to be stored in sectors, that will get
rid of even more mess.

BTW your patches arrive without a valid "To" field.  The Date is odd
too.

To: unlisted-recipients: ;(no To-header on input)
Apparently-To: <maan@skl-net.de>
Subject: [PATCH 7/8] md: update_size(): Remove useless variable "fit".
Date:	Sat, 5 Apr 2008 15:54:49 +0200

Thanks,
NeilBrown


