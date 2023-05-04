Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C990C77B78
	for <linux-raid@archiver.kernel.org>; Thu,  4 May 2023 01:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjEDB5p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 May 2023 21:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjEDB5o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 May 2023 21:57:44 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765E8FB
        for <linux-raid@vger.kernel.org>; Wed,  3 May 2023 18:57:41 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QBcQM6dnwz4f3nQc
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 09:57:31 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3X7MMEVNkvdvZIg--.2618S3;
        Thu, 04 May 2023 09:57:33 +0800 (CST)
Subject: Re: linux mdadm assembly error: md: cannot handle concurrent
 replacement and reshape. (reboot while reshaping)
To:     Peter Neuwirth <reddunur@online.de>,
        Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <23052452-30bf-4391-76f3-14ab8ff2014c@online.de>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <91f30db4-9f2b-732b-cea7-b8196c80004c@huaweicloud.com>
Date:   Thu, 4 May 2023 09:57:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <23052452-30bf-4391-76f3-14ab8ff2014c@online.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3X7MMEVNkvdvZIg--.2618S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JF47trW3ArWkWF4DurWxWFg_yoWfCF1kpr
        n3J3W3GryUGw18Jr1Utr1UJryUJr1UJw1UJr45XFy8Jr1UAr12qr4UXr10grWUJrWrJr1U
        Jw1UJryUZr1UGr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
        Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU5WlkUU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/05/02 19:30, Peter Neuwirth 写道:
> Hello Kuai,
> 
> thank you for your suggestion!
> It is true, as I read the source of error message in drivers/md/raid5.c,
> I saw that growing and replacement is to much to handle.
> So I did what you suggested and started the raid 5 (that was in a
> raid 6 transformation with addition of two more drives) with only the
> 5 members, that should run a degraded raid 5.
> 
> mdadm --assemble --run   /dev/md0 /dev/sdd /dev/sdc /dev/sdb /dev/sdi 
> /dev/sdj
> 
> this worked and it was assembled.
> 
> 
> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] 
> [raid1] [raid10]
> md0 : active (auto-read-only) raid6 sdd[0] sdi[6] sdj[4] sdb[2] sdc[1]
>       4883151360 blocks super 1.2 level 6, 256k chunk, algorithm 18 
> [7/5] [UUU_UU_]
>       bitmap: 0/8 pages [0KB], 65536KB chunk
> 
> unused devices: <none>
> 
> mdadm --detail /dev/md0
> /dev/md0:
>            Version : 1.2
>      Creation Time : Mon Mar  6 18:17:30 2023
>         Raid Level : raid6
>         Array Size : 4883151360 (4656.94 GiB 5000.35 GB)
>      Used Dev Size : 976630272 (931.39 GiB 1000.07 GB)
>       Raid Devices : 7
>      Total Devices : 5
>        Persistence : Superblock is persistent
> 
>      Intent Bitmap : Internal
> 
>        Update Time : Fri Apr 28 04:21:03 2023
>              State : clean, degraded
>     Active Devices : 5
>    Working Devices : 5
>     Failed Devices : 0
>      Spare Devices : 0
> 
>             Layout : left-symmetric-6
>         Chunk Size : 256K
> 
> Consistency Policy : bitmap
> 
>         New Layout : left-symmetric
> 
>               Name : solidsrv11:0  (local to host solidsrv11)
>               UUID : 1a87479e:7513dd65:37c61ca1:43184f65
>             Events : 6336
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       48        0      active sync   /dev/sdd
>        1       8       32        1      active sync   /dev/sdc
>        2       8       16        2      active sync   /dev/sdb
>        -       0        0        3      removed
>        4       8      144        4      active sync   /dev/sdj
>        6       8      128        5      active sync   /dev/sdi
>        -       0        0        6      removed
> 
> 
> 
> But when I try to mount it as xfs fs:
> 
> mount: /mnt/image: mount(2) system call failed: Structure needs cleaning.
> 
> When I try to repair the xfs fs, it tells me, that there was no superblock
> found..

Sorry to hear that, it seems like data is corrupted already, and this
really is a kernel issue that somehow replacement（resync?) and reshape
is messed. And I suspect that reboot while reshape is in progress and
replacement exist can trigger this...

I have no idea for now, but I'll try to repoduce this problem and fix
it.

