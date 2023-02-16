Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E3CC61DA4
	for <linux-raid@archiver.kernel.org>; Thu, 16 Feb 2023 23:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjBPXw2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Feb 2023 18:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBPXw0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Feb 2023 18:52:26 -0500
Received: from out-14.mta0.migadu.com (out-14.mta0.migadu.com [91.218.175.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F504BEAA
        for <linux-raid@vger.kernel.org>; Thu, 16 Feb 2023 15:52:24 -0800 (PST)
Message-ID: <850848e9-77db-8c93-d921-ba0be3ba7c38@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676591540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wwoEuZLsdonAUkaxvVGJ5KbLPPz8JZ/HVkHn7ieyWGo=;
        b=GBR9+PXPIKSaqYRgrzb3NKwmYcri4mBYpmX0dtnstKdjig0x/xwRqTUI8OBdO5hIH1L9On
        /SEKfJhdMK+ba4qiCEPnSIdvPEYl7R6lvfbL8AE8tvyuTN7dxkm3wouzrkdVvJcGC6Tx33
        DDDGYFkhnFrshz1GqN4LcfjuR9zDoOM=
Date:   Thu, 16 Feb 2023 16:52:17 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] md: Use optimal I/O size for last bitmap page
Content-Language: en-US
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org,
        Sushma Kalakota <sushma.kalakota@intel.com>
References: <20230118005319.147-1-jonathan.derrick@linux.dev>
 <80812f87-a743-2deb-3d43-d07fcc4ce895@linux.dev>
 <CAPhsuW65Qai4Dq-wzrcMbCR-s7J9astse1K8U8TwoAuxD4FyzQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
In-Reply-To: <CAPhsuW65Qai4Dq-wzrcMbCR-s7J9astse1K8U8TwoAuxD4FyzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2/10/2023 10:32 AM, Song Liu wrote:
> Hi Jonathan,
> 
> On Thu, Feb 9, 2023 at 12:38 PM Jonathan Derrick
> <jonathan.derrick@linux.dev> wrote:
>>
>> Hi Song,
>>
>> Any thoughts on this?
> 
> I am really sorry that I missed this patch.
> 
>>
>> On 1/17/2023 5:53 PM, Jonathan Derrick wrote:
>>> From: Jon Derrick <jonathan.derrick@linux.dev>
>>>
>>> If the bitmap space has enough room, size the I/O for the last bitmap
>>> page write to the optimal I/O size for the storage device. The expanded
>>> write is checked that it won't overrun the data or metadata.
>>>
>>> This change helps increase performance by preventing unnecessary
>>> device-side read-mod-writes due to non-atomic write unit sizes.
>>>
>>> Ex biosnoop log. Device lba size 512, optimal size 4k:
>>> Before:
>>> Time        Process        PID     Device      LBA        Size      Lat
>>> 0.843734    md0_raid10     5267    nvme0n1   W 24         3584      1.17
>>> 0.843933    md0_raid10     5267    nvme1n1   W 24         3584      1.36
>>> 0.843968    md0_raid10     5267    nvme1n1   W 14207939968 4096      0.01
>>> 0.843979    md0_raid10     5267    nvme0n1   W 14207939968 4096      0.02
>>>
>>> After:
>>> Time        Process        PID     Device      LBA        Size      Lat
>>> 18.374244   md0_raid10     6559    nvme0n1   W 24         4096      0.01
>>> 18.374253   md0_raid10     6559    nvme1n1   W 24         4096      0.01
>>> 18.374300   md0_raid10     6559    nvme0n1   W 11020272296 4096      0.01
>>> 18.374306   md0_raid10     6559    nvme1n1   W 11020272296 4096      0.02
> 
> Do we see significant improvements from io benchmarks?
Yes. With lbaf=512, optimal i/o size=4k:

Without patch:
  write: IOPS=1570, BW=6283KiB/s (6434kB/s)(368MiB/60001msec); 0 zone resets
With patch:
  write: IOPS=59.7k, BW=233MiB/s (245MB/s)(13.7GiB/60001msec); 0 zone resets

It's going to be different for different drives, but this was a drive where a
drive-side read-mod-write has huge penalty.

> 
> IIUC, fewer future HDDs will use 512B LBA size.We probably don't need
> such optimizations in the future.
Maybe. But many drives still ship with 512B formatting as default.

> 
> Thanks,
> Song
> 
>>>
>>> Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
>>> ---
>>>  drivers/md/md-bitmap.c | 27 ++++++++++++++++++---------
>>>  1 file changed, 18 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>>> index e7cc6ba1b657..569297ea9b99 100644
>>> --- a/drivers/md/md-bitmap.c
>>> +++ b/drivers/md/md-bitmap.c
>>> @@ -220,6 +220,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>>       rdev = NULL;
>>>       while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
>>>               int size = PAGE_SIZE;
>>> +             int optimal_size = PAGE_SIZE;
>>>               loff_t offset = mddev->bitmap_info.offset;
>>>
>>>               bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
>>> @@ -228,9 +229,14 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>>                       int last_page_size = store->bytes & (PAGE_SIZE-1);
>>>                       if (last_page_size == 0)
>>>                               last_page_size = PAGE_SIZE;
>>> -                     size = roundup(last_page_size,
>>> -                                    bdev_logical_block_size(bdev));
>>> +                     size = roundup(last_page_size, bdev_logical_block_size(bdev));
>>> +                     if (bdev_io_opt(bdev) > bdev_logical_block_size(bdev))
>>> +                             optimal_size = roundup(last_page_size, bdev_io_opt(bdev));
>>> +                     else
>>> +                             optimal_size = size;
>>>               }
>>> +
>>> +
>>>               /* Just make sure we aren't corrupting data or
>>>                * metadata
>>>                */
>>> @@ -246,9 +252,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>>                               goto bad_alignment;
>>>               } else if (offset < 0) {
>>>                       /* DATA  BITMAP METADATA  */
>>> -                     if (offset
>>> -                         + (long)(page->index * (PAGE_SIZE/512))
>>> -                         + size/512 > 0)
>>> +                     loff_t off = offset + (long)(page->index * (PAGE_SIZE/512));
>>> +                     if (size != optimal_size &&
>>> +                         off + optimal_size/512 <= 0)
>>> +                             size = optimal_size;
>>> +                     else if (off + size/512 > 0)
>>>                               /* bitmap runs in to metadata */
>>>                               goto bad_alignment;
>>>                       if (rdev->data_offset + mddev->dev_sectors
>>> @@ -257,10 +265,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>>                               goto bad_alignment;
>>>               } else if (rdev->sb_start < rdev->data_offset) {
>>>                       /* METADATA BITMAP DATA */
>>> -                     if (rdev->sb_start
>>> -                         + offset
>>> -                         + page->index*(PAGE_SIZE/512) + size/512
>>> -                         > rdev->data_offset)
>>> +                     loff_t off = rdev->sb_start + offset + page->index*(PAGE_SIZE/512);
>>> +                     if (size != optimal_size &&
>>> +                         off + optimal_size/512 <= rdev->data_offset)
>>> +                             size = optimal_size;
>>> +                     else if (off + size/512 > rdev->data_offset)
>>>                               /* bitmap runs in to data */
>>>                               goto bad_alignment;
>>>               } else {
