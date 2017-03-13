From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] md:fix a trivial typo in comments
Date: Mon, 13 Mar 2017 22:59:39 +0800
Message-ID: <c46115df-7eb5-fa28-b71b-933ca9b3fbc2@suse.de>
References: <1489384407-12672-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489384407-12672-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017/3/13 下午1:53, Zhilong Liu wrote:
> fix a trivial typo in freeze_array() of raid1.c
> 
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  drivers/md/raid1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7b0f647..2ec0617 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -958,7 +958,7 @@ static void allow_barrier(struct r1conf *conf, sector_t start_next_window,
>  static void freeze_array(struct r1conf *conf, int extra)
>  {
>  	/* stop syncio and normal IO and wait for everything to
> -	 * go quite.

	It should be "quiet"， this is a typo， thanks for catching it :-)

Coly
