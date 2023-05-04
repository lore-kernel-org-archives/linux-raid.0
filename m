Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA547C77B7F
	for <linux-raid@archiver.kernel.org>; Thu,  4 May 2023 02:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjEDCKy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 May 2023 22:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjEDCKw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 May 2023 22:10:52 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E974135
        for <linux-raid@vger.kernel.org>; Wed,  3 May 2023 19:10:50 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QBcjf3hz8z4f3tqY
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 10:10:46 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP3 (Coremail) with SMTP id _Ch0CgCHZQMmFFNkWLAOIA--.64571S3;
        Thu, 04 May 2023 10:10:47 +0800 (CST)
Subject: Re: linux mdadm assembly error: md: cannot handle concurrent
 replacement and reshape. (reboot while reshaping)
To:     Yu Kuai <yukuai1@huaweicloud.com>,
        Peter Neuwirth <reddunur@online.de>,
        linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <23052452-30bf-4391-76f3-14ab8ff2014c@online.de>
 <91f30db4-9f2b-732b-cea7-b8196c80004c@huaweicloud.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <237b2b96-647f-5503-32eb-6f0b528ae72c@huaweicloud.com>
Date:   Thu, 4 May 2023 10:10:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <91f30db4-9f2b-732b-cea7-b8196c80004c@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgCHZQMmFFNkWLAOIA--.64571S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZw15Aw1ftryxJry5WFW8tFb_yoWrAFykpr
        1kt3W5CryUGw1ktryUCr1jqa4UJry8Xa1UJr1UJFy7Ar45Jr12qr4UXr1jgr1UJr4rJF1U
        Jr1UJry3Zr1UGF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
        JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUozVbDU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/05/04 9:57, Yu Kuai 写道:
> Hi,
> 
> 在 2023/05/02 19:30, Peter Neuwirth 写道:
>> Hello Kuai,
>>
>> thank you for your suggestion!
>> It is true, as I read the source of error message in drivers/md/raid5.c,
>> I saw that growing and replacement is to much to handle.
>> So I did what you suggested and started the raid 5 (that was in a
>> raid 6 transformation with addition of two more drives) with only the
>> 5 members, that should run a degraded raid 5.
>>
>> mdadm --assemble --run   /dev/md0 /dev/sdd /dev/sdc /dev/sdb /dev/sdi 
>> /dev/sdj
>>
>> this worked and it was assembled.
>>
>>
>> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] 
>> [raid1] [raid10]
>> md0 : active (auto-read-only) raid6 sdd[0] sdi[6] sdj[4] sdb[2] sdc[1]
>>       4883151360 blocks super 1.2 level 6, 256k chunk, algorithm 18 
>> [7/5] [UUU_UU_]
>>       bitmap: 0/8 pages [0KB], 65536KB chunk
>>
>> unused devices: <none>
>>
>> mdadm --detail /dev/md0
>> /dev/md0:
>>            Version : 1.2
>>      Creation Time : Mon Mar  6 18:17:30 2023
>>         Raid Level : raid6
>>         Array Size : 4883151360 (4656.94 GiB 5000.35 GB)
>>      Used Dev Size : 976630272 (931.39 GiB 1000.07 GB)
>>       Raid Devices : 7
>>      Total Devices : 5
>>        Persistence : Superblock is persistent
>>
>>      Intent Bitmap : Internal
>>
>>        Update Time : Fri Apr 28 04:21:03 2023
>>              State : clean, degraded
>>     Active Devices : 5
>>    Working Devices : 5
>>     Failed Devices : 0
>>      Spare Devices : 0
>>
>>             Layout : left-symmetric-6
>>         Chunk Size : 256K
>>
>> Consistency Policy : bitmap
>>
>>         New Layout : left-symmetric
>>
>>               Name : solidsrv11:0  (local to host solidsrv11)
>>               UUID : 1a87479e:7513dd65:37c61ca1:43184f65
>>             Events : 6336
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       48        0      active sync   /dev/sdd
>>        1       8       32        1      active sync   /dev/sdc
>>        2       8       16        2      active sync   /dev/sdb
>>        -       0        0        3      removed
>>        4       8      144        4      active sync   /dev/sdj
>>        6       8      128        5      active sync   /dev/sdi
>>        -       0        0        6      removed
>>
>>
>>
>> But when I try to mount it as xfs fs:
>>
>> mount: /mnt/image: mount(2) system call failed: Structure needs cleaning.
>>
>> When I try to repair the xfs fs, it tells me, that there was no 
>> superblock
>> found..
> 
> Sorry to hear that, it seems like data is corrupted already, and this
> really is a kernel issue that somehow replacement（resync?) and reshape
> is messed. And I suspect that reboot while reshape is in progress and
> replacement exist can trigger this...
> 
> I have no idea for now, but I'll try to repoduce this problem and fix
> it.

Hi,

I can reporduce this based on the steps you described:

mdadm --assemble --run /dev/md0 /dev/sd[abcdefgh] will fail:
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error

kernel will complain:
[  186.133231] md: cannot handle concurrent replacement and reshape.
[  186.179587] md/raid:md0: failed to run raid set.
[  186.180851] md: pers->run() failed ...

mdadm -D shows:
  Number   Major   Minor   RaidDevice State
     -       0        0        0      removed
     -       0        0        1      removed
     -       0        0        2      removed
     -       0        0        3      removed
     -       0        0        4      removed
     -       0        0        5      removed
     -       0        0        6      removed

     -       8       64        4      sync   /dev/sde
     -       8       32        2      sync   /dev/sdc
     -       8        0        0      sync   /dev/sda
     -       8      112        6      spare rebuilding   /dev/sdh
     -       8       80        5      sync   /dev/sdf
     -       8       48        3      sync   /dev/sdd
     -       8       16        1      sync   /dev/sdb
     -       8       96        0      spare rebuilding   /dev/sdg

I'll try to come up with a solution.

Thanks,
Kuai

