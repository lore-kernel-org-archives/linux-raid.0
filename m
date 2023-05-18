Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C753EC77B7A
	for <linux-raid@archiver.kernel.org>; Thu, 18 May 2023 03:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjERDQU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 May 2023 23:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjERDQK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 May 2023 23:16:10 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2BB3A9A
        for <linux-raid@vger.kernel.org>; Wed, 17 May 2023 20:15:57 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QMFVK0qSkz4f3jHm
        for <linux-raid@vger.kernel.org>; Thu, 18 May 2023 11:15:53 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBn0LNnmGVk6B+0Jg--.16430S3;
        Thu, 18 May 2023 11:15:53 +0800 (CST)
Subject: Re: RAID5 Phantom Drive Appeared while Reshaping Four Drive Array
 (HARDLOCK)
To:     Wol <antlists@youngman.org.uk>, raid@electrons.cloud,
        linux-raid@vger.kernel.org
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <60563747e11acd6757b20ba19006fcdcff5df519.camel@electrons.cloud>
 <96524acc-504d-6a07-85a0-0b56a9e2f2d7@youngman.org.uk>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9b22d5ce-5f1b-0fc8-acdc-02c2e8cefa55@huaweicloud.com>
Date:   Thu, 18 May 2023 11:15:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <96524acc-504d-6a07-85a0-0b56a9e2f2d7@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBn0LNnmGVk6B+0Jg--.16430S3
X-Coremail-Antispam: 1UD129KBjvAXoWfJF48Jry3JFW7WFW3KFy5CFg_yoW8JF47Wo
        WUKw13Cr4rXF4DKr1UJF1UJr13Gw1UGrnFqr1UGr13Jr1kJr1jy348GryUX3y7Jry8Gr18
        Aa4Utr15AFyUAr1rn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUYw7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
        j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
        x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
        Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
        xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CE
        bIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
        DUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/05/18 7:45, Wol 写道:
> Hmmm. Firstly, what command did you give to grow the array?
> 
> Secondly, take a look at the thread "Raid5 to raid6 grow interrupted, 
> mdadm hangs on assemble command". There's a problem there with rebuilds 
> locking up, which is not fatal, and will be fixed, but might not have 
> rippled through yet ...
> 
> That raid0 thing is almost certainly nothing to be worried about - it 
> seems to be normal for any array that doesn't assemble completely.
> 
> The only things that bother me slightly are I believe mdadm 4.2 has been 
> released? Don't quote me on that. And scterc is disabled by default? Weird.
> 
> I've cc'd a few people who I hope can help further ...

