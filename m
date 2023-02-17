Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13E5C05027
	for <linux-raid@archiver.kernel.org>; Fri, 17 Feb 2023 18:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBQSXA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Feb 2023 13:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBQSXA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 17 Feb 2023 13:23:00 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB39621A30
        for <linux-raid@vger.kernel.org>; Fri, 17 Feb 2023 10:22:57 -0800 (PST)
Message-ID: <7761fbc3-f140-2208-8252-647b7acd6284@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676658176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PMX1+yiQjchThYcEwMgIMU20fOgxUZ353+ASLEJxvlU=;
        b=Av1qUJOhefLmVg9VFYcrrDWGcgsyz9bEO0Om/vjQpy8NNXZ2tpl0hXjR2NJRQUa1bDV79D
        0qrSTFf/zAy79jqPhodMT/5PNT4BZVm6uF4TjBdxU+POts8TAoDyDvPC+m9hwUmFNmdG6l
        2HKAFRwL3g7Ijpxk9tFE0mlh0d/nxeE=
Date:   Fri, 17 Feb 2023 11:22:53 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] md: Use optimal I/O size for last bitmap page
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Sushma Kalakota <sushma.kalakota@intel.com>
References: <20230118005319.147-1-jonathan.derrick@linux.dev>
 <80812f87-a743-2deb-3d43-d07fcc4ce895@linux.dev>
 <CAPhsuW65Qai4Dq-wzrcMbCR-s7J9astse1K8U8TwoAuxD4FyzQ@mail.gmail.com>
 <850848e9-77db-8c93-d921-ba0be3ba7c38@linux.dev>
 <80ee7efe-a13f-223f-f72c-e851e1f1a612@molgen.mpg.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
In-Reply-To: <80ee7efe-a13f-223f-f72c-e851e1f1a612@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2/17/2023 6:21 AM, Paul Menzel wrote:
> Dear Jonathan,
> 
> 
> Thank you for your patch.
> 
> Am 17.02.23 um 00:52 schrieb Jonathan Derrick:
> 
>> On 2/10/2023 10:32 AM, Song Liu wrote:
> 
>>> On Thu, Feb 9, 2023 at 12:38 PM Jonathan Derrick wrote:
> 
>>>> Any thoughts on this?
>>>
>>> I am really sorry that I missed this patch.
>>>
>>>> On 1/17/2023 5:53 PM, Jonathan Derrick wrote:
>>>>> From: Jon Derrick <jonathan.derrick@linux.dev>
>>>>>
>>>>> If the bitmap space has enough room, size the I/O for the last bitmap
>>>>> page write to the optimal I/O size for the storage device. The expanded
>>>>> write is checked that it won't overrun the data or metadata.
>>>>>
>>>>> This change helps increase performance by preventing unnecessary
>>>>> device-side read-mod-writes due to non-atomic write unit sizes.
>>>>>
>>>>> Ex biosnoop log. Device lba size 512, optimal size 4k:
>>>>> Before:
>>>>> Time        Process        PID     Device      LBA        Size      Lat
>>>>> 0.843734    md0_raid10     5267    nvme0n1   W 24         3584      1.17
>>>>> 0.843933    md0_raid10     5267    nvme1n1   W 24         3584      1.36
>>>>> 0.843968    md0_raid10     5267    nvme1n1   W 14207939968 4096      0.01
>>>>> 0.843979    md0_raid10     5267    nvme0n1   W 14207939968 4096      0.02
>>>>>
>>>>> After:
>>>>> Time        Process        PID     Device      LBA        Size      Lat
>>>>> 18.374244   md0_raid10     6559    nvme0n1   W 24         4096      0.01
>>>>> 18.374253   md0_raid10     6559    nvme1n1   W 24         4096      0.01
>>>>> 18.374300   md0_raid10     6559    nvme0n1   W 11020272296 4096      0.01
>>>>> 18.374306   md0_raid10     6559    nvme1n1   W 11020272296 4096      0.02
>>>
>>> Do we see significant improvements from io benchmarks?
>>
>> Yes. With lbaf=512, optimal i/o size=4k:
>>
>> Without patch:
>>    write: IOPS=1570, BW=6283KiB/s (6434kB/s)(368MiB/60001msec); 0 zone resets
>> With patch:
>>    write: IOPS=59.7k, BW=233MiB/s (245MB/s)(13.7GiB/60001msec); 0 zone resets
>>
>> It's going to be different for different drives, but this was a drive where a
>> drive-side read-mod-write has huge penalty.
> 
> Nice. Can you share the drive model used for benchmarking. Also, maybe also add that to the commit message?
> 
It's an Intel/Solidigm P5520 but other drives show similar results.
The mdraid configuration had it having 2 bitmap pages, which meant that the 'last' bitmap page was
being exercised in the random workload roughly 50% of the time, leading to this high latency result.


