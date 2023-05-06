Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6699C77B75
	for <linux-raid@archiver.kernel.org>; Sat,  6 May 2023 08:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjEFIg6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 May 2023 04:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjEFIg4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 May 2023 04:36:56 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04ABB10B
        for <linux-raid@vger.kernel.org>; Sat,  6 May 2023 01:36:52 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QD1B81Ymlz4f3mHl
        for <linux-raid@vger.kernel.org>; Sat,  6 May 2023 16:36:48 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3rLCbEVZkNB16Iw--.19864S3;
        Sat, 06 May 2023 16:36:45 +0800 (CST)
Subject: Re: mdadm grow raid 5 to 6 failure (crash)
To:     David Gilmour <dgilmour76@gmail.com>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>, Song Liu <song@kernel.org>
References: <CAO2ABipzbw6QL5eNa44CQHjiVa-LTvS696Mh9QaTw+qsUKFUCw@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6fcbab2f-8211-774a-7aa9-883ed5d74168@huaweicloud.com>
Date:   Sat, 6 May 2023 16:36:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAO2ABipzbw6QL5eNa44CQHjiVa-LTvS696Mh9QaTw+qsUKFUCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3rLCbEVZkNB16Iw--.19864S3
X-Coremail-Antispam: 1UD129KBjvJXoWfGw13Aryxtr1DCrW5tFy8AFb_yoWkZrW5pF
        WfJ3WS9rZrtw4xuw1kA34xK3Z5Ga4SvrZ0yw1vg34Ikas8Krn2vFWxGr1rtayjyw13KF92
        vw4DXFyUCF98tr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/05/06 11:29, David Gilmour 写道:
> Hi all, after exhausting all other sources I could find online I have
> come here in the hopes that someone may have some guidance that will
> save my data. While I have an offsite backup of the most critical data
> I definitely would prefer to find some \ ANY way to recover my array
> to recover ALL my data.
> 
> Situation: I had a healthy raid 5 array made up of 5 - 8TB drives. I
> had always wanted to increase redundancy by growing this to a raid 6
> array. I finally decided to get another drive and kicked off the
> process with the following commands
> 
> mdadm --add /dev/md127 /dev/sde #adding the 6th 8TB drive as a spare
> mdadm --grow /dev/md127 --level=raid6 --raid-devices=6
> --backup-file=/root/mdadm5-6_backup_md127
> 
> Reshape started and everything looked good but after about 10mins
> something crashed and I started seeing messages about drives not
> responding and the shape process slowly slowed down to 0kbps. I
> rebooted and my drives would not assemble showing (ignore the changing
> drive letters as they swap around on each reboot but I am verifying
> the right disks are in play for each command):
> 
> Personalities : [raid1]
> md127 : inactive sdh[1](S) sdg[3](S) sdb[5](S) sda[6](S) sdf[7](S) sdc[4](S)
>        46883373072 blocks super 1.2
> md1 : active raid1 sde3[0] sdd3[1]
>        1919958912 blocks super 1.0 [2/2] [UU]
>        bitmap: 5/15 pages [20KB], 65536KB chunk
> md0 : active raid1 sde1[3] sdd1[2]
>        1047488 blocks super 1.0 [2/2] [UU]
> 
> /dev/md127:
>             Version : 1.2
>          Raid Level : raid6
>       Total Devices : 6
>         Persistence : Superblock is persistent
>               State : inactive
>     Working Devices : 6
>           New Level : raid6
>          New Layout : left-symmetric
>       New Chunksize : 512K
>                Name : milhouse.wooky.org:0
>                UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
>              Events : 984922
>      Number   Major   Minor   RaidDevice
>         -       8       32        -        /dev/sdc
>         -       8        0        -        /dev/sda
>         -       8      112        -        /dev/sdh
>         -       8       80        -        /dev/sdf
>         -       8       16        -        /dev/sdb
>         -       8       96        -        /dev/sdg
> 
> First thing I tried was stopping and restarting the array pointing to
> the backup file I had on another partition with:
> 
> mdadm --stop /dev/md127
> mdadm --assemble --verbose --backup-file /root/mdadm5-6_backup_md127
> /dev/md127 /dev/sdc /dev/sda /dev/sdh /dev/sdf /dev/sdb /dev/sdg
> 
> But I get this fun error:
> mdadm: looking for devices for /dev/md127
> mdadm: /dev/sdc is identified as a member of /dev/md127, slot 3.
> mdadm: /dev/sda is identified as a member of /dev/md127, slot 0.
> mdadm: /dev/sdh is identified as a member of /dev/md127, slot 1.
> mdadm: /dev/sdf is identified as a member of /dev/md127, slot 5.
> mdadm: /dev/sdb is identified as a member of /dev/md127, slot 4.
> mdadm: /dev/sdg is identified as a member of /dev/md127, slot 2.
> mdadm: /dev/md127 has an active reshape - checking if critical section
> needs to be restored
> mdadm: No backup metadata on /root/mdadm5-6_backup_md127
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
> 
> Beyond that here is a list of things I have tried thus far :
> 
> mdadm --assemble --verbose --backup-file=/root/mdadm5-6_backup_md127
> /dev/md127 /dev/sdc /dev/sda /dev/sdh /dev/sdf /dev/sdb /dev/sdg #with
> and without the --force option
> mdadm --assemble --verbose --invalid-backup
> --backup-file=/root/mdadm5-6_backup_md127 /dev/md127 /dev/sdc /dev/sda
> /dev/sdh /dev/sdf /dev/sdb /dev/sdg #with and without the --force
> option
> 
> Oddly enough this command with the force option causes my system to hang

