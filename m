From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/3] Don't jump to compute_result state from check_result
 state
Date: Fri, 29 Mar 2019 11:51:11 -0600
Message-ID: <97dc86ee-b9d6-152e-ba5a-b485ac6a3fde@kernel.dk>
References: <20190329174617.3670341-1-songliubraving@fb.com>
 <20190329174617.3670341-2-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190329174617.3670341-2-songliubraving@fb.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
Cc: kernel-team@fb.com, neilb@suse.com, xni@redhat.com, ncroxon@redhat.com, stable@vger.kernel.org, David Jeffy <djeffery@redhat.com>
List-Id: linux-raid.ids

On 3/29/19 11:46 AM, Song Liu wrote:
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c033bfcb209e..4204a972ecf2 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4223,26 +4223,15 @@ static void handle_parity_checks6(struct r5conf *conf, struct stripe_head *sh,
>  	case check_state_check_result:
>  		sh->check_state = check_state_idle;
>  
> +		if (s->failed > 1)            
> +		    break;

Not sure what happened here, but there's a lot of whitespace after that
if statement, and the break is using 4 spaces instead of a tab. I fixed
both of these up, but please review the style of patches going forward.

-- 
Jens Axboe
