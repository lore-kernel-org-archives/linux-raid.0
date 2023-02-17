Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF60C636D4
	for <linux-raid@archiver.kernel.org>; Fri, 17 Feb 2023 13:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjBQNVs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Feb 2023 08:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBQNVs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 17 Feb 2023 08:21:48 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCFD60A6C
        for <linux-raid@vger.kernel.org>; Fri, 17 Feb 2023 05:21:45 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4B1E661CC40F9;
        Fri, 17 Feb 2023 14:21:42 +0100 (CET)
Message-ID: <80ee7efe-a13f-223f-f72c-e851e1f1a612@molgen.mpg.de>
Date:   Fri, 17 Feb 2023 14:21:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] md: Use optimal I/O size for last bitmap page
Content-Language: en-US
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Sushma Kalakota <sushma.kalakota@intel.com>
References: <20230118005319.147-1-jonathan.derrick@linux.dev>
 <80812f87-a743-2deb-3d43-d07fcc4ce895@linux.dev>
 <CAPhsuW65Qai4Dq-wzrcMbCR-s7J9astse1K8U8TwoAuxD4FyzQ@mail.gmail.com>
 <850848e9-77db-8c93-d921-ba0be3ba7c38@linux.dev>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <850848e9-77db-8c93-d921-ba0be3ba7c38@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Jonathan,


Thank you for your patch.

Am 17.02.23 um 00:52 schrieb Jonathan Derrick:

> On 2/10/2023 10:32 AM, Song Liu wrote:

>> On Thu, Feb 9, 2023 at 12:38 PM Jonathan Derrick wrote:

>>> Any thoughts on this?
>>
>> I am really sorry that I missed this patch.
>>
>>> On 1/17/2023 5:53 PM, Jonathan Derrick wrote:
>>>> From: Jon Derrick <jonathan.derrick@linux.dev>
>>>>
>>>> If the bitmap space has enough room, size the I/O for the last bitmap
>>>> page write to the optimal I/O size for the storage device. The expanded
>>>> write is checked that it won't overrun the data or metadata.
>>>>
>>>> This change helps increase performance by preventing unnecessary
>>>> device-side read-mod-writes due to non-atomic write unit sizes.
>>>>
>>>> Ex biosnoop log. Device lba size 512, optimal size 4k:
>>>> Before:
>>>> Time        Process        PID     Device      LBA        Size      Lat
>>>> 0.843734    md0_raid10     5267    nvme0n1   W 24         3584      1.17
>>>> 0.843933    md0_raid10     5267    nvme1n1   W 24         3584      1.36
>>>> 0.843968    md0_raid10     5267    nvme1n1   W 14207939968 4096      0.01
>>>> 0.843979    md0_raid10     5267    nvme0n1   W 14207939968 4096      0.02
>>>>
>>>> After:
>>>> Time        Process        PID     Device      LBA        Size      Lat
>>>> 18.374244   md0_raid10     6559    nvme0n1   W 24         4096      0.01
>>>> 18.374253   md0_raid10     6559    nvme1n1   W 24         4096      0.01
>>>> 18.374300   md0_raid10     6559    nvme0n1   W 11020272296 4096      0.01
>>>> 18.374306   md0_raid10     6559    nvme1n1   W 11020272296 4096      0.02
>>
>> Do we see significant improvements from io benchmarks?
> 
> Yes. With lbaf=512, optimal i/o size=4k:
> 
> Without patch:
>    write: IOPS=1570, BW=6283KiB/s (6434kB/s)(368MiB/60001msec); 0 zone resets
> With patch:
>    write: IOPS=59.7k, BW=233MiB/s (245MB/s)(13.7GiB/60001msec); 0 zone resets
> 
> It's going to be different for different drives, but this was a drive where a
> drive-side read-mod-write has huge penalty.

Nice. Can you share the drive model used for benchmarking. Also, maybe 
also add that to the commit message?

>> IIUC, fewer future HDDs will use 512B LBA size.We probably don't need
>> such optimizations in the future.
> 
> Maybe. But many drives still ship with 512B formatting as default.

