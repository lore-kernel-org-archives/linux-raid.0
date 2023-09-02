Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C41BCA0FE7
	for <linux-raid@archiver.kernel.org>; Sat,  2 Sep 2023 03:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjIBD5H (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 23:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjIBD5G (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 23:57:06 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938EA1704
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 20:57:02 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rd1LK3MkCz4f3lgC
        for <linux-raid@vger.kernel.org>; Sat,  2 Sep 2023 11:56:57 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgA3xqiJsvJk49mhCA--.16762S3;
        Sat, 02 Sep 2023 11:56:58 +0800 (CST)
Subject: Re: raid10, far layout initial sync slow + XFS question
To:     CoolCold <coolthecold@gmail.com>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
Cc:     "yukuai (C)" <yukuai3@huawei.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7a10a252-46be-4921-7a68-59b2e0dca570@huaweicloud.com>
Date:   Sat, 2 Sep 2023 11:56:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgA3xqiJsvJk49mhCA--.16762S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WF48uF48XrWUuFWxWw4DArb_yoW8Cr1kpa
        y8JFy5Ar18JFy0y3yDt3WrW3WxC3s8urW3Cr98tryxZ3yfJF9xJ3WUCrs8KrZxZrn5Cr42
        q34kJFy5uFy3KrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
        k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/09/02 4:23, CoolCold 写道:
> Good day!
> 
> I have 4 NVMe new drives which are planned to replace 2 current NVMe
> drives, serving primarily as MYSQL storage, Hetzner dedicated server
> AX161 if it matters. Drives are SAMSUNG MZQL23T8HCLS-00A07, 3.8TB .
> System - Ubuntu 20.04 / 5.4.0-153-generic #170-Ubuntu
> 
> So the strange thing I do observe, is its initial raid sync speed.
> Created with:
> mdadm --create /dev/md3 --run -b none --level=10 --layout=f2
> --chunk=16 --raid-devices=4 /dev/nvme0n1 /dev/nvme4n1 /dev/nvme3n1
> /dev/nvme5n1
> 
> sync speed:
> 
> md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
>        7501212288 blocks super 1.2 16K chunks 2 far-copies [4/4] [UUUU]
>        [=>...................]  resync =  6.2% (466905632/7501212288)
> finish=207.7min speed=564418K/sec
> 
Is there any read/write to the array? Because for raid10, normal io
can't concurrent with sync io, brandwidth will be bad if they both exit,
specially for old kernels.

Thanks,
Kuai

> If I try to create RAID1 with just two drives - sync speed is around
> 3.2GByte per second, sysclt is tuned of course:
> dev.raid.speed_limit_max = 8000000
> 
> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
> [raid4] [raid10]
> md70 : active raid1 nvme4n1[1] nvme5n1[0]
>        3750606144 blocks super 1.2 [2/2] [UU]
>        [>....................]  resync =  1.5% (58270272/3750606144)
> finish=19.0min speed=3237244K/sec
> 
>>From iostat, drives are basically doing just READs, no writes.
> Quick tests with fio, mounting single drive shows it can do around 30k
> IOPS with 16kb ( fio --rw=write --ioengine=sync --fdatasync=1
> --directory=test-data --size=8200m --bs=16k --name=mytest ) so likely
> issue are not drives themselves.
> 
> Not sure where to look further, please advise.
> 

