Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A073AEB64D7
	for <linux-raid@archiver.kernel.org>; Wed, 21 Jun 2023 03:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjFUDmq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Jun 2023 23:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjFUDmM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Jun 2023 23:42:12 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31CE1BF7;
        Tue, 20 Jun 2023 20:41:40 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Qm82G4NYSz4f3nTY;
        Wed, 21 Jun 2023 11:22:30 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3X7P1bJJkzg20MA--.30704S3;
        Wed, 21 Jun 2023 11:22:31 +0800 (CST)
Subject: Re: [PATCH -next 3/8] raid5: fix missing io accounting in
 raid5_align_endio()
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     xni@redhat.com, song@kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20230619204826.755559-1-yukuai1@huaweicloud.com>
 <20230619204826.755559-4-yukuai1@huaweicloud.com>
 <6f05e7b4-461c-68db-20c5-e3bfd52cc7f6@molgen.mpg.de>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8626ee12-e4df-1645-21e9-c6b648ceb1eb@huaweicloud.com>
Date:   Wed, 21 Jun 2023 11:22:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6f05e7b4-461c-68db-20c5-e3bfd52cc7f6@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3X7P1bJJkzg20MA--.30704S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXF4UZr17XF1rArykGrW5trb_yoWrWw1Dpa
        n7tFy3JrW5Xr1rWrW7tw4UGa4Sqw4Dta97JryxXa48tw42yFyjga1UXry0gFyUAFW8Wr1U
        Jw1jqrsrur17GFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
        DUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/06/20 17:57, Paul Menzel 写道:
> Dear Yu,
> 
> 
> Thank you for your patch.
> 
> Am 19.06.23 um 22:48 schrieb Yu Kuai:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Io will only be accounted as done from raid5_align_endio() if the io
>> succeed, and io inflight counter will be leaked if such io failed.
> 
> succeed*s* or succeed*ed*?

I'll up date this.

> 
>> Fix this problem by switching to use md_account_bio() for io accounting.
> 
> How can this be tested?
> 
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/raid5.c | 29 ++++++++---------------------
>>   1 file changed, 8 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index cef0b400b2ee..4cdb35e54251 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -5468,26 +5468,17 @@ static struct bio 
>> *remove_bio_from_retry(struct r5conf *conf,
>>    */
>>   static void raid5_align_endio(struct bio *bi)
>>   {
>> -    struct md_io_clone *md_io_clone = bi->bi_private;
>> -    struct bio *raid_bi = md_io_clone->orig_bio;
>> -    struct mddev *mddev;
>> -    struct r5conf *conf;
>> -    struct md_rdev *rdev;
>> +    struct bio *raid_bi = bi->bi_private;
>> +    struct md_rdev *rdev = (void *)raid_bi->bi_next;
>> +    struct mddev *mddev = rdev->mddev;
>> +    struct r5conf *conf = mddev->private;
>>       blk_status_t error = bi->bi_status;
>> -    unsigned long start_time = md_io_clone->start_time;
>>       bio_put(bi);
>> -
>> -    rdev = (void*)raid_bi->bi_next;
>>       raid_bi->bi_next = NULL;
>> -    mddev = rdev->mddev;
>> -    conf = mddev->private;
>> -
> 
> This looks like unnecessary refactoring. No idea what the preferred 
> style for the subsystem is though. If it is wanted, maybe make it a 
> separate commit?

You mean that I initialize 'rdev' and 'mdev' while declaration?
I think code is cleaner this way, and this is too tiny to make a patch
for this... I will keep this for now.  😉

Thanks,
Kuai

> 
>>       rdev_dec_pending(rdev, conf->mddev);
>>       if (!error) {
>> -        if (blk_queue_io_stat(raid_bi->bi_bdev->bd_disk->queue))
>> -            bio_end_io_acct(raid_bi, start_time);
>>           bio_endio(raid_bi);
>>           if (atomic_dec_and_test(&conf->active_aligned_reads))
>>               wake_up(&conf->wait_for_quiescent);
>> @@ -5506,7 +5497,6 @@ static int raid5_read_one_chunk(struct mddev 
>> *mddev, struct bio *raid_bio)
>>       struct md_rdev *rdev;
>>       sector_t sector, end_sector, first_bad;
>>       int bad_sectors, dd_idx;
>> -    struct md_io_clone *md_io_clone;
>>       bool did_inc;
>>       if (!in_chunk_boundary(mddev, raid_bio)) {
>> @@ -5543,16 +5533,13 @@ static int raid5_read_one_chunk(struct mddev 
>> *mddev, struct bio *raid_bio)
>>           return 0;
>>       }
>> -    align_bio = bio_alloc_clone(rdev->bdev, raid_bio, GFP_NOIO,
>> -                    &mddev->io_clone_set);
>> -    md_io_clone = container_of(align_bio, struct md_io_clone, 
>> bio_clone);
>> +    md_account_bio(mddev, &raid_bio);
>>       raid_bio->bi_next = (void *)rdev;
>> -    if (blk_queue_io_stat(raid_bio->bi_bdev->bd_disk->queue))
>> -        md_io_clone->start_time = bio_start_io_acct(raid_bio);
>> -    md_io_clone->orig_bio = raid_bio;
>> +    align_bio = bio_alloc_clone(rdev->bdev, raid_bio, GFP_NOIO,
>> +                    &mddev->bio_set);
>>       align_bio->bi_end_io = raid5_align_endio;
>> -    align_bio->bi_private = md_io_clone;
>> +    align_bio->bi_private = raid_bio;
>>       align_bio->bi_iter.bi_sector = sector;
>>       /* No reshape active, so we can trust rdev->data_offset */
> 
> 
> Kind regards,
> 
> Paul
> 
> .
> 

