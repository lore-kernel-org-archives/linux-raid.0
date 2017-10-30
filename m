From: Shaohua Li <shli@kernel.org>
Subject: Re: [mdadm PATCH] mdadm: make create clustered raid10 possible
Date: Sun, 29 Oct 2017 22:57:17 -0700
Message-ID: <20171030055717.x5rgvkymaygitzfn@kernel.org>
References: <20171024073124.7751-1-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171024073124.7751-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: jsorensen@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 24, 2017 at 03:31:24PM +0800, Guoqing Jiang wrote:
> This change to make we can create a clustered
> raid10 array as well.
> 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  mdadm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mdadm.c b/mdadm.c
> index 7cdcdba7c652..60d80e0103f4 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1542,8 +1542,9 @@ int main(int argc, char *argv[])
>  				break;
>  			}
>  
> -			if (s.level != 1) {
> -				pr_err("--bitmap=clustered is currently supported with RAID mirror only\n");
> +			if (s.level != 1 && s.level != 10) {
> +				pr_err("--bitmap=clustered is currently "
> +				       "supported with raid1/10 only\n");
>  				rv = 1;
>  				break;

Since kernel only supports near layout for raid10 cluster, probably check the
layout in mdadm too?
