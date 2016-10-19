From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] imsm: block chunk size change for RAID 10
Date: Wed, 19 Oct 2016 11:23:00 -0400
Message-ID: <wrfj37jswegb.fsf@redhat.com>
References: <1476275322-1251-1-git-send-email-mariusz.dabrowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1476275322-1251-1-git-send-email-mariusz.dabrowski@intel.com>
        (Mariusz Dabrowski's message of "Wed, 12 Oct 2016 14:28:42 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Cc: linux-raid@vger.kernel.org, tomasz.majchrzak@intel.com, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com, maksymilian.kunt@intel.com
List-Id: linux-raid.ids

Mariusz Dabrowski <mariusz.dabrowski@intel.com> writes:
> Chunk size change of RAID 10 array fails because it is not supported but
> invalid values still are being written to metadata and array cannot be
> assembled after stop. Operation should be blocked before metadata update.
>
> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
> ---
>  super-intel.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index 92817e9..0b3b2b1 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -10074,10 +10074,16 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
>  	}
>  
>  	if ((geo->chunksize > 0) && (geo->chunksize != UnSet)
> -	    && (geo->chunksize != info.array.chunk_size))
> +	    && (geo->chunksize != info.array.chunk_size)) {
> +		if (info.array.level == 10) {
> +			pr_err("Error. Chunk size change for RAID 10 is not supported.\n");
> +			change = -1;
> +			goto analyse_change_exit;
> +		}
>  		change = CH_MIGRATION;
> -	else
> +	} else {
>  		geo->chunksize = info.array.chunk_size;
> +	}
>  
>  	chunk = geo->chunksize / 1024;

Applied, however I am going to go in and fix up the broken formatting of
that if statement as well.

Thanks,
Jes
