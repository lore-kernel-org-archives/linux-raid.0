Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62F9C47074
	for <linux-raid@archiver.kernel.org>; Wed, 15 Nov 2023 07:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbjKOHPg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Nov 2023 02:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjKOHPf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Nov 2023 02:15:35 -0500
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C8CE9
        for <linux-raid@vger.kernel.org>; Tue, 14 Nov 2023 23:15:29 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.216])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SVZF62bkQz4f3l0y
        for <linux-raid@vger.kernel.org>; Wed, 15 Nov 2023 15:15:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
        by mail.maildlp.com (Postfix) with ESMTP id 650BF1A0181
        for <linux-raid@vger.kernel.org>; Wed, 15 Nov 2023 15:15:26 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP1 (Coremail) with SMTP id cCh0CgDX2xEMcFRlJJzkAw--.4042S3;
        Wed, 15 Nov 2023 15:15:26 +0800 (CST)
Subject: Re: RAID1 possible data corruption following a write failure to
 superblock
To:     lev.vainblat@zadara.com, 'Yu Kuai' <yukuai1@huaweicloud.com>,
        linux-raid@vger.kernel.org
Cc:     'Lev Vainblat' <lev@zadara.com>,
        'Shyam Kaushik' <shyam.kaushik@zadara.com>,
        'Alex Lyakas' <alex@zadara.com>,
        'Yaron Presente' <yaron@zadara.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CAH4CUCMS-FBH7mgKUGEwMMjMWQx3ZNDfAAKABbx5dA7XbUREMg@mail.gmail.com>
 <80b2a590-75b5-b7ef-fc69-b2cf259634b2@huaweicloud.com>
 <028001da1304$b9a97b60$2cfc7220$@zadarastorage.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d1672286-0965-70d5-dd76-8775afa6c756@huaweicloud.com>
Date:   Wed, 15 Nov 2023 15:15:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <028001da1304$b9a97b60$2cfc7220$@zadarastorage.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgDX2xEMcFRlJJzkAw--.4042S3
X-Coremail-Antispam: 1UD129KBjvAXoW3KFy7Zr1kGF4kCr45Xr17trb_yoW8XF48uo
        W5AF42gr4rKF1kCwn0k3W8WrZ3Jr1ayF1xXr45Xr4jgan0q3ZFywnrKFy8u39Yvr1j9a1a
        vryfG393t3WFqrn7n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUYF7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
        j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
        x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
        Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
        xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CE
        bIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/11/09 20:03, Lev Vainblat 写道:
> Hi Kuai,
> 
> On the target side we have a proprietary device mapper that fails write to
> sector 3048 on leg 0 and allows write to sector 3048 on leg1 (matching to
> the sector 1000 at md). After the 1st write to sector 3048, it fails all
> subsequent writes (to any address) to the same device.

Sorry for the delay, I didn't check inbox of huaweicloud.com...

So, superblock update is disabled, and badblocks never writen to disk,
this looks like remove a disk, issue a write and then readd the removed
disk, the difference is that you stop the array and reassemble. Can you
please try to hot remove disk 0 and then readd it?

