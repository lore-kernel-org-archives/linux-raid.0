Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B9CBC64EC4
	for <linux-raid@archiver.kernel.org>; Tue, 28 Feb 2023 23:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjB1XKH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Feb 2023 18:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjB1XKG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Feb 2023 18:10:06 -0500
Received: from out-7.mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327D112064
        for <linux-raid@vger.kernel.org>; Tue, 28 Feb 2023 15:10:04 -0800 (PST)
Message-ID: <2f2ba1cb-a053-7494-ce42-4670b66baacf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677625800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UMa415PWn7RwX/XXTQZc3rt12mI78ihDIzz3KEgT3v4=;
        b=NiTaedqJzm8scLmaLrtXPxXvTbCMXePpkDq01TAiwXp3vfXNJu1CT/qPh6L/M6EQY4ey28
        QXNTfw4+hLGYYbcjrhWIvuOykVkfzGg1HT1uzr+2fydDIJPXAc/XccbPmzywTTd5MFR9rB
        YRQkPLkXdoGPz2dIJBfoHVyiec9Uyo8=
Date:   Tue, 28 Feb 2023 16:09:56 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v5 3/3] md: Use optimal I/O size for last bitmap page
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Reindl Harald <h.reindl@thelounge.net>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>
References: <20230224183323.638-1-jonathan.derrick@linux.dev>
 <20230224183323.638-4-jonathan.derrick@linux.dev>
 <CALTww2_P6TaV7C5i2k5sUeHOpnqTxjFB-ZA98Y2re+17J5d7Kw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
In-Reply-To: <CALTww2_P6TaV7C5i2k5sUeHOpnqTxjFB-ZA98Y2re+17J5d7Kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao

On 2/26/2023 6:56 PM, Xiao Ni wrote:
> Hi Jonathan
> 
> I did a test in my environment, but I didn't see such a big
> performance difference.
> 
> The first environment:
> All nvme devices have 512 logical size, 512 phy size, and 0 optimal size. Then
> I used your way to rebuild the kernel
> /sys/block/nvme0n1/queue/physical_block_size 512
> /sys/block/nvme0n1/queue/optimal_io_size 4096
> cat /sys/block/nvme0n1/queue/logical_block_size 512
> 
> without the patch set
> write: IOPS=68.0k, BW=266MiB/s (279MB/s)(15.6GiB/60001msec); 0 zone resets
> with the patch set
> write: IOPS=69.1k, BW=270MiB/s (283MB/s)(15.8GiB/60001msec); 0 zone resets
> 
> The second environment:
> The nvme devices' opt size are 4096. So I don't need to rebuild the kernel.
> /sys/block/nvme0n1/queue/logical_block_size
> /sys/block/nvme0n1/queue/physical_block_size
> /sys/block/nvme0n1/queue/optimal_io_size
> 
> without the patch set
> write: IOPS=51.6k, BW=202MiB/s (212MB/s)(11.8GiB/60001msec); 0 zone resets
> with the patch set
> write: IOPS=53.5k, BW=209MiB/s (219MB/s)(12.2GiB/60001msec); 0 zone resets
> 
Sounds like your devices may not have latency issues at sub-optimal sizes.
Can you provide biosnoop traces with and without patches?

Still, 'works fine for me' is generally not a reason to reject the patches.

