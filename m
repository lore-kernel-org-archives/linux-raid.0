Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2C6E81816
	for <linux-raid@archiver.kernel.org>; Tue, 26 Sep 2023 03:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbjIZD3B (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Sep 2023 23:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbjIZD26 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Sep 2023 23:28:58 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8242ED8
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 20:28:50 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4RvlZf5ShCz4f3jsq
        for <linux-raid@vger.kernel.org>; Tue, 26 Sep 2023 11:28:42 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAnvdztTxJlxXikBQ--.47968S3;
        Tue, 26 Sep 2023 11:28:47 +0800 (CST)
Subject: Re: fstrim on raid1 LV with writemostly PV leads to system freeze
To:     Kirill Kirilenko <kirill@ultracoder.org>,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Roman Mamedov <rm@romanrm.net>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com> <20230922030340.2eaa46bc@nvm>
 <6b7c6377-c4be-a1bc-d05d-37680175f84c@huaweicloud.com>
 <6a1165f7-c792-c054-b8f0-1ad4f7b8ae01@ultracoder.org>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d45ffbcd-cf55-f07c-c406-0cf762a4b4ec@huaweicloud.com>
Date:   Tue, 26 Sep 2023 11:28:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6a1165f7-c792-c054-b8f0-1ad4f7b8ae01@ultracoder.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAnvdztTxJlxXikBQ--.47968S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF17KFWUtF4fArWDAr1fZwb_yoW8trWDpr
        WvqFWYvrWUJr1kJr1DJr1UAry8Jr1Dt39rKr18XFyUXr17JFyjqr4kXryjgr1DGr48Gw1j
        qw1UJr1UuFyUJrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
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

在 2023/09/26 7:59, Kirill Kirilenko 写道:
> On 25.09.2023 05:58 +0300, Yu Kuai wrote:
>> Roman and Kirill, can you test the following patch?
>>
>> Thanks,
>> Kuai
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 4b30a1742162..4963f864ef99 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1345,6 +1345,7 @@ static void raid1_write_request(struct mddev
>> *mddev, struct bio *bio,
>>          int first_clone;
>>          int max_sectors;
>>          bool write_behind = false;
>> +       bool is_discard = (bio_op(bio) == REQ_OP_DISCARD);
>>
>>          if (mddev_is_clustered(mddev) &&
>>               md_cluster_ops->area_resyncing(mddev, WRITE,
>> @@ -1405,7 +1406,7 @@ static void raid1_write_request(struct mddev
>> *mddev, struct bio *bio,
>>                   * write-mostly, which means we could allocate write
>> behind
>>                   * bio later.
>>                   */
>> -               if (rdev && test_bit(WriteMostly, &rdev->flags))
>> +               if (!is_discard && rdev && test_bit(WriteMostly,
>> &rdev->flags))
>>                          write_behind = true;
>>
>>                  if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
> 
> Thank you. I can confirm, that your patch eliminates freezes during
> 'fstrim' execution. Tested on kernel 6.5.0.
> Still 'fstrim' takes more than 2 minutes, but I believe it's normal to a
> file system with 1M+ inodes.
Thanks for the test.

> 
> Probably I'm wrong here, but to me this doesn't look like a solution,
> more like a masking the real problem.
> Even with TRIM operations split in 1MB pieces, I don't expect kernel to
> freeze.

I still don't quite understand what you mean 'kernel freeze', this patch
indeed fix a problem that diskcard bio is treated as normal write bio
and it's splitted.

Can you explain more by how do you judge 'kernel freeze'? In the
meantime dose 'iostat -dmx 1' shows that disk is idle and no dicard io
is handled?

Thanks,
Kuai

> 
> .
> 

