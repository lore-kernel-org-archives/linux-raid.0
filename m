Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D626FC433ED
	for <linux-raid@archiver.kernel.org>; Fri,  9 Apr 2021 21:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A67DE61074
	for <linux-raid@archiver.kernel.org>; Fri,  9 Apr 2021 21:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhDIVlX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Apr 2021 17:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhDIVlW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Apr 2021 17:41:22 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0C1C061762
        for <linux-raid@vger.kernel.org>; Fri,  9 Apr 2021 14:41:09 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id u3so3425002qvj.8
        for <linux-raid@vger.kernel.org>; Fri, 09 Apr 2021 14:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rtbhouse.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=MhT4PqyIe/Ta5ohWw0KEmlZY50G56C57051+r4shXj8=;
        b=hWTQep5BGUFc9tsYAgBXA/M6FMHpnsNESSt6jV2jvNT/fL8At1c+Lb9tcK6L++zJEl
         /nbvQxVtD1dlvBQOrOhyoMsZlOnwJmSsozaQi8X9bfRrW+sWBdydEZZx1XzLrcdnznfR
         l7o98nRkb4SkLJdo8IitnA2I4SCOq3QLgY1anTpzkGOShKgmRVVH0dTh/9p40FqKtMws
         oE5CzjTKZevGLPLGQPqb/V5qbSAf8csQfrOQc0q9qtfW36Izb0O1dyORN9Cdi539iFVH
         Ob19egZvIyrqlemn32ncM6YTrJ2pwq27nTo8zeaoHRovqFr8MwhPzR24e5TiMY2Iy21c
         nqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=MhT4PqyIe/Ta5ohWw0KEmlZY50G56C57051+r4shXj8=;
        b=a0jccgcLG+T5b6iHDKk1DZfqGUnMP6EOQBddFwC0D0ln85VrhnnYnHNhpHthfTRh/5
         TdQ+5y1b53NoWvOnfGsZxpqM86NC/1gRjyZ8yDr3WL/gO8H47YA2f3HDZGl8Olv/Ngr3
         f/fbyWod5lBQFv0Noz07hUOeYynVKFOuM2vrNJPQ0yRDVFqEm/bz5blWfPQ7fKQPbYn7
         5UcwoEV3kYwm28kvsy0sYxkItxoGVlx3VRYCyk91lmZZoyh/Y1f9IBI8cmcg4NO7ZrnY
         tSRhZcdkTMbBysOvrzCEkS/uVfQAxy888NZgntQrqMOq2ZU1BZdFcs34HuWHJ9N5cSp6
         bk+Q==
X-Gm-Message-State: AOAM533mFd0erY663YTxkp4KC9di6VSWKoHA7DVAsi0vM5p8xDbtDyw7
        M+ViqAQcyZNV0OjV0M6miiPmlFY1yQ0jwqvLZBGpmQ==
X-Google-Smtp-Source: ABdhPJyoyilliipgYUHwtam2eUjfJ4oaMU/8sqVI6oajZMVw4C6TMs0tS1mu/i8UVJOt+xpzM/rksKxHTdeDH4eh70o=
X-Received: by 2002:ad4:4052:: with SMTP id r18mr8089527qvp.8.1618004468387;
 Fri, 09 Apr 2021 14:41:08 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Pawe=C5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>
Date:   Fri, 9 Apr 2021 23:40:52 +0200
Message-ID: <CADLTsw2OJtc30HyAHCpQVbbUyoD7P9bK-ZfaH+nrdZc+Je4b6g@mail.gmail.com>
Subject: PROBLEM: double fault in md_end_io
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

Two of my machines constantly crash with a double fault like this:

