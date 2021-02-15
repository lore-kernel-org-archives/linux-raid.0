Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F65DC433E0
	for <linux-raid@archiver.kernel.org>; Mon, 15 Feb 2021 21:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3107864E57
	for <linux-raid@archiver.kernel.org>; Mon, 15 Feb 2021 21:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhBOVb4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Feb 2021 16:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhBOVbt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 15 Feb 2021 16:31:49 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42044C0613D6
        for <linux-raid@vger.kernel.org>; Mon, 15 Feb 2021 13:31:05 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id w1so4395366ejk.6
        for <linux-raid@vger.kernel.org>; Mon, 15 Feb 2021 13:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ALVoxLKHJ3hi641D91jGiU18EAUA+ZLkvm+sDhMaFrg=;
        b=KEyw/vJ9F+btZMAX2DjUsHlXlLGH6Y1CbfzcOXmSWRYTl/zFE3ysZOhgmdDX64ZVo3
         9+gClM5gsth7qNBJr6LOmBBPMHI+3a6OM3IvOjO+4J/rsUdvQDMJuV6PQdYhbteGd0ef
         CkwHwyQde9A3qAmgcsqyn8pZYY3eUaVDi/Ro4kCfbL/cbBn/TaDez03rXF2KwKf82Yx1
         IKUGv9xx2UcVpZDmBOvPu9/Dc5vwWBAmgK8vx0beqku8pVIUv/QkFgIDcnZgCNvVgq2y
         gGWWIo4SSSQxIJ0YcYOI4WFgVUHJN8XDzNNG9GZYCQ+sKid8KYhYbMwa7+5gu2nqMlPw
         qxFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ALVoxLKHJ3hi641D91jGiU18EAUA+ZLkvm+sDhMaFrg=;
        b=eFrqidPXGKyTftxatCKJtipLg1vfSEhJJFbBiZRXHc4NZMPaI6OHYKWVyZAyXncyR1
         oU/rPLrnZrkexy1rQUCBPmNP5A9bthMxWqb7u8OLS3cCjBsEyWBCWDva1vf1IpBK3VPB
         K1z3gJR1NFlUjZoVIAQCAS9H2Eamz9tgPD6MvXdSFMnKma7SrmLUusKkLbGeROsIOwuM
         PA+gP/59R/H2igXQsPiEz+uN5fAClQA3yQyov9Mz0xKjzFMYm+5Ol+MQ+bBOHHf9vGC6
         tj6TAC0WgZvTxPBPx3minPnJ0OtugKvjAiRMRpZjpY9iulJzI8foaR7XSqPAEeFhNvd6
         pItw==
X-Gm-Message-State: AOAM531IJDPa6uYYepw73en3S328QwJM1SPv/fAq17j9w1YHBG9frW1u
        +kEszhqVjM4INF9wfvfDlUywedbLkkx6NrImtH+dWrXXgk8=
X-Google-Smtp-Source: ABdhPJy/Hxj2HENNKjgnbuNDO3eq3TcxOVyUyV6jykFnPf1dKJafIBcpN7HPbM7MH5l+HqUDoD83f/9Sfo+dUwQoGbE=
X-Received: by 2002:a17:906:798:: with SMTP id l24mr17664060ejc.92.1613424663624;
 Mon, 15 Feb 2021 13:31:03 -0800 (PST)
MIME-Version: 1.0
From:   "Michael D. O'Brien" <obrienmd@gmail.com>
Date:   Mon, 15 Feb 2021 13:31:01 -0800
Message-ID: <CACs3Z9oqWPRt4uT1pYKMHzH+7JHNtsk_stE_-OmQZSQsy4n46g@mail.gmail.com>
Subject: mdxxx_raid6 kernel thread frozen
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, I have a single mdadm raid6 in a 56-drive raid60 (7x8) with a
kernel thread stuck at 100% cpu. The stuck thread typically happens
during array checks, but is not the resync thread - md122_raid6 is at
100% cpu, whereas md122_resync is at ~0%. When this happens, the
reported sync speed drops until it reaches 4K/sec. Setting sync_action
to idle gets stuck.

iostat shows backing devices aren't doing anything i/o wise, SMART is
clean for all member drives, and dmesg doesn't say anything useful
(until the thread is hung for a long time, then it tells me as much -
I'll post that message when the current issue times out). A reboot
typically clears the issue, but takes quite a long time, as the raid
60 is the backing device for a bcache device (with an optane cache)
that has a large mounted xfs file system in place.

I figured I could strace the process, but I learned that's impossible
with kernel threads :)

Output of various things - please let me know what else I can run to
help track this down:

/prod/mdstat:
md118 : active raid0 md120[4] md119[5] md123[6] md125[3] md121[0]
md124[1] md122[2]
      410183875584 blocks super 1.2 3072k chunks
md119 : active raid6 sdbh[1] sdbi[2] sdan[4] sdbc[0] sdar[7] sdaq[6]
sdbe[8] sdao[5]
      58597828608 blocks super 1.2 level 6, 512k chunk, algorithm 2
[8/8] [UUUUUUUU]
md120 : active raid6 sdbd[7] sdat[1] sdaz[4] sday[3] sdau[2] sdba[5]
sdbb[6] sdas[0]
      58597828608 blocks super 1.2 level 6, 512k chunk, algorithm 2
[8/8] [UUUUUUUU]
md121 : active raid6 sdaj[5] sdag[2] sdal[7] sdai[4] sdae[0] sdak[6]
sdaf[1] sdah[3]
      58597828608 blocks super 1.2 level 6, 512k chunk, algorithm 2
