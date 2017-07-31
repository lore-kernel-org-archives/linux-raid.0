From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: replace seq_release_private with seq_release
Date: Mon, 31 Jul 2017 09:49:13 -0700
Message-ID: <20170731164913.awweojd4mlhlbso5@kernel.org>
References: <1501347165-32241-1-git-send-email-cakturk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501347165-32241-1-git-send-email-cakturk@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cihangir Akturk <cakturk@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jul 29, 2017 at 07:52:45PM +0300, Cihangir Akturk wrote:
> Since commit f15146380d28 ("fs: seq_file - add event counter to simplify
> poll() support"), md.c code has been no longer used the private field of
> the struct seq_file, but seq_release_private() has been continued to be
> used to release the allocated seq_file. This seems to have been
> forgotten. So convert it to use seq_release() instead of
> seq_release_private().
> 
> Signed-off-by: Cihangir Akturk <cakturk@gmail.com>

applied, thanks!
> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8cdca029..6174360 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7836,7 +7836,7 @@ static const struct file_operations md_seq_fops = {
>  	.open           = md_seq_open,
>  	.read           = seq_read,
>  	.llseek         = seq_lseek,
> -	.release	= seq_release_private,
> +	.release	= seq_release,
>  	.poll		= mdstat_poll,
>  };
>  
> -- 
> 2.7.4
> 