Here's a test on another system.
Raid10, Chunk-size 64M, bitmap-size 57228 bits
Without patch:
  write: IOPS=1676, BW=6708KiB/s (6869kB/s)(393MiB/60001msec); 0 zone resets

With patch:
  write: IOPS=15.7k, BW=61.4MiB/s (64.4MB/s)(3683MiB/60001msec); 0 zone resets


Biosnoop:
Without patch:
Time        Process        PID     Device      LBA        Size      Lat
1.410377    md0_raid10     6900    nvme0n1   W 16         4096      0.02
1.410387    md0_raid10     6900    nvme2n1   W 16         4096      0.02
1.410374    md0_raid10     6900    nvme3n1   W 16         4096      0.01
1.410381    md0_raid10     6900    nvme1n1   W 16         4096      0.02
1.410411    md0_raid10     6900    nvme1n1   W 115346512  4096      0.01
1.410418    md0_raid10     6900    nvme0n1   W 115346512  4096      0.02
1.410915    md0_raid10     6900    nvme2n1   W 24         3584      0.43
1.410935    md0_raid10     6900    nvme3n1   W 24         3584      0.45
1.411124    md0_raid10     6900    nvme1n1   W 24         3584      0.64
1.411147    md0_raid10     6900    nvme0n1   W 24         3584      0.66
1.411176    md0_raid10     6900    nvme3n1   W 2019022184 4096      0.01
1.411189    md0_raid10     6900    nvme2n1   W 2019022184 4096      0.02

With patch:
Time        Process        PID     Device      LBA        Size      Lat
5.747193    md0_raid10     727     nvme0n1   W 16         4096      0.01
5.747192    md0_raid10     727     nvme1n1   W 16         4096      0.02
5.747195    md0_raid10     727     nvme3n1   W 16         4096      0.01
5.747202    md0_raid10     727     nvme2n1   W 16         4096      0.02
5.747229    md0_raid10     727     nvme3n1   W 1196223704 4096      0.02
5.747224    md0_raid10     727     nvme0n1   W 1196223704 4096      0.01
5.747279    md0_raid10     727     nvme0n1   W 24         4096      0.01
5.747279    md0_raid10     727     nvme1n1   W 24         4096      0.02
5.747284    md0_raid10     727     nvme3n1   W 24         4096      0.02
5.747291    md0_raid10     727     nvme2n1   W 24         4096      0.02
5.747314    md0_raid10     727     nvme2n1   W 2234636712 4096      0.01
5.747317    md0_raid10     727     nvme1n1   W 2234636712 4096      0.02



>>> IIUC, fewer future HDDs will use 512B LBA size.We probably don't need
>>> such optimizations in the future.
>>
>> Maybe. But many drives still ship with 512B formatting as default.
> 
> Is that the problem on “desktop” HDDs, where `PHY-SEC` and `LOG-SEC` are different?
> 
>     $ lsblk -o NAME,MODEL,ALIGNMENT,MIN-IO,OPT-IO,PHY-SEC,LOG-SEC,ROTA,SCHED,RQ-SIZE,RA,WSAME -d /dev/sda
>     NAME MODEL              ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
>     sda  TOSHIBA DT01ACA050         0   4096      0    4096     512 1 bfq        64 128    0B
> 
> (Though these are not used in a RAID here.)
In the test scenario, both PHYS-SEC and LOG-SEC are 512, however MIN-IO and OPT-IO are 4k.

