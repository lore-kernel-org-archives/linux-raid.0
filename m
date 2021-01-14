Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B396C433E0
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jan 2021 08:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CB93239FD
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jan 2021 08:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbhANInr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Jan 2021 03:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbhANInr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Jan 2021 03:43:47 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE688C061575
        for <linux-raid@vger.kernel.org>; Thu, 14 Jan 2021 00:43:06 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 3so3916552wmg.4
        for <linux-raid@vger.kernel.org>; Thu, 14 Jan 2021 00:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=OlKUHninUCEzulEZ5xwf2e5LW4bK+sizfnjn5E8/OEQ=;
        b=s8AGr6Mn/1JEuSpVCn3Zrf4cwBlq2yaOLfzjq5xW36/OLK8vLByVXiQ8ABHakwEeDq
         pNEuOAKL3Ilp4w66xJBPJFfVqAs3rV5V3SCKc+Lg8ixN1C/Yw5yRlPDnje2SM9KqJ244
         txGz7HTyplevNDsZC117juF+uEjGdMeYPGJQ6fAuJ3NOgPt0D/HMC0Yf+ppq3Q/lF8WS
         FRI8PezdHparNTJnnDb/eoKmmL+OwszCubVzQQdQJEVhC8Kpj0FQ/id1NxYly1QLM0u5
         VTeJxUqF3t0kinpB5z/OAnOvBqfvkmi2CIuDG6KYarqMeV4IYm5SpuFUo9SQvMgwd3q1
         Epig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OlKUHninUCEzulEZ5xwf2e5LW4bK+sizfnjn5E8/OEQ=;
        b=loyi1yp8A6YBnSWBTE99y5QWeCDqGO9ZV+HXnW6z2iurR+maqXSd6h2LWGhI7aFRf4
         bwc3jKQp1PnjmC/lo22PIOiJT7TjTTNO6IV7JBVM9stIpNupzCd16Pn1nImh8Wa4L08y
         3AD2aovT6BMLDu0bV2FdSfcXIZdbLIDD0hmm/ISIbGnSbLEwRQzrI4ouNEO6YdgDidHx
         FNJyXrl4VUlkFWSwJBipYxZxobSZYVjQbALWpVFPaLCLmXi+VIhVjYghNAdeO1UmBGc/
         UZNvmBp7By/jZAL4HwDkKrRs25nXrt1HFM7qkSZ4zmkNTiDrpUx7qGOm2QSLKh+FzQtZ
         B6WA==
X-Gm-Message-State: AOAM532jO13pjuibkG1dMme6X2/uTcm1Kt0aQr7+q4/INVYjyfFMOl2h
        UDuiCZFEAAXXQuR/UYfje8Ndl3u+r8x+xEBPe4oqMeGhzSs=
X-Google-Smtp-Source: ABdhPJyxhvbTGLmpBpdETNp0Ghk9Ci8Y388tRFNqbtbqsXAhuENAmqIVzeuNVaTtAh8w6WMSPGcuzEgnMgME/ao5EIs=
X-Received: by 2002:a1c:6283:: with SMTP id w125mr2794723wmb.155.1610613785309;
 Thu, 14 Jan 2021 00:43:05 -0800 (PST)
MIME-Version: 1.0
From:   Marcus Lell <marcus.lell@gmail.com>
Date:   Thu, 14 Jan 2021 09:42:56 +0100
Message-ID: <CAM7EtNjpS3yr=3XtGkgfc3=L=fSfqJW7P8mSZ__+L7fwjLu8eA@mail.gmail.com>
Subject: raid5 size reduced after system reinstall, how to fix?
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

after reinstalling gentoo on my main system,
I had to find out, that my clean raid5 has been resized
from ca. 18,2TB to ca. 2,2 TB
.
I don't have any clue, why..

First, the array gets assembled successfully.

lxcore ~ # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[2] sdb1[1] sdc1[0]
      2352740224 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 0/9 pages [0KB], 65536KB chunk

unused devices: <none>

lxcore ~ # mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sat Nov 10 23:04:14 2018
        Raid Level : raid5
        Array Size : 2352740224 (2243.75 GiB 2409.21 GB)
     Used Dev Size : 1176370112 (1121.87 GiB 1204.60 GB)
      Raid Devices : 3
     Total Devices : 3
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Tue Jan 12 14:58:40 2021
             State : clean
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 64K

Consistency Policy : bitmap

              Name : lxcore:0  (local to host lxcore)
              UUID : 0e3c432b:c68cda5b:0bf31e79:9dfe252b
            Events : 80471

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       17        1      active sync   /dev/sdb1
       2       8       49        2      active sync   /dev/sdd1

but the partitions are ok

lxcore ~ # fdisk -l /dev/sdb1
Disk /dev/sdb1: 9.1 TiB, 10000830283264 bytes, 19532871647 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes

same with sdc1 and sdd1
Here is the problem:

lxcore ~ # mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 0e3c432b:c68cda5b:0bf31e79:9dfe252b
           Name : lxcore:0  (local to host lxcore)
  Creation Time : Sat Nov 10 23:04:14 2018
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 19532609759 (9313.87 GiB 10000.70 GB)
     Array Size : 2352740224 (2243.75 GiB 2409.21 GB)
  Used Dev Size : 2352740224 (1121.87 GiB 1204.60 GB)
    Data Offset : 261888 sectors
   Super Offset : 8 sectors
   Unused Space : before=261800 sectors, after=17179869535 sectors
          State : clean
    Device UUID : a8fbe4dd:a7ac9c16:d1d29abd:e2a0d573

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Jan 12 14:58:40 2021
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 86f42300 - correct
         Events : 80471

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)

same with /dev/sdc1 and /dev/sdd1
It shows, that only 1121.68GB are used instead of the
available 9.1TB, so the array size results in 2.2TB


Will a simple
mdadm --grow --size=max /dev/md0
fix this and leave the data untouched?

Any further advice?

Have a nice day.

marcus

please CC me, I'm not subscribed.
