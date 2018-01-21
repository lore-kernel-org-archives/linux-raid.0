From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] imsm: update name in --detail-platform
Date: Sun, 21 Jan 2018 16:17:38 -0500
Message-ID: <b75e156d-ea74-4f00-b458-c0b203e1f128@gmail.com>
References: <20180116112309.22450-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180116112309.22450-1-artur.paszkiewicz@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/16/2018 06:23 AM, Artur Paszkiewicz wrote:
> For IMSM enterprise firmware starting with major version 6, present the
> platform name as Intel VROC.
> 
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  super-intel.c | 2 ++
>  1 file changed, 2 insertions(+)

Applied!

Thanks,
Jes

> diff --git a/super-intel.c b/super-intel.c
> index c55802f1..c4a5a1be 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2369,6 +2369,8 @@ static void print_imsm_capability(const struct imsm_orom *orom)
>  	printf("       Platform : Intel(R) ");
>  	if (orom->capabilities == 0 && orom->driver_features == 0)
>  		printf("Matrix Storage Manager\n");
> +	else if (imsm_orom_is_enterprise(orom) && orom->major_ver >= 6)
> +		printf("Virtual RAID on CPU\n");
>  	else
>  		printf("Rapid Storage Technology%s\n",
>  			imsm_orom_is_enterprise(orom) ? " enterprise" : "");
> 

