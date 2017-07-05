From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [MDADM PATCH 1/1] Array size is wrong when run mdadm -E
Date: Wed, 5 Jul 2017 09:56:35 +0800
Message-ID: <03fe6bb9-714e-bebb-1bbe-63a9d6ccee69@suse.com>
References: <1499151006-7924-1-git-send-email-xni@redhat.com>
 <595B59E2.10407@suse.com>
 <1330216631.28557919.1499162158000.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1330216631.28557919.1499162158000.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, jes sorensen <jes.sorensen@gmail.com>
List-Id: linux-raid.ids



On 07/04/2017 05:55 PM, Xiao Ni wrote:
>
> ----- Original Message -----
>> From: "Guoqing Jiang" <gqjiang@suse.com>
>> To: "Xiao Ni" <xni@redhat.com>, linux-raid@vger.kernel.org
>> Cc: ncroxon@redhat.com, "jes sorensen" <jes.sorensen@gmail.com>
>> Sent: Tuesday, July 4, 2017 5:03:30 PM
>> Subject: Re: [MDADM PATCH 1/1] Array size is wrong when run mdadm -E
>>
>>
>>
>> On 07/04/2017 02:50 PM, Xiao Ni wrote:
>>> The size of array shows wrongly. It shifs wrong number.
>>>
>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>> ---
>>>    super1.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/super1.c b/super1.c
>>> index 86ec850..f3b864d 100644
>>> --- a/super1.c
>>> +++ b/super1.c
>>> @@ -366,7 +366,7 @@ static void examine_super1(struct supertype *st, char
>>> *homehost)
>>>    		}
>>>    		if (ddsks) {
>>>    			long long asize = __le64_to_cpu(sb->size);
>>> -			asize = (asize << 9) * ddsks / ddsks_denom;
>>> +			asize = (asize << 10) * ddsks / ddsks_denom;
>>>    			printf("     Array Size : %llu%s\n",
>>>    			       asize >> 10,  human_size(asize));
>>>    		}
>> IIRC, sb->size represents the num of sectors, so the shift should be 9.
> Yes, it should be 9. It should pass bytes to human_size. Thanks for this.
> It was introduced in d4633e06dfc01723911627fcb104af2ffb6f6a95. So there is
> the same problem in super0. Is it ok:
>
> diff --git a/super0.c b/super0.c
> index 756cab5..4b4680c 100644
> --- a/super0.c
> +++ b/super0.c
> @@ -131,9 +131,9 @@ static void examine_super0(struct supertype *st, char *homehost)
>                  }
>                  if (ddsks) {
>                          long long asize = sb->size;
> -                       asize = (asize << 10) * ddsks / ddsks_denom;
> +                       asize = (asize << 9) * ddsks / ddsks_denom;
>                          printf("     Array Size : %llu%s\n",
> -                              asize >> 10,  human_size(asize));
> +                              asize >> 9,  human_size(asize));
>                  }

No, for 0.9 metadata, sb->size means KB not sector.

>          }
>          printf("   Raid Devices : %d\n", sb->raid_disks);
> diff --git a/super1.c b/super1.c
> index 86ec850..2bb1454 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -368,7 +368,7 @@ static void examine_super1(struct supertype *st, char *homehost)
>                          long long asize = __le64_to_cpu(sb->size);
>                          asize = (asize << 9) * ddsks / ddsks_denom;
>                          printf("     Array Size : %llu%s\n",
> -                              asize >> 10,  human_size(asize));
> +                              asize >> 9,  human_size(asize));
>                  }
>                  if (sb->size != sb->data_size)
>                          printf("  Used Dev Size : %llu%s\n",

It is better that you can provide the output of "mdadm -E DISK" etc to prove
current code is wrong, at least I can see correct output from my side.

Thanks,
Guoqing
