Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D791C77B73
	for <linux-raid@archiver.kernel.org>; Mon, 22 May 2023 07:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjEVHyQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 May 2023 03:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjEVHxi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 22 May 2023 03:53:38 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39838213C
        for <linux-raid@vger.kernel.org>; Mon, 22 May 2023 00:52:01 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QPqR02JWVz4f3lx7
        for <linux-raid@vger.kernel.org>; Mon, 22 May 2023 15:51:56 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP3 (Coremail) with SMTP id _Ch0CgD31QMcH2tkklK0JA--.45393S3;
        Mon, 22 May 2023 15:51:58 +0800 (CST)
Subject: Re: RAID5 Phantom Drive Appeared while Reshaping Four Drive Array
 (HARDLOCK)
To:     raid@electrons.cloud, Yu Kuai <yukuai1@huaweicloud.com>,
        Wol <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
Cc:     Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <60563747e11acd6757b20ba19006fcdcff5df519.camel@electrons.cloud>
 <96524acc-504d-6a07-85a0-0b56a9e2f2d7@youngman.org.uk>
 <9b22d5ce-5f1b-0fc8-acdc-02c2e8cefa55@huaweicloud.com>
 <b18cfe9f6f8e44285aa4ab4300e0c0e1b863fe08.camel@electrons.cloud>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a78c4551-defb-d531-3b5e-372889158f28@huaweicloud.com>
Date:   Mon, 22 May 2023 15:51:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <b18cfe9f6f8e44285aa4ab4300e0c0e1b863fe08.camel@electrons.cloud>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgD31QMcH2tkklK0JA--.45393S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCry5tw4rXrWxXw47Aw1kZrb_yoWrZFWkp3
        Z3WF4Y9wsxWw4xGas2vw48GFy8trW7ZrWfJw1qqryYka15Wrn3t39rJr4rJFWDWrn8uFZ2
        v3WktFZ8urWYyaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2023/05/22 14:56, raid 写道:
