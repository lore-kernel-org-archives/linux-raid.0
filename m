Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519BEC4167B
	for <linux-raid@archiver.kernel.org>; Thu,  9 Nov 2023 01:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjKIBJf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Nov 2023 20:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjKIBJf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Nov 2023 20:09:35 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A0B258F
        for <linux-raid@vger.kernel.org>; Wed,  8 Nov 2023 17:09:32 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.235])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SQkPf078fz4f3kp6
        for <linux-raid@vger.kernel.org>; Thu,  9 Nov 2023 09:09:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
        by mail.maildlp.com (Postfix) with ESMTP id 5B9BF1A016D
        for <linux-raid@vger.kernel.org>; Thu,  9 Nov 2023 09:09:28 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP1 (Coremail) with SMTP id cCh0CgDHyhBGMUxlwACrAQ--.6168S3;
        Thu, 09 Nov 2023 09:09:28 +0800 (CST)
Subject: Re: RAID1 possible data corruption following a write failure to
 superblock
To:     Yaron Presente <yaron.presente@zadara.com>,
        linux-raid@vger.kernel.org
Cc:     Lev Vainblat <lev@zadara.com>,
        Shyam Kaushik <shyam.kaushik@zadara.com>,
        Alex Lyakas <alex@zadara.com>,
        Yaron Presente <yaron@zadara.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CAH4CUCMS-FBH7mgKUGEwMMjMWQx3ZNDfAAKABbx5dA7XbUREMg@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <80b2a590-75b5-b7ef-fc69-b2cf259634b2@huaweicloud.com>
Date:   Thu, 9 Nov 2023 09:09:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAH4CUCMS-FBH7mgKUGEwMMjMWQx3ZNDfAAKABbx5dA7XbUREMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgDHyhBGMUxlwACrAQ--.6168S3
X-Coremail-Antispam: 1UD129KBjvJXoWfGry5ZF18ZryDWr4kJr18Zrb_yoWDuF43pr
        47CFs5GrWkAw47t3s2kw4rGa4UXFWqya15Gry5WrnYk3s0y3ZrJ3WkXr4I9rZ5Xrn3CF9x
        WFW0q392yws8JaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/11/08 23:33, Yaron Presente 写道:
> Hi All,
> While investigating data corruption that occurred on one of our
> systems, we came across a theoretical RAID1 scenario which we thought
> could be problematic (detail follow below).
> In order to create the scenario we used a VM installed with Ubuntu
> Mantic 23.10 (kernel 6.5.0), configured with a RAID1 on top of 2 iSCSi
> drives that were exported from a second VM.
> On the latter VM we ran a proprietary device mapper on top of the
> drives which allowed us to inject errors at the exact timing that we
> wanted. This is the flow:
> 0. 'zero' a specific block using dd (direct) on top of the raid1. read
> it to make sure that the block was indeed zeroed out
> 1. Issue a 'write' on top of the RAID1 device (using 'dd' direct of random data)
> 2. Allow 'write' to the 2nd leg to succeed, but fail 'write' to the
> 1st leg. Then fail also 'write' to the Superblock of both legs so that
> the events counters (on both drives) are not updated

What exactly did you do to inject error, and what cat 
/sys/block/md0/md/rd*/bad_blocks shows?

Thanks,
Kuai

