From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH] md: Fix bug where new drives added to an md array sometimes
 don't sync properly.
Date: Thu, 12 Oct 2006 14:02:25 +0400
Message-ID: <452E12B1.1070506@tls.msk.ru>
References: <20061005171233.6542.patches@notabene>	<1061005071326.6578@suse.de>	<45255C54.6060608@ilm.com>	<4526DBCE.6070906@ilm.com> <17706.65210.999441.373846@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17706.65210.999441.373846@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Eli Stair <estair@ilm.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
[]
> Fix count of degraded drives in raid10.
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> --- .prev/drivers/md/raid10.c	2006-10-09 14:18:00.000000000 +1000
> +++ ./drivers/md/raid10.c	2006-10-05 20:10:07.000000000 +1000
> @@ -2079,7 +2079,7 @@ static int run(mddev_t *mddev)
>  		disk = conf->mirrors + i;
>  
>  		if (!disk->rdev ||
> -		    !test_bit(In_sync, &rdev->flags)) {
> +		    !test_bit(In_sync, &disk->rdev->flags)) {
>  			disk->head_position = 0;
>  			mddev->degraded++;
>  		}

Neil, this makes me nervous.  Seriously.

How many bugs like this has been fixed so far? 10? 50?  I stopped counting
long time ago.  And it's the same thing in every case - misuse of rdev vs
disk->rdev.  The same pattern.

I wonder if it can be avoided in the first place somehow - maybe don't
declare and use local variable `rdev' (not by name, but by the semantics
of it), and always use disk->rdev or mddev->whatever in every place,
explicitly, and let the compiler optimize the deref if possible?

And btw, this is another 2.6.18.1 candidate (if it's not too late already).

Thanks.

/mjt
