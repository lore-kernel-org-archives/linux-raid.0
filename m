Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251B8C77B61
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 20:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjDXUXX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 16:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjDXUXV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 16:23:21 -0400
X-Greylist: delayed 564 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 24 Apr 2023 13:23:18 PDT
Received: from out-10.mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D148265A8
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 13:23:18 -0700 (PDT)
Message-ID: <3eb2ccba-9b0c-b740-f303-1c9920ebbd84@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682367232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PHmG3XC92b4E8/m/mMjBm3IeK88RhB5JDvpr+lcToxo=;
        b=jaDCPyaTq4r905tWm6MO0wuADK1YZ0mUPRszJ4WlR3XBi+H8y5v5AG6Bt1tyyK6Zkf3JzY
        RZ2OwsPxtKEQacqbu8VnzgftGCWwAHqcr4Oil3TJ6x5o5mvlt6Lc+h1ljAqrqZ0Q/H5DvG
        mOhLwIm25wuJvYlSORr63pR1CkRBR3U=
Date:   Mon, 24 Apr 2023 14:13:49 -0600
MIME-Version: 1.0
Subject: Re: [bug report] md: Fix types in sb writer
To:     Song Liu <song@kernel.org>,
        Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-raid@vger.kernel.org
References: <2dc52026-8261-49da-90c8-55cd5c5c6959@kili.mountain>
 <CAPhsuW6nb+9kVmCi2j93zWPxZ6UcQQBSnHFSCp1c7Bi3+xUZXA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
In-Reply-To: <CAPhsuW6nb+9kVmCi2j93zWPxZ6UcQQBSnHFSCp1c7Bi3+xUZXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 4/24/23 12:00 PM, Song Liu wrote:
> Hi Dan,
> 
> Thanks for the report!.
> 
> On Fri, Apr 21, 2023 at 3:45 AM Dan Carpenter <dan.carpenter@linaro.org> wrote:
>>
>> Hello Jon Derrick,
>>
>> The patch 10172f200b67: "md: Fix types in sb writer" from Feb 24,
>> 2023, leads to the following Smatch static checker warning:
>>
>>          drivers/md/md-bitmap.c:265 __write_sb_page()
>>          warn: unsigned 'offset' is never less than zero.
>>
>> drivers/md/md-bitmap.c
>>      234 static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>>      235                            struct page *page)
>>      236 {
>>      237         struct block_device *bdev;
>>      238         struct mddev *mddev = bitmap->mddev;
>>      239         struct bitmap_storage *store = &bitmap->storage;
>>      240         sector_t offset = mddev->bitmap_info.offset;
>>                  ^^^^^^^^
>> offset used to be llof_t which is s64.
> 
> Hi Jon,
> 
> Please look into this soon.
> 
> Thanks,
> Song
> 
>>
>>      241         sector_t ps, sboff, doff;
>>      242         unsigned int size = PAGE_SIZE;
>>      243         unsigned int opt_size = PAGE_SIZE;
>>      244
>>      245         bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
>>      246         if (page->index == store->file_pages - 1) {
>>      247                 unsigned int last_page_size = store->bytes & (PAGE_SIZE - 1);
>>      248
>>      249                 if (last_page_size == 0)
>>      250                         last_page_size = PAGE_SIZE;
>>      251                 size = roundup(last_page_size, bdev_logical_block_size(bdev));
>>      252                 opt_size = optimal_io_size(bdev, last_page_size, size);
>>      253         }
>>      254
>>      255         ps = page->index * PAGE_SIZE / SECTOR_SIZE;
>>      256         sboff = rdev->sb_start + offset;
>>      257         doff = rdev->data_offset;
>>      258
>>      259         /* Just make sure we aren't corrupting data or metadata */
>>      260         if (mddev->external) {
>>      261                 /* Bitmap could be anywhere. */
>>      262                 if (sboff + ps > doff &&
>>      263                     sboff < (doff + mddev->dev_sectors + PAGE_SIZE / SECTOR_SIZE))
>>      264                         return -EINVAL;
>> --> 265         } else if (offset < 0) {
>>                             ^^^^^^^^^^
>> Now that it's a sector_t this is impossible.
>>
>>      266                 /* DATA  BITMAP METADATA  */
>>      267                 size = bitmap_io_size(size, opt_size, offset + ps, 0);
>>      268                 if (size == 0)
>>      269                         /* bitmap runs in to metadata */
>>      270                         return -EINVAL;
>>      271
>>      272                 if (doff + mddev->dev_sectors > sboff)
>>      273                         /* data runs in to bitmap */
>>      274                         return -EINVAL;
>>      275         } else if (rdev->sb_start < rdev->data_offset) {
>>      276                 /* METADATA BITMAP DATA */
>>      277                 size = bitmap_io_size(size, opt_size, sboff + ps, doff);
>>      278                 if (size == 0)
>>      279                         /* bitmap runs in to data */
>>      280                         return -EINVAL;
>>      281         } else {
>>      282                 /* DATA METADATA BITMAP - no problems */
>>      283         }
>>      284
>>      285         md_super_write(mddev, rdev, sboff + ps, (int) size, page);
>>      286         return 0;
>>      287 }
>>
>> regards,
>> dan carpenter

Seems like just changing it (and sboff) back to loff_t would be acceptable.

Do you want a follow-up, or a series respin?