> Best Regards
> Xiao
> 
> On Sat, Feb 25, 2023 at 2:34 AM Jonathan Derrick
> <jonathan.derrick@linux.dev> wrote:
>>
>> From: Jon Derrick <jonathan.derrick@linux.dev>
>>
>> If the bitmap space has enough room, size the I/O for the last bitmap
>> page write to the optimal I/O size for the storage device. The expanded
>> write is checked that it won't overrun the data or metadata.
>>
>> The drive this was tested against has higher latencies when there are
>> sub-4k writes due to device-side read-mod-writes of its atomic 4k write
>> unit. This change helps increase performance by sizing the last bitmap
>> page I/O for the device's preferred write unit, if it is given.
>>
>> Example Intel/Solidigm P5520
>> Raid10, Chunk-size 64M, bitmap-size 57228 bits
>>
>> $ mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/nvme{0,1,2,3}n1
>>         --assume-clean --bitmap=internal --bitmap-chunk=64M
>> $ fio --name=test --direct=1 --filename=/dev/md0 --rw=randwrite --bs=4k --runtime=60
>>
>> Without patch:
>>   write: IOPS=1676, BW=6708KiB/s (6869kB/s)(393MiB/60001msec); 0 zone resets
>>
>> With patch:
>>   write: IOPS=15.7k, BW=61.4MiB/s (64.4MB/s)(3683MiB/60001msec); 0 zone resets
>>
>> Biosnoop:
>> Without patch:
>> Time        Process        PID     Device      LBA        Size      Lat
>> 1.410377    md0_raid10     6900    nvme0n1   W 16         4096      0.02
>> 1.410387    md0_raid10     6900    nvme2n1   W 16         4096      0.02
>> 1.410374    md0_raid10     6900    nvme3n1   W 16         4096      0.01
>> 1.410381    md0_raid10     6900    nvme1n1   W 16         4096      0.02
>> 1.410411    md0_raid10     6900    nvme1n1   W 115346512  4096      0.01
>> 1.410418    md0_raid10     6900    nvme0n1   W 115346512  4096      0.02
>> 1.410915    md0_raid10     6900    nvme2n1   W 24         3584      0.43 <--
>> 1.410935    md0_raid10     6900    nvme3n1   W 24         3584      0.45 <--
>> 1.411124    md0_raid10     6900    nvme1n1   W 24         3584      0.64 <--
>> 1.411147    md0_raid10     6900    nvme0n1   W 24         3584      0.66 <--
>> 1.411176    md0_raid10     6900    nvme3n1   W 2019022184 4096      0.01
>> 1.411189    md0_raid10     6900    nvme2n1   W 2019022184 4096      0.02
>>
>> With patch:
>> Time        Process        PID     Device      LBA        Size      Lat
>> 5.747193    md0_raid10     727     nvme0n1   W 16         4096      0.01
>> 5.747192    md0_raid10     727     nvme1n1   W 16         4096      0.02
>> 5.747195    md0_raid10     727     nvme3n1   W 16         4096      0.01
>> 5.747202    md0_raid10     727     nvme2n1   W 16         4096      0.02
>> 5.747229    md0_raid10     727     nvme3n1   W 1196223704 4096      0.02
>> 5.747224    md0_raid10     727     nvme0n1   W 1196223704 4096      0.01
>> 5.747279    md0_raid10     727     nvme0n1   W 24         4096      0.01 <--
>> 5.747279    md0_raid10     727     nvme1n1   W 24         4096      0.02 <--
>> 5.747284    md0_raid10     727     nvme3n1   W 24         4096      0.02 <--
>> 5.747291    md0_raid10     727     nvme2n1   W 24         4096      0.02 <--
>> 5.747314    md0_raid10     727     nvme2n1   W 2234636712 4096      0.01
>> 5.747317    md0_raid10     727     nvme1n1   W 2234636712 4096      0.02
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
>> ---
>>  drivers/md/md-bitmap.c | 33 +++++++++++++++++++++++++++++----
>>  1 file changed, 29 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index bf250a5e3a86..920bb68156d2 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -209,6 +209,28 @@ static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mdde
>>         return NULL;
>>  }
>>
>> +static unsigned int optimal_io_size(struct block_device *bdev,
>> +                                   unsigned int last_page_size,
>> +                                   unsigned int io_size)
>> +{
>> +       if (bdev_io_opt(bdev) > bdev_logical_block_size(bdev))
>> +               return roundup(last_page_size, bdev_io_opt(bdev));
>> +       return io_size;
>> +}
>> +
>> +static unsigned int bitmap_io_size(unsigned int io_size, unsigned int opt_size,
>> +                                  sector_t start, sector_t boundary)
>> +{
>> +       if (io_size != opt_size &&
>> +           start + opt_size / SECTOR_SIZE <= boundary)
>> +               return opt_size;
>> +       if (start + io_size / SECTOR_SIZE <= boundary)
>> +               return io_size;
>> +
>> +       /* Overflows boundary */
>> +       return 0;
>> +}
>> +
>>  static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>>                            struct page *page)
>>  {
>> @@ -218,6 +240,7 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>>         sector_t offset = mddev->bitmap_info.offset;
>>         sector_t ps, sboff, doff;
>>         unsigned int size = PAGE_SIZE;
>> +       unsigned int opt_size = PAGE_SIZE;
>>
>>         bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
>>         if (page->index == store->file_pages - 1) {
>> @@ -225,8 +248,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>>
>>                 if (last_page_size == 0)
>>                         last_page_size = PAGE_SIZE;
>> -               size = roundup(last_page_size,
>> -                              bdev_logical_block_size(bdev));
>> +               size = roundup(last_page_size, bdev_logical_block_size(bdev));
>> +               opt_size = optimal_io_size(bdev, last_page_size, size);
>>         }
>>
>>         ps = page->index * PAGE_SIZE / SECTOR_SIZE;
>> @@ -241,7 +264,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>>                         return -EINVAL;
>>         } else if (offset < 0) {
>>                 /* DATA  BITMAP METADATA  */
>> -               if (offset + ps + size / SECTOR_SIZE > 0)
>> +               size = bitmap_io_size(size, opt_size, offset + ps, 0);
>> +               if (size == 0)
>>                         /* bitmap runs in to metadata */
>>                         return -EINVAL;
>>
>> @@ -250,7 +274,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>>                         return -EINVAL;
>>         } else if (rdev->sb_start < rdev->data_offset) {
>>                 /* METADATA BITMAP DATA */
>> -               if (sboff + ps + size / SECTOR_SIZE > doff)
>> +               size = bitmap_io_size(size, opt_size, sboff + ps, doff);
>> +               if (size == 0)
>>                         /* bitmap runs in to data */
>>                         return -EINVAL;
>>         } else {
>> --
>> 2.27.0
>>
> 
