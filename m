Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00512C4743E
	for <linux-raid@archiver.kernel.org>; Mon,  7 Jun 2021 03:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1EBB61107
	for <linux-raid@archiver.kernel.org>; Mon,  7 Jun 2021 03:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhFGDKu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Jun 2021 23:10:50 -0400
Received: from mail-qv1-f44.google.com ([209.85.219.44]:35524 "EHLO
        mail-qv1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhFGDKs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Jun 2021 23:10:48 -0400
Received: by mail-qv1-f44.google.com with SMTP id q6so8148673qvb.2
        for <linux-raid@vger.kernel.org>; Sun, 06 Jun 2021 20:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=HguK/6EecZTnuuanHE52uddo49Pb+9J/70+rt58uPuU=;
        b=YbZnEj2m3XVGaPOY+8gLV7cYxFanx3iGU40S4fLQzlFrVGokCKEmsdJmNcyJanrm3B
         RirWtvdNuBCgxzlTQVUB7mUqDi1bUeHUDIATiu9vy3MEllje3O5H4dC1VaDVi9345ilJ
         SRA1RmOTy/4c9JLEHaRQWkd7K8Klv4yw9ykELlMiXQDcaE1P4Z0lymDiGXY5+TYlPMCQ
         0QlhmeVNb1b3zExuEpOEd8CFYgt2nuBvXf2sHISlRgKBgF8ojLjr2UQkR/JKihYnzaqu
         de3OQrHfrTRsST3M902PN0Zts32HN9Fb+HpXGZBg7MD4r0fHRjgcAcsXnCESi2WGZrjk
         tAZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=HguK/6EecZTnuuanHE52uddo49Pb+9J/70+rt58uPuU=;
        b=AGe3m32dSxIeENETTlyfHptMpQw1yiffhpwL+CzrZm4RW9RzhhQjqntJrMucY6um4H
         lpBkShe9xv+JATWfDLBDPjaDiPYhU8zTpx0i/74MfUiZKxupf1aAnwewrzAvTSAZcC7C
         7JIz8pJ+8woK8l2WZPuxqSEmMnCEkN8rfffq728VoqDhySw9QeCQH9I8F0ayOgcQ+/GU
         CHLCFIMN0tNcJLJuNccgU7pb+9B4cICz8dbOesXRH8x7Dz7JpsIS2DnTAioiFn7uvkMN
         yB+ro6J7+HkA0MaNX3hJuMTG1bdufOtvx68YHYSIti038qknO2VeCTkNdTagSKGnfsTA
         Jn2g==
X-Gm-Message-State: AOAM5338yPu34pFtnchkIsl6uoSI5ZUNmSDlAyY406Do8ub/Shmtr1Dp
        3WUMft9ADKU+ajjNVsCVFGifi2kfZHNt
X-Google-Smtp-Source: ABdhPJw++BcudTIHDsJ/lVULcXuj7l5jnLNy84czGD+3Ype1/IDKUw0qa02LQXF24nGdw2tvbqIcqg==
X-Received: by 2002:a0c:e902:: with SMTP id a2mr16116688qvo.39.1623035262807;
        Sun, 06 Jun 2021 20:07:42 -0700 (PDT)
Received: from ?IPv6:2001:1284:f016:b99f:4ccb:254b:3fb5:79ba? ([2001:1284:f016:b99f:4ccb:254b:3fb5:79ba])
        by smtp.gmail.com with ESMTPSA id 137sm8012522qko.29.2021.06.06.20.07.40
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 20:07:41 -0700 (PDT)
To:     linux-raid@vger.kernel.org
From:   Carlos Maziero <carlos.maziero@gmail.com>
Subject: Recover from crash in RAID6 due to hardware failure
Message-ID: <bd617822-79bd-ce40-f50e-21d482570324@gmail.com>
Date:   Mon, 7 Jun 2021 00:07:39 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all,

My Synology NAS (a very old DS508) awaken this morning with a severe
disk failure: 3 out of 5 disks failed at once. It uses RAID 6, thus I'm
not able to gracefully recover the data using the standard Synology
tools. I disassembled the box, cleaned the SATA slots and all electric
plugs/sockets and the disks are being recognized again, but the RAID
volume displays as crashed and its data is not accessible.

The dmesg log shows this:

[   38.762338] md: md2 stopped.
[   38.799568] md: bind<sda3>
[   38.802723] md: bind<sdb3>
[   38.807089] md: bind<sdc3>
[   38.811295] md: bind<sdd3>
[   38.816123] md: bind<sde3>
[   38.818918] md: kicking non-fresh sdd3 from array!
[   38.823766] md: unbind<sdd3>
[   38.826649] md: export_rdev(sdd3)
[   38.829978] md: kicking non-fresh sdc3 from array!
[   38.834773] md: unbind<sdc3>
[   38.837653] md: export_rdev(sdc3)
[   38.840976] md: kicking non-fresh sdb3 from array!
[   38.845770] md: unbind<sdb3>
[   38.848650] md: export_rdev(sdb3)
[   38.851973] md: kicking non-fresh sda3 from array!
[   38.856767] md: unbind<sda3>
[   38.859657] md: export_rdev(sda3)
[   38.876922] raid5: device sde3 operational as raid disk 4
[   38.883676] raid5: allocated 5262kB for md2
[   38.899483] 4: w=1 pa=0 pr=5 m=2 a=2 r=5 op1=0 op2=0
[   38.904454] raid5: raid level 6 set md2 active with 1 out of 5
devices, algorithm 2
[   38.912141] RAID5 conf printout:
[   38.915366]  --- rd:5 wd:1
[   38.918071]  disk 4, o:1, dev:sde3
[   38.921544] md2: detected capacity change from 0 to 8987271954432
[   38.973111]  md2: unknown partition table

Naively, I searched a bit and found that I could add the disks back to
the array, and did this:

    mdadm /dev/md2 --fail /dev/sda3 --remove /dev/sda3
    mdadm /dev/md2 --add /dev/sda3
    mdadm /dev/md2 --fail /dev/sdb3 --remove /dev/sdb3
    mdadm /dev/md2 --add /dev/sdb3
    mdadm /dev/md2 --fail /dev/sdc3 --remove /dev/sdc3
    mdadm /dev/md2 --add /dev/sdc3
    mdadm /dev/md2 --fail /dev/sdd3 --remove /dev/sdd3
    mdadm /dev/md2 --add /dev/sdd3

However, the disks where added as spares and the volume remained
crashed. Now I'm afraid that such commands have erased metadata and made
things worse... :-(

Is there a way to reconstruct the array and to recover its data, at
least partially? (The most relevant data was backed up, but there are
some TB of movies and music that I would be glad to recover). The NAS
was mostly used for file reading (serving media files to the local network).

Contents of /proc/mdstat (after the commands above):

Personalities : [raid1] [linear] [raid0] [raid10] [raid6] [raid5] [raid4]
md2 : active raid6 sda3[0](S) sdb3[1](S) sdc3[2](S) sdd3[3](S) sde3[4]
      8776632768 blocks super 1.2 level 6, 64k chunk, algorithm 2 [5/1]
[____U]
     
md1 : active raid1 sda2[1] sdb2[2] sdc2[3] sdd2[0] sde2[4]
      2097088 blocks [5/5] [UUUUU]
     
md0 : active raid1 sda1[1] sdb1[2] sdc1[3] sdd1[0] sde1[4]
      2490176 blocks [5/5] [UUUUU]
     
unused devices: <none>

Output of mdadm --detail /dev/md2 (also after the commands above)

/dev/md2:
        Version : 1.2
  Creation Time : Sat Sep  5 12:46:57 2020
     Raid Level : raid6
     Array Size : 8776632768 (8370.05 GiB 8987.27 GB)
  Used Dev Size : 2925544256 (2790.02 GiB 2995.76 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Sun Jun  6 22:48:34 2021
          State : clean, FAILED
 Active Devices : 1
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 4

         Layout : left-symmetric
     Chunk Size : 64K

           Name : DiskStation:2  (local to host DiskStation)
           UUID : dcb32778:c99523d8:2efdeb61:54303019
         Events : 78

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       0        0        1      removed
       2       0        0        2      removed
       3       0        0        3      removed
       4       8       67        4      active sync   /dev/sde3

       0       8        3        -      spare   /dev/hda3
       1       8       19        -      spare   /dev/sdb3
       2       8       35        -      spare   /dev/hdc3
       3       8       51        -      spare   /dev/sdd3

Best regards and many thanks for any help!

Carlos

