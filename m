Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FDAC38142
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 07:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjBAHOb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 02:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBAHOa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 02:14:30 -0500
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEA91BE7
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 23:14:29 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4P6CpR5rmVz4f3kp7
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 15:14:23 +0800 (CST)
Received: from [10.174.176.117] (unknown [10.174.176.117])
        by APP2 (Coremail) with SMTP id Syh0CgBnWOZOEdpjxXsDCw--.11413S2;
        Wed, 01 Feb 2023 15:14:26 +0800 (CST)
Subject: Re: [PATCH] md: use MD_RESYNC_* whenever possible
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Logan Gunthorpe <logang@deltatee.com>, houtao1@huawei.com
References: <20230201064657.2768402-1-houtao@huaweicloud.com>
 <CAPhsuW6GmGdtaALpcY7LpsEr4SHXLRxDb9iZWTPG2h8q2UX5Mw@mail.gmail.com>
From:   Hou Tao <houtao@huaweicloud.com>
Message-ID: <025148b5-f213-86a8-2c1d-ac76c52f7165@huaweicloud.com>
Date:   Wed, 1 Feb 2023 15:14:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6GmGdtaALpcY7LpsEr4SHXLRxDb9iZWTPG2h8q2UX5Mw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: Syh0CgBnWOZOEdpjxXsDCw--.11413S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFW5WFy3ZFWkWFyfWw1xZrb_yoW8Cw4rp3
        yxXFWavrWUZrWYq3y2qFn0vFyFqr1SkFZrtrW7ua43Aw1fWr4kGry5Kw45XFn0va4rAr42
        v3yYga15uFn2gw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On 2/1/2023 3:06 PM, Song Liu wrote:
> On Tue, Jan 31, 2023 at 10:18 PM Hou Tao <houtao@huaweicloud.com> wrote:
>> From: Hou Tao <houtao1@huawei.com>
>>
>> Just replace magic numbers by MD_RESYNC_* enumerations.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
> Thanks for the patch. But it doesn't apply. I guess this is caused
> by some local debug commit?
Yes. Will send v2 based on md-next.
>
> Song
>
>> ---
>> Hi,
>>
>> The cleanup patch should be sent out with patch "md: don't update
>> recovery_cp when curr_resync is ACTIVE" together as a tiny patchset,
>> but i forgot about it, so now send it alone.
>>
>>  drivers/md/md.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 67ef1c768456..16da504aa156 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6156,7 +6156,7 @@ static void md_clean(struct mddev *mddev)
>>         mddev->new_level = LEVEL_NONE;
>>         mddev->new_layout = 0;
>>         mddev->new_chunk_sectors = 0;
>> -       mddev->curr_resync = 0;
>> +       mddev->curr_resync = MD_RESYNC_NONE;
>>         atomic64_set(&mddev->resync_mismatches, 0);
>>         mddev->suspend_lo = mddev->suspend_hi = 0;
>>         mddev->sync_speed_min = mddev->sync_speed_max = 0;
>> @@ -8887,7 +8887,7 @@ void md_do_sync(struct md_thread *thread)
>>         atomic_set(&mddev->recovery_active, 0);
>>         last_check = 0;
>>
>> -       if (j>2) {
>> +       if (j >= MD_RESYNC_ACTIVE) {
>>                 pr_debug("md: resuming %s of %s from checkpoint.\n",
>>                          desc, mdname(mddev));
>>                 pr_info("md: resuming %s of %s from 0x%llx\n", desc, mdname(mddev), j);
>> @@ -8967,7 +8967,7 @@ void md_do_sync(struct md_thread *thread)
>>                 if (j > max_sectors)
>>                         /* when skipping, extra large numbers can be returned. */
>>                         j = max_sectors;
>> -               if (j > 2)
>> +               if (j >= MD_RESYNC_ACTIVE)
>>                         mddev->curr_resync = j;
>>                 mddev->curr_mark_cnt = io_sectors;
>>                 if (last_check == 0)
>> --
>> 2.29.2
>>