Hi, please cc yukuai3@huawei.com for me, huaweicloud email is just for
send, I don't receive emails from this...
> 
> Cheers,
> Wol
> 
> On 17/05/2023 14:26, raid wrote:
>> RAID5 Phantom Drive Appeared while Reshaping Four Drive Array
>> (HARDLOCK)
>>
>> I've been struggling with this for about two weeks now, realizing that
>> I need some expert help.
>>
>> My original 18 month old RAID5 consists of three newer TOSHIBA drives.
>> /dev/sdc :: TOSHIBA MG08ACA16TE (4303) :: 16 TB (16,000,900,661,248
>> bytes)
>> /dev/sdd :: TOSHIBA MG08ACA16TE (4303) :: 16 TB (16,000,900,661,248
>> bytes)
>> /dev/sde :: TOSHIBA MG08ACA16TE (4002) :: 16 TB (16,000,900,661,248
>> bytes)
>>
>> Recently added...
>> /dev/sdf :: TOSHIBA MG08ACA16TE (4303) :: 16 TB (16,000,900,661,248
>> bytes)
>>
>> In a nutshell, I've added a fourth drive to my RAID5 and executed --
>> grow & mdadm estimated completion in 3-5 days.
>> At about 30-50% of reshaping, the computer hard locked. Pushing the
>> reset button was the agonizing requirement.
>>
>> After first reboot mdadm assembled & continued. But it displayed a
>> fifth physical disk.
>> The phantom FIFTH drive appeared as failed, while the other four
>> continued reshaping, temporarily.
>> The reshaping speed dropped to 0 after another day or so. It was near
>> 80%, I think.
>> So, I used mdadm -S then mdadm --assemble --scan it couldn't start
>> (because phantom drive?) not enough
>> drives to start the array. The Array State on each member shows the
>> fifth drive with varying status.
>>
>> File system (ext4) appears damaged and won't mount. Unrecognized
>> filesystem.
>> 20TB are backed up, there are, however, about 7000 newly scanned
>> documents that aren't.
>> I've done a cursory examination of data using R-Linux. Abit of in depth
>> peeking using Active Disk Editor.
>>
>> Life goes on. I've researched and read way more than I ever thought I
>> would about mdadm RAID.
>> Not any closer on how to proceed. I'm a hardware technician with some
>> software skills. I'm stumped.
>> Also trying to be cautious not to damage whats left of the RAID. ANY
>> help with what commands
>> I can attempt to at least get the RAID to assemble WITHOUT the phantom
>> fifth drive would be
>> immensely appreciated.
>>
>> All four drives now appear as spares.
>>
>> ---
>> watch -c -d -n 1 cat /proc/mdstat
>> md480 : inactive sdc1[0](S) sdd1[1](S) sdf1[4](S) sde1[3](S)
>>        62502985709 blocks super 1.2
>> ---
>> uname -a
>> Linux OAK2023 4.19.0-24-amd64 #1 SMP Debian 4.19.282-1 (2023-04-29)
>> x86_64 GNU/Linux
>> ---
>> mdadm --version
>> mdadm - v4.1 - 2018-10-01
>> ---
>> mdadm -E /dev/sd[c-f]1
>> /dev/sdc1:
>>            Magic : a92b4efc
>>          Version : 1.2
>>      Feature Map : 0x45
>>       Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
>>             Name : GRANDSLAM:480
>>    Creation Time : Tue Oct 26 14:06:53 2021
>>       Raid Level : raid5
>>     Raid Devices : 5
>>
>>   Avail Dev Size : 31251492831 (14901.87 GiB 16000.76 GB)
>>       Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
>>    Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
>>      Data Offset : 264192 sectors
>>       New Offset : 261120 sectors
>>     Super Offset : 8 sectors
>>            State : clean
>>      Device UUID : 8f0835db:3ea24540:2ab4232d:6203d1b7
>>
>> Internal Bitmap : 8 sectors from superblock
>>    Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
>>    Delta Devices : 1 (4->5)
>>
>>      Update Time : Thu May  4 14:39:03 2023
>>    Bad Block Log : 512 entries available at offset 72 sectors
>>         Checksum : 37ac3c04 - correct
>>           Events : 78714
>>
>>           Layout : left-symmetric
>>       Chunk Size : 512K
>>
>>     Device Role : Active device 0
>>     Array State : AA.A. ('A' == active, '.' == missing, 'R' ==
>> replacing)
>> /dev/sdd1:
>>            Magic : a92b4efc
>>          Version : 1.2
>>      Feature Map : 0x45
>>       Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
>>             Name : GRANDSLAM:480
>>    Creation Time : Tue Oct 26 14:06:53 2021
>>       Raid Level : raid5
>>     Raid Devices : 5
>>
>>   Avail Dev Size : 31251492831 (14901.87 GiB 16000.76 GB)
>>       Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
>>    Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
>>      Data Offset : 264192 sectors
>>       New Offset : 261120 sectors
>>     Super Offset : 8 sectors
>>            State : clean
>>      Device UUID : b4660f49:867b9f1e:ecad0ace:c7119c37
>>
>> Internal Bitmap : 8 sectors from superblock
>>    Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
>>    Delta Devices : 1 (4->5)
>>
>>      Update Time : Thu May  4 14:39:03 2023
>>    Bad Block Log : 512 entries available at offset 72 sectors
>>         Checksum : a4927b98 - correct
>>           Events : 78714
>>
>>           Layout : left-symmetric
>>       Chunk Size : 512K
>>
>>     Device Role : Active device 1
>>     Array State : AA.A. ('A' == active, '.' == missing, 'R' ==
>> replacing)
>> /dev/sde1:
>>            Magic : a92b4efc
>>          Version : 1.2
>>      Feature Map : 0x45
>>       Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
>>             Name : GRANDSLAM:480
>>    Creation Time : Tue Oct 26 14:06:53 2021
>>       Raid Level : raid5
>>     Raid Devices : 5
>>
>>   Avail Dev Size : 31251492831 (14901.87 GiB 16000.76 GB)
>>       Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
>>    Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
>>      Data Offset : 264192 sectors
>>       New Offset : 261120 sectors
>>     Super Offset : 8 sectors
>>            State : clean
>>      Device UUID : 79a3dff4:c53f9071:f9c1c262:403fbc10
>>
>> Internal Bitmap : 8 sectors from superblock
>>    Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
>>    Delta Devices : 1 (4->5)
>>
>>      Update Time : Thu May  4 14:38:38 2023
>>    Bad Block Log : 512 entries available at offset 72 sectors
>>         Checksum : 112fbe09 - correct
>>           Events : 78712
>>
>>           Layout : left-symmetric
>>       Chunk Size : 512K
>>
>>     Device Role : Active device 2
>>     Array State : AAAA. ('A' == active, '.' == missing, 'R' ==
>> replacing)

I have no idle why other disk shows that device 2 is missing, and what
is device 4.

Anyway, can you try the following?

mdadm -I /dev/sdc1
mdadm -D /dev/mdxxx

mdadm -I /dev/sdd1
mdadm -D /dev/mdxxx

mdadm -I /dev/sde1
mdadm -D /dev/mdxxx

mdadm -I /dev/sdf1
mdadm -D /dev/mdxxx

If above works well, you can try:

mdadm -R /dev/mdxxx, and see if the array can be started.

