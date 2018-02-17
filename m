From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2] md-multipath: Use seq_putc() in multipath_status()
Date: Sat, 17 Feb 2018 13:01:20 -0800
Message-ID: <20180217210120.6wwgxiwcyewbubff@kernel.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
 <6e70a1a7-fd86-914e-84ab-bd5c7facb235@users.sourceforge.net>
 <0b59904d-1be7-7a76-9c32-3f7f9696ff2d@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0b59904d-1be7-7a76-9c32-3f7f9696ff2d@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 13, 2018 at 09:55:08AM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 13 Jan 2018 09:49:03 +0100
> 
> A single character (closing square bracket) should be put into a sequence.
> Thus use the corresponding function "seq_putc".
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
applied, thanks
> ---
>  drivers/md/md-multipath.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
> index e40065bdbfc8..0a7e99d62c69 100644
> --- a/drivers/md/md-multipath.c
> +++ b/drivers/md/md-multipath.c
> @@ -157,7 +157,7 @@ static void multipath_status(struct seq_file *seq, struct mddev *mddev)
>  		seq_printf (seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
>  	}
>  	rcu_read_unlock();
> -	seq_printf (seq, "]");
> +	seq_putc(seq, ']');
>  }
>  
>  static int multipath_congested(struct mddev *mddev, int bits)
> -- 
> 2.15.1
> 
