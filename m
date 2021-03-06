Return-Path: <SRS0=ebs+=IE=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBD6C433DB
	for <linux-raid@archiver.kernel.org>; Sat,  6 Mar 2021 11:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B81406501A
	for <linux-raid@archiver.kernel.org>; Sat,  6 Mar 2021 11:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhCFLhg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 Mar 2021 06:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhCFLhH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 Mar 2021 06:37:07 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1109AC06175F
        for <linux-raid@vger.kernel.org>; Sat,  6 Mar 2021 03:37:05 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id r23so7827396ljh.1
        for <linux-raid@vger.kernel.org>; Sat, 06 Mar 2021 03:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=duqeVD3a9HSAI90yw70Sc+du0Yj++G9l3qMxJuOmJOs=;
        b=PMxQYrV5conwrmrmLlYaVQG6u+m18GSYJ/Ab9Vzk/2s1L2FRRIGjDDssXXyjh79VoH
         kSUEqA6fByBZ28ryA6/xh2wGuSgtOjukgBBCBF3M46SVWjx1SAdDPhfXgsV/RyQy/SiY
         QApEBBeGk8TGXEFUSP+sa5MQ+bZTn5T4gvaxh7mjVjLnZ+8TADNQtJUsXeG4CzCH5zwx
         y0vBogjCWuwchUiEx3OVGCl3tH3b2pq3JSWKhhWMJWO2eQ4y5SMsBBVX5qGe6HNcWYqN
         WgjPQfcO2jBTcOfZjjiX3eIff+erOsCmZstKYqGHboGQ9hE3XyDjEnxy8Ipev+0r3vpm
         bJ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=duqeVD3a9HSAI90yw70Sc+du0Yj++G9l3qMxJuOmJOs=;
        b=r3JIY6ui93yWGn6wU1MajMshclGzm2P8OSd6xzmSp/7xT68HRXzV0ZIM5DihMavEQ3
         sduz+EO6vRnVOBKFKpi9dZjRCIEodC8OTgsySCh7ZKP3lZKf38vKhb8IBftcSJhhd6U/
         FsXC8w0A93vStMO/aMOAwtaBmREMoJJvTbaS7aTgMRa4SmOL9YE32AvrEs+rLZiDAAhr
         EZMZ8yvpwnTX5J+3qVo5jAc+ot0WDTq9F9mLuw0ipTFGteqNPrxu6oHk/P4xtJZ5I2Np
         9Hfn3ZDyk6luJEx57IljXBnsvmrRh3XyqR8oZX2NMSe+xsbUVTY15H+lrXzCwrj8fwhx
         I20Q==
X-Gm-Message-State: AOAM532LZ0XehyfdBl+86PRGQBinXmRX9Mc0TZYW6da+TLMh8pZWU8iz
        n5iM4+1CJgs+WD+6UkdH9+qVxI+YCM00KpEFrl+HMEmL
X-Google-Smtp-Source: ABdhPJyE5OyIDDJGLIcgCppoVUL14gbihDVzY9uRzjXJhHAF47WavT6i793Oqhwv/VNRYTvxoPkVXZXaojf5z6xYvXc=
X-Received: by 2002:a2e:b8c9:: with SMTP id s9mr8189226ljp.187.1615030623263;
 Sat, 06 Mar 2021 03:37:03 -0800 (PST)
MIME-Version: 1.0
From:   apfc123@gmail.com
Date:   Sat, 6 Mar 2021 11:36:51 +0000
Message-ID: <CAPJ7j64RtvGb3=OFde+rDmeBA3GzqAKtpofvTnrhjkfm2m7ehw@mail.gmail.com>
Subject: Raid5 to Raid6 reshape stalled
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

Reshape is currently stalled at 58%. If I reboot the system, the array
is started in auto-read-only mode with resync pending. I can freeze
the sync and mount the filesystem read only to access the data.

When it first stalled and rebooted, I ran extended smart tests on all
18 drives and one came back with read error. I ddrescued it to a new
one (99.99% rescued) and swapped it out, but the reshape still stalls
immediately when setting the array to --readwrite.

