Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9485CA0FFF
	for <linux-raid@archiver.kernel.org>; Tue,  5 Sep 2023 16:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbjIEQDz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243986AbjIEBH5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Sep 2023 21:07:57 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E4C1B8
        for <linux-raid@vger.kernel.org>; Mon,  4 Sep 2023 18:07:49 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RfnRj1GRDz4f3mJ8
        for <linux-raid@vger.kernel.org>; Tue,  5 Sep 2023 09:07:45 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAH5KZdf_ZknyCPCQ--.57174S3;
        Tue, 05 Sep 2023 09:07:42 +0800 (CST)
Subject: Re: Reshape Failure
To:     Jason Moss <phate408@gmail.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org,
        "yangerkun@huawei.com" <yangerkun@huawei.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CA+w1tCeQw5STTQAEoTHTcpT4s_nT0zdgGSce6n-CT24BbNmukA@mail.gmail.com>
 <afb56bef-4547-d7f1-d3c2-730b7d7658f2@huaweicloud.com>
 <CA+w1tCeZmqreX_HRrsGRqq9-MmjNyo6VAt6sDEQgpS2R4=DxoA@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0ef44108-2a81-89df-c839-0c16d9499c29@huaweicloud.com>
Date:   Tue, 5 Sep 2023 09:07:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+w1tCeZmqreX_HRrsGRqq9-MmjNyo6VAt6sDEQgpS2R4=DxoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAH5KZdf_ZknyCPCQ--.57174S3
X-Coremail-Antispam: 1UD129KBjvAXoWfCF17ur1fGrW3Zr47JF47Arb_yoW5Ww48Wo
        ZI9w13C3Wrtry8uF95C3srGws7W3W5Cr48WryUW395Zanxta1UKa45Cr4DXrsxXFy0gr47
        Aas5Gw1YkFWjgwn3n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUYF7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xva
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
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbrMaU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/09/05 0:38, Jason Moss 写道:
> Hi Kuai,
> 
> Thank you for the suggestion, I was previously on 5.15.0. I've built
> an environment with 6.5.0.1 now and assembled the array there, but the
> same problem happens. It reshaped for 20-30 seconds, then completely
> stopped.
> 
> Processes and /proc/<PID>/stack output:
> root       24593  0.0  0.0      0     0 ?        I<   09:22   0:00 [raid5wq]
> root       24594 96.5  0.0      0     0 ?        R    09:22   2:29 [md0_raid6]
> root       24595  0.3  0.0      0     0 ?        D    09:22   0:00 [md0_reshape]
> 
> [root@arch ~]# cat /proc/24593/stack
> [<0>] rescuer_thread+0x2b0/0x3b0
> [<0>] kthread+0xe8/0x120
> [<0>] ret_from_fork+0x34/0x50
> [<0>] ret_from_fork_asm+0x1b/0x30
> 
> [root@arch ~]# cat /proc/24594/stack
> 
> [root@arch ~]# cat /proc/24595/stack
> [<0>] reshape_request+0x416/0x9f0 [raid456]
Can you provide the addr2line result? Let's see where reshape_request()
is stuck first.

Thanks,
Kuai

