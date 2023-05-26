Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E04AC77B7E
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 02:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbjEZCrw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 May 2023 22:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjEZCrv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 May 2023 22:47:51 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53F0B6
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 19:47:49 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QS8V95P8zz4f3pCH
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 10:47:45 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHcLPRHXBk2ILoKA--.42909S3;
        Fri, 26 May 2023 10:47:46 +0800 (CST)
Subject: Re: Fwd: The read data is wrong from raid5 when recovery happens
To:     Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <CALTww2_4pS=wF6tR0rVejg1ocyGhkTJic0aA=WCcTXDh+cZXQQ@mail.gmail.com>
 <1dd27191-a4c7-101a-1d1b-5f71503756a6@huaweicloud.com>
 <CALTww28_feZ7zW6fLPeyhsuvUcXukGtjTZKQ+_cQ9TQpc06TgA@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <25f36f90-e2ee-7af3-2bfa-8fa9747f6dfd@huaweicloud.com>
Date:   Fri, 26 May 2023 10:47:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww28_feZ7zW6fLPeyhsuvUcXukGtjTZKQ+_cQ9TQpc06TgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHcLPRHXBk2ILoKA--.42909S3
X-Coremail-Antispam: 1UD129KBjvJXoWxury5ArWrGrW3ZFW5uw1rWFg_yoW5CF1kpF
        ZxJanxtrW8JFy3GwnFq3ZYvFy0q3ykJr9IqrWUJw1xA3sYyr9aqrW8Ww4rurySvryrWr4r
        Zw4UWFW3WrW3Ka7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

在 2023/05/26 10:40, Xiao Ni 写道:
> On Fri, May 26, 2023 at 10:18 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/05/26 10:08, Xiao Ni 写道:
>>> I received an email that this email can't delivered to someone. Resent
>>> it to linux-raid again.
>>>
>>> ---------- Forwarded message ---------
>>> From: Xiao Ni <xni@redhat.com>
>>> Date: Fri, May 26, 2023 at 9:49 AM
>>> Subject: The read data is wrong from raid5 when recovery happens
>>> To: Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>
>>> Cc: linux-raid <linux-raid@vger.kernel.org>, Heinz Mauelshagen
>>> <heinzm@redhat.com>, Nigel Croxon <ncroxon@redhat.com>
>>>
>>>
>>> Hi all
>>>
>>> We found a problem recently. The read data is wrong when recovery
>>> happens. Now we've found it's introduced by patch 10764815f (md: add
>>> io accounting for raid0 and raid5). I can reproduce this 100%. This
>>> problem exists in upstream. The test steps are like this:
>>>
>>> 1. mdadm -CR $devname -l5 -n4 /dev/sd[b-e] --force --assume-clean
>>> 2. mkfs.ext4 -F $devname
>>> 3. mount $devname $mount_point
>>> 4. mdadm --incremental --fail sdd
>>> 5. dd if=/dev/zero of=/tmp/pythontest/file1 bs=1M count=100000 status=progress
>>> 6. mdadm /dev/md126 --add /dev/sdd
>> Can you try to zero superblock before add sdd? just to bypass readd.
> 
> Hi Kuai
> 
> I tried with this. It can still be reproduced.

Ok, I asked this because we found readd has some problem while testing
raid10, and it's easy to reporduce...

Then, there is a related fixed patch just merged:

md/raid5: fix miscalculation of 'end_sector' in raid5_read_one_chunk()

The upstream that you tried contain this one?

Thanks,
Kuai
> 
>>
>> Thanks,
>> Kuai
>>> 7. create 31 processes that writes and reads. It compares the content
>>> with md5sum. The test will go on until the recovery stops
>>> 8. wait for about 10 minutes, we can see some processes report
>>> checksum is wrong. But if it re-read the data again, the checksum will
>>> be good.
>>>
>>> I tried to narrow this problem like this:
>>>
>>> -       md_account_bio(mddev, &bi);
>>> +       if (rw == WRITE)
>>> +               md_account_bio(mddev, &bi);
>>> If it only do account for write requests, the problem can disappear.
>>>
>>> -       if (rw == READ && mddev->degraded == 0 &&
>>> -           mddev->reshape_position == MaxSector) {
>>> -               bi = chunk_aligned_read(mddev, bi);
>>> -               if (!bi)
>>> -                       return true;
>>> -       }
>>> +       //if (rw == READ && mddev->degraded == 0 &&
>>> +       //    mddev->reshape_position == MaxSector) {
>>> +       //      bi = chunk_aligned_read(mddev, bi);
>>> +       //      if (!bi)
>>> +       //              return true;
>>> +       //}
>>>
>>>           if (unlikely(bio_op(bi) == REQ_OP_DISCARD)) {
>>>                   make_discard_request(mddev, bi);
>>> @@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev
>>> *mddev, struct bio * bi)
>>>                           md_write_end(mddev);
>>>                   return true;
>>>           }
>>> -       md_account_bio(mddev, &bi);
>>> +       if (rw == READ)
>>> +               md_account_bio(mddev, &bi);
>>>
>>> I comment the chunk_aligned_read out and only account for read
>>> requests, this problem can be reproduced.
>>>
>>
> 
> 

