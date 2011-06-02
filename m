From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md: convert double atomic_inc() to atomic_add()
Date: Thu, 2 Jun 2011 15:47:54 +1000
Message-ID: <20110602154754.142920c6@notabene.brown>
References: <1306990383-14133-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1306990383-14133-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu,  2 Jun 2011 13:53:02 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/md.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aa640a85bb21..f210e42a56ca 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -396,8 +396,7 @@ static void submit_flushes(struct work_struct *ws)
>  			 * we reclaim rcu_read_lock
>  			 */
>  			struct bio *bi;
> -			atomic_inc(&rdev->nr_pending);
> -			atomic_inc(&rdev->nr_pending);
> +			atomic_add(2, &rdev->nr_pending);
>  			rcu_read_unlock();
>  			bi = bio_alloc_mddev(GFP_KERNEL, 0, mddev);
>  			bi->bi_end_io = md_end_flush;

Thanks, but I don't think I want this patch.
I'm happy having two separate 'atomic_inc' calls. I think it makes it a bit
clearer what is happening, and it is easier to search for all atomic_inc
calls.

NeilBrown