> [<0>] raid5_sync_request+0x2fc/0x3d0 [raid456]
> [<0>] md_do_sync+0x7d6/0x11d0 [md_mod]
> [<0>] md_thread+0xae/0x190 [md_mod]
> [<0>] kthread+0xe8/0x120
> [<0>] ret_from_fork+0x34/0x50
> [<0>] ret_from_fork_asm+0x1b/0x30
> 
> Please let me know if there's a better way to provide the stack info.
> 
> Thank you
> 
> On Sun, Sep 3, 2023 at 6:41 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/09/04 5:39, Jason Moss 写道:
>>> Hello,
>>>
>>> I recently attempted to add a new drive to my 8-drive RAID 6 array,
>>> growing it to 9 drives. I've done similar before with the same array,
>>> having previously grown it from 6 drives to 7 and then from 7 to 8
>>> with no issues. Drives are WD Reds, most older than 2019, some
>>> (including the newest) newer, but all confirmed CMR and not SMR.
>>>
>>> Process used to expand the array:
>>> mdadm --add /dev/md0 /dev/sdb1
>>> mdadm --grow --raid-devices=9 --backup-file=/root/grow_md0.bak /dev/md0
>>>
>>> The reshape started off fine, the process was underway, and the volume
>>> was still usable as expected. However, 15-30 minutes into the reshape,
>>> I lost access to the contents of the drive. Checking /proc/mdstat, the
>>> reshape was stopped at 0.6% with the counter not incrementing at all.
>>> Any process accessing the array would just hang until killed. I waited
>>
>> What kernel version are you using? And it'll be very helpful if you can
>> collect the stack of all stuck thread. There is a known deadlock for
>> raid5 related to reshape, and it's fixed in v6.5:
>>
>> https://lore.kernel.org/r/20230512015610.821290-6-yukuai1@huaweicloud.com
>>
>>> a half hour and there was still no further change to the counter. At
>>> this point, I restarted the server and found that when it came back up
>>> it would begin reshaping again, but only very briefly, under 30
>>> seconds, but the counter would be increasing during that time.
>>>
>>> I searched furiously for ideas and tried stopping and reassembling the
>>> array, assembling with an invalid-backup flag, echoing "frozen" then
>>> "reshape" to the sync_action file, and echoing "max" to the sync_max
>>> file. Nothing ever seemed to make a difference.
>>>
>>
>> Don't do this before v6.5, echo "reshape" while reshape is still in
>> progress will corrupt your data:
>>
>> https://lore.kernel.org/r/20230512015610.821290-3-yukuai1@huaweicloud.com
>>
>> Thanks,
>> Kuai
>>
>>> Here is where I slightly panicked, worried that I'd borked my array,
>>> and powered off the server again and disconnected the new drive that
>>> was just added, assuming that since it was the change, it may be the
>>> problem despite having burn-in tested it, and figuring that I'll rush
>>> order a new drive, so long as the reshape continues and I can just
>>> rebuild onto a new drive once the reshape finishes. However, this made
>>> no difference and the array continued to not rebuild.
>>>
>>> Much searching later, I'd found nothing substantially different then
>>> I'd already tried and one of the common threads in other people's
>>> issues was bad drives, so I ran a self-test against each of the
>>> existing drives and found one drive that failed the read test.
>>> Thinking I had the culprit now, I dropped that drive out of the array
>>> and assembled the array again, but the same behavior persists. The
>>> array reshapes very briefly, then completely stops.
>>>
>>> Down to 0 drives of redundancy (in the reshaped section at least), not
>>> finding any new ideas on any of the forums, mailing list, wiki, etc,
>>> and very frustrated, I took a break, bought all new drives to build a
>>> new array in another server and restored from a backup. However, there
>>> is still some data not captured by the most recent backup that I would
>>> like to recover, and I'd also like to solve the problem purely to
>>> understand what happened and how to recover in the future.
>>>
>>> Is there anything else I should try to recover this array, or is this
>>> a lost cause?
>>>
>>> Details requested by the wiki to follow and I'm happy to collect any
>>> further data that would assist. /dev/sdb is the new drive that was
>>> added, then disconnected. /dev/sdh is the drive that failed a
>>> self-test and was removed from the array.
>>>
>>> Thank you in advance for any help provided!
>>>
>>>
>>> $ uname -a
>>> Linux Blyth 5.15.0-76-generic #83-Ubuntu SMP Thu Jun 15 19:16:32 UTC
>>> 2023 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> $ mdadm --version
>>> mdadm - v4.2 - 2021-12-30
>>>
>>>
>>> $ sudo smartctl -H -i -l scterc /dev/sda
>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (local build)
>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Western Digital Red
>>> Device Model:     WDC WD30EFRX-68EUZN0
>>> Serial Number:    WD-WCC4N7AT7R7X
>>> LU WWN Device Id: 5 0014ee 268545f93
>>> Firmware Version: 82.00A82
>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>> Rotation Rate:    5400 rpm
>>> Device is:        In smartctl database [for details use: -P show]
>>> ATA Version is:   ACS-2 (minor revision not indicated)
>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
>>> Local Time is:    Sun Sep  3 13:27:55 2023 PDT
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>>
>>> === START OF READ SMART DATA SECTION ===
>>> SMART overall-health self-assessment test result: PASSED
>>>
>>> SCT Error Recovery Control:
>>>              Read:     70 (7.0 seconds)
>>>             Write:     70 (7.0 seconds)
>>>
>>> $ sudo smartctl -H -i -l scterc /dev/sda
>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (local build)
>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Western Digital Red
>>> Device Model:     WDC WD30EFRX-68EUZN0
>>> Serial Number:    WD-WCC4N7AT7R7X
>>> LU WWN Device Id: 5 0014ee 268545f93
>>> Firmware Version: 82.00A82
>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>> Rotation Rate:    5400 rpm
>>> Device is:        In smartctl database [for details use: -P show]
>>> ATA Version is:   ACS-2 (minor revision not indicated)
>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
>>> Local Time is:    Sun Sep  3 13:28:16 2023 PDT
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>>
>>> === START OF READ SMART DATA SECTION ===
>>> SMART overall-health self-assessment test result: PASSED
>>>
>>> SCT Error Recovery Control:
>>>              Read:     70 (7.0 seconds)
>>>             Write:     70 (7.0 seconds)
>>>
>>> $ sudo smartctl -H -i -l scterc /dev/sdb
>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (local build)
>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Western Digital Red
>>> Device Model:     WDC WD30EFRX-68EUZN0
>>> Serial Number:    WD-WXG1A8UGLS42
>>> LU WWN Device Id: 5 0014ee 2b75ef53b
>>> Firmware Version: 80.00A80
>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>> Rotation Rate:    5400 rpm
>>> Device is:        In smartctl database [for details use: -P show]
>>> ATA Version is:   ACS-2 (minor revision not indicated)
>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
>>> Local Time is:    Sun Sep  3 13:28:19 2023 PDT
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>>
>>> === START OF READ SMART DATA SECTION ===
>>> SMART overall-health self-assessment test result: PASSED
>>>
>>> SCT Error Recovery Control:
>>>              Read:     70 (7.0 seconds)
>>>             Write:     70 (7.0 seconds)
>>>
>>> $ sudo smartctl -H -i -l scterc /dev/sdc
>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (local build)
>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Western Digital Red
>>> Device Model:     WDC WD30EFRX-68EUZN0
>>> Serial Number:    WD-WCC4N4HYL32Y
>>> LU WWN Device Id: 5 0014ee 2630752f8
>>> Firmware Version: 82.00A82
>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>> Rotation Rate:    5400 rpm
>>> Device is:        In smartctl database [for details use: -P show]
>>> ATA Version is:   ACS-2 (minor revision not indicated)
>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
>>> Local Time is:    Sun Sep  3 13:28:20 2023 PDT
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>>
>>> === START OF READ SMART DATA SECTION ===
>>> SMART overall-health self-assessment test result: PASSED
>>>
>>> SCT Error Recovery Control:
>>>              Read:     70 (7.0 seconds)
>>>             Write:     70 (7.0 seconds)
>>>
>>> $ sudo smartctl -H -i -l scterc /dev/sdd
>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (local build)
>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Western Digital Red
>>> Device Model:     WDC WD30EFRX-68N32N0
>>> Serial Number:    WD-WCC7K1FF6DYK
>>> LU WWN Device Id: 5 0014ee 2ba952a30
>>> Firmware Version: 82.00A82
>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>> Rotation Rate:    5400 rpm
>>> Form Factor:      3.5 inches
>>> Device is:        In smartctl database [for details use: -P show]
>>> ATA Version is:   ACS-3 T13/2161-D revision 5
>>> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
>>> Local Time is:    Sun Sep  3 13:28:21 2023 PDT
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>>
>>> === START OF READ SMART DATA SECTION ===
>>> SMART overall-health self-assessment test result: PASSED
>>>
>>> SCT Error Recovery Control:
>>>              Read:     70 (7.0 seconds)
>>>             Write:     70 (7.0 seconds)
>>>
>>> $ sudo smartctl -H -i -l scterc /dev/sde
>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (local build)
>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Western Digital Red
>>> Device Model:     WDC WD30EFRX-68EUZN0
>>> Serial Number:    WD-WCC4N5ZHTRJF
>>> LU WWN Device Id: 5 0014ee 2b88b83bb
>>> Firmware Version: 82.00A82
>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>> Rotation Rate:    5400 rpm
>>> Device is:        In smartctl database [for details use: -P show]
>>> ATA Version is:   ACS-2 (minor revision not indicated)
>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
>>> Local Time is:    Sun Sep  3 13:28:22 2023 PDT
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>>
>>> === START OF READ SMART DATA SECTION ===
>>> SMART overall-health self-assessment test result: PASSED
>>>
>>> SCT Error Recovery Control:
>>>              Read:     70 (7.0 seconds)
>>>             Write:     70 (7.0 seconds)
>>>
>>> $ sudo smartctl -H -i -l scterc /dev/sdf
>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (local build)
>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Western Digital Red
>>> Device Model:     WDC WD30EFRX-68AX9N0
>>> Serial Number:    WD-WMC1T3804790
>>> LU WWN Device Id: 5 0014ee 6036b6826
>>> Firmware Version: 80.00A80
>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>> Device is:        In smartctl database [for details use: -P show]
>>> ATA Version is:   ACS-2 (minor revision not indicated)
>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
>>> Local Time is:    Sun Sep  3 13:28:23 2023 PDT
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>>
>>> === START OF READ SMART DATA SECTION ===
>>> SMART overall-health self-assessment test result: PASSED
>>>
>>> SCT Error Recovery Control:
>>>              Read:     70 (7.0 seconds)
>>>             Write:     70 (7.0 seconds)
>>>
>>> $ sudo smartctl -H -i -l scterc /dev/sdg
>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (local build)
>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Western Digital Red
>>> Device Model:     WDC WD30EFRX-68EUZN0
>>> Serial Number:    WD-WMC4N0H692Z9
>>> LU WWN Device Id: 5 0014ee 65af39740
>>> Firmware Version: 82.00A82
>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>> Rotation Rate:    5400 rpm
>>> Device is:        In smartctl database [for details use: -P show]
>>> ATA Version is:   ACS-2 (minor revision not indicated)
>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
>>> Local Time is:    Sun Sep  3 13:28:24 2023 PDT
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>>
>>> === START OF READ SMART DATA SECTION ===
>>> SMART overall-health self-assessment test result: PASSED
>>>
>>> SCT Error Recovery Control:
>>>              Read:     70 (7.0 seconds)
>>>             Write:     70 (7.0 seconds)
>>>
>>> $ sudo smartctl -H -i -l scterc /dev/sdh
>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (local build)
>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Western Digital Red
>>> Device Model:     WDC WD30EFRX-68EUZN0
>>> Serial Number:    WD-WMC4N0K5S750
>>> LU WWN Device Id: 5 0014ee 6b048d9ca
>>> Firmware Version: 82.00A82
>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>> Rotation Rate:    5400 rpm
>>> Device is:        In smartctl database [for details use: -P show]
>>> ATA Version is:   ACS-2 (minor revision not indicated)
>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
>>> Local Time is:    Sun Sep  3 13:28:24 2023 PDT
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>>
>>> === START OF READ SMART DATA SECTION ===
>>> SMART overall-health self-assessment test result: PASSED
>>>
>>> SCT Error Recovery Control:
>>>              Read:     70 (7.0 seconds)
>>>             Write:     70 (7.0 seconds)
>>>
>>> $ sudo smartctl -H -i -l scterc /dev/sdi
>>> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.15.0-76-generic] (local build)
>>> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
>>>
>>> === START OF INFORMATION SECTION ===
>>> Model Family:     Western Digital Red
>>> Device Model:     WDC WD30EFRX-68AX9N0
>>> Serial Number:    WD-WMC1T1502475
>>> LU WWN Device Id: 5 0014ee 058d2e5cb
>>> Firmware Version: 80.00A80
>>> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
>>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>>> Device is:        In smartctl database [for details use: -P show]
>>> ATA Version is:   ACS-2 (minor revision not indicated)
>>> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
>>> Local Time is:    Sun Sep  3 13:28:27 2023 PDT
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>>
>>> === START OF READ SMART DATA SECTION ===
>>> SMART overall-health self-assessment test result: PASSED
>>>
>>> SCT Error Recovery Control:
>>>              Read:     70 (7.0 seconds)
>>>             Write:     70 (7.0 seconds)
>>>
>>>
>>> $ sudo mdadm --examine /dev/sda
>>> /dev/sda:
>>>      MBR Magic : aa55
>>> Partition[0] :   4294967295 sectors at            1 (type ee)
>>> $ sudo mdadm --examine /dev/sda1
>>> /dev/sda1:
>>>             Magic : a92b4efc
>>>           Version : 1.2
>>>       Feature Map : 0xd
>>>        Array UUID : 440dc11e:079308b1:131eda79:9a74c670
>>>              Name : Blyth:0  (local to host Blyth)
>>>     Creation Time : Tue Aug  4 23:47:57 2015
>>>        Raid Level : raid6
>>>      Raid Devices : 9
>>>
>>>    Avail Dev Size : 5856376832 sectors (2.73 TiB 3.00 TB)
>>>        Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
>>>     Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
>>>       Data Offset : 247808 sectors
>>>      Super Offset : 8 sectors
>>>      Unused Space : before=247728 sectors, after=14336 sectors
>>>             State : clean
>>>       Device UUID : 8ca60ad5:60d19333:11b24820:91453532
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
>>>     Delta Devices : 1 (8->9)
>>>
>>>       Update Time : Tue Jul 11 23:12:08 2023
>>>     Bad Block Log : 512 entries available at offset 24 sectors - bad
>>> blocks present.
>>>          Checksum : b6d8f4d1 - correct
>>>            Events : 181105
>>>
>>>            Layout : left-symmetric
>>>        Chunk Size : 512K
>>>
>>>      Device Role : Active device 7
>>>      Array State : AA.AAAAA. ('A' == active, '.' == missing, 'R' == replacing)
>>>
>>> $ sudo mdadm --examine /dev/sdb
>>> /dev/sdb:
>>>      MBR Magic : aa55
>>> Partition[0] :   4294967295 sectors at            1 (type ee)
>>> $ sudo mdadm --examine /dev/sdb1
>>> /dev/sdb1:
>>>             Magic : a92b4efc
>>>           Version : 1.2
>>>       Feature Map : 0x5
>>>        Array UUID : 440dc11e:079308b1:131eda79:9a74c670
>>>              Name : Blyth:0  (local to host Blyth)
>>>     Creation Time : Tue Aug  4 23:47:57 2015
>>>        Raid Level : raid6
>>>      Raid Devices : 9
>>>
>>>    Avail Dev Size : 5856376832 sectors (2.73 TiB 3.00 TB)
>>>        Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
>>>     Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
>>>       Data Offset : 247808 sectors
>>>      Super Offset : 8 sectors
>>>      Unused Space : before=247728 sectors, after=14336 sectors
>>>             State : clean
>>>       Device UUID : 386d3001:16447e43:4d2a5459:85618d11
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Reshape pos'n : 124207104 (118.45 GiB 127.19 GB)
>>>     Delta Devices : 1 (8->9)
>>>
>>>       Update Time : Tue Jul 11 00:02:59 2023
>>>     Bad Block Log : 512 entries available at offset 24 sectors
>>>          Checksum : b544a39 - correct
>>>            Events : 181077
>>>
>>>            Layout : left-symmetric
>>>        Chunk Size : 512K
>>>
>>>      Device Role : Active device 8
>>>      Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
>>>
>>> $ sudo mdadm --examine /dev/sdc
>>> /dev/sdc:
>>>      MBR Magic : aa55
>>> Partition[0] :   4294967295 sectors at            1 (type ee)
>>> $ sudo mdadm --examine /dev/sdc1
>>> /dev/sdc1:
>>>             Magic : a92b4efc
>>>           Version : 1.2
>>>       Feature Map : 0xd
>>>        Array UUID : 440dc11e:079308b1:131eda79:9a74c670
>>>              Name : Blyth:0  (local to host Blyth)
>>>     Creation Time : Tue Aug  4 23:47:57 2015
>>>        Raid Level : raid6
>>>      Raid Devices : 9
>>>
>>>    Avail Dev Size : 5856376832 sectors (2.73 TiB 3.00 TB)
>>>        Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
>>>     Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
>>>       Data Offset : 247808 sectors
>>>      Super Offset : 8 sectors
>>>      Unused Space : before=247720 sectors, after=14336 sectors
>>>             State : clean
>>>       Device UUID : 1798ec4f:72c56905:4e74ea61:2468db75
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
>>>     Delta Devices : 1 (8->9)
>>>
>>>       Update Time : Tue Jul 11 23:12:08 2023
>>>     Bad Block Log : 512 entries available at offset 72 sectors - bad
>>> blocks present.
>>>          Checksum : 88d8b8fc - correct
>>>            Events : 181105
>>>
>>>            Layout : left-symmetric
>>>        Chunk Size : 512K
>>>
>>>      Device Role : Active device 4
>>>      Array State : AA.AAAAA. ('A' == active, '.' == missing, 'R' == replacing)
>>>
>>> $ sudo mdadm --examine /dev/sdd
>>> /dev/sdd:
>>>      MBR Magic : aa55
>>> Partition[0] :   4294967295 sectors at            1 (type ee)
>>> $ sudo mdadm --examine /dev/sdd1
>>> /dev/sdd1:
>>>             Magic : a92b4efc
>>>           Version : 1.2
>>>       Feature Map : 0x5
>>>        Array UUID : 440dc11e:079308b1:131eda79:9a74c670
>>>              Name : Blyth:0  (local to host Blyth)
>>>     Creation Time : Tue Aug  4 23:47:57 2015
>>>        Raid Level : raid6
>>>      Raid Devices : 9
>>>
>>>    Avail Dev Size : 5856376832 sectors (2.73 TiB 3.00 TB)
>>>        Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
>>>     Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
>>>       Data Offset : 247808 sectors
>>>      Super Offset : 8 sectors
>>>      Unused Space : before=247728 sectors, after=14336 sectors
>>>             State : clean
>>>       Device UUID : a198095b:f54d26a9:deb3be8f:d6de9be1
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
>>>     Delta Devices : 1 (8->9)
>>>
>>>       Update Time : Tue Jul 11 23:12:08 2023
>>>     Bad Block Log : 512 entries available at offset 24 sectors
>>>          Checksum : d1471d9d - correct
>>>            Events : 181105
>>>
>>>            Layout : left-symmetric
>>>        Chunk Size : 512K
>>>
>>>      Device Role : Active device 6
>>>      Array State : AA.AAAAA. ('A' == active, '.' == missing, 'R' == replacing)
>>>
>>> $ sudo mdadm --examine /dev/sde
>>> /dev/sde:
>>>      MBR Magic : aa55
>>> Partition[0] :   4294967295 sectors at            1 (type ee)
>>> $ sudo mdadm --examine /dev/sde1
>>> /dev/sde1:
>>>             Magic : a92b4efc
>>>           Version : 1.2
>>>       Feature Map : 0x5
>>>        Array UUID : 440dc11e:079308b1:131eda79:9a74c670
>>>              Name : Blyth:0  (local to host Blyth)
>>>     Creation Time : Tue Aug  4 23:47:57 2015
>>>        Raid Level : raid6
>>>      Raid Devices : 9
>>>
>>>    Avail Dev Size : 5856376832 sectors (2.73 TiB 3.00 TB)
>>>        Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
>>>     Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
>>>       Data Offset : 247808 sectors
>>>      Super Offset : 8 sectors
>>>      Unused Space : before=247720 sectors, after=14336 sectors
>>>             State : clean
>>>       Device UUID : acf7ba2e:35d2fa91:6b12b0ce:33a73af5
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
>>>     Delta Devices : 1 (8->9)
>>>
>>>       Update Time : Tue Jul 11 23:12:08 2023
>>>     Bad Block Log : 512 entries available at offset 72 sectors
>>>          Checksum : e05d0278 - correct
>>>            Events : 181105
>>>
>>>            Layout : left-symmetric
>>>        Chunk Size : 512K
>>>
>>>      Device Role : Active device 5
>>>      Array State : AA.AAAAA. ('A' == active, '.' == missing, 'R' == replacing)
>>>
>>> $ sudo mdadm --examine /dev/sdf
>>> /dev/sdf:
>>>      MBR Magic : aa55
>>> Partition[0] :   4294967295 sectors at            1 (type ee)
>>> $ sudo mdadm --examine /dev/sdf1
>>> /dev/sdf1:
>>>             Magic : a92b4efc
>>>           Version : 1.2
>>>       Feature Map : 0x5
>>>        Array UUID : 440dc11e:079308b1:131eda79:9a74c670
>>>              Name : Blyth:0  (local to host Blyth)
>>>     Creation Time : Tue Aug  4 23:47:57 2015
>>>        Raid Level : raid6
>>>      Raid Devices : 9
>>>
>>>    Avail Dev Size : 5856373760 sectors (2.73 TiB 3.00 TB)
>>>        Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
>>>     Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
>>>       Data Offset : 247808 sectors
>>>      Super Offset : 8 sectors
>>>      Unused Space : before=247720 sectors, after=14336 sectors
>>>             State : clean
>>>       Device UUID : 31e7b86d:c274ff45:aa6dab50:2ff058c6
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
>>>     Delta Devices : 1 (8->9)
>>>
>>>       Update Time : Tue Jul 11 23:12:08 2023
>>>     Bad Block Log : 512 entries available at offset 72 sectors
>>>          Checksum : 26792cc0 - correct
>>>            Events : 181105
>>>
>>>            Layout : left-symmetric
>>>        Chunk Size : 512K
>>>
>>>      Device Role : Active device 0
>>>      Array State : AA.AAAAA. ('A' == active, '.' == missing, 'R' == replacing)
>>>
>>> $ sudo mdadm --examine /dev/sdg
>>> /dev/sdg:
>>>      MBR Magic : aa55
>>> Partition[0] :   4294967295 sectors at            1 (type ee)
>>> $ sudo mdadm --examine /dev/sdg1
>>> /dev/sdg1:
>>>             Magic : a92b4efc
>>>           Version : 1.2
>>>       Feature Map : 0x5
>>>        Array UUID : 440dc11e:079308b1:131eda79:9a74c670
>>>              Name : Blyth:0  (local to host Blyth)
>>>     Creation Time : Tue Aug  4 23:47:57 2015
>>>        Raid Level : raid6
>>>      Raid Devices : 9
>>>
>>>    Avail Dev Size : 5856373760 sectors (2.73 TiB 3.00 TB)
>>>        Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
>>>     Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
>>>       Data Offset : 247808 sectors
>>>      Super Offset : 8 sectors
>>>      Unused Space : before=247720 sectors, after=14336 sectors
>>>             State : clean
>>>       Device UUID : 74476ce7:4edc23f6:08120711:ba281425
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
>>>     Delta Devices : 1 (8->9)
>>>
>>>       Update Time : Tue Jul 11 23:12:08 2023
>>>     Bad Block Log : 512 entries available at offset 72 sectors
>>>          Checksum : 6f67d179 - correct
>>>            Events : 181105
>>>
>>>            Layout : left-symmetric
>>>        Chunk Size : 512K
>>>
>>>      Device Role : Active device 1
>>>      Array State : AA.AAAAA. ('A' == active, '.' == missing, 'R' == replacing)
>>>
>>> $ sudo mdadm --examine /dev/sdh
>>> /dev/sdh:
>>>      MBR Magic : aa55
>>> Partition[0] :   4294967295 sectors at            1 (type ee)
>>> $ sudo mdadm --examine /dev/sdh1
>>> /dev/sdh1:
>>>             Magic : a92b4efc
>>>           Version : 1.2
>>>       Feature Map : 0xd
>>>        Array UUID : 440dc11e:079308b1:131eda79:9a74c670
>>>              Name : Blyth:0  (local to host Blyth)
>>>     Creation Time : Tue Aug  4 23:47:57 2015
>>>        Raid Level : raid6
>>>      Raid Devices : 9
>>>
>>>    Avail Dev Size : 5856373760 sectors (2.73 TiB 3.00 TB)
>>>        Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
>>>     Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
>>>       Data Offset : 247808 sectors
>>>      Super Offset : 8 sectors
>>>      Unused Space : before=247720 sectors, after=14336 sectors
>>>             State : clean
>>>       Device UUID : 31c08263:b135f0f5:763bc86b:f81d7296
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Reshape pos'n : 124207104 (118.45 GiB 127.19 GB)
>>>     Delta Devices : 1 (8->9)
>>>
>>>       Update Time : Tue Jul 11 20:09:14 2023
>>>     Bad Block Log : 512 entries available at offset 72 sectors - bad
>>> blocks present.
>>>          Checksum : b7696b68 - correct
>>>            Events : 181089
>>>
>>>            Layout : left-symmetric
>>>        Chunk Size : 512K
>>>
>>>      Device Role : Active device 2
>>>      Array State : AAAAAAAA. ('A' == active, '.' == missing, 'R' == replacing)
>>>
>>> $ sudo mdadm --examine /dev/sdi
>>> /dev/sdi:
>>>      MBR Magic : aa55
>>> Partition[0] :   4294967295 sectors at            1 (type ee)
>>> $ sudo mdadm --examine /dev/sdi1
>>> /dev/sdi1:
>>>             Magic : a92b4efc
>>>           Version : 1.2
>>>       Feature Map : 0x5
>>>        Array UUID : 440dc11e:079308b1:131eda79:9a74c670
>>>              Name : Blyth:0  (local to host Blyth)
>>>     Creation Time : Tue Aug  4 23:47:57 2015
>>>        Raid Level : raid6
>>>      Raid Devices : 9
>>>
>>>    Avail Dev Size : 5856373760 sectors (2.73 TiB 3.00 TB)
>>>        Array Size : 20497268736 KiB (19.09 TiB 20.99 TB)
>>>     Used Dev Size : 5856362496 sectors (2.73 TiB 3.00 TB)
>>>       Data Offset : 247808 sectors
>>>      Super Offset : 8 sectors
>>>      Unused Space : before=247720 sectors, after=14336 sectors
>>>             State : clean
>>>       Device UUID : ac1063fc:d9d66e6d:f3de33da:b396f483
>>>
>>> Internal Bitmap : 8 sectors from superblock
>>>     Reshape pos'n : 124311040 (118.55 GiB 127.29 GB)
>>>     Delta Devices : 1 (8->9)
>>>
>>>       Update Time : Tue Jul 11 23:12:08 2023
>>>     Bad Block Log : 512 entries available at offset 72 sectors
>>>          Checksum : 23b6d024 - correct
>>>            Events : 181105
>>>
>>>            Layout : left-symmetric
>>>        Chunk Size : 512K
>>>
>>>      Device Role : Active device 3
>>>      Array State : AA.AAAAA. ('A' == active, '.' == missing, 'R' == replacing)
>>>
>>> $ sudo mdadm --detail /dev/md0
>>> /dev/md0:
>>>              Version : 1.2
>>>           Raid Level : raid6
>>>        Total Devices : 9
>>>          Persistence : Superblock is persistent
>>>
>>>                State : inactive
>>>      Working Devices : 9
>>>
>>>        Delta Devices : 1, (-1->0)
>>>            New Level : raid6
>>>           New Layout : left-symmetric
>>>        New Chunksize : 512K
>>>
>>>                 Name : Blyth:0  (local to host Blyth)
>>>                 UUID : 440dc11e:079308b1:131eda79:9a74c670
>>>               Events : 181105
>>>
>>>       Number   Major   Minor   RaidDevice
>>>
>>>          -       8        1        -        /dev/sda1
>>>          -       8      129        -        /dev/sdi1
>>>          -       8      113        -        /dev/sdh1
>>>          -       8       97        -        /dev/sdg1
>>>          -       8       81        -        /dev/sdf1
>>>          -       8       65        -        /dev/sde1
>>>          -       8       49        -        /dev/sdd1
>>>          -       8       33        -        /dev/sdc1
>>>          -       8       17        -        /dev/sdb1
>>>
>>> $ cat /proc/mdstat
>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>>> [raid4] [raid10]
>>> md0 : inactive sdb1[9](S) sdi1[4](S) sdf1[0](S) sdg1[1](S) sdh1[3](S)
>>> sda1[8](S) sdd1[7](S) sdc1[6](S) sde1[5](S)
>>>         26353689600 blocks super 1.2
>>>
>>> unused devices: <none>
>>>
>>> .
>>>
>>
> 
> .
> 

