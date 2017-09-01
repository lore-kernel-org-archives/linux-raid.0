From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: [PATCH 2/2] mdadm: remove journal with "remove-journal"
Date: Fri, 1 Sep 2017 10:56:19 -0400
Message-ID: <a81f5a9a-21ce-be5d-45df-acafb076a900@nuclearwinter.com>
References: <63717f4b-5b81-7290-5265-087713f0bd45@nuclearwinter.com>
 <20170831175101.2965834-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170831175101.2965834-1-songliubraving@fb.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org
Cc: shli@kernel.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

Thanks!

--Larkin

On 8/31/2017 1:51 PM, Song Liu wrote:
> Hi Larkin,
>
> We didn't ship this patch. Instead, we decide to use sysfs entry
>
> /sys/block/mdXXX/md/consistency_policy
>
> You can find the patch at:
>
> https://marc.info/?l=linux-raid&m=149063896208043
>
> Thanks,
> Song
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

