Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9C4C433DB
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 07:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC45221FB
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 07:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731639AbhAOH6v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jan 2021 02:58:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbhAOH6u (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Jan 2021 02:58:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61866221FB
        for <linux-raid@vger.kernel.org>; Fri, 15 Jan 2021 07:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610697489;
        bh=DHX/5c187/earOS8i8gfpeqWEzgZFOP/4JbKqkNqJJE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WziOScC1XPUbZ/XmNNYwGGoAFN/fMS0C/+8yvxO/dVf9nLNr3B7RnjDk2pVj6dmMj
         uclCyiKvlrS3sVy+ne04Unl4OjNiAnjiItaCaugtZH37uKVTIPwx5L+T73WDt6rm0i
         vXwlJSOs3sdPH+EPUyB9/9uvfqt0K3xVFOgTDCgAkWcUAWHp20xB0hjUGrJFxwNpp+
         HnROcSqkPOcY74qV2u7bAn7e2FktIAQDx2QUGeRnq0bjZm/bKBmVTGdrqIobsYYi95
         SYIK7nbrbt4skvFW0LcoELn3WNk3vnMYL1I+ukA+RDxZ4t8DV9VHzuwI+YjmWYS/0r
         v8LWz+A1LXz2Q==
Received: by mail-lj1-f178.google.com with SMTP id b10so9378748ljp.6
        for <linux-raid@vger.kernel.org>; Thu, 14 Jan 2021 23:58:09 -0800 (PST)
X-Gm-Message-State: AOAM531+BJYbKuS0qSKzstzLihHnJ+PntbkefC1tngVow1Ynl75QqGcK
        yxocSekMgLRP6UxZqZGH1KgQnyVHeTcYzlD54qU=
X-Google-Smtp-Source: ABdhPJyTfPn52w5Cj0fJig9A8Kc30ysX+O0uylhfQ3wZmOAVH+toSXBT2tsdT5PreB135qOmslPXB3EZ6tyrBUiRXmI=
X-Received: by 2002:a2e:a402:: with SMTP id p2mr4863337ljn.270.1610697487653;
 Thu, 14 Jan 2021 23:58:07 -0800 (PST)
MIME-Version: 1.0
References: <CAM7EtNjpS3yr=3XtGkgfc3=L=fSfqJW7P8mSZ__+L7fwjLu8eA@mail.gmail.com>
 <24576.47848.628487.833800@quad.stoffel.home>
In-Reply-To: <24576.47848.628487.833800@quad.stoffel.home>
From:   Song Liu <song@kernel.org>
Date:   Thu, 14 Jan 2021 23:57:56 -0800
X-Gmail-Original-Message-ID: <CAPhsuW53Y84PVBgM1q_S8phVKHq00gbxZH0O40BNgNo+qka6mQ@mail.gmail.com>
Message-ID: <CAPhsuW53Y84PVBgM1q_S8phVKHq00gbxZH0O40BNgNo+qka6mQ@mail.gmail.com>
Subject: Re: raid5 size reduced after system reinstall, how to fix?
To:     John Stoffel <john@stoffel.org>
Cc:     Marcus Lell <marcus.lell@gmail.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jan 14, 2021 at 1:45 PM John Stoffel <john@stoffel.org> wrote:
>
> >>>>> "Marcus" == Marcus Lell <marcus.lell@gmail.com> writes:
>
>
> Marcus> after reinstalling gentoo on my main system, I had to find
> Marcus> out, that my clean raid5 has been resized from ca. 18,2TB to
> Marcus> ca. 2,2 TB .  I don't have any clue, why..
>
> How full was your array before?  And what filesystem are you using on
> there?  Does the filesystem pass 'fsck' checks?  And did you lose any
> data that you know of?
>
> Can you show us the output of:  cat /proc/partitions
>
> because it sounds like you're disks got messed up somewhere.
> Hmm... did you use the full disks before by any chance?  /dev/sdb,
> /dev/sdc and /dev/sdd instead of /dev/sdb1, sdc1 and sdd1?  That might
> be the problem.
>
> If the partitions are too small, what I might do is:
>
> 0. don't panic!  And don't do anything without thinking and taking
>    your time.
> 1. stop the array completely.
> 2. goto the RAID wiki and look at the instructions for how to setup
>    overlays, so you dont' write to your disks while expermienting.
>
>    https://raid.wiki.kernel.org/index.php/Linux_Raid
>
> 3. Examine sdb, and compare it with sdb1.  See the difference?  You
>    might have done whole disk setup, instead of using partitions.
>
>    mdadm -E /dev/sdb
>
>
> 4. Check your partitioning.
>
>    It might be possible (if this is the problem) to just extend your
>    paritions to the end of the disk, and then re-mount your disks.
>
>
> Good luck!  Let us know what you find.
>
> John
>
>
> Marcus> First, the array gets assembled successfully.
>
> Marcus> lxcore ~ # cat /proc/mdstat
> Marcus> Personalities : [raid1] [raid6] [raid5] [raid4]
> Marcus> md0 : active raid5 sdd1[2] sdb1[1] sdc1[0]
> Marcus>       2352740224 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> Marcus>       bitmap: 0/9 pages [0KB], 65536KB chunk
>
> Marcus> unused devices: <none>
>
> Marcus> lxcore ~ # mdadm --detail /dev/md0
> Marcus> /dev/md0:
> Marcus>            Version : 1.2
> Marcus>      Creation Time : Sat Nov 10 23:04:14 2018
> Marcus>         Raid Level : raid5
> Marcus>         Array Size : 2352740224 (2243.75 GiB 2409.21 GB)
> Marcus>      Used Dev Size : 1176370112 (1121.87 GiB 1204.60 GB)
> Marcus>       Raid Devices : 3
> Marcus>      Total Devices : 3
> Marcus>        Persistence : Superblock is persistent
>
> Marcus>      Intent Bitmap : Internal
>
> Marcus>        Update Time : Tue Jan 12 14:58:40 2021
> Marcus>              State : clean
> Marcus>     Active Devices : 3
> Marcus>    Working Devices : 3
> Marcus>     Failed Devices : 0
> Marcus>      Spare Devices : 0
>
> Marcus>             Layout : left-symmetric
> Marcus>         Chunk Size : 64K
>
> Marcus> Consistency Policy : bitmap
>
> Marcus>               Name : lxcore:0  (local to host lxcore)
> Marcus>               UUID : 0e3c432b:c68cda5b:0bf31e79:9dfe252b
> Marcus>             Events : 80471
>
> Marcus>     Number   Major   Minor   RaidDevice State
> Marcus>        0       8       33        0      active sync   /dev/sdc1
> Marcus>        1       8       17        1      active sync   /dev/sdb1
> Marcus>        2       8       49        2      active sync   /dev/sdd1
>
> Marcus> but the partitions are ok
>
> Marcus> lxcore ~ # fdisk -l /dev/sdb1
> Marcus> Disk /dev/sdb1: 9.1 TiB, 10000830283264 bytes, 19532871647 sectors
> Marcus> Units: sectors of 1 * 512 = 512 bytes
> Marcus> Sector size (logical/physical): 512 bytes / 4096 bytes
> Marcus> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>
> Marcus> same with sdc1 and sdd1
> Marcus> Here is the problem:
>
> Marcus> lxcore ~ # mdadm --examine /dev/sdb1
> Marcus> /dev/sdb1:
> Marcus>           Magic : a92b4efc
> Marcus>         Version : 1.2
> Marcus>     Feature Map : 0x1
> Marcus>      Array UUID : 0e3c432b:c68cda5b:0bf31e79:9dfe252b
> Marcus>            Name : lxcore:0  (local to host lxcore)
> Marcus>   Creation Time : Sat Nov 10 23:04:14 2018
> Marcus>      Raid Level : raid5
> Marcus>    Raid Devices : 3
>
> Marcus>  Avail Dev Size : 19532609759 (9313.87 GiB 10000.70 GB)
> Marcus>      Array Size : 2352740224 (2243.75 GiB 2409.21 GB)
> Marcus>   Used Dev Size : 2352740224 (1121.87 GiB 1204.60 GB)
> Marcus>     Data Offset : 261888 sectors
> Marcus>    Super Offset : 8 sectors
> Marcus>    Unused Space : before=261800 sectors, after=17179869535 sectors
> Marcus>           State : clean
> Marcus>     Device UUID : a8fbe4dd:a7ac9c16:d1d29abd:e2a0d573
>
> Marcus> Internal Bitmap : 8 sectors from superblock
> Marcus>     Update Time : Tue Jan 12 14:58:40 2021
> Marcus>   Bad Block Log : 512 entries available at offset 72 sectors
> Marcus>        Checksum : 86f42300 - correct
> Marcus>          Events : 80471
>
> Marcus>          Layout : left-symmetric
> Marcus>      Chunk Size : 64K
>
> Marcus>    Device Role : Active device 1
> Marcus>    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
>
> Marcus> same with /dev/sdc1 and /dev/sdd1
> Marcus> It shows, that only 1121.68GB are used instead of the
> Marcus> available 9.1TB, so the array size results in 2.2TB
>
>
> Marcus> Will a simple
> Marcus> mdadm --grow --size=max /dev/md0
> Marcus> fix this and leave the data untouched?

Are you running kernel 5.10? If so, please upgrade to 5.10.1 or later.
There was an
bug in 5.10 kernel. After upgrading the kernel, the mdadm --grow command above
should fix this. The --grow will trigger a resync for the newly grown
area. If the array
was not in degraded mode, the resync should not change any data.

Please let me know if this works.

Thanks,
Song