Is that the problem on “desktop” HDDs, where `PHY-SEC` and `LOG-SEC` are 
different?

     $ lsblk -o 
NAME,MODEL,ALIGNMENT,MIN-IO,OPT-IO,PHY-SEC,LOG-SEC,ROTA,SCHED,RQ-SIZE,RA,WSAME 
-d /dev/sda
     NAME MODEL              ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC 
ROTA SCHED RQ-SIZE  RA WSAME
     sda  TOSHIBA DT01ACA050         0   4096      0    4096     512 
1 bfq        64 128    0B

(Though these are not used in a RAID here.)


Kind regards,

Paul


[1]: 
https://toshiba.semicon-storage.com/content/dam/toshiba-ss-v3/master/en/storage/product/internal-specialty/cHDD-DT01ACAxxx-Product-Overview.pdf


>>>> Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
>>>> ---
>>>>   drivers/md/md-bitmap.c | 27 ++++++++++++++++++---------
>>>>   1 file changed, 18 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>>>> index e7cc6ba1b657..569297ea9b99 100644
>>>> --- a/drivers/md/md-bitmap.c
>>>> +++ b/drivers/md/md-bitmap.c
>>>> @@ -220,6 +220,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>>>        rdev = NULL;
>>>>        while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
>>>>                int size = PAGE_SIZE;
>>>> +             int optimal_size = PAGE_SIZE;
>>>>                loff_t offset = mddev->bitmap_info.offset;
>>>>
>>>>                bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
>>>> @@ -228,9 +229,14 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>>>                        int last_page_size = store->bytes & (PAGE_SIZE-1);
>>>>                        if (last_page_size == 0)
>>>>                                last_page_size = PAGE_SIZE;
>>>> -                     size = roundup(last_page_size,
>>>> -                                    bdev_logical_block_size(bdev));
>>>> +                     size = roundup(last_page_size, bdev_logical_block_size(bdev));
>>>> +                     if (bdev_io_opt(bdev) > bdev_logical_block_size(bdev))
>>>> +                             optimal_size = roundup(last_page_size, bdev_io_opt(bdev));
>>>> +                     else
>>>> +                             optimal_size = size;
>>>>                }
>>>> +
>>>> +
>>>>                /* Just make sure we aren't corrupting data or
>>>>                 * metadata
>>>>                 */
>>>> @@ -246,9 +252,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>>>                                goto bad_alignment;
>>>>                } else if (offset < 0) {
>>>>                        /* DATA  BITMAP METADATA  */
>>>> -                     if (offset
>>>> -                         + (long)(page->index * (PAGE_SIZE/512))
>>>> -                         + size/512 > 0)
>>>> +                     loff_t off = offset + (long)(page->index * (PAGE_SIZE/512));
>>>> +                     if (size != optimal_size &&
>>>> +                         off + optimal_size/512 <= 0)
>>>> +                             size = optimal_size;
>>>> +                     else if (off + size/512 > 0)
>>>>                                /* bitmap runs in to metadata */
>>>>                                goto bad_alignment;
>>>>                        if (rdev->data_offset + mddev->dev_sectors
>>>> @@ -257,10 +265,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>>>                                goto bad_alignment;
>>>>                } else if (rdev->sb_start < rdev->data_offset) {
>>>>                        /* METADATA BITMAP DATA */
>>>> -                     if (rdev->sb_start
>>>> -                         + offset
>>>> -                         + page->index*(PAGE_SIZE/512) + size/512
>>>> -                         > rdev->data_offset)
>>>> +                     loff_t off = rdev->sb_start + offset + page->index*(PAGE_SIZE/512);
>>>> +                     if (size != optimal_size &&
>>>> +                         off + optimal_size/512 <= rdev->data_offset)
>>>> +                             size = optimal_size;
>>>> +                     else if (off + size/512 > rdev->data_offset)
>>>>                                /* bitmap runs in to data */
>>>>                                goto bad_alignment;
>>>>                } else {
