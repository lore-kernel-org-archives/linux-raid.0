Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A08C77B7D
	for <linux-raid@archiver.kernel.org>; Sat,  6 May 2023 01:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjEFBdv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 May 2023 21:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjEFBds (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 May 2023 21:33:48 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F35469F
        for <linux-raid@vger.kernel.org>; Fri,  5 May 2023 18:33:33 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QCqnj2dn0z4f3jLq
        for <linux-raid@vger.kernel.org>; Sat,  6 May 2023 09:33:29 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCnD7NprlVkbpBlIw--.33975S3;
        Sat, 06 May 2023 09:33:30 +0800 (CST)
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Jove <jovetoo@gmail.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Wol <antlists@youngman.org.uk>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com>
 <CAFig2ct4BJZ0A9BKuXn8RM71+KrUzB8vKGQY0fSjNZiNenQZBg@mail.gmail.com>
 <c71c8381-f26e-f7de-c6f5-3c4411f08b15@huaweicloud.com>
 <d159161d-a5eb-8790-49c4-b7013e66ba65@youngman.org.uk>
 <6f391690-992f-1196-3109-6d422b3522f7@huaweicloud.com>
 <CAFig2ct+ZbHYEho7p9eubaz-kozGR+GkSJ1tVL+LGaciUBixyw@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <bc698b03-446b-a42e-cf0c-5c1b3cb62559@huaweicloud.com>
Date:   Sat, 6 May 2023 09:33:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAFig2ct+ZbHYEho7p9eubaz-kozGR+GkSJ1tVL+LGaciUBixyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCnD7NprlVkbpBlIw--.33975S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCFWxuF13Kw15uw4DKFyUZFb_yoW5XF1kpa
        y8t3Wqkr4DJF9YyFW2y34Iqa4Fkry5Gr98Xwn0q34UCrZ8KFyIkrWxKrs0kF92kw1fCr4Y
        yF4Ut3srWryYgaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU5WlkUU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/05/05 23:47, Jove 写道:
> Hi Kuai.
> 
>> Jove, As I understand this, if mdadm make progress without a blocked
>> io, and reshape continues, it seems you can use this array without
>> problem
> 
> I've had to do some sleuthing to figure out who was doing that array
> access, I was already running a minimal FedoraCore image. I've
> discovered that the culprit is the systemd-udevd daemon. I do not know
> why it accesses the array but if I stop it and rename that executable
> (it gets started automatically when the array is assembled) then the
> reshape continues.

Thanks for confirming this, however, I have no idea why systemd-udevd is
accessing the array.

In the meantime, I'll try to fix this deadlock, hope you don't mind a
reported-by tag.

Thanks,
Kuai
> 
> Now it is just a matter of time until the reshape is finished and I
> can discover just how much data I still have :)
> 
> Thank you all for your help, I will send a last mail when I know more.
> 
> Best regards,
> 
>        Johan
> 
> 
> 
> On Fri, May 5, 2023 at 10:02 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/05/05 14:58, Wol 写道:
>>> On 05/05/2023 02:34, Yu Kuai wrote:
>>>>> I have had one case in which mdadm didn't hang and in which the
>>>>> reshape continued. Sadly, I was using sparse overlay files and the
>>>>> filesystem could not handle the full 4x 4TB. I had to terminate the
>>>>> reshape.
>>>>
>>>> This sounds like a dead end for now, normal io beyond reshape position
>>>> must wait:
>>>>
>>>> raid5_make_request
>>>>    make_stripe_request
>>>>     ahead_of_reshape
>>>>      wait_woken
>>>
>>> Not sure if I've got the wrong end of the stick, but if I've understood
>>> correctly, that shouldn't be the case.
>>>
>>> Reshape takes place in a window. All io *beyond* the window is allowed
>>> to proceed normally - that part of the array has not been reshaped so
>>> the old parameters are used.
>>>
>>> All io *in front* of the window is allowed to proceed normally - that
>>> part of the array has been reshaped so the new parameters are used.
>>>
>>> io *IN* the window is paused until the window has passed. This
>>> interruption should be short and sweet.
>>
>> Yes, it's correct, and in this case reshape_safe should be the same as
>> reshapge_progress, and I guess io is stuck because
>> stripe_ahead_of_reshape() return true.
>>
>> So this deadlock happens when io is blocked because of reshape, and
>> mddev_suspend() is waiting for this io to be done, in the meantime
>> reshape can't start untill mddev_suspend() returns.
>>
>> Jove, As I understand this, if mdadm make progress without a blocked
>> io, and reshape continues, it seems you can use this array without
>> problem.
>>
>> Thanks,
>> Kuai
>>>
>>> Cheers,
>>> Wol
>>>
>>> .
>>>
>>
> .
> 

