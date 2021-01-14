Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBE1C433DB
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jan 2021 21:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2B1C23B08
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jan 2021 21:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbhANVnr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Jan 2021 16:43:47 -0500
Received: from li1843-175.members.linode.com ([172.104.24.175]:47590 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbhANVnq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Jan 2021 16:43:46 -0500
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 481B226345;
        Thu, 14 Jan 2021 16:43:05 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id AC570A6B58; Thu, 14 Jan 2021 16:43:04 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24576.47848.628487.833800@quad.stoffel.home>
Date:   Thu, 14 Jan 2021 16:43:04 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     Marcus Lell <marcus.lell@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: raid5 size reduced after system reinstall, how to fix?
In-Reply-To: <CAM7EtNjpS3yr=3XtGkgfc3=L=fSfqJW7P8mSZ__+L7fwjLu8eA@mail.gmail.com>
References: <CAM7EtNjpS3yr=3XtGkgfc3=L=fSfqJW7P8mSZ__+L7fwjLu8eA@mail.gmail.com>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Marcus" == Marcus Lell <marcus.lell@gmail.com> writes:


Marcus> after reinstalling gentoo on my main system, I had to find
Marcus> out, that my clean raid5 has been resized from ca. 18,2TB to
Marcus> ca. 2,2 TB .  I don't have any clue, why..

How full was your array before?  And what filesystem are you using on
there?  Does the filesystem pass 'fsck' checks?  And did you lose any
data that you know of?

Can you show us the output of:  cat /proc/partitions

because it sounds like you're disks got messed up somewhere.
Hmm... did you use the full disks before by any chance?  /dev/sdb,
/dev/sdc and /dev/sdd instead of /dev/sdb1, sdc1 and sdd1?  That might
be the problem.

If the partitions are too small, what I might do is:

0. don't panic!  And don't do anything without thinking and taking
   your time.
1. stop the array completely.
2. goto the RAID wiki and look at the instructions for how to setup
   overlays, so you dont' write to your disks while expermienting.  

   https://raid.wiki.kernel.org/index.php/Linux_Raid

3. Examine sdb, and compare it with sdb1.  See the difference?  You
   might have done whole disk setup, instead of using partitions.  

   mdadm -E /dev/sdb


4. Check your partitioning.

   It might be possible (if this is the problem) to just extend your
   paritions to the end of the disk, and then re-mount your disks.


Good luck!  Let us know what you find.

John


Marcus> First, the array gets assembled successfully.

Marcus> lxcore ~ # cat /proc/mdstat
Marcus> Personalities : [raid1] [raid6] [raid5] [raid4]
Marcus> md0 : active raid5 sdd1[2] sdb1[1] sdc1[0]
Marcus>       2352740224 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
Marcus>       bitmap: 0/9 pages [0KB], 65536KB chunk

Marcus> unused devices: <none>

Marcus> lxcore ~ # mdadm --detail /dev/md0
Marcus> /dev/md0:
Marcus>            Version : 1.2
Marcus>      Creation Time : Sat Nov 10 23:04:14 2018
Marcus>         Raid Level : raid5
Marcus>         Array Size : 2352740224 (2243.75 GiB 2409.21 GB)
Marcus>      Used Dev Size : 1176370112 (1121.87 GiB 1204.60 GB)
Marcus>       Raid Devices : 3
Marcus>      Total Devices : 3
Marcus>        Persistence : Superblock is persistent

Marcus>      Intent Bitmap : Internal

Marcus>        Update Time : Tue Jan 12 14:58:40 2021
Marcus>              State : clean
Marcus>     Active Devices : 3
Marcus>    Working Devices : 3
Marcus>     Failed Devices : 0
Marcus>      Spare Devices : 0

Marcus>             Layout : left-symmetric
Marcus>         Chunk Size : 64K

Marcus> Consistency Policy : bitmap

Marcus>               Name : lxcore:0  (local to host lxcore)
Marcus>               UUID : 0e3c432b:c68cda5b:0bf31e79:9dfe252b
Marcus>             Events : 80471

Marcus>     Number   Major   Minor   RaidDevice State
Marcus>        0       8       33        0      active sync   /dev/sdc1
Marcus>        1       8       17        1      active sync   /dev/sdb1
Marcus>        2       8       49        2      active sync   /dev/sdd1

Marcus> but the partitions are ok

Marcus> lxcore ~ # fdisk -l /dev/sdb1
Marcus> Disk /dev/sdb1: 9.1 TiB, 10000830283264 bytes, 19532871647 sectors
Marcus> Units: sectors of 1 * 512 = 512 bytes
Marcus> Sector size (logical/physical): 512 bytes / 4096 bytes
Marcus> I/O size (minimum/optimal): 4096 bytes / 4096 bytes

Marcus> same with sdc1 and sdd1
Marcus> Here is the problem:

Marcus> lxcore ~ # mdadm --examine /dev/sdb1
Marcus> /dev/sdb1:
Marcus>           Magic : a92b4efc
Marcus>         Version : 1.2
Marcus>     Feature Map : 0x1
Marcus>      Array UUID : 0e3c432b:c68cda5b:0bf31e79:9dfe252b
Marcus>            Name : lxcore:0  (local to host lxcore)
Marcus>   Creation Time : Sat Nov 10 23:04:14 2018
Marcus>      Raid Level : raid5
Marcus>    Raid Devices : 3

Marcus>  Avail Dev Size : 19532609759 (9313.87 GiB 10000.70 GB)
Marcus>      Array Size : 2352740224 (2243.75 GiB 2409.21 GB)
Marcus>   Used Dev Size : 2352740224 (1121.87 GiB 1204.60 GB)
Marcus>     Data Offset : 261888 sectors
Marcus>    Super Offset : 8 sectors
Marcus>    Unused Space : before=261800 sectors, after=17179869535 sectors
Marcus>           State : clean
Marcus>     Device UUID : a8fbe4dd:a7ac9c16:d1d29abd:e2a0d573

Marcus> Internal Bitmap : 8 sectors from superblock
Marcus>     Update Time : Tue Jan 12 14:58:40 2021
Marcus>   Bad Block Log : 512 entries available at offset 72 sectors
Marcus>        Checksum : 86f42300 - correct
Marcus>          Events : 80471

Marcus>          Layout : left-symmetric
Marcus>      Chunk Size : 64K

Marcus>    Device Role : Active device 1
Marcus>    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)

Marcus> same with /dev/sdc1 and /dev/sdd1
Marcus> It shows, that only 1121.68GB are used instead of the
Marcus> available 9.1TB, so the array size results in 2.2TB


Marcus> Will a simple
Marcus> mdadm --grow --size=max /dev/md0
Marcus> fix this and leave the data untouched?

Marcus> Any further advice?

Marcus> Have a nice day.

Marcus> marcus

Marcus> please CC me, I'm not subscribed.
