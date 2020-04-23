From: Yufen Yu <yuyufen@huawei.com>
Subject: Re: [PATCH RFC v2 0/8] md/raid5: set STRIPE_SIZE as a configurable
 value
Date: Thu, 23 Apr 2020 11:01:28 +0800
Message-ID: <ab38eb52-32fa-8a87-4edf-765b1e9ff48c@huawei.com>
References: <20200421123952.49025-1-yuyufen@huawei.com>
 <67039bd4-1b24-a7f5-d82a-fabb3ebfce12@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <67039bd4-1b24-a7f5-d82a-fabb3ebfce12@molgen.mpg.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>, song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, colyli@suse.de, xni@redhat.com, houtao1@huawei.com
List-Id: linux-raid.ids

Hi

On 2020/4/21 20:56, Paul Menzel wrote:
> Dear Yufen,
> 
> 
> Thank you for your patch set.
> 
> Am 21.04.20 um 14:39 schrieb Yufen Yu:
> 
>>   For now, STRIPE_SIZE is equal to the value of PAGE_SIZE. That means, RAID5 will
>>   issus echo bio to disk at least 64KB when PAGE_SIZE is 64KB in arm64. However,
> 
> issue
> 
>>   filesystem usually issue bio in the unit of 4KB. Then, RAID5 will waste resource
>>   of disk bandwidth.
>>
>>   To solve the problem, this patchset provide a new config CONFIG_MD_RAID456_STRIPE_SIZE
>>   to let user config STRIPE_SIZE. The default value is 4096.
>>
>>   Normally, using default STRIPE_SIZE can get better performance. And NeilBrown have
>>   suggested just to fix the STRIPE_SIZE as 4096. But, out test result show that
>>   big value of STRIPE_SIZE may have better performance when size of issued IOs are
>>   mostly bigger than 4096. Thus, in this patchset, we still want to set STRIPE_SIZE
>>   as a configureable value.
> 
> configurable
> 
>>   In current implementation, grow_buffers() uses alloc_page() to allocate the buffers
>>   for each stripe_head. With the change, it means we allocate 64K buffers but just
>>   use 4K of them. To save memory, we try to 'compress' multiple buffers of stripe_head
>>   to only one real page. Detail shows in patch #2.
>>
>>   To evaluate the new feature, we create raid5 device '/dev/md5' with 4 SSD disk
>>   and test it on arm64 machine with 64KB PAGE_SIZE.
> 
> […]
> 
> So, what is affecting the performance? The size of the bio in the used file system? Shouldn’t it then be a run-time option (Linux CLI parameter and /proc) so the Linux kernel doesn’t need to be recompiled for different servers? Should the option be even per RAID, as each RAID5 device might be using another filesystem?


We have used perf and blktrace to dig factors that affect the performance. Test
'4KB randwrite' respectively on 'STRIPE_SIZE = 4K' and 'STRIPE_SIZE = 64K' on
our arm64 with 64KB PAGE_SIZE machine. It shows that (STRIPE_SIZE = 64K) needs
more time to compute xor and issue IO. Details:

1) perf and Flame Graph show that compute xor function(i.e. async_xor) percentage
    is about 1.45% vs 14.87%. For each 4KB bio, raid5 compute 64KB xor when
    'STRIPE_SIZE = 64K', while computing 4KB on 'STRIPE_SIZE = 4K'.

2) blktrace can trace each issued bio and it show that D2C latency (i.e. issue io
    to driver until it complete) about 114.7us vs 1325.6us. That means big bio will
    consume more time in driver.

We know RAID5 can be reshaped by user. If STRIPE_SIZE is not equal to that before doing
reshape, it can cause more complicated problems. But I think we can add a modules parameter
for raid5 to set STRIPE_SIZE.

Thanks,
Yufen
