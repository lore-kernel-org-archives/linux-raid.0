From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.6.x regression, fails creation of raid1 w/ v1.0 sb and internal bitmap
Date: Tue, 23 Oct 2007 15:11:19 +1000
Message-ID: <18205.33399.277434.48658@notabene.brown>
References: <170fa0d20710170837g1b0cd549w3b7fe8e663a01b7e@mail.gmail.com>
	<18198.62670.605246.270516@notabene.brown>
	<170fa0d20710180510o1edff608p22953fa712e217f6@mail.gmail.com>
	<18200.6319.487833.714355@notabene.brown>
	<170fa0d20710182152i4763c347r704c9d939e0a4638@mail.gmail.com>
	<170fa0d20710182215v19756cabp30ddddeb7a7668a2@mail.gmail.com>
	<18200.17870.419986.530609@notabene.brown>
	<170fa0d20710191618s3e284d07q738662987acfe452@mail.gmail.com>
	<18204.18756.505903.297754@notabene.brown>
	<170fa0d20710220705m158b897sb74d7050ccd38b47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Monday October 22
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 22, snitzer@gmail.com wrote:
> 
> Hey Neil,
> 
> Your fix works for me too.  However, I'm wondering why you held back
> on fixing the same issue in the "bitmap runs into data" comparison
> that follows:

It isn't really needed here.  In this case bitmap->offset is positive,
so all the numbers are positive, so it doesn't matter if the
comparison is signed or not.

Thanks for mentioning it though.

NeilBrown


> 
> --- ./drivers/md/bitmap.c 2007-10-19 19:11:58.000000000 -0400
> +++ ./drivers/md/bitmap.c 2007-10-22 09:53:41.000000000 -0400
> @@ -286,7 +286,7 @@
>                                 /* METADATA BITMAP DATA */
>                                 if (rdev->sb_offset*2
>                                     + bitmap->offset
> -                                   + page->index*(PAGE_SIZE/512) + size/512
> +                                   +
> (long)(page->index*(PAGE_SIZE/512)) + size/512
>                                     > rdev->data_offset)
>                                         /* bitmap runs in to data */
>                                         return -EINVAL;
> 
> Thanks,
> Mike
