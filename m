From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [MDADM PATCH 1/1] Array size is wrong when run mdadm -E
Date: Tue, 4 Jul 2017 17:03:30 +0800
Message-ID: <595B59E2.10407@suse.com>
References: <1499151006-7924-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1499151006-7924-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, jes.sorensen@gmail.com
List-Id: linux-raid.ids



On 07/04/2017 02:50 PM, Xiao Ni wrote:
> The size of array shows wrongly. It shifs wrong number.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   super1.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/super1.c b/super1.c
> index 86ec850..f3b864d 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -366,7 +366,7 @@ static void examine_super1(struct supertype *st, char *homehost)
>   		}
>   		if (ddsks) {
>   			long long asize = __le64_to_cpu(sb->size);
> -			asize = (asize << 9) * ddsks / ddsks_denom;
> +			asize = (asize << 10) * ddsks / ddsks_denom;
>   			printf("     Array Size : %llu%s\n",
>   			       asize >> 10,  human_size(asize));
>   		}

IIRC, sb->size represents the num of sectors, so the shift should be 9.

Thanks,
Guoqing
