From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] md: Combine two kmalloc() calls into one in sb_equal()
Date: Fri, 09 Dec 2016 11:05:14 -0800
Message-ID: <1481310314.5946.40.camel@perches.com>
References: <f4df733d-8e06-8ba1-c4c3-800d8c5615ba@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f4df733d-8e06-8ba1-c4c3-800d8c5615ba@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2016-12-09 at 19:30 +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 9 Dec 2016 19:09:13 +0100
> 
> The function "kmalloc" was called in one case by the function "sb_equal"
> without checking immediately if it failed.
> This issue was detected by using the Coccinelle software.
> 
> Perform the desired memory allocation (and release at the end)
> by a single function call instead.
> 
> Fixes: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 ("Linux-2.6.12-rc2")

Making a change does not mean fixes.

There's nothing particularly _wrong_ with the code as-is.

2 kmemdup calls might make the code more obvious.

There's a small optimization possible in that only the
first MB_SB_GENERIC_CONSTANT_WORDS of the struct are
actually compared.  Alloc and copy of both entire structs
is inefficient and unnecessary.

Perhaps something like the below would be marginally
better/faster, but the whole thing is dubious.

static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
{
	int ret;
	void *tmp1, *tmp2;

	tmp1 = kmemdup(sb1, MD_SB_GENERIC_CONSTANT_WORDS * sizeof(__u32), GFP_KERNEL);
	tmp2 = kmemdup(sb2, MD_SB_GENERIC_CONSTANT_WORDS * sizeof(__u32), GFP_KERNEL);

	if (!tmp1 || !tmp2) {
		ret = 0;
		goto out;
	}

	/*
	 * nr_disks is not constant
	 */
	((mdp_super_t *)tmp1)->nr_disks = 0;
	((mdp_super_t *)tmp2)->nr_disks = 0;

	ret = memcmp(tmp1, tmp2, MD_SB_GENERIC_CONSTANT_WORDS * sizeof(__u32)) == 0;

out:
	kfree(tmp1);
	kfree(tmp2);
	return ret;
}

> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/md/md.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b088668269b0..86caf2536255 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -843,15 +843,12 @@ static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
>  	int ret;
>  	mdp_super_t *tmp1, *tmp2;
>  
> -	tmp1 = kmalloc(sizeof(*tmp1),GFP_KERNEL);
> -	tmp2 = kmalloc(sizeof(*tmp2),GFP_KERNEL);
> -
> -	if (!tmp1 || !tmp2) {
> -		ret = 0;
> -		goto abort;
> -	}
> +	tmp1 = kmalloc(2 * sizeof(*tmp1), GFP_KERNEL);
> +	if (!tmp1)
> +		return 0;
>  
>  	*tmp1 = *sb1;
> +	tmp2 = tmp1 + 1;
>  	*tmp2 = *sb2;
>  
>  	/*
> @@ -861,9 +858,7 @@ static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
>  	tmp2->nr_disks = 0;
>  
>  	ret = (memcmp(tmp1, tmp2, MD_SB_GENERIC_CONSTANT_WORDS * 4) == 0);
> -abort:
>  	kfree(tmp1);
> -	kfree(tmp2);
>  	return ret;
>  }