You can check this thread:

https://lore.kernel.org/all/CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com/

If your hang is the same, before this bug if fixed, you can bypass this
hang by don't access the array before assemble is done.

Thanks,
Kuai
> 
> I created raid overlay files and tried just creating the array in
> various ways, all of which assemble ok but none are mountable (bad fs,
> superblock etc message)
> 
> Tried recreating as a raid 6 with the same parameters as the grow
> (with and without the 6th 8TB that was originally added:
> 
> mdadm --create /dev/md127 --level=6 --chunk=512K --metadata=1.2
> --layout left-symmetric --data-offset=262144s --raid-devices=6
> /dev/mapper/sda /dev/mapper/sdh /dev/mapper/sdg /dev/mapper/sdc
> /dev/mapper/sde --assume-clean --readonly
>   mdadm --create /dev/md127 --level=6 --chunk=512K --metadata=1.2
> --layout left-symmetric --data-offset=262144s --raid-devices=5
> /dev/mapper/sda /dev/mapper/sdh /dev/mapper/sdg /dev/mapper/sdc
> /dev/mapper/sde --assume-clean --readonly
> 
> Tried recreating the original raid 5 array with the 6th member removed
> 
>   mdadm --create /dev/md127 --level=5 --chunk=512K --metadata=1.2
> --layout left-symmetric --data-offset=262144s --raid-devices=5
> /dev/mapper/sdb /dev/mapper/sdh /dev/mapper/sdg /dev/mapper/sdc
> /dev/mapper/sde --assume-clean --readonly
> 
> 
> This is where I am at... one thing I am curious about is the various
> array state messages in the following mdadm --examine output for each
> of these drives. Some show "AAAAAA" and some (3) show drives missing
> in array "A..AA.". Does it make sense to remove the ones the system
> thinks are missing then re-add them to the array? Any risk to this? I
> would imagine the assemble with the force option would of covered this
> possibility but maybe I misunderstand something here.
> 
> # mdadm --examine /dev/sdc
> /dev/sdc:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x5
>       Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
>             Name : milhouse.wooky.org:0
>    Creation Time : Thu Sep  7 03:12:27 2017
>       Raid Level : raid6
>     Raid Devices : 6
>   Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
>       Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
>    Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262056 sectors, after=688 sectors
>            State : active
>      Device UUID : 42809136:2f8a0b1d:d519e4cb:ffc4ebd8
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
>       New Layout : left-symmetric
>      Update Time : Mon May  1 04:48:57 2023
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : 31a0dcf6 - correct
>           Events : 984922
>           Layout : left-symmetric-6
>       Chunk Size : 512K
>     Device Role : Active device 3
>     Array State : A..AA. ('A' == active, '.' == missing, 'R' == replacing)
> 
> # mdadm --examine /dev/sda
> /dev/sda:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x5
>       Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
>             Name : milhouse.wooky.org:0
>    Creation Time : Thu Sep  7 03:12:27 2017
>       Raid Level : raid6
>     Raid Devices : 6
>   Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
>       Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
>    Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262056 sectors, after=688 sectors
>            State : clean
>      Device UUID : 49955753:d202b004:64d74e3f:56480d25
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
>       New Layout : left-symmetric
>      Update Time : Mon May  1 04:48:57 2023
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : f59eab84 - correct
>           Events : 984922
>           Layout : left-symmetric-6
>       Chunk Size : 512K
>     Device Role : Active device 0
>     Array State : AAAAA. ('A' == active, '.' == missing, 'R' == replacing)
> 
> # mdadm --examine /dev/sdh
> /dev/sdh:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x5
>       Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
>             Name : milhouse.wooky.org:0
>    Creation Time : Thu Sep  7 03:12:27 2017
>       Raid Level : raid6
>     Raid Devices : 6
>   Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
>       Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
>    Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262056 sectors, after=688 sectors
>            State : active
>      Device UUID : c915a45d:f2cc52ba:629dbf61:4c85efe6
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
>       New Layout : left-symmetric
>      Update Time : Mon May  1 04:47:53 2023
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : 99e7f8d4 - correct
>           Events : 984922
>           Layout : left-symmetric-6
>       Chunk Size : 512K
>     Device Role : Active device 1
>     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> # mdadm --examine /dev/sdf
> /dev/sdf:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x7
>       Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
>             Name : milhouse.wooky.org:0
>    Creation Time : Thu Sep  7 03:12:27 2017
>       Raid Level : raid6
>     Raid Devices : 6
>   Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
>       Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
>    Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
> Recovery Offset : 8012800 sectors
>     Unused Space : before=262064 sectors, after=688 sectors
>            State : active
>      Device UUID : 75127e45:a31ad132:d8dba6bc:0282e2bc
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
>       New Layout : left-symmetric
>      Update Time : Mon May  1 04:47:53 2023
>    Bad Block Log : 512 entries available at offset 40 sectors
>         Checksum : 2b94c243 - correct
>           Events : 984920
>           Layout : left-symmetric-6
>       Chunk Size : 512K
>     Device Role : Active device 5
>     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> # mdadm --examine /dev/sdb
> /dev/sdb:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x5
>       Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
>             Name : milhouse.wooky.org:0
>    Creation Time : Thu Sep  7 03:12:27 2017
>       Raid Level : raid6
>     Raid Devices : 6
>   Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
>       Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
>    Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262056 sectors, after=688 sectors
>            State : active
>      Device UUID : 61265e10:8333498a:177ef638:617442f8
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
>       New Layout : left-symmetric
>      Update Time : Mon May  1 04:48:57 2023
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : 51446d6 - correct
>           Events : 984922
>           Layout : left-symmetric-6
>       Chunk Size : 512K
>     Device Role : Active device 4
>     Array State : A..AA. ('A' == active, '.' == missing, 'R' == replacing)
> 
> # mdadm --examine /dev/sdg
> /dev/sdg:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x5
>       Array UUID : 5dc190ba:ad8a8dc1:8e9fbfb2:7d68737d
>             Name : milhouse.wooky.org:0
>    Creation Time : Thu Sep  7 03:12:27 2017
>       Raid Level : raid6
>     Raid Devices : 6
>   Avail Dev Size : 15627791024 sectors (7.28 TiB 8.00 TB)
>       Array Size : 31255580672 KiB (29.11 TiB 32.01 TB)
>    Used Dev Size : 15627790336 sectors (7.28 TiB 8.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262056 sectors, after=688 sectors
>            State : active
>      Device UUID : d064611f:a97d457f:141f9fcf:e6471bb8
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 16025600 (15.28 GiB 16.41 GB)
>       New Layout : left-symmetric
>      Update Time : Mon May  1 04:47:53 2023
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : 5fa33ce0 - correct
>           Events : 984922
>           Layout : left-symmetric-6
>       Chunk Size : 512K
>     Device Role : Active device 2
>     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> .
> 