> Hi,
> Thanks for the guidance as the current state has at least changed somewhat.
> 
> BTW Sorry about Life getting in the way of tech. =) Reason for my delayed response.
> 
> -sudo mdadm -I /dev/sdc1
> mdadm: /dev/sdc1 attached to /dev/md480, not enough to start (1).
> -sudo mdadm -D /dev/md480
> /dev/md480:
>             Version : 1.2
>          Raid Level : raid0
>       Total Devices : 1
>         Persistence : Superblock is persistent
> 
>               State : inactive
>     Working Devices : 1
> 
>       Delta Devices : 1, (-1->0)
>           New Level : raid5
>          New Layout : left-symmetric
>       New Chunksize : 512K
> 
>                Name : GRANDSLAM:480
>                UUID : 20211025:02005a7a:5a7abeef:cafebabe
>              Events : 78714
> 
>      Number   Major   Minor   RaidDevice
> 
>         -       8       33        -        /dev/sdc1
> -sudo mdadm -I /dev/sdd1
> mdadm: /dev/sdd1 attached to /dev/md480, not enough to start (2).
> -sudo mdadm -D /dev/md480
> /dev/md480:
>             Version : 1.2
>          Raid Level : raid0
>       Total Devices : 2
>         Persistence : Superblock is persistent
> 
>               State : inactive
>     Working Devices : 2
> 
>       Delta Devices : 1, (-1->0)
>           New Level : raid5
>          New Layout : left-symmetric
>       New Chunksize : 512K
> 
>                Name : GRANDSLAM:480
>                UUID : 20211025:02005a7a:5a7abeef:cafebabe
>              Events : 78714
> 
>      Number   Major   Minor   RaidDevice
> 
>         -       8       49        -        /dev/sdd1
>         -       8       33        -        /dev/sdc1
> -sudo mdadm -I /dev/sde1
> mdadm: /dev/sde1 attached to /dev/md480, not enough to start (2).
> -sudo mdadm -D /dev/md480
> /dev/md480:
>             Version : 1.2
>          Raid Level : raid0
>       Total Devices : 3
>         Persistence : Superblock is persistent
> 
>               State : inactive
>     Working Devices : 3
> 
>       Delta Devices : 1, (-1->0)
>           New Level : raid5
>          New Layout : left-symmetric
>       New Chunksize : 512K
> 
>                Name : GRANDSLAM:480
>                UUID : 20211025:02005a7a:5a7abeef:cafebabe
>              Events : 78712
> 
>      Number   Major   Minor   RaidDevice
> 
>         -       8       65        -        /dev/sde1
>         -       8       49        -        /dev/sdd1
>         -       8       33        -        /dev/sdc1
> -sudo mdadm -I /dev/sdf1
> mdadm: /dev/sdf1 attached to /dev/md480, not enough to start (3).
> -sudo mdadm -D /dev/md480
> /dev/md480:
>             Version : 1.2
>          Raid Level : raid0
>       Total Devices : 4
>         Persistence : Superblock is persistent
> 
>               State : inactive
>     Working Devices : 4
> 
>       Delta Devices : 1, (-1->0)
>           New Level : raid5
>          New Layout : left-symmetric
>       New Chunksize : 512K
> 
>                Name : GRANDSLAM:480
>                UUID : 20211025:02005a7a:5a7abeef:cafebabe
>              Events : 78714
> 
>      Number   Major   Minor   RaidDevice
> 
>         -       8       81        -        /dev/sdf1
>         -       8       65        -        /dev/sde1
>         -       8       49        -        /dev/sdd1
>         -       8       33        -        /dev/sdc1
> -sudo mdadm -R /dev/md480
> mdadm: failed to start array /dev/md480: Input/output error
> ---
> NOTE: Of additional interest...
> ---
> -sudo mdadm -D /dev/md480
> /dev/md480:
>             Version : 1.2
>       Creation Time : Tue Oct 26 14:06:53 2021
>          Raid Level : raid5
>       Used Dev Size : 18446744073709551615
>        Raid Devices : 5
>       Total Devices : 3
>         Persistence : Superblock is persistent
> 
>         Update Time : Thu May  4 14:39:03 2023
>               State : active, FAILED, Not Started
>      Active Devices : 3
>     Working Devices : 3
>      Failed Devices : 0
>       Spare Devices : 0
> 
>              Layout : left-symmetric
>          Chunk Size : 512K
> 
> Consistency Policy : unknown
> 
>       Delta Devices : 1, (4->5)
> 
>                Name : GRANDSLAM:480
>                UUID : 20211025:02005a7a:5a7abeef:cafebabe
>              Events : 78714
> 
>      Number   Major   Minor   RaidDevice State
>         -       0        0        0      removed
>         -       0        0        1      removed
>         -       0        0        2      removed
>         -       0        0        3      removed
>         -       0        0        4      removed
> 
>         -       8       81        3      sync   /dev/sdf1
>         -       8       49        1      sync   /dev/sdd1
>         -       8       33        0      sync   /dev/sdc1

So the reason that this array can't start is that /dev/sde1 is not
recognized as RaidDevice 2, and there are two RaidDevice missing for
a raid5.

Sadly I have no idea to workaroud this, sb metadate seems to be broken.

Thanks,
Kuai
> 
> ---
> -watch -c -d -n 1 cat /proc/mdstat
> ---
> Every 1.0s: cat /proc/mdstat                                                     OAK2023: Mon May 22 01:48:24 2023
> 
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> md480 : inactive sdf1[4] sdd1[1] sdc1[0]
>        46877239294 blocks super 1.2
> 
> unused devices: <none>
> ---
> Hopeful that is some progress towards an array start? It's definately unexpected output to me.
> I/O Error starting md480
> 
> Thanks!
> SA
> 
> On Thu, 2023-05-18 at 11:15 +0800, Yu Kuai wrote:
> 
>> I have no idle why other disk shows that device 2 is missing, and what
>> is device 4.
>>
>> Anyway, can you try the following?
>>
>> mdadm -I /dev/sdc1
>> mdadm -D /dev/mdxxx
>>
>> mdadm -I /dev/sdd1
>> mdadm -D /dev/mdxxx
>>
>> mdadm -I /dev/sde1
>> mdadm -D /dev/mdxxx
>>
>> mdadm -I /dev/sdf1
>> mdadm -D /dev/mdxxx
>>
>> If above works well, you can try:
>>
>> mdadm -R /dev/mdxxx, and see if the array can be started.
>>
>> Thanks,
>> Kuai
> 
> 
> 
> 
> .
> 