The raid5 array started out with 12 drives. I added 6 more drives then
grew it to 18 drives and raid level 6 at the same time. This migration
was started with mdadm 4.1 running on kernel 4.19. I've tried booting
with debian testing running kernel 5.10 (didn't check mdadm version),
and also archlinux running 5.11 but with the same results.

/dev/md0:
           Version : 1.2
     Creation Time : Tue Dec 17 01:51:38 2019
        Raid Level : raid6
        Array Size : 42975736320 (40984.86 GiB 44007.15 GB)
     Used Dev Size : 3906885120 (3725.90 GiB 4000.65 GB)
      Raid Devices : 18
     Total Devices : 18
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Sat Mar  6 09:41:58 2021
             State : clean, degraded, resyncing (PENDING)
    Active Devices : 17
   Working Devices : 18
    Failed Devices : 0
     Spare Devices : 1

            Layout : left-symmetric-6
        Chunk Size : 512K

Consistency Policy : bitmap

     Delta Devices : 5, (13->18)
        New Layout : left-symmetric

              Name : debian:0  (local to host debian)
              UUID : 2a0d5568:ea53b429:30df79c9:e7559668
            Events : 303246

    Number   Major   Minor   RaidDevice State
       0       8      129        0      active sync   /dev/sdi1
       1       8       49        1      active sync   /dev/sdd1
       2       8      209        2      active sync   /dev/sdn1
       3       8        1        3      active sync   /dev/sda1
       4       8       65        4      active sync   /dev/sde1
       5       8      145        5      active sync   /dev/sdj1
       6      65       17        6      active sync   /dev/sdr1
       7       8      113        7      active sync   /dev/sdh1
       8      65        1        8      active sync   /dev/sdq1
       9       8       81        9      active sync   /dev/sdf1
      10       8       17       10      active sync   /dev/sdb1
      12       8      193       11      active sync   /dev/sdm1
      18       8      241       12      spare rebuilding   /dev/sdp1
      17       8      225       13      active sync   /dev/sdo1
      16       8      177       14      active sync   /dev/sdl1
      15       8      161       15      active sync   /dev/sdk1
      14       8       97       16      active sync   /dev/sdg1
      13       8       33       17      active sync   /dev/sdc1

One of the entries from dmesg the first time reshaping stalled:

[105003.994653] INFO: task md0_reshape:3296 blocked for more than 120 seconds.
[105003.994916]       Tainted: G          I       4.19.0-6-amd64 #1
Debian 4.19.67-2+deb10u1
[105003.995169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[105003.995434] md0_reshape     D    0  3296      2 0x80000000
[105003.995436] Call Trace:
[105003.995441]  ? __schedule+0x2a2/0x870
[105003.995442]  schedule+0x28/0x80
[105003.995448]  reshape_request+0x862/0x940 [raid456]
[105003.995451]  ? finish_wait+0x80/0x80
[105003.995454]  raid5_sync_request+0x34a/0x3b0 [raid456]
[105003.995460]  md_do_sync.cold.86+0x3f4/0x911 [md_mod]
[105003.995461]  ? finish_wait+0x80/0x80
[105003.995464]  ? __switch_to_asm+0x35/0x70
[105003.995467]  ? md_rdev_init+0xb0/0xb0 [md_mod]
[105003.995471]  md_thread+0x94/0x150 [md_mod]
[105003.995473]  kthread+0x112/0x130
[105003.995475]  ? kthread_bind+0x30/0x30
[105003.995476]  ret_from_fork+0x35/0x40

I'm not sure where to continue troubleshooting. Been moving drives
around in the storage appliance in case there are bad ports on the
backplane but doesn't seem to make any difference. I only have one
4-port HBA right now so can't even try another. The storage appliance
has 2 controllers and already tried swapping them as well as the SAS
cables. Only thing left I can try hardware wise is to install the
interposers that go in between the drives and the backplane but not
very hopeful.

Any help would be greatly appreciated. I don't have the extra space
right now to copy everything out and create a new array so really
hoping to get past this stalling issue. Thanks.
