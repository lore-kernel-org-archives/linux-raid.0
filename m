From: Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH] mdadm/grow: correct the s->size > 1 to make 'max' work
Date: Tue, 28 Nov 2017 11:07:50 -0500
Message-ID: <406f55fe-04e6-d731-bd6f-471c9549a8e0@fb.com>
References: <1511406644-12565-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1511406644-12565-1-git-send-email-zlliu@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/22/2017 10:10 PM, Zhilong Liu wrote:
> To fix the commit: 1b21c449e6f2
> (mdadm/grow: adding a test to ensure resize was required)

The correct way to put this in is:
Fixes: 1b21c449e6f2 ("mdadm/grow: adding a test to ensure resize was
required")

I fixed it up this time and applied the patch, but please comply with
the normal rules next time.

Thanks,
Jes

> s->size > 1 : s->size is '1' when '--grow --size max'
> parameter is specified, so correct this test here.
> 
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> 
> resend it due to the missed patch:
> [PATCH v3] mdadm/grow: adding a test to ensure resize was required
> 
>  Grow.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 80176e3..3ee015b 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1815,7 +1815,7 @@ int Grow_reshape(char *devname, int fd,
>  		return 1;
>  	}
>  
> -	if (array.level > 1 && s->size > 0 &&
> +	if (array.level > 1 && s->size > 1 &&
>  	    (array.chunk_size / 1024) > (int)s->size) {
>  		pr_err("component size must be larger than chunk size.\n");
>  		return 1;
> 

