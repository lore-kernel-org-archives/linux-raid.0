Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18388C77B60
	for <linux-raid@archiver.kernel.org>; Fri, 28 Apr 2023 09:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345520AbjD1JcL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Apr 2023 05:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345387AbjD1JcJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Apr 2023 05:32:09 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8E54497
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 02:32:04 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Q76nW2LqGz4f3p0x
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 17:31:59 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBH_rGOkktkUsZHIQ--.65000S3;
        Fri, 28 Apr 2023 17:32:00 +0800 (CST)
Subject: Re: [question] solution for raid10 configuration concurrent with io
To:     Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>, logang@deltatee.com,
        guoqing.jiang@linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <cb390b39-1b1e-04e1-55ad-2ff8afc47e1b@huawei.com>
 <CALTww2__S7y9zZ0Y2R6qOW4A_V0S0Z7Z_ixOvoe6BoGxqbnd4g@mail.gmail.com>
 <3ebb2a0a-3a1c-7e76-c331-f0ebfaed2634@huaweicloud.com>
 <CALTww28Z94iN6srV2axvaiVxJ=1xryHqLiM6G-OuNWjXqdZJ9g@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <bfd1bb0c-d06f-61e8-838b-af442141fcc3@huaweicloud.com>
Date:   Fri, 28 Apr 2023 17:31:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww28Z94iN6srV2axvaiVxJ=1xryHqLiM6G-OuNWjXqdZJ9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBH_rGOkktkUsZHIQ--.65000S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFy7tw45Xr45WFW5XFWfuFg_yoW5Zryfp3
        yYgFs8KF4DX3yqyw1ktr47ury0g3y2q3y3Xr93C3s7u3srAr92q3yfJF45ur9xZr9rtw40
        vr4UXws8WryjgFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/04/28 17:11, Xiao Ni 写道:
> On Thu, Apr 27, 2023 at 3:13 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/04/27 14:53, Xiao Ni 写道:
>>>> for example, null-ptr-dereference:
>>>>
>>>> t1:                             t2:
>>>> raid10_write_request:
>>>>
>>>>     // read rdev
>>>>     rdev = conf->mirros[].rdev;
>>>>                                   raid10_remove_disk
>>>>                                    p = conf->mirros + number;
>>>>                                    rdevp = &p->rdev;
>>>>                                    // reset rdev
>>>>                                    *rdevp = NULL
>>>>     raid10_write_one_disk
>>>>      // reread rdev got NULL
>>>>      rdev = conf->mirrors[devnum].rdev
>>>>        // null-ptr-dereference
>>>>       mbio = bio_alloc_clone(rdev->bdev...)
>>>>                                    synchronize_rcu()
>>>
>>> Hi Yu kuai
>>>
>>> raid10_write_request adds the rdev->nr_pending with rcu lock
>>> protection. Can this case happen? After adding ->nr_pending, the rdev
>>> can't be removed.
>>
>> The current rcu protection really is a mess, many places access rdev
>> after rcu_read_unlock()...
> 
> Hi Yu Kuai
> 
> It looks like a problem that is it safe to access rdev after adding
> rdev->nr_pending and rcu_read_unlock. Because besides raid10, other
> personalities still do in the same way. After reading the related
> codes, I have the same question.

I think it's not safe, that's basically what the first solution try to
avoid, but it's just in raid10, and I'm not quite familiar with all the
personality but I think they can be fixed likewise. I'll keep looking
into the details. 😉

> 
>>
>> For the above case, noted that raid10_remove_disk is called before
>> nr_pending is increased, and raid10_write_one_disk() is called after
>> rcu_read_unlock().
>>
>> t1:                             t2:
>>
>> raid10_write_request
>>    rcu_read_lock
>>    rdev = conf->mirros[].rdev
>>                                  raid10_remove_disk
>>                                   ......
>>                                   // nr_pending is 0, remove disk
>>    // read inside rcu
>>    rcu_read_unlock
>>
>>    raid10_write_one_disk
>>    // trigger null-ptr-dereference
>>                                  synchronize_rcu()
> 
> Function remove_and_add_spares sets RemoveSynchronized, calls
> synchronize_rcu and calls raid10_remove_disk. So the right position of
> synchronize_rcu in your case should be before raid10_remove_disk?
> 
> But it still can't resolve the problem. raid10_remove_disk can set
> rdev to NULL between rcu_dereference and adding ->nr_pending
> 
> raid10_write_request                     remove_and_add_spares
> 
>                                                         set RemoveSynchronized
>                                                         synchronize_rcu
> rcu_read_lock
> rdev = rcu_dereference
>                                                       <-------     *rdevp = NULL
> atomic_inc rdev->nr_pending
> rcu_read_unlock
> 
> raid10_write_one_disk
> // trigger null-ptr-dereference
> 
> Can we check RemoveSynchronized in pers->make_request? It can't submit
> bio to this rdev after synchronize_rcu. For the
> pers->hot_remove_disk(raid10_remove_disk) side, as you said in the
> second solution, maybe it needs a new method to know all
> pers->make_request(raid10_make_request) exit.
> 

First of all, this is just one example for many existing problems. Then,
there are some contions to set RemoveSynchronized in
remove_and_add_spares, check the flag can't cover all the case.

I do prefer second solution, however, there will be a lot of changes,
I'll wait for more response before I start working on that.

Thanks,
Kuai

