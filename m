Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3632DC77B73
	for <linux-raid@archiver.kernel.org>; Tue,  2 May 2023 11:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbjEBLb1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 May 2023 07:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbjEBLbZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 May 2023 07:31:25 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7983955AB
        for <linux-raid@vger.kernel.org>; Tue,  2 May 2023 04:30:51 -0700 (PDT)
Received: from [192.168.100.1] ([94.134.214.237]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MOV26-1pba2d1Qre-00PxkV; Tue, 02 May 2023 13:30:13 +0200
Message-ID: <23052452-30bf-4391-76f3-14ab8ff2014c@online.de>
Date:   Tue, 2 May 2023 13:30:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
From:   Peter Neuwirth <reddunur@online.de>
To:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org
Cc:     "yukuai (C)" <yukuai3@huawei.com>
Content-Language: de-DE
Subject: Re: linux mdadm assembly error: md: cannot handle concurrent
 replacement and reshape. (reboot while reshaping)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:vjFHNUeq006uBV/AaFso2KoF78iwYk9dfc/8rRgZSCbhojdVQuf
 deeQw6is6wTQ87OoCoVTvoWB03jebEW7MkGpinaHSiqUIlC4NwPLdV5xumiomXAbzVS48lo
 /pjGckG5zcTUeFaRip/RojR+mBlZ3G8btpyPFaeEZf8uIN23RYtshHJbk4U+KOywh0I4olY
 0Vm2T9G6HHaRKv8tnPBwQ==
UI-OutboundReport: notjunk:1;M01:P0:CJ6De8oT51Q=;S4pTOcrPXZeRDKfkTwRcyAp3nQA
 x1AOHpoZwYghINq1QjtMoLwshChb66PNWMpwGFD3TwvQ512eoldJgrLsDQ+KLZ0fcscAiVnso
 Df4Qtm2iUrmtNBnab+mSdfxnZ4OuaZln7XD5MzziN/Qq6HD/Z5E0InFxRFGbmIQBFKAXpqIUA
 PLiKrSG2m6xusO4QtTazbDoYM3N6nKd34fYExta6sQ1eB2HsV//BdFpwPBe1XMwoyGQ0svtvS
 ZlGwXCd3xWDamBZzQlqeSrWqM5LK6J7ZENd/Ml4vBIcQZOrv15GN428HSniwNNePX6yE/yxbg
 LND3QjrP0SiI9faXJT4eTMG94uKGjtqJbaIs/g7Z8sqPrnk2im3hUJ1xVasKjUPBSxTJWzHTF
 3vK8QXjumVk9HkOfsGAbspR8CWRlUG4rCbVnKgd246vXzBUGhPB+qt3kGS1jlQ42SHo97bC7A
 wUaAu1ZGKoBAP2cIhz4ZhP4nNrUDrK1LiH4qsXdM1+Am+o5DUwIFtD8J+1g6HvQ/4ExZ0gz7s
 McUFJIYRLU9WpW0f3Nv/gCCT0hoI86qEZo84COLURqyxC5qcT559YYHKCqWX8Lq7Z//BKAJgM
 +4JUeX8zHRikcf3CV+88xKYA8ZCTXnZVhm4L/1ZZPxqszizz1J1qqBQvz37vUfuRrp456Rzu5
 xjK8+J0pqd4ihocUmLX6PFSmcDDlzNlncCH7QRGRDQ==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Kuai,

thank you for your suggestion!
It is true, as I read the source of error message in drivers/md/raid5.c,
I saw that growing and replacement is to much to handle.
So I did what you suggested and started the raid 5 (that was in a
raid 6 transformation with addition of two more drives) with only the
5 members, that should run a degraded raid 5.

mdadm --assemble --run   /dev/md0 /dev/sdd /dev/sdc /dev/sdb /dev/sdi /dev/sdj

this worked and it was assembled.


Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10]
md0 : active (auto-read-only) raid6 sdd[0] sdi[6] sdj[4] sdb[2] sdc[1]
      4883151360 blocks super 1.2 level 6, 256k chunk, algorithm 18 [7/5] [UUU_UU_]
      bitmap: 0/8 pages [0KB], 65536KB chunk

unused devices: <none>

mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Mon Mar  6 18:17:30 2023
        Raid Level : raid6
        Array Size : 4883151360 (4656.94 GiB 5000.35 GB)
     Used Dev Size : 976630272 (931.39 GiB 1000.07 GB)
      Raid Devices : 7
     Total Devices : 5
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Fri Apr 28 04:21:03 2023
             State : clean, degraded
    Active Devices : 5
   Working Devices : 5
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric-6
        Chunk Size : 256K