Thanks,
Kuai
> 
> xfs_repair -n /dev/md0
> Phase 1 - find and verify superblock...
> couldn't verify primary superblock - not enough secondary superblocks 
> with matching geometry !!!
> 
> attempting to find secondary superblock...
> .................found candidate secondary superblock...
> unable to verify superblock, continuing...
> .found candidate secondary superblock...
> unable to verify superblock, continuing...
> 
> ...
> 
> .found candidate secondary superblock...
> unable to verify superblock, continuing...
> .found candidate secondary superblock...
> unable to verify superblock, continuing...
> ...........................................
> 
> Sadly I do not exactly understand, what happens in the grow+replacement 
> phase,
> where all evil begun. As I could see, the two added hard disk drives 
> still have their old
> partition table, so I suppose, the rebuild process was still in moving 
> the raid 5 geometry
> to a raid-5-to-6 transient geometry. I'm not sure if in this process, 
> raid 5 promise (1 drive
> may fail) still holds. However, the two additional drives were treated 
> as spare since
> this moment after reboot. And one drive of the prior riad5, now raid6 
> seems to be defect.
> 
> Is it possible that the process restart somehow scrambled some raidset 
> informations and
> messed up my raid level striping in continued growth process ? then the 
> still mounted device
> crashed and disappeared from mounts. And from this point on, there was 
> no way to reconstruct
> the messed raidset informations and striping?
> 
> This whole matter with striped data, transient raid geometries, 
> expansion and growth
> processing, etc. seems so complex and intransparent to me, that I start 
> to consider
> my data on this raidset as lost :(
> 
> For any tools and suggestions helping to save at least parts of the data 
> on the
> raid, I would be very happy.
> 
> regards,
> 
> Peter
> 
> 
> 
> Am 28.04.23 um 04:01 schrieb Yu Kuai:
>> Hi,
>>
>> 在 2023/04/28 5:09, Peter Neuwirth 写道:
>>>
>>> ------------------------------------------------------------------------------------------------------------------------ 
>>>
>>> Some Logs:
>>> ------------------------------------------------------------------------------------------------------------------------ 
>>>
>>>
>>> uname -a ; mdadm --version
>>> Linux srv11 5.10.0-21-amd64 #1 SMP Debian 5.10.162-1 (2023-01-21) 
>>> x86_64 GNU/Linux
>>> mdadm - v4.1 - 2018-10-01
>>>
>>> srv11:~# mdadm -D /dev/md0
>>> /dev/md0:
>>>             Version : 1.2
>>>       Creation Time : Mon Mar  6 18:17:30 2023
>>>          Raid Level : raid6
>>>       Used Dev Size : 976630272 (931.39 GiB 1000.07 GB)
>>>        Raid Devices : 7
>>>       Total Devices : 6
>>>         Persistence : Superblock is persistent
>>>
>>>         Update Time : Thu Apr 27 17:36:15 2023
>>>               State : active, FAILED, Not Started
>>>      Active Devices : 5
>>>     Working Devices : 6
>>>      Failed Devices : 0
>>>       Spare Devices : 1
>>>
>>>              Layout : left-symmetric-6
>>>          Chunk Size : 256K
>>>
>>> Consistency Policy : unknown
>>>
>>>          New Layout : left-symmetric
>>>
>>>                Name : solidsrv11:0  (local to host solidsrv11)
>>>                UUID : 1a87479e:7513dd65:37c61ca1:43184f65
>>>              Events : 4700
>>>
>>>      Number   Major   Minor   RaidDevice State
>>>         -       0        0        0      removed
>>>         -       0        0        1      removed
>>>         -       0        0        2      removed
>>>         -       0        0        3      removed
>>>         -       0        0        4      removed
>>>         -       0        0        5      removed
>>>         -       0        0        6      removed
>>>
>>>         -       8       32        2      sync   /dev/sdc
>>>         -       8      144        4      sync   /dev/sdj
>>>         -       8       80        0      sync   /dev/sdf
>>>         -       8       16        1      sync   /dev/sdb
>>>         -       8      128        5      sync   /dev/sdi
>>>         -       8       96        4      spare rebuilding /dev/sdg
>>
>> Looks like the /dev/sdg is not the original device, above log shows that
>> RaidDevice 3 is missing, and /dev/sdg is replacement of /dev/sdj.
>>
>> So reshapge is still in progress, and somehow sdg is the replacement of
>> sdj, this matches the condition in raid5_run:
>>
>> 7952                 if 
>> (rcu_access_pointer(conf->disks[i].replacement) &&
>> 7953                     conf->reshape_progress != MaxSector) {
>> 7954                         /* replacements and reshape simply do not 
>> mix. */
>> 7955                         pr_warn("md: cannot handle concurrent 
>> replacement and reshape.\n");
>> 7956                         goto abort;
>> 7957                 }
>>
>> I'm by no means raid5 expert but I will suggest to remove /dev/sdg and
>> try again to assemble.
>>
>> Thanks,
>> Kuai
>>
> 
> 
> .
> 

