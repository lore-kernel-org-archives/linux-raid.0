From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH RFC v2 0/8] md/raid5: set STRIPE_SIZE as a configurable
 value
Date: Tue, 21 Apr 2020 14:56:07 +0200
Message-ID: <67039bd4-1b24-a7f5-d82a-fabb3ebfce12@molgen.mpg.de>
References: <20200421123952.49025-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200421123952.49025-1-yuyufen@huawei.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, colyli@suse.de, xni@redhat.com, houtao1@huawei.com
List-Id: linux-raid.ids

Dear Yufen,


Thank you for your patch set.

Am 21.04.20 um 14:39 schrieb Yufen Yu:

>   For now, STRIPE_SIZE is equal to the value of PAGE_SIZE. That means, RAID5 will
>   issus echo bio to disk at least 64KB when PAGE_SIZE is 64KB in arm64. However,

issue

>   filesystem usually issue bio in the unit of 4KB. Then, RAID5 will waste resource
>   of disk bandwidth.
> 
>   To solve the problem, this patchset provide a new config CONFIG_MD_RAID456_STRIPE_SIZE
>   to let user config STRIPE_SIZE. The default value is 4096.
> 
>   Normally, using default STRIPE_SIZE can get better performance. And NeilBrown have
>   suggested just to fix the STRIPE_SIZE as 4096. But, out test result show that
>   big value of STRIPE_SIZE may have better performance when size of issued IOs are
>   mostly bigger than 4096. Thus, in this patchset, we still want to set STRIPE_SIZE
>   as a configureable value.

configurable

>   In current implementation, grow_buffers() uses alloc_page() to allocate the buffers
>   for each stripe_head. With the change, it means we allocate 64K buffers but just
>   use 4K of them. To save memory, we try to 'compress' multiple buffers of stripe_head
>   to only one real page. Detail shows in patch #2.
> 
>   To evaluate the new feature, we create raid5 device '/dev/md5' with 4 SSD disk
>   and test it on arm64 machine with 64KB PAGE_SIZE.

[…]

So, what is affecting the performance? The size of the bio in the used 
file system? Shouldn’t it then be a run-time option (Linux CLI parameter 
and /proc) so the Linux kernel doesn’t need to be recompiled for 
different servers? Should the option be even per RAID, as each RAID5 
device might be using another filesystem?


Kind regards,

Paul