1146  <0>[33685.629591] traps: PANIC: double fault, error_code: 0x0
1147  <4>[33685.629593] double fault: 0000 [#1] SMP NOPTI
1148  <4>[33685.629594] CPU: 10 PID: 2118287 Comm: kworker/10:0
Tainted: P           OE     5.11.8-051108-generic #202103200636
1149  <4>[33685.629595] Hardware name: ASUSTeK COMPUTER INC. KRPG-U8
Series/KRPG-U8 Series, BIOS 4201 09/25/2020
1150  <4>[33685.629595] Workqueue: xfs-conv/md12 xfs_end_io [xfs]
1151  <4>[33685.629596] RIP: 0010:__slab_free+0x23/0x340
1152  <4>[33685.629597] Code: 4c fe ff ff 0f 1f 00 0f 1f 44 00 00 55
48 89 e5 41 57 49 89 cf 41 56 49 89 fe 41 55 41 54 49 89 f4 53 48 83
e4 f0 48 83 ec 70 <48> 89 54 24 28 0f 1f 44 00 00 41 8b 46 28 4d 8b 6c
24 20 49 8b 5c
1153  <4>[33685.629598] RSP: 0018:ffffa9bc00848fa0 EFLAGS: 00010086
1154  <4>[33685.629599] RAX: ffff94c04d8b10a0 RBX: ffff94437a34a880
RCX: ffff94437a34a880
1155  <4>[33685.629599] RDX: ffff94437a34a880 RSI: ffffcec745e8d280
RDI: ffff944300043b00
1156  <4>[33685.629599] RBP: ffffa9bc00849040 R08: 0000000000000001
R09: ffffffff82a5d6de
1157  <4>[33685.629600] R10: 0000000000000001 R11: 000000009c109000
R12: ffffcec745e8d280
1158  <4>[33685.629600] R13: ffff944300043b00 R14: ffff944300043b00
R15: ffff94437a34a880
1159  <4>[33685.629601] FS:  0000000000000000(0000)
GS:ffff94c04d880000(0000) knlGS:0000000000000000
1160  <4>[33685.629601] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1161  <4>[33685.629602] CR2: ffffa9bc00848f98 CR3: 000000014d04e000
CR4: 0000000000350ee0
1162  <4>[33685.629602] Call Trace:
1163  <4>[33685.629603]  <IRQ>
1164  <4>[33685.629603]  ? kfree+0x3bc/0x3e0
1165  <4>[33685.629603]  ? mempool_kfree+0xe/0x10
1166  <4>[33685.629603]  ? mempool_kfree+0xe/0x10
1167  <4>[33685.629604]  ? mempool_free+0x2f/0x80
1168  <4>[33685.629604]  ? md_end_io+0x4a/0x70
1169  <4>[33685.629604]  ? bio_endio+0xdc/0x130
1170  <4>[33685.629605]  ? bio_chain_endio+0x2d/0x40
1171  <4>[33685.629605]  ? md_end_io+0x5c/0x70
1172  <4>[33685.629605]  ? bio_endio+0xdc/0x130
1173  <4>[33685.629605]  ? bio_chain_endio+0x2d/0x40
1174  <4>[33685.629606]  ? md_end_io+0x5c/0x70
1175  <4>[33685.629606]  ? bio_endio+0xdc/0x130
1176  <4>[33685.629606]  ? bio_chain_endio+0x2d/0x40
1177  <4>[33685.629607]  ? md_end_io+0x5c/0x70
... repeated ...
1436  <4>[33685.629677]  ? bio_endio+0xdc/0x130
1437  <4>[33685.629677]  ? bio_chain_endio+0x2d/0x40
1438  <4>[33685.629677]  ? md_end_io+0x5c/0x70
1439  <4>[33685.629677]  ? bio_endio+0xdc/0x130
1440  <4>[33685.629678]  ? bio_chain_endio+0x2d/0x40
1441  <4>[33685.629678]  ? md_
1442  <4>[33685.629679] Lost 357 message(s)!

This happens on:
5.11.8-051108-generic #202103200636 SMP Sat Mar 20 11:17:32 UTC 2021
and on 5.8.0-44-generic #50~20.04.1-Ubuntu
(https://changelogs.ubuntu.com/changelogs/pool/main/l/linux/linux_5.8.0-44.=
50/changelog)
which contains backported
https://github.com/torvalds/linux/commit/41d2d848e5c09209bdb57ff9c0ca34075e=
22783d
("md: improve io stats accounting").
The 5.8.18-050818-generic #202011011237 SMP Sun Nov 1 12:40:15 UTC
2020 which does not contain above suspected change does not crash.

If there's a better way/place to report this bug just let me know. If
not, here are steps to reproduce:

1. Create a RAID 0 device using three Micron_9300_MTFDHAL7T6TDP disks.
mdadm --create --verbose /dev/md12 --level=3Dstripe --raid-devices=3D3
/dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1

2. Setup xfs on it:
mkfs.xfs /dev/md12 and mount it

3. Write to a file on this filesystem:
while true; do rm -rf /mnt/md12/crash* ; for i in `seq 8`; do dd
if=3D/dev/zero of=3D/mnt/md12/crash$i bs=3D32K count=3D50000000 & done; wai=
t;
done
Wait for a crash (usually less than 20 min).

I couldn't reproduce it with a single dd process (maybe I have to wait
a little longer), but a single cat
/very/large/file/on/cephfs/over100GbE > /mnt/md12/crash is enough for
this double fault to occur.