Thanks,
Kuai
> 
> 
> This is the status of bad_blocks after we write some data to the md device:
> 
> root@mantic:~# dd if=/dev/urandom bs=512 count=1 seek=1000 oflag=direct of=/dev/md0
> 1+0 records in
> 1+0 records out
> 512 bytes copied, 1.9608 s, 0.3 kB/s
> 
> root@mantic:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> md0 : active raid1 sdb[0] sdc[1](F)
>        31744 blocks super 1.2 [2/1] [U_]
>        
> root@mantic:~# ls -l /sys/block/md0/md/rd*
> lrwxrwxrwx 1 root root 0 Nov  9 10:58 /sys/block/md0/md/rd0 -> dev-sdb
> 
> root@mantic:~# cat /sys/block/md0/md/rd0/bad_blocks
> 3048 1
> 
> 
> If we assemble md with option --update=no-bbl, we're able read the recently written
> data, that will "disappear" after reassemble:
> 
> root@mantic:~# mdadm --verbose --verbose --assemble --update=no-bbl /dev/md0 /dev/sdb /dev/sdc
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
> mdadm: added /dev/sdc to /dev/md0 as 1
> mdadm: added /dev/sdb to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 2 drives.
> 
> root@mantic:~# dd if=/dev/urandom bs=512 count=1 seek=1000 oflag=direct of=/dev/md0
> 1+0 records in
> 1+0 records out
> 512 bytes copied, 1.70216 s, 0.3 kB/s
> 
> root@mantic:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> md0 : active raid1 sdb[0](F) sdc[1]
>        31744 blocks super 1.2 [2/1] [_U]
> 	
> root@mantic:~# cat /sys/block/md0/md/rd1/bad_blocks
> root@mantic:~#
> 
> root@mantic:~# dd if=/dev/md0 iflag=direct bs=512 count=1 skip=1000 | hexdump -C | head
> 1+0 records in
> 1+0 records out
> 512 bytes copied, 0.00154344 s, 332 kB/s
> 00000000  91 1c 6a 3e fa 08 fe 1c  c7 ce 42 71 20 21 68 1f  |..j>......Bq !h.|
> 00000010  e1 40 07 12 b7 97 9b f4  29 2c 7a ae 7f 47 de e5  |.@......),z..G..|
> 00000020  8a b8 27 79 4b 5d 3b 46  4a e5 5b 20 d5 39 a7 4e  |..'yK];FJ.[ .9.N|
> 00000030  f5 53 ae bc cf cb ce c6  4e 4a 25 3b 24 33 ca ee  |.S......NJ%;$3..|
> 00000040  57 15 5b 74 24 93 af 9d  1c ec 92 15 4b 24 95 df  |W.[t$.......K$..|
> 00000050  ef ec e3 d6 9a af 2b 16  23 d9 44 fb ff 42 5c 99  |......+.#.D..B\.|
> 00000060  49 10 1e 17 dc a7 14 a8  ac c6 e5 a1 40 c9 31 4b  |I...........@.1K|
> 00000070  f9 52 cc e0 e1 7c f5 ec  a6 d5 b0 61 22 bc ca b2  |.R...|.....a"...|
> 00000080  d5 77 8d f6 60 a9 c2 e8  9b bf 06 24 9a 30 db fc  |.w..`......$.0..|
> 00000090  d0 25 35 1b eb 11 f2 7c  1c 3b 3a b0 ba 9a e0 90  |.%5....|.;:.....|
> 
> root@mantic:~# mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
> 
> root@mantic:~# mdadm --verbose --verbose --assemble --update=no-bbl /dev/md0 /dev/sdb /dev/sdc
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
> mdadm: added /dev/sdc to /dev/md0 as 1
> mdadm: added /dev/sdb to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 2 drives.
> 
> root@mantic:~# dd if=/dev/md0 iflag=direct bs=512 count=1 skip=1000 | hexdump -C | head
> 1+0 records in
> 1+0 records out
> 512 bytes copied, 0.000770035 s, 665 kB/s
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000200
> 
> Thanks,
>    -Lev.
> 
> 
> -----Original Message-----
> From: Yu Kuai [mailto:yukuai1@huaweicloud.com]
> Sent: Thursday, November 9, 2023 3:09
> To: Yaron Presente; linux-raid@vger.kernel.org
> Cc: Lev Vainblat; Shyam Kaushik; Alex Lyakas; Yaron Presente; yukuai (C)
> Subject: Re: RAID1 possible data corruption following a write failure to superblock
> 
> Hi,
> 
> 在 2023/11/08 23:33, Yaron Presente 写道:
>> Hi All,
>> While investigating data corruption that occurred on one of our
>> systems, we came across a theoretical RAID1 scenario which we thought
>> could be problematic (detail follow below).
>> In order to create the scenario we used a VM installed with Ubuntu
>> Mantic 23.10 (kernel 6.5.0), configured with a RAID1 on top of 2 iSCSi
>> drives that were exported from a second VM.
>> On the latter VM we ran a proprietary device mapper on top of the
>> drives which allowed us to inject errors at the exact timing that we
>> wanted. This is the flow:
>> 0. 'zero' a specific block using dd (direct) on top of the raid1. read
>> it to make sure that the block was indeed zeroed out
>> 1. Issue a 'write' on top of the RAID1 device (using 'dd' direct of random data)
>> 2. Allow 'write' to the 2nd leg to succeed, but fail 'write' to the
>> 1st leg. Then fail also 'write' to the Superblock of both legs so that
>> the events counters (on both drives) are not updated
> 
> What exactly did you do to inject error, and what cat
> /sys/block/md0/md/rd*/bad_blocks shows?
> 
> Thanks,
> Kuai
> 
>> 3. 'dd' returns with a success (although at this point the RAID cannot
>> tell which leg is more updated)
>> 4. Stop the raid device and then re-assemble it, and let it re-sync
>> 5. Read the same offset, it reads zeros (as it sync'ed from the wrong
>> drive - in the case of matching event counters always from the 1st to
>> the 2nd ).
>>
>> Indeed, there are 2 concurrent failures (of different drives) in this
>> scenario. However, we still think that once returning 'ok' to a user
>> write operation, it is an unexpected behavior of the RAID1 to return
>> bad data.
>> Regards,
>> Yaron
>>
>>
>> Issue reproduction on kernel 6.5.0 (Ubuntu Mantic 23.10):
>>
>> root@mantic:~# uname -a
>> Linux mantic 6.5.0-10-generic #10-Ubuntu SMP PREEMPT_DYNAMIC Fri Oct
>> 13 13:49:38 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
>>
>> 1. Create md raid1 with 2 legs:
>> root@mantic:~# mdadm --create --verbose /dev/md0 --level=1
>> --raid-devices=2 /dev/sdb /dev/sdc
>> mdadm: array /dev/md0 started.
>>
>> 2. Write zeros to md0.
>> root@mantic:~# dd if=/dev/zero bs=512 count=1 seek=1000 oflag=direct of=/dev/md0
>> 1+0 records in
>> 1+0 records out
>> 512 bytes copied, 0.00271111 s, 189 kB/s
>>
>> 3. Read from md0 – read zeros, as expected
>> root@mantic:~# dd if=/dev/md0 iflag=direct bs=512 count=1 skip=1000
>> 2>/dev/null | hexdump –C
>> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>> *
>> 00000200
>>
>> 4. Enable error injection on the target
>>
>> 5. Write some random data to md0. Only data write to /dev/sdc
>> succeeded, data write to /dev/sdb and all superblock updates failed.
>> root@mantic:~# dd if=/dev/urandom bs=512 count=1 seek=1000
>> oflag=direct of=/dev/md0
>> 1+0 records in
>> 1+0 records out
>> 512 bytes copied, 1.94887 s, 0.3 kB/s
>> root@mantic:~# echo $?
>> 0
>>
>> root@mantic:~# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md0 : active raid1 sdb[0](F) sdc[1]
>>         31744 blocks super 1.2 [2/1] [_U]
>>
>> root@mantic:~# tail -F /var/log/kern.log
>> Nov  7 16:01:24.559661 mantic kernel: [ 6443.216430] sd 2:0:0:0: [sdb]
>> tag#81 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
>> Nov  7 16:01:24.559688 mantic kernel: [ 6443.216455] sd 2:0:0:0: [sdb]
>> tag#81 Sense Key : Medium Error [current]
>> Nov  7 16:01:24.559689 mantic kernel: [ 6443.216458] sd 2:0:0:0: [sdb]
>> tag#81 Add. Sense: Peripheral device write fault
>> Nov  7 16:01:24.559689 mantic kernel: [ 6443.216462] sd 2:0:0:0: [sdb]
>> tag#81 CDB: Write(10) 2a 00 00 00 0b e8 00 00 01 00
>> Nov  7 16:01:24.559690 mantic kernel: [ 6443.216465] I/O error, dev
>> sdb, sector 3048 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 2
>> Nov  7 16:01:25.069779 mantic kernel: [ 6443.726477] sd 2:0:0:0: [sdb]
>> tag#87 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
>> Nov  7 16:01:25.069805 mantic kernel: [ 6443.726495] sd 2:0:0:0: [sdb]
>> tag#87 Sense Key : Medium Error [current]
>> Nov  7 16:01:25.069806 mantic kernel: [ 6443.726498] sd 2:0:0:0: [sdb]
>> tag#87 Add. Sense: Peripheral device write fault
>> Nov  7 16:01:25.069807 mantic kernel: [ 6443.726502] sd 2:0:0:0: [sdb]
>> tag#87 CDB: Write(10) 2a 00 00 00 0b e8 00 00 01 00
>> Nov  7 16:01:25.069808 mantic kernel: [ 6443.726504] I/O error, dev
>> sdb, sector 3048 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 2
>> Nov  7 16:01:25.153362 mantic kernel: [ 6443.808395] sd 2:0:0:1: [sdc]
>> tag#83 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
>> Nov  7 16:01:25.153367 mantic kernel: [ 6443.808401] sd 2:0:0:1: [sdc]
>> tag#83 Sense Key : Medium Error [current]
>> Nov  7 16:01:25.153368 mantic kernel: [ 6443.808404] sd 2:0:0:1: [sdc]
>> tag#83 Add. Sense: Peripheral device write fault
>> Nov  7 16:01:25.153368 mantic kernel: [ 6443.808406] sd 2:0:0:1: [sdc]
>> tag#83 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
>> Nov  7 16:01:25.153369 mantic kernel: [ 6443.808411] I/O error, dev
>> sdc, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
>> Nov  7 16:01:25.153370 mantic kernel: [ 6443.808459] md: super_written
>> gets error=-5
>> Nov  7 16:01:25.153377 mantic kernel: [ 6443.808480] md/raid1:md0:
>> Disk failure on sdc, disabling device.
>> Nov  7 16:01:25.153378 mantic kernel: [ 6443.808480] md/raid1:md0:
>> Operation continuing on 1 devices.
>> Nov  7 16:01:25.157324 mantic kernel: [ 6443.812155] sd 2:0:0:0: [sdb]
>> tag#84 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
>> Nov  7 16:01:25.157334 mantic kernel: [ 6443.812160] sd 2:0:0:0: [sdb]
>> tag#84 Sense Key : Medium Error [current]
>> Nov  7 16:01:25.157335 mantic kernel: [ 6443.812162] sd 2:0:0:0: [sdb]
>> tag#84 Add. Sense: Peripheral device write fault
>> Nov  7 16:01:25.157336 mantic kernel: [ 6443.812164] sd 2:0:0:0: [sdb]
>> tag#84 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
>> Nov  7 16:01:25.157336 mantic kernel: [ 6443.812169] I/O error, dev
>> sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
>> Nov  7 16:01:25.157337 mantic kernel: [ 6443.812193] md: super_written
>> gets error=-5
>> Nov  7 16:01:25.235620 mantic kernel: [ 6443.892311] sd 2:0:0:0: [sdb]
>> tag#90 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
>> Nov  7 16:01:25.235634 mantic kernel: [ 6443.892330] sd 2:0:0:0: [sdb]
>> tag#90 Sense Key : Medium Error [current]
>> Nov  7 16:01:25.235635 mantic kernel: [ 6443.892333] sd 2:0:0:0: [sdb]
>> tag#90 Add. Sense: Peripheral device write fault
>> Nov  7 16:01:25.235635 mantic kernel: [ 6443.892336] sd 2:0:0:0: [sdb]
>> tag#90 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
>> Nov  7 16:01:25.235636 mantic kernel: [ 6443.892341] I/O error, dev
>> sdb, sector 24 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
>> Nov  7 16:01:25.235637 mantic kernel: [ 6443.892366] md: super_written
>> gets error=-5
>> Nov  7 16:01:25.319616 mantic kernel: [ 6443.976317] sd 2:0:0:0: [sdb]
>> tag#80 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
>> Nov  7 16:01:25.319635 mantic kernel: [ 6443.976336] sd 2:0:0:0: [sdb]
>> tag#80 Sense Key : Medium Error [current]
>> Nov  7 16:01:25.319637 mantic kernel: [ 6443.976341] sd 2:0:0:0: [sdb]
>> tag#80 Add. Sense: Peripheral device write fault
>> Nov  7 16:01:25.319638 mantic kernel: [ 6443.976346] sd 2:0:0:0: [sdb]
>> tag#80 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
>> Nov  7 16:01:25.319639 mantic kernel: [ 6443.976353] I/O error, dev
>> sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
>> Nov  7 16:01:25.319640 mantic kernel: [ 6443.976404] md: super_written
>> gets error=-5
>> Nov  7 16:01:25.414605 mantic kernel: [ 6444.068218] sd 2:0:0:0: [sdb]
>> tag#86 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
>> Nov  7 16:01:25.414621 mantic kernel: [ 6444.068235] sd 2:0:0:0: [sdb]
>> tag#86 Sense Key : Medium Error [current]
>> Nov  7 16:01:25.414623 mantic kernel: [ 6444.068240] sd 2:0:0:0: [sdb]
>> tag#86 Add. Sense: Peripheral device write fault
>> Nov  7 16:01:25.414624 mantic kernel: [ 6444.068245] sd 2:0:0:0: [sdb]
>> tag#86 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
>> Nov  7 16:01:25.414625 mantic kernel: [ 6444.068252] I/O error, dev
>> sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
>> Nov  7 16:01:25.414626 mantic kernel: [ 6444.068320] md: super_written
>> gets error=-5
>> Nov  7 16:01:25.915709 mantic kernel: [ 6444.572401] sd 2:0:0:0: [sdb]
>> tag#84 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
>> Nov  7 16:01:25.915732 mantic kernel: [ 6444.572423] sd 2:0:0:0: [sdb]
>> tag#84 Sense Key : Medium Error [current]
>> Nov  7 16:01:25.915733 mantic kernel: [ 6444.572427] sd 2:0:0:0: [sdb]
>> tag#84 Add. Sense: Peripheral device write fault
>> Nov  7 16:01:25.915733 mantic kernel: [ 6444.572430] sd 2:0:0:0: [sdb]
>> tag#84 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
>> Nov  7 16:01:25.915734 mantic kernel: [ 6444.572448] I/O error, dev
>> sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
>> Nov  7 16:01:25.915735 mantic kernel: [ 6444.572495] md: super_written
>> gets error=-5
>>
>> 6. Disable error injection on the target
>>
>> 7. Reassemble md raid1
>> root@mantic:~# mdadm --stop /dev/md0
>> mdadm: stopped /dev/md0
>>
>> root@mantic:~# mdadm --verbose --assemble /dev/md0 /dev/sdb /dev/sdc
>> mdadm: looking for devices for /dev/md0
>> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
>> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
>> mdadm: added /dev/sdc to /dev/md0 as 1
>> mdadm: added /dev/sdb to /dev/md0 as 0
>> mdadm: /dev/md0 has been started with 2 drives.
>>
>> root@mantic:~# tail -F /var/log/kern.log
>> Nov  7 16:06:27.073412 mantic kernel: [ 6745.728446] md: md0 stopped.
>> Nov  7 16:06:27.085369 mantic kernel: [ 6745.740822] md/raid1:md0: not
>> clean -- starting background reconstruction
>> Nov  7 16:06:27.085382 mantic kernel: [ 6745.740827] md/raid1:md0:
>> active with 2 out of 2 mirrors
>> Nov  7 16:06:27.085384 mantic kernel: [ 6745.740842] md0: detected
>> capacity change from 0 to 63488
>> Nov  7 16:06:27.089518 mantic kernel: [ 6745.742959] md: resync of
>> RAID array md0
>> Nov  7 16:06:27.365351 mantic kernel: [ 6746.019437] md: md0: resync done.
>>
>> 8. Read from md0 – read zeros, although previously write random data succeeded
>> root@mantic:~# dd if=/dev/md0 iflag=direct bs=512 count=1 skip=1000
>> 2>/dev/null | hexdump –C
>> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>> *
>> 00000200
>>
>> .
>>
> 
> 
> .
> 