[8/8] [UUUUUUUU]
md122 : active raid6 sdu[7] sdq[3] sdr[4] sdp[2] sdn[0] sdt[6] sds[5] sdo[1=
]
      58597828608 blocks super 1.2 level 6, 512k chunk, algorithm 2
[8/8] [UUUUUUUU]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>....]  check =3D 81=
.5% (7963280396/9766304768)
finish=3D147106.8min speed=3D204K/sec
md123 : active raid6 sdax[7] sdaw[6] sdav[5] sdap[4] sdy[3] sdc[0] sdd[1] s=
dh[2]
      58597828608 blocks super 1.2 level 6, 512k chunk, algorithm 2
[8/8] [UUUUUUUU]
md124 : active raid6 sdab[5] sdaa[4] sdad[7] sdz[3] sdv[0] sdx[2] sdac[6] s=
dw[1]
      58597828608 blocks super 1.2 level 6, 512k chunk, algorithm 2
[8/8] [UUUUUUUU]
md125 : active raid6 sde[0] sdam[7] sdg[2] sdbg[8] sdf[1] sdi[3] sdk[5] sdj=
[4]
      58597828608 blocks super 1.2 level 6, 512k chunk, algorithm 2
[8/8] [UUUUUUUU]

/proc/{PID of md122_raid6}/stack alternates between nothing and:
[<0>] ops_run_io+0x3e/0xdb0 [raid456]
[<0>] handle_stripe+0x144/0x1260 [raid456]
[<0>] handle_active_stripes.isra.0+0x3c5/0x5a0 [raid456]
[<0>] raid5d+0x35c/0x550 [raid456]
[<0>] md_thread+0x97/0x160
[<0>] kthread+0x114/0x150
[<0>] ret_from_fork+0x22/0x30

/proc/{PID of md122_raid6}/status:
Name:   md122_raid6
Umask:  0000
State:  R (running)
Tgid:   2167
Ngid:   0
Pid:    2167
PPid:   2
TracerPid:      0
Uid:    0       0       0       0
Gid:    0       0       0       0
FDSize: 64
Groups:
NStgid: 2167
NSpid:  2167
NSpgid: 0
NSsid:  0
Threads:        1
SigQ:   0/1031010
SigPnd: 0000000000000000
ShdPnd: 0000000000000000
SigBlk: 0000000000000000
SigIgn: fffffffffffffeff
SigCgt: 0000000000000100
CapInh: 0000000000000000
CapPrm: 000000ffffffffff
CapEff: 000000ffffffffff
CapBnd: 000000ffffffffff
CapAmb: 0000000000000000
NoNewPrivs:     0
Seccomp:        0
Speculation_Store_Bypass:       thread vulnerable
Cpus_allowed:   ffffff
Cpus_allowed_list:      0-23
Mems_allowed:
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,000=
00000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,000000=
00,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,=
00000000,00000000,00000000,00000000,00000000,00000000,00000003
Mems_allowed_list:      0-1
voluntary_ctxt_switches:        73369830
nonvoluntary_ctxt_switches:     29419786

/proc/{PID of md122_raid6}/stat:
2167 (md122_raid6) R 2 0 0 0 -1 2129984 0 0 0 0 0 5079064 0 0 20 0 1 0
1724 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483391 256 0 0 0 17 21
0 0 390998 0 0 0 0 0 0 0 0 0 0

mdadm -D {raid_60_device}:
/dev/md118:
           Version : 1.2
     Creation Time : Sun Apr  5 13:43:11 2020
        Raid Level : raid0
        Array Size : 410183875584 (391181.83 GiB 420028.29 GB)
      Raid Devices : 7
     Total Devices : 7
       Persistence : Superblock is persistent

       Update Time : Sun Apr  5 13:43:11 2020
             State : clean
    Active Devices : 7
   Working Devices : 7
    Failed Devices : 0
     Spare Devices : 0

            Layout : -unknown-
        Chunk Size : 3072K

Consistency Policy : none

              Name : host:all_spinners
              UUID : 74727e9d:8d3cd62a:48369430:dea1e4eb
            Events : 0

    Number   Major   Minor   RaidDevice State
       0       9      121        0      active sync   /dev/md/host:spinners=
_1
       1       9      124        1      active sync   /dev/md/host:spinners=
_2
       2       9      122        2      active sync   /dev/md/host:spinners=
_3
       3       9      125        3      active sync   /dev/md/host:spinners=
_4
       4       9      120        4      active sync   /dev/md/host:spinners=
_5
       5       9      119        5      active sync   /dev/md/host:spinners=
_6
       6       9      123        6      active sync   /dev/md/host:spinners=
_7

mdadm -D {md122, frozen device}:
/dev/md122:
           Version : 1.2
     Creation Time : Sat Apr  4 10:12:53 2020
        Raid Level : raid6
        Array Size : 58597828608 (55883.24 GiB 60004.18 GB)
     Used Dev Size : 9766304768 (9313.87 GiB 10000.70 GB)
      Raid Devices : 8
     Total Devices : 8
       Persistence : Superblock is persistent

       Update Time : Mon Feb 15 12:02:41 2021
             State : active, checking
    Active Devices : 8
   Working Devices : 8
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

      Check Status : 81% complete

              Name : host:spinners_3
              UUID : 331bc2af:3207b40c:983b923f:14fe1762
            Events : 5869

    Number   Major   Minor   RaidDevice State
       0       8      208        0      active sync   /dev/sdn
       1       8      224        1      active sync   /dev/sdo
       2       8      240        2      active sync   /dev/sdp
       3      65        0        3      active sync   /dev/sdq
       4      65       16        4      active sync   /dev/sdr
       5      65       32        5      active sync   /dev/sds
       6      65       48        6      active sync   /dev/sdt
       7      65       64        7      active sync   /dev/sdu
