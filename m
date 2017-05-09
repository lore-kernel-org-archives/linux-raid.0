From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] IMSM: Correct --examine output for 4k disks
Date: Tue, 9 May 2017 12:04:27 -0400
Message-ID: <1aca3793-3786-00dc-910e-920a21a1108b@gmail.com>
References: <1494331407-2049-1-git-send-email-mariusz.dabrowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1494331407-2049-1-git-send-email-mariusz.dabrowski@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>, linux-raid@vger.kernel.org
Cc: Maksymilian Kunt <maksymilian.kunt@intel.com>
List-Id: linux-raid.ids

On 05/09/2017 08:03 AM, Mariusz Dabrowski wrote:
> From: Maksymilian Kunt <maksymilian.kunt@intel.com>
> 
> "Array Size" and "Per Dev Size" are incorrect for disks with sector size
> different than 512B.
> 
> Calculate "Array Size" and "Per Dev Size" based on sector size. Additionally
> print "Sector Size".
> 
> Signed-off-by: Maksymilian Kunt <maksymilian.kunt@intel.com>
> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
> ---
>   super-intel.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)

I am a little wary of this change as it changes the order of the output. 
Does anyone have tools parsing this information which could break from this?

Jes

> diff --git a/super-intel.c b/super-intel.c
> index e13c940..147a70c 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1473,13 +1473,16 @@ static void print_imsm_dev(struct intel_super *super,
>   		       ord & IMSM_ORD_REBUILD ? " (out-of-sync)" : "");
>   	} else
>   		printf("      This Slot : ?\n");
> +	printf("    Sector Size : %u\n", super->sector_size);
>   	sz = __le32_to_cpu(dev->size_high);
>   	sz <<= 32;
>   	sz += __le32_to_cpu(dev->size_low);
> -	printf("     Array Size : %llu%s\n", (unsigned long long)sz,
> +	printf("     Array Size : %llu%s\n",
> +		   (unsigned long long)sz * 512 / super->sector_size,
>   	       human_size(sz * 512));
>   	sz = blocks_per_member(map);
> -	printf("   Per Dev Size : %llu%s\n", (unsigned long long)sz,
> +	printf("   Per Dev Size : %llu%s\n",
> +		   (unsigned long long)sz * 512 / super->sector_size,
>   	       human_size(sz * 512));
>   	printf("  Sector Offset : %llu\n",
>   		pba_of_lba0(map));
> 