> 
> 
> Kind regards,
> 
> Paul
> 
> 
> [1]: https://toshiba.semicon-storage.com/content/dam/toshiba-ss-v3/master/en/storage/product/internal-specialty/cHDD-DT01ACAxxx-Product-Overview.pdf
> 
> 
>>>>> Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
>>>>> ---
>>>>>   drivers/md/md-bitmap.c | 27 ++++++++++++++++++---------
>>>>>   1 file changed, 18 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>>>>> index e7cc6ba1b657..569297ea9b99 100644
>>>>> --- a/drivers/md/md-bitmap.c
>>>>> +++ b/drivers/md/md-bitmap.c
>>>>> @@ -220,6 +220,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>>>>        rdev = NULL;
>>>>>        while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
>>>>>                int size = PAGE_SIZE;
>>>>> +             int optimal_size = PAGE_SIZE;
>>>>>                loff_t offset = mddev->bitmap_info.offset;
>>>>>
>>>>>                bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
>>>>> @@ -228,9 +229,14 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>>>>                        int last_page_size = store->bytes & (PAGE_SIZE-1);
>>>>>                        if (last_page_size == 0)
>>>>>                                last_page_size = PAGE_SIZE;
>>>>> -                     size = roundup(last_page_size,
>>>>> -                                    bdev_logical_block_size(bdev));
>>>>> +                     size = roundup(last_page_size, bdev_logical_block_size(bdev));
>>>>> +                     if (bdev_io_opt(bdev) > bdev_logical_block_size(bdev))
>>>>> +                             optimal_size = roundup(last_page_size, bdev_io_opt(bdev));
>>>>> +                     else
>>>>> +                             optimal_size = size;
>>>>>                }
>>>>> +
>>>>> +
>>>>>                /* Just make sure we aren't corrupting data or
>>>>>                 * metadata
>>>>>                 */
>>>>> @@ -246,9 +252,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>>>>                                goto bad_alignment;
>>>>>                } else if (offset < 0) {
>>>>>                        /* DATA  BITMAP METADATA  */
>>>>> -                     if (offset
>>>>> -                         + (long)(page->index * (PAGE_SIZE/512))
>>>>> -                         + size/512 > 0)
>>>>> +                     loff_t off = offset + (long)(page->index * (PAGE_SIZE/512));
>>>>> +                     if (size != optimal_size &&
>>>>> +                         off + optimal_size/512 <= 0)
>>>>> +                             size = optimal_size;
>>>>> +                     else if (off + size/512 > 0)
>>>>>                                /* bitmap runs in to metadata */
>>>>>                                goto bad_alignment;
>>>>>                        if (rdev->data_offset + mddev->dev_sectors
>>>>> @@ -257,10 +265,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>>>>                                goto bad_alignment;
>>>>>                } else if (rdev->sb_start < rdev->data_offset) {
>>>>>                        /* METADATA BITMAP DATA */
>>>>> -                     if (rdev->sb_start
>>>>> -                         + offset
>>>>> -                         + page->index*(PAGE_SIZE/512) + size/512
>>>>> -                         > rdev->data_offset)
>>>>> +                     loff_t off = rdev->sb_start + offset + page->index*(PAGE_SIZE/512);
>>>>> +                     if (size != optimal_size &&
>>>>> +                         off + optimal_size/512 <= rdev->data_offset)
>>>>> +                             size = optimal_size;
>>>>> +                     else if (off + size/512 > rdev->data_offset)
>>>>>                                /* bitmap runs in to data */
>>>>>                                goto bad_alignment;
>>>>>                } else {
