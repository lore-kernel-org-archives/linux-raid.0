Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BA8C072A2
	for <linux-raid@archiver.kernel.org>; Mon, 20 Nov 2023 01:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjKTBEV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Nov 2023 20:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjKTBEV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Nov 2023 20:04:21 -0500
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D83107
        for <linux-raid@vger.kernel.org>; Sun, 19 Nov 2023 17:04:17 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.216])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SYTmW2h8xz4f3l8k
        for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 09:04:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
        by mail.maildlp.com (Postfix) with ESMTP id 0847B1A0169
        for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 09:04:14 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP1 (Coremail) with SMTP id cCh0CgDX2hCMsFpl3LeZBQ--.59773S3;
        Mon, 20 Nov 2023 09:04:13 +0800 (CST)
Subject: Re: [REGRESSION] Data read from a degraded RAID 4/5/6 array could be
 silently corrupted.
To:     Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Bhanu Victor DiCara <00bvd0+linux@gmail.com>,
        Xiao Ni <xni@redhat.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org, regressions@lists.linux.dev,
        jiangguoqing@kylinos.cn, jgq516@gmail.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <5727380.DvuYhMxLoT@bvd0>
 <CAPhsuW4+Ktd7mzTQ6M4n9-=8vgyMDJUi8Xkcv50JXTf_2yqTFA@mail.gmail.com>
 <1956a189-107b-4445-9e53-336f1533c4b9@huaweicloud.com>
 <CAPhsuW6v+acp9jrwt-19fF7BUpLtDTRvVG4FNimpww4ztODHrg@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0a2a8a7e-e3a6-6ff2-0df5-ab091f666206@huaweicloud.com>
Date:   Mon, 20 Nov 2023 09:04:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6v+acp9jrwt-19fF7BUpLtDTRvVG4FNimpww4ztODHrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgDX2hCMsFpl3LeZBQ--.59773S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tr1DWr4fCw1xCF1UWr4Durg_yoW8uF17pr
        y8XF45tr4DXFyF9rW7K3WUCFn5trsIgrWIqrykJa1fJr90qr9rWr18W34rWr98XryfCFy2
        v3WDWF9xuF45taDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
        3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCT
        nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/11/18 8:32, Song Liu 写道:
> On Thu, Nov 16, 2023 at 5:05 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/11/17 0:24, Song Liu 写道:
>>> + more folks.
>>>
>>> On Fri, Nov 10, 2023 at 7:00 PM Bhanu Victor DiCara
>>> <00bvd0+linux@gmail.com> wrote:
>>>>
>>>> A degraded RAID 4/5/6 array can sometimes read 0s instead of the actual data.
>>>>
>>>>
>>>> #regzbot introduced: 10764815ff4728d2c57da677cd5d3dd6f446cf5f
>>>> (The problem does not occur in the previous commit.)
>>>>
>>>> In commit 10764815ff4728d2c57da677cd5d3dd6f446cf5f, file drivers/md/raid5.c, line 5808, there is `md_account_bio(mddev, &bi);`. When this line (and the previous line) is removed, the problem does not occur.
>>>
>>> The patch below should fix it. Please give it more thorough tests and
>>> let me know whether it fixes everything. I will send patch later with
>>> more details.
>>>
>>> Thanks,
>>> Song
>>>
>>> diff --git i/drivers/md/md.c w/drivers/md/md.c
>>> index 68f3bb6e89cb..d4fb1aa5c86f 100644
>>> --- i/drivers/md/md.c
>>> +++ w/drivers/md/md.c
>>> @@ -8674,7 +8674,8 @@ static void md_end_clone_io(struct bio *bio)
>>>           struct bio *orig_bio = md_io_clone->orig_bio;
>>>           struct mddev *mddev = md_io_clone->mddev;
>>>
>>> -       orig_bio->bi_status = bio->bi_status;
>>> +       if (bio->bi_status)
>>> +               orig_bio->bi_status = bio->bi_status;
>>
>> I'm confused, do you mean that orig_bio can have error while bio
>> doesn't? If this is the case, can you explain more how this is
>> possible?
> 
> Yes, this is possible.
> 
> Basically, a big bio is split by md_submit_bio => bio_split_to_limits, so
> we will have two bio's into md_clone_bio(). Let's call them
> parent_orig_bio and split_orig_bio. Errors from split_orig_bio will be
> propagated to parent_orig_bio by __bio_chain_endio(). If
> parent_orig_bio succeeded, md_end_clone_io may overwrite the error
> reported by split_orig_bio. Does this make sense?

Yes, this is a good catch, there should be similiar conditions from
__bio_chain_endio().

Thanks,
Kuai

> 
> Thanks,
> Song
> .
> 

