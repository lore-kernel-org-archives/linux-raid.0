From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] md:fix a trivial typo in comments
Date: Mon, 13 Mar 2017 10:27:55 -0400
Message-ID: <22726.44139.863057.288208@quad.stoffel.home>
References: <1489384407-12672-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489384407-12672-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Zhilong" == Zhilong Liu <zlliu@suse.com> writes:

Zhilong> fix a trivial typo in freeze_array() of raid1.c
Zhilong> Signed-off-by: Zhilong Liu <zlliu@suse.com>
Zhilong> ---
Zhilong>  drivers/md/raid1.c | 2 +-
Zhilong>  1 file changed, 1 insertion(+), 1 deletion(-)

Zhilong> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
Zhilong> index 7b0f647..2ec0617 100644
Zhilong> --- a/drivers/md/raid1.c
Zhilong> +++ b/drivers/md/raid1.c
Zhilong> @@ -958,7 +958,7 @@ static void allow_barrier(struct r1conf *conf, sector_t start_next_window,
Zhilong>  static void freeze_array(struct r1conf *conf, int extra)
Zhilong>  {
Zhilong>  	/* stop syncio and normal IO and wait for everything to
Zhilong> -	 * go quite.
Zhilong> +	 * go quit.
Zhilong>  	 * We wait until nr_pending match nr_queued+extra
Zhilong>  	 * This is called in the context of one normal IO request
Zhilong>  	 * that has failed. Thus any sync request that might be pending
Zhilong> -- 
Zhilong> 2.6.6

Don't you mean "quiet" instead?

John