Thanks,
Kuai
>> /dev/sdf1:
>>            Magic : a92b4efc
>>          Version : 1.2
>>      Feature Map : 0x45
>>       Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
>>             Name : GRANDSLAM:480
>>    Creation Time : Tue Oct 26 14:06:53 2021
>>       Raid Level : raid5
>>     Raid Devices : 5
>>
>>   Avail Dev Size : 31251492926 (14901.87 GiB 16000.76 GB)
>>       Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
>>    Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
>>      Data Offset : 264192 sectors
>>       New Offset : 261120 sectors
>>     Super Offset : 8 sectors
>>            State : clean
>>      Device UUID : 9d9c1c0d:030844a7:f365ace6:5e568930
>>
>> Internal Bitmap : 8 sectors from superblock
>>    Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
>>    Delta Devices : 1 (4->5)
>>
>>      Update Time : Thu May  4 14:39:03 2023
>>    Bad Block Log : 512 entries available at offset 72 sectors
>>         Checksum : 2d33aff - correct
>>           Events : 78714
>>
>>           Layout : left-symmetric
>>       Chunk Size : 512K
>>
>>     Device Role : Active device 3
>>     Array State : AA.A. ('A' == active, '.' == missing, 'R' ==
>> replacing)
>> ---
>> mdadm -E /dev/sd[c-f]1 | grep -E '^/dev/sd|Update'
>> /dev/sdc1:
>>      Update Time : Thu May  4 14:39:03 2023
>> /dev/sdd1:
>>      Update Time : Thu May  4 14:39:03 2023
>> /dev/sde1:
>>      Update Time : Thu May  4 14:38:38 2023
>> /dev/sdf1:
>>      Update Time : Thu May  4 14:39:03 2023
>> ---
>> mdadm --assemble --scan
>> mdadm: /dev/md/GRANDSLAM:480 assembled from 3 drives - not enough to
>> start the array.
>> ---
>> /etc/mdadm/mdadm.conf
>> # This configuration was auto-generated on Tue, 26 Oct 2021 12:52:33
>> -0500 by mkconf
>> ARRAY /dev/md480 metadata=1.2 name=GRANDSLAM:480
>> UUID=20211025:02005a7a:5a7abeef:cafebabe
>> ---
>>
>> NOTE: Raid Level is now shown below to be raid0. This is a RAID5.
>>        Delta Devices are munged?
>>
>> NOW;mdadm -D /dev/md480
>>   2023.05.17 02:44:06 AM
>> /dev/md480:
>>             Version : 1.2
>>          Raid Level : raid0
>>       Total Devices : 4
>>         Persistence : Superblock is persistent
>>
>>               State : inactive
>>     Working Devices : 4
>>
>>       Delta Devices : 1, (-1->0)
>>           New Level : raid5
>>          New Layout : left-symmetric
>>       New Chunksize : 512K
>>
>>                Name : GRANDSLAM:480
>>                UUID : 20211025:02005a7a:5a7abeef:cafebabe
>>              Events : 78714
>>
>>      Number   Major   Minor   RaidDevice
>>
>>         -       8       81        -        /dev/sdf1
>>         -       8       65        -        /dev/sde1
>>         -       8       49        -        /dev/sdd1
>>         -       8       33        -        /dev/sdc1
>> ---
>>
>> NOTE: The HITACHI MG08ACA16TE drives default to DISABLED
>>        I've since enabled the setting if this helps.
>>
>> smartctl -l scterc /dev/sdc; smartctl -l scterc /dev/sdd; smartctl -l
>> scterc /dev/sde; smartctl -l scterc /dev/sdf
>>
>> smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
>> build)
>> Copyright (C) 2002-17, Bruce Allen, Christian Franke,
>> www.smartmontools.org
>>
>> SCT Error Recovery Control:
>>             Read:     70 (7.0 seconds)
>>            Write:     70 (7.0 seconds)
>>
>> smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
>> build)
>> Copyright (C) 2002-17, Bruce Allen, Christian Franke,
>> www.smartmontools.org
>>
>> SCT Error Recovery Control:
>>             Read:     70 (7.0 seconds)
>>            Write:     70 (7.0 seconds)
>>
>> smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
>> build)
>> Copyright (C) 2002-17, Bruce Allen, Christian Franke,
>> www.smartmontools.org
>>
>> SCT Error Recovery Control:
>>             Read:     70 (7.0 seconds)
>>            Write:     70 (7.0 seconds)
>>
>> smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
>> build)
>> Copyright (C) 2002-17, Bruce Allen, Christian Franke,
>> www.smartmontools.org
>>
>> SCT Error Recovery Control:
>>             Read:     70 (7.0 seconds)
>>            Write:     70 (7.0 seconds)
>>
>> ---
>>
>> Exhausted and maybe I'm just looking for someone to suggest running the
>> command that I really don't want to run yet.
>>
>> Enabling Loss Of Confusion flag hasn't worked either.
>>
> 
> .
> 

