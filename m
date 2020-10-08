Return-Path: <SRS0=hplT=DP=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71562C433E7
	for <linux-raid@archiver.kernel.org>; Thu,  8 Oct 2020 18:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DB79221FE
	for <linux-raid@archiver.kernel.org>; Thu,  8 Oct 2020 18:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pT5vKGMP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731297AbgJHSLp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Oct 2020 14:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731273AbgJHSLp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Oct 2020 14:11:45 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40618C0613D3
        for <linux-raid@vger.kernel.org>; Thu,  8 Oct 2020 11:11:45 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b1so2490291iot.4
        for <linux-raid@vger.kernel.org>; Thu, 08 Oct 2020 11:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=CSoXq+8L+uC2Fsay1hVylBa3yjr5bnHuLLVYJzuZ4aI=;
        b=pT5vKGMPtJ8Uu1GPdNg182aAorfrqDbkZNvk9nq43R+BMkMwkl8RCmSJClcMtqi1D8
         1sLlRVSNdcKtaJBFjjabLfw/1JIGfpFfe3Y/dQ8ptZ3ONr59BWTSz++BzaoAWcNwUdzK
         Y7THOwqhyOFuEyaTnDXUrN3zWGDUKvYtcbj9vdWSMJLlrcLad9evL4yGR/qiKWcLHPJW
         5aaXo/0Y9jtxJjRKtwHwxGsJTXAGQ2GpD574EMRJtmFwWJedx9N1PDJE3P86Q7LFF5/L
         2oJO7nZ1VUdnaer8JJDMixfNSrfiy6AUFTkag3CCXKS3DxHw5r/4xz2VXu0E0Ri2NLtl
         dIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=CSoXq+8L+uC2Fsay1hVylBa3yjr5bnHuLLVYJzuZ4aI=;
        b=pWEfhyYcFyeAV84NX0JINwqRh7omJO/B54Kh4aVoEZmvCquR/KPMos/WpUm8+oeArM
         IhJABD5I3Kiz6a1HkDj00mOnZUixCcWbw6mYv7Uic5km5AqPqDds3HHpMigKkHmcJB2+
         0yVYduPG01cM8UybInZCugpQ7czvQoVPNr6Ifk75jsF7RCis/QP3el05d6rG5aR7UnVd
         MKPhWilwEILyeMnJcPcQBXUqGWBQrTdy6vDhwgz8SJIGV1z2mDUnegPdnarWE3PjQ20Y
         7EZ7Utd7llJHU5Mq4c8PR6fo2EKyaPwxhvdw1cj1jvaRIu/FdYT/TMPIUCOHkQtrsa3c
         rNlg==
X-Gm-Message-State: AOAM533RmDR/aEoa5NWDhjYfomcz/Aaznn3p0pJlDLZ4NK8Nk93d9JJi
        q/ldcZxfoSmmjUFEHghV2x880Ozz4Fk9Tez+pigu5Q==
X-Google-Smtp-Source: ABdhPJzVlut/DlArUd8JRiXjai5dHk1kcamlui+SCoUrieIyqKit4kOehyULHhdcXTviwgnXEt638LyGUxQgcYISjOA=
X-Received: by 2002:a6b:b208:: with SMTP id b8mr6973090iof.36.1602180703879;
 Thu, 08 Oct 2020 11:11:43 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 8 Oct 2020 23:41:32 +0530
Message-ID: <CA+G9fYtwisRJtN4ht=ApeWc1jWssDok-7y2wee6Z0kzMP-atKg@mail.gmail.com>
Subject: [ Regressions ] linux next 20201008: blk_update_request: I/O error,
 dev sda, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0
To:     dm-devel@redhat.com, open list <linux-kernel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        drbd-dev@lists.linbit.com,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>, linux-raid@vger.kernel.org,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There are two major regressions noticed on linux next tag 20201008.
I will bisect this problem and get back to you.

1) qemu_i386 and qemu_x86 boot failed due to mount rootfs failing [1].

        Starting Remount Root and Kernel File Systems...
[    1.750740] ata1.00: WARNING: zero len r/w req
[    1.751423] ata1.00: WARNING: zero len r/w req
[    1.752361] ata1.00: WARNING: zero len r/w req
[    1.753400] ata1.00: WARNING: zero len r/w req
[    1.754447] ata1.00: WARNING: zero len r/w req
[    1.755529] ata1.00: WARNING: zero len r/w req
[    1.756630] sd 0:0:0:0: [sda] tag#0 FAILED Result:
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[    1.758622] sd 0:0:0:0: [sda] tag#0 CDB: Synchronize Cache(10) 35
00 00 00 00 00 00 00 00 00
[    1.760576] blk_update_request: I/O error, dev sda, sector 0 op
0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[    1.761534] Buffer I/O error on dev sda, logical block 0, lost sync
page write
[    1.764158] EXT4-fs (sda): I/O error while writing superblock


2) the devices boot pass but mkfs failed on x86_64, i386, arm64
Juno-r2 devices [2].

mkfs -t ext4 /dev/disk/by-id/ata-TOSHIBA_MG03ACA100_37O9KGL0F
[   72.159789] ata3.00: WARNING: zero len r/w req
[   72.164287] ata3.00: WARNING: zero len r/w req
[   72.168774] ata3.00: WARNING: zero len r/w req
[   72.168777] ata3.00: WARNING: zero len r/w req
[   72.168779] ata3.00: WARNING: zero len r/w req
[   72.168781] ata3.00: WARNING: zero len r/w req
[   72.168786] sd 2:0:0:0: [sda] tag#5 FAILED Result:
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[   72.168788] sd 2:0:0:0: [sda] tag#5 CDB: Synchronize Cache(10) 35
00 00 00 00 00 00 00 00 00
[   72.168791] blk_update_request: I/O error, dev sda, sector 0 op
0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

metadata:
  git branch: master
  git repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
  git commit: e4fb79c771fbe2e6fcb3cffa87d5823a9bbf3f10
  git describe: next-20201008
  make_kernelversion: 5.9.0-rc8
  kernel-config:
https://builds.tuxbuild.com/pOW-FELX2VUycejkuyiKZg/kernel.config


steps to reproduce:
--------------------------
1) qemu boot command:

/usr/bin/qemu-system-x86_64 -cpu host -enable-kvm -nographic -net
nic,model=virtio,macaddr=DE:AD:BE:EF:66:06 -net tap -m 1024 -monitor
none -kernel bzImage --append "root=/dev/sda  rootwait
console=ttyS0,115200" -hda
rpb-console-image-lkft-intel-corei7-64-20200723162342-41.rootfs.ext4
-m 4096 -smp 4 -nographic

2) boot x86_64 with linux next 20201008 tag kernel and attach SDD drive.

mkfs -t ext4 /dev/<drive-partition>

Full log links,
[1 ]https://lkft.validation.linaro.org/scheduler/job/1823906#L688
[2] https://lkft.validation.linaro.org/scheduler/job/1823938#L2065


-- 
Linaro LKFT
https://lkft.linaro.org
