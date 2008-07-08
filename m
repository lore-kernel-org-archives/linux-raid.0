From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2/8] md: Simplify sb_equal().
Date: Wed, 9 Jul 2008 08:54:16 +1000
Message-ID: <18547.61464.526968.728138@notabene.brown>
References: <20080708155541.GS23944@skl-net.de>
	<S1754151AbYGHQdg/20080708163337Z+60@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Sunday March 23
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday March 23, maan@systemlinux.org wrote:
> The only caller of sb_equal() tests the return value against
> zero, so it's OK to return the negated return value of memcmp().
> 
> Signed-off-by: Andre Noll <maan@systemlinux.org>
> ---
>  drivers/md/md.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c559b9e..58762dd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -572,11 +572,7 @@ static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
>  	tmp1->nr_disks = 0;
>  	tmp2->nr_disks = 0;
>  
> -	if (memcmp(tmp1, tmp2, MD_SB_GENERIC_CONSTANT_WORDS * 4))
> -		ret = 0;
> -	else
> -		ret = 1;
> -
> +	ret = !memcmp(tmp1, tmp2, MD_SB_GENERIC_CONSTANT_WORDS * 4);

One of my pet hates is "!strcmp" and similarly "!memcmp".
memcmp doesn't return a "boolean", so testing it or its inverse
doesn't read well.  I always compare the result with '0'.  The
comparison operator used matches exactly how I want to compare the two
values.
So I've changed this to
        ret = (memcmp(....) == 0).

NeilBrown