Consistency Policy : bitmap

        New Layout : left-symmetric

              Name : solidsrv11:0  (local to host solidsrv11)
              UUID : 1a87479e:7513dd65:37c61ca1:43184f65
            Events : 6336

    Number   Major   Minor   RaidDevice State
       0       8       48        0      active sync   /dev/sdd
       1       8       32        1      active sync   /dev/sdc
       2       8       16        2      active sync   /dev/sdb
       -       0        0        3      removed
       4       8      144        4      active sync   /dev/sdj
       6       8      128        5      active sync   /dev/sdi
       -       0        0        6      removed



But when I try to mount it as xfs fs:

mount: /mnt/image: mount(2) system call failed: Structure needs cleaning.

When I try to repair the xfs fs, it tells me, that there was no superblock
found..

xfs_repair -n /dev/md0
Phase 1 - find and verify superblock...
couldn't verify primary superblock - not enough secondary superblocks with matching geometry !!!

attempting to find secondary superblock...
.................found candidate secondary superblock...
unable to verify superblock, continuing...
.found candidate secondary superblock...
unable to verify superblock, continuing...

...

.found candidate secondary superblock...
unable to verify superblock, continuing...
.found candidate secondary superblock...
unable to verify superblock, continuing...
...........................................

Sadly I do not exactly understand, what happens in the grow+replacement phase,
where all evil begun. As I could see, the two added hard disk drives still have their old
partition table, so I suppose, the rebuild process was still in moving the raid 5 geometry
to a raid-5-to-6 transient geometry. I'm not sure if in this process, raid 5 promise (1 drive
may fail) still holds. However, the two additional drives were treated as spare since
this moment after reboot. And one drive of the prior riad5, now raid6 seems to be defect.

Is it possible that the process restart somehow scrambled some raidset informations and
messed up my raid level striping in continued growth process ? then the still mounted device
crashed and disappeared from mounts. And from this point on, there was no way to reconstruct
the messed raidset informations and striping?

This whole matter with striped data, transient raid geometries, expansion and growth
processing, etc. seems so complex and intransparent to me, that I start to consider
my data on this raidset as lost :(

For any tools and suggestions helping to save at least parts of the data on the
raid, I would be very happy.

regards,

Peter



Am 28.04.23 um 04:01 schrieb Yu Kuai:
> Hi,
>
> 在 2023/04/28 5:09, Peter Neuwirth 写道:
>>
>> ------------------------------------------------------------------------------------------------------------------------
>> Some Logs:
>> ------------------------------------------------------------------------------------------------------------------------
>>
>> uname -a ; mdadm --version
>> Linux srv11 5.10.0-21-amd64 #1 SMP Debian 5.10.162-1 (2023-01-21) x86_64 GNU/Linux
>> mdadm - v4.1 - 2018-10-01
>>
>> srv11:~# mdadm -D /dev/md0
>> /dev/md0:
>>             Version : 1.2
>>       Creation Time : Mon Mar  6 18:17:30 2023
>>          Raid Level : raid6
>>       Used Dev Size : 976630272 (931.39 GiB 1000.07 GB)
>>        Raid Devices : 7
>>       Total Devices : 6
>>         Persistence : Superblock is persistent
>>
>>         Update Time : Thu Apr 27 17:36:15 2023
>>               State : active, FAILED, Not Started
>>      Active Devices : 5
>>     Working Devices : 6
>>      Failed Devices : 0
>>       Spare Devices : 1
>>
>>              Layout : left-symmetric-6
>>          Chunk Size : 256K
>>
>> Consistency Policy : unknown
>>
>>          New Layout : left-symmetric
>>
>>                Name : solidsrv11:0  (local to host solidsrv11)
>>                UUID : 1a87479e:7513dd65:37c61ca1:43184f65
>>              Events : 4700
>>
>>      Number   Major   Minor   RaidDevice State
>>         -       0        0        0      removed
>>         -       0        0        1      removed
>>         -       0        0        2      removed
>>         -       0        0        3      removed
>>         -       0        0        4      removed
>>         -       0        0        5      removed
>>         -       0        0        6      removed
>>
>>         -       8       32        2      sync   /dev/sdc
>>         -       8      144        4      sync   /dev/sdj
>>         -       8       80        0      sync   /dev/sdf
>>         -       8       16        1      sync   /dev/sdb
>>         -       8      128        5      sync   /dev/sdi
>>         -       8       96        4      spare rebuilding /dev/sdg
>
> Looks like the /dev/sdg is not the original device, above log shows that
> RaidDevice 3 is missing, and /dev/sdg is replacement of /dev/sdj.
>
> So reshapge is still in progress, and somehow sdg is the replacement of
> sdj, this matches the condition in raid5_run:
>
> 7952                 if (rcu_access_pointer(conf->disks[i].replacement) &&
> 7953                     conf->reshape_progress != MaxSector) {
> 7954                         /* replacements and reshape simply do not mix. */
> 7955                         pr_warn("md: cannot handle concurrent replacement and reshape.\n");
> 7956                         goto abort;
> 7957                 }
>
> I'm by no means raid5 expert but I will suggest to remove /dev/sdg and
> try again to assemble.
>
> Thanks,
> Kuai
>

