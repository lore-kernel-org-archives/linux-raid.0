From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH] fs/direct-io.c: Set bi_rw when alloc bio.
Date: Fri, 27 Jul 2012 10:21:58 -0400
Message-ID: <x496299708p.fsf@segfault.boston.devel.redhat.com>
References: <201207271602081096921@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201207271602081096921@gmail.com> (majianpeng@gmail.com's message
	of "Fri, 27 Jul 2012 16:02:10 +0800")
Sender: linux-fsdevel-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: viro <viro@ZenIV.linux.org.uk>, Neil Brown <neilb@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

majianpeng <majianpeng@gmail.com> writes:

> When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,
> it will use bi_rw.
> Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().
> The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
>>> if ((bvm->bi_rw & 1) == WRITE)
>>>		return biovec->bv_len; /* always allow writes to be mergeable */
>
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>

Good catch.  How did you find this?  Did you experience data corruption
as a result of this oversight, reduced performance due to missed merge
opportunities, or did you just notice it in reviewing the code?

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

>
> There are many place like this in kernel.If you think this patch ok, i will correct those.
> ---
>  fs/direct-io.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 1faf4cb..77f0bbf 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -349,6 +349,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
>  
>  	bio->bi_bdev = bdev;
>  	bio->bi_sector = first_sector;
> +	bio->bi_rw = dio->rw;
>  	if (dio->is_async)
>  		bio->bi_end_io = dio_bio_end_aio;
>  	else
