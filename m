From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: use REQ_NOIDLE flag in md_super_write()
Date: Thu, 4 Aug 2011 14:26:39 +1000
Message-ID: <20110804142639.6484de94@notabene.brown>
References: <1312387077-26617-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1312387077-26617-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu,  4 Aug 2011 00:57:57 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Queue idling is used for the anticipation of immediate
> sequencial I/O's but md_super_write() is a kind of one-
> shot operation, coupled with md_super_wait(), so the
> idling in this case will be just a waste of time.
> 
> Specifying REQ_NOIDLE prevents it. Instead of adding
> the flag to submit_bio() directly, use pre-defined
> macro WRITE_FLUSH_FUA.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/md.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d97a62534798..8650e9a0ce7c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -848,7 +848,7 @@ void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
>  	bio->bi_end_io = super_written;
>  
>  	atomic_inc(&mddev->pending_writes);
> -	submit_bio(REQ_WRITE | REQ_SYNC | REQ_FLUSH | REQ_FUA, bio);
> +	submit_bio(WRITE_FLUSH_FUA, bio);
>  }
>  
>  void md_super_wait(mddev_t *mddev)

Applied, thanks.

NeilBrown