> 3. 'dd' returns with a success (although at this point the RAID cannot
> tell which leg is more updated)
> 4. Stop the raid device and then re-assemble it, and let it re-sync
> 5. Read the same offset, it reads zeros (as it sync'ed from the wrong
> drive - in the case of matching event counters always from the 1st to
> the 2nd ).
> 
> Indeed, there are 2 concurrent failures (of different drives) in this
> scenario. However, we still think that once returning 'ok' to a user
> write operation, it is an unexpected behavior of the RAID1 to return
> bad data.
> Regards,
> Yaron
> 
> 
> Issue reproduction on kernel 6.5.0 (Ubuntu Mantic 23.10):
> 
> root@mantic:~# uname -a
> Linux mantic 6.5.0-10-generic #10-Ubuntu SMP PREEMPT_DYNAMIC Fri Oct
> 13 13:49:38 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
> 
> 1. Create md raid1 with 2 legs:
> root@mantic:~# mdadm --create --verbose /dev/md0 --level=1
> --raid-devices=2 /dev/sdb /dev/sdc
> mdadm: array /dev/md0 started.
> 
> 2. Write zeros to md0.
> root@mantic:~# dd if=/dev/zero bs=512 count=1 seek=1000 oflag=direct of=/dev/md0
> 1+0 records in
> 1+0 records out
> 512 bytes copied, 0.00271111 s, 189 kB/s
> 
> 3. Read from md0 – read zeros, as expected
> root@mantic:~# dd if=/dev/md0 iflag=direct bs=512 count=1 skip=1000
> 2>/dev/null | hexdump –C
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000200
> 
> 4. Enable error injection on the target
> 
> 5. Write some random data to md0. Only data write to /dev/sdc
> succeeded, data write to /dev/sdb and all superblock updates failed.
> root@mantic:~# dd if=/dev/urandom bs=512 count=1 seek=1000
> oflag=direct of=/dev/md0
> 1+0 records in
> 1+0 records out
> 512 bytes copied, 1.94887 s, 0.3 kB/s
> root@mantic:~# echo $?
> 0
> 
> root@mantic:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid1 sdb[0](F) sdc[1]
>        31744 blocks super 1.2 [2/1] [_U]
> 
> root@mantic:~# tail -F /var/log/kern.log
> Nov  7 16:01:24.559661 mantic kernel: [ 6443.216430] sd 2:0:0:0: [sdb]
> tag#81 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> Nov  7 16:01:24.559688 mantic kernel: [ 6443.216455] sd 2:0:0:0: [sdb]
> tag#81 Sense Key : Medium Error [current]
> Nov  7 16:01:24.559689 mantic kernel: [ 6443.216458] sd 2:0:0:0: [sdb]
> tag#81 Add. Sense: Peripheral device write fault
> Nov  7 16:01:24.559689 mantic kernel: [ 6443.216462] sd 2:0:0:0: [sdb]
> tag#81 CDB: Write(10) 2a 00 00 00 0b e8 00 00 01 00
> Nov  7 16:01:24.559690 mantic kernel: [ 6443.216465] I/O error, dev
> sdb, sector 3048 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 2
> Nov  7 16:01:25.069779 mantic kernel: [ 6443.726477] sd 2:0:0:0: [sdb]
> tag#87 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> Nov  7 16:01:25.069805 mantic kernel: [ 6443.726495] sd 2:0:0:0: [sdb]
> tag#87 Sense Key : Medium Error [current]
> Nov  7 16:01:25.069806 mantic kernel: [ 6443.726498] sd 2:0:0:0: [sdb]
> tag#87 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.069807 mantic kernel: [ 6443.726502] sd 2:0:0:0: [sdb]
> tag#87 CDB: Write(10) 2a 00 00 00 0b e8 00 00 01 00
> Nov  7 16:01:25.069808 mantic kernel: [ 6443.726504] I/O error, dev
> sdb, sector 3048 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 2
> Nov  7 16:01:25.153362 mantic kernel: [ 6443.808395] sd 2:0:0:1: [sdc]
> tag#83 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> Nov  7 16:01:25.153367 mantic kernel: [ 6443.808401] sd 2:0:0:1: [sdc]
> tag#83 Sense Key : Medium Error [current]
> Nov  7 16:01:25.153368 mantic kernel: [ 6443.808404] sd 2:0:0:1: [sdc]
> tag#83 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.153368 mantic kernel: [ 6443.808406] sd 2:0:0:1: [sdc]
> tag#83 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> Nov  7 16:01:25.153369 mantic kernel: [ 6443.808411] I/O error, dev
> sdc, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
> Nov  7 16:01:25.153370 mantic kernel: [ 6443.808459] md: super_written
> gets error=-5
> Nov  7 16:01:25.153377 mantic kernel: [ 6443.808480] md/raid1:md0:
> Disk failure on sdc, disabling device.
> Nov  7 16:01:25.153378 mantic kernel: [ 6443.808480] md/raid1:md0:
> Operation continuing on 1 devices.
> Nov  7 16:01:25.157324 mantic kernel: [ 6443.812155] sd 2:0:0:0: [sdb]
> tag#84 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> Nov  7 16:01:25.157334 mantic kernel: [ 6443.812160] sd 2:0:0:0: [sdb]
> tag#84 Sense Key : Medium Error [current]
> Nov  7 16:01:25.157335 mantic kernel: [ 6443.812162] sd 2:0:0:0: [sdb]
> tag#84 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.157336 mantic kernel: [ 6443.812164] sd 2:0:0:0: [sdb]
> tag#84 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> Nov  7 16:01:25.157336 mantic kernel: [ 6443.812169] I/O error, dev
> sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
> Nov  7 16:01:25.157337 mantic kernel: [ 6443.812193] md: super_written
> gets error=-5
> Nov  7 16:01:25.235620 mantic kernel: [ 6443.892311] sd 2:0:0:0: [sdb]
> tag#90 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> Nov  7 16:01:25.235634 mantic kernel: [ 6443.892330] sd 2:0:0:0: [sdb]
> tag#90 Sense Key : Medium Error [current]
> Nov  7 16:01:25.235635 mantic kernel: [ 6443.892333] sd 2:0:0:0: [sdb]
> tag#90 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.235635 mantic kernel: [ 6443.892336] sd 2:0:0:0: [sdb]
> tag#90 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> Nov  7 16:01:25.235636 mantic kernel: [ 6443.892341] I/O error, dev
> sdb, sector 24 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
> Nov  7 16:01:25.235637 mantic kernel: [ 6443.892366] md: super_written
> gets error=-5
> Nov  7 16:01:25.319616 mantic kernel: [ 6443.976317] sd 2:0:0:0: [sdb]
> tag#80 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> Nov  7 16:01:25.319635 mantic kernel: [ 6443.976336] sd 2:0:0:0: [sdb]
> tag#80 Sense Key : Medium Error [current]
> Nov  7 16:01:25.319637 mantic kernel: [ 6443.976341] sd 2:0:0:0: [sdb]
> tag#80 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.319638 mantic kernel: [ 6443.976346] sd 2:0:0:0: [sdb]
> tag#80 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> Nov  7 16:01:25.319639 mantic kernel: [ 6443.976353] I/O error, dev
> sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
> Nov  7 16:01:25.319640 mantic kernel: [ 6443.976404] md: super_written
> gets error=-5
> Nov  7 16:01:25.414605 mantic kernel: [ 6444.068218] sd 2:0:0:0: [sdb]
> tag#86 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> Nov  7 16:01:25.414621 mantic kernel: [ 6444.068235] sd 2:0:0:0: [sdb]
> tag#86 Sense Key : Medium Error [current]
> Nov  7 16:01:25.414623 mantic kernel: [ 6444.068240] sd 2:0:0:0: [sdb]
> tag#86 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.414624 mantic kernel: [ 6444.068245] sd 2:0:0:0: [sdb]
> tag#86 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> Nov  7 16:01:25.414625 mantic kernel: [ 6444.068252] I/O error, dev
> sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
> Nov  7 16:01:25.414626 mantic kernel: [ 6444.068320] md: super_written
> gets error=-5
> Nov  7 16:01:25.915709 mantic kernel: [ 6444.572401] sd 2:0:0:0: [sdb]
> tag#84 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> Nov  7 16:01:25.915732 mantic kernel: [ 6444.572423] sd 2:0:0:0: [sdb]
> tag#84 Sense Key : Medium Error [current]
> Nov  7 16:01:25.915733 mantic kernel: [ 6444.572427] sd 2:0:0:0: [sdb]
> tag#84 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.915733 mantic kernel: [ 6444.572430] sd 2:0:0:0: [sdb]
> tag#84 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> Nov  7 16:01:25.915734 mantic kernel: [ 6444.572448] I/O error, dev
> sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
> Nov  7 16:01:25.915735 mantic kernel: [ 6444.572495] md: super_written
> gets error=-5
> 
> 6. Disable error injection on the target
> 
> 7. Reassemble md raid1
> root@mantic:~# mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
> 
> root@mantic:~# mdadm --verbose --assemble /dev/md0 /dev/sdb /dev/sdc
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
> mdadm: added /dev/sdc to /dev/md0 as 1
> mdadm: added /dev/sdb to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 2 drives.
> 
> root@mantic:~# tail -F /var/log/kern.log
> Nov  7 16:06:27.073412 mantic kernel: [ 6745.728446] md: md0 stopped.
> Nov  7 16:06:27.085369 mantic kernel: [ 6745.740822] md/raid1:md0: not
> clean -- starting background reconstruction
> Nov  7 16:06:27.085382 mantic kernel: [ 6745.740827] md/raid1:md0:
> active with 2 out of 2 mirrors
> Nov  7 16:06:27.085384 mantic kernel: [ 6745.740842] md0: detected
> capacity change from 0 to 63488
> Nov  7 16:06:27.089518 mantic kernel: [ 6745.742959] md: resync of
> RAID array md0
> Nov  7 16:06:27.365351 mantic kernel: [ 6746.019437] md: md0: resync done.
> 
> 8. Read from md0 – read zeros, although previously write random data succeeded
> root@mantic:~# dd if=/dev/md0 iflag=direct bs=512 count=1 skip=1000
> 2>/dev/null | hexdump –C
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000200
> 
> .
> 

