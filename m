Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9636ACA0FF8
	for <linux-raid@archiver.kernel.org>; Sat,  2 Sep 2023 06:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351644AbjIBGN3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Sep 2023 02:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjIBGN1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Sep 2023 02:13:27 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D938710F5
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 23:13:23 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rd4Mg2Q2Lz4f3jZj
        for <linux-raid@vger.kernel.org>; Sat,  2 Sep 2023 14:13:19 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgA3x6l+0vJkoMipCA--.63774S3;
        Sat, 02 Sep 2023 14:13:19 +0800 (CST)
Subject: Re: raid10, far layout initial sync slow + XFS question
To:     CoolCold <coolthecold@gmail.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>,
        "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
 <7a10a252-46be-4921-7a68-59b2e0dca570@huaweicloud.com>
 <CAGqmV7opNzLp+Zbp__bS0ctQQ2M2tPSe_W1vBWXghFpwCFrcUA@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7e920033-be0b-ef0b-a1b7-6c9611b339a0@huaweicloud.com>
Date:   Sat, 2 Sep 2023 14:13:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGqmV7opNzLp+Zbp__bS0ctQQ2M2tPSe_W1vBWXghFpwCFrcUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgA3x6l+0vJkoMipCA--.63774S3
X-Coremail-Antispam: 1UD129KBjvJXoWxurW5uF4kZr1kCryxXr4ktFb_yoW5GFWxpa
        48XFyUKr18XFyrJ3yqyw1rG3WSy3s5WrW3ur98try8u397KF95G3WUCr45CrZ8Zrn5Cr4j
        q34ktFW3Za4YkaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUywZ7UUU
        UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/09/02 14:07, CoolCold 写道:
> Good day!
> No, no other activities happened during initial sync - at least I have
> not done anything. In iostat it were only read operations as well.
> 
I think this is because resync is different for raid1 and raid10,

In raid1, just read from one rdev and write to the other rdev.

In raid10, resync must read from all rdev first, and then compare and
write if contents is different, it is obvious that raid10 will be slower
if contents is different. However, I do feel this behavior is strange,
because contents is likely different in initial sync.

Thanks,
Kuai

> 
> On Sat, 2 Sept 2023, 10:57 Yu Kuai, <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/09/02 4:23, CoolCold 写道:
>>> Good day!
>>>
>>> I have 4 NVMe new drives which are planned to replace 2 current NVMe
>>> drives, serving primarily as MYSQL storage, Hetzner dedicated server
>>> AX161 if it matters. Drives are SAMSUNG MZQL23T8HCLS-00A07, 3.8TB .
>>> System - Ubuntu 20.04 / 5.4.0-153-generic #170-Ubuntu
>>>
>>> So the strange thing I do observe, is its initial raid sync speed.
>>> Created with:
>>> mdadm --create /dev/md3 --run -b none --level=10 --layout=f2
>>> --chunk=16 --raid-devices=4 /dev/nvme0n1 /dev/nvme4n1 /dev/nvme3n1
>>> /dev/nvme5n1
>>>
>>> sync speed:
>>>
>>> md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
>>>         7501212288 blocks super 1.2 16K chunks 2 far-copies [4/4] [UUUU]
>>>         [=>...................]  resync =  6.2% (466905632/7501212288)
>>> finish=207.7min speed=564418K/sec
>>>
>> Is there any read/write to the array? Because for raid10, normal io
>> can't concurrent with sync io, brandwidth will be bad if they both exit,
>> specially for old kernels.
>>
>> Thanks,
>> Kuai
>>
>>> If I try to create RAID1 with just two drives - sync speed is around
>>> 3.2GByte per second, sysclt is tuned of course:
>>> dev.raid.speed_limit_max = 8000000
>>>
>>> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
>>> [raid4] [raid10]
>>> md70 : active raid1 nvme4n1[1] nvme5n1[0]
>>>         3750606144 blocks super 1.2 [2/2] [UU]
>>>         [>....................]  resync =  1.5% (58270272/3750606144)
>>> finish=19.0min speed=3237244K/sec
>>>
>>> >From iostat, drives are basically doing just READs, no writes.
>>> Quick tests with fio, mounting single drive shows it can do around 30k
>>> IOPS with 16kb ( fio --rw=write --ioengine=sync --fdatasync=1
>>> --directory=test-data --size=8200m --bs=16k --name=mytest ) so likely
>>> issue are not drives themselves.
>>>
>>> Not sure where to look further, please advise.
>>>
>>
> 
> .
> 

