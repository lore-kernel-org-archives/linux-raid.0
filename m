From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Grow: fix version number in error message
Date: Tue, 26 Jul 2011 14:31:11 +1000
Message-ID: <20110726143111.53e4a5a6@notabene.brown>
References: <1311050053-2831-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1311050053-2831-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 19 Jul 2011 13:34:13 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> As the conditional checks, reshape to fewer devices is supported
> since Linux kernel 2.6.30 not 2.6.32.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  Grow.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index a4092b5..e4fc222 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1268,7 +1268,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
>  
>  	if (re->after.data_disks < re->before.data_disks &&
>  	    get_linux_version() < 2006030)
> -		return "reshape to fewer devices is not supported before 2.6.32 - sorry.";
> +		return "reshape to fewer devices is not supported before 2.6.30 - sorry.";
>  
>  	re->backup_blocks = compute_backup_blocks(
>  		info->new_chunk, info->array.chunk_size,

applied, thanks.

NeilBrown
