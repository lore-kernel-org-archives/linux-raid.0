Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D6BCE7A91
	for <linux-raid@archiver.kernel.org>; Mon, 25 Sep 2023 01:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjIYBnu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 24 Sep 2023 21:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjIYBnt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 24 Sep 2023 21:43:49 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38DABD
        for <linux-raid@vger.kernel.org>; Sun, 24 Sep 2023 18:43:42 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Rv5Hq4FRVz4f3kGD
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 09:43:35 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAnvdzL5RBlZKdKBQ--.18403S3;
        Mon, 25 Sep 2023 09:43:40 +0800 (CST)
Subject: Re: request for help on IMSM-metadata RAID-5 array
To:     Joel Parthemore <joel@parthemores.com>,
        Roman Mamedov <rm@romanrm.net>
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <507b6ab0-fd8f-d770-ba82-28def5f53d25@parthemores.com>
 <20230923162449.3ea0d586@nvm>
 <4095b51a-1038-2fd0-6503-64c0daa913d8@parthemores.com>
 <20230923203512.581fcd7d@nvm>
 <72388663-3997-a410-76f0-066dcd7d2a63@parthemores.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4d606b3d-ccec-e791-97ba-2cb5af0cc226@huaweicloud.com>
Date:   Mon, 25 Sep 2023 09:43:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <72388663-3997-a410-76f0-066dcd7d2a63@parthemores.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAnvdzL5RBlZKdKBQ--.18403S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJw4fJF45tr13CF1kJF4rAFb_yoW5Xw15pF
        W3KFZIkrsxJr47Aw12vr18Ga4Yyr45ZrZxGrn8GrWkAwn0vrnrWr4xKryruF9rurW8Gw4j
        vr18ArW7CrZ8AaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrNtxDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/09/24 2:49, Joel Parthemore 写道:
> So, dd finally sped up and finished. It appears that I have lost none of 
> my data. I am a very happy man. A question: is there anything useful I 
> am likely to discover from keeping the RAID array as it is a bit longer 
> before I recreate it and copy the data back?

It'll be much helper for developers to collect kernel stack for all
stuck thread(and it'll be much better to use add2line).

Thanks,
Kuai

> 
> Joel
> 
> ----------------------------------------------------------------------------- 
> 
> 
> I have been wondering about HDD issues all along, of course, though I 
> didn't see any smoking gun.
> 
> 
> I ran iostat -x 2 /dev/sdX on all three drives. All show an idle rate of 
> just under 90%. So I don't think that's the problem.
> 
> Joel
> 
> Den 2023-09-23 kl. 17:35, skrev Roman Mamedov:
>> On Sat, 23 Sep 2023 17:18:00 +0200
>> Joel Parthemore <joel@parthemores.com> wrote:
>>
>>> I didn't want to try that again until I had confirmation that the
>>> out-of-sync wouldn't (or shouldn't) be an issue. (I had tried it once
>>> before, but the system had somehow swapped /dev/md126 and /dev/md127 so
>>> that /dev/md126 became the container and /dev/md127 the RAID-5 array,
>>> which confused me. So I stopped experimenting further until I had a
>>> chance to write to the list.)
>>>
>>> The array is assembled read only, and this time both /dev/md126 and
>>> /dev/md127 are looking like I expect them to. I started dd to make a
>>> backup image using dd if=/dev/md126 of=/dev/sdc bs=64K
>>> conv=noerror,sync. (The EXT4 file store on the 2TB RAID-5 array is about
>>> 900GB full.) At first, it was running most of the time and just
>>> occasionally in uninterruptible sleep, but the periods of
>>> uninterruptible sleep quickly started getting longer. Now it seems to be
>>> spending most but not quite all of its time in uninterruptible sleep. Is
>>> this some kind of race condition? Anyway, I'll leave it running
>>> overnight to see if it completes.
>>>
>>> Accessing the RAID array definitely isn't locking things up this time. I
>>> can go in and look at the partition table, for example, no problem.
>>> Access is awfully slow, but I assume that's because of whatever dd is or
>>> isn't doing.
>>>
>>> By the way, I'm using kernel 6.5.3, which isn't the latest (that would
>>> be 6.5.5) but is close.
>> Maybe it's an HDD issue, one of them did have some unreadable sectors 
>> in the
>> past, although the firmware has not decided to do anything about that, 
>> such
>> as reallocating them and recording that in SMART.
>>
>> Check if one of the drives is holding up things, with a command like
>>
>> iostat -x 2 /dev/sd?
>>
>> If you see 100% next to one of the drives, and much less for others, 
>> that one
>> might be culprit.
> .
> 