More info:
This long mempool_kfree - md_end_io - *  -md_end_io stack trace looks
always the same, but the panic occurs in different places:

pstore/6948115143318/dmesg.txt-<4>[545649.087998] CPU: 88 PID: 0 Comm:
swapper/88 Tainted: P           OE     5.11.8-051108-generic
#202103200636
pstore/6948377398316/dmesg.txt-<4>[11275.914909] CPU: 14 PID: 0 Comm:
swapper/14 Tainted: P           OE     5.11.8-051108-generic
#202103200636
pstore/6948532816002/dmesg.txt-<4>[33685.629594] CPU: 10 PID: 2118287
Comm: kworker/10:0 Tainted: P           OE     5.11.8-051108-generic
#202103200636
pstore/6948532816002/dmesg.txt-<4>[33685.629595] Workqueue:
xfs-conv/md12 xfs_end_io [xfs]
pstore/6948855849083/dmesg.txt-<4>[42934.321129] CPU: 85 PID: 0 Comm:
swapper/85 Tainted: P           OE     5.11.8-051108-generic
#202103200636
pstore/6948876331782/dmesg.txt-<4>[ 3475.020672] CPU: 86 PID: 0 Comm:
swapper/86 Tainted: P           OE     5.11.8-051108-generic
#202103200636
pstore/6949083860307/dmesg.txt-<4>[43048.254375] CPU: 45 PID: 0 Comm:
swapper/45 Tainted: P           OE     5.11.8-051108-generic
#202103200636
pstore/6949091775931/dmesg.txt-<4>[ 1150.790240] CPU: 64 PID: 0 Comm:
swapper/64 Tainted: P           OE     5.11.8-051108-generic
#202103200636
pstore/6949123356826/dmesg.txt-<4>[ 6963.858253] CPU: 6 PID: 51 Comm:
kworker/6:0 Tainted: P           OE     5.11.8-051108-generic
#202103200636
pstore/6949123356826/dmesg.txt-<4>[ 6963.858255] Workqueue: ceph-msgr
ceph_con_workfn [libceph]
pstore/6949123356826/dmesg.txt-<4>[ 6963.858253] CPU: 6 PID: 51 Comm:
kworker/6:0 Tainted: P           OE     5.11.8-051108-generic
#202103200636
pstore/6949123356826/dmesg.txt-<4>[ 6963.858255] Workqueue: ceph-msgr
ceph_con_workfn [libceph]
pstore/6949152322085/dmesg.txt-<4>[ 6437.077874] CPU: 59 PID: 0 Comm:
swapper/59 Tainted: P           OE     5.11.8-051108-generic
#202103200636

cat /proc/cmdline
BOOT_IMAGE=3D/vmlinuz-5.11.8-051108-generic
root=3D/dev/mapper/ubuntu--vg-ubuntu--lv ro net.ifnames=3D0 biosdevname=3D0
strict-devmem=3D0 mitigations=3Doff iommu=3Dpt

cat /proc/cpuinfo
model name      : AMD EPYC 7552 48-Core Processor

cat /proc/mounts
/dev/md12 /mnt/ssd1 xfs
rw,noatime,attr2,inode64,logbufs=3D8,logbsize=3D32k,sunit=3D1024,swidth=3D3=
072,prjquota
0 0

Let me know if you need more information.

Best regards,
Pawe=C5=82 Wiejacha
