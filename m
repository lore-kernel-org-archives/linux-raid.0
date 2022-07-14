Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F55C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jul 2022 16:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbiGNQ2r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Jul 2022 12:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239000AbiGNQ2l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Jul 2022 12:28:41 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AB7B1F4
        for <linux-raid@vger.kernel.org>; Thu, 14 Jul 2022 09:28:40 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id z1so864966plb.1
        for <linux-raid@vger.kernel.org>; Thu, 14 Jul 2022 09:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=51FMChkJehx7pHQ73T1R4wuQ3K5opuWy1ShYWSXgcLc=;
        b=2bg3ecZuRFVjrx0xZziz+wHecVVGRtdcCdgSMS92KHHiTPhlz0piUC25EoCFkiNcXD
         ZrtVuuscGJ3ZnZfBTgChXQnCFyfUBrhPX5e8M/zFNjSoVGmOABMfhOMMc1VXJeZde9yF
         rkhBC/zlk12GZPYcdOE70ojApWUfJrQ4v8wfHrqZpA5XAHgkgkqr0BJRHbcyKTV9uRWM
         yZunbnmee68SYkDf5V4/Nt2oZmzcf/IUmstH+wxkeEimDPJbvqE9p7Zx5YNXRPqCEw54
         Z8ZJSqV8x7AwD/xypaV8GyHoC46hA1ZkCv7+2DReyqjnduqQHonXixJQXYq22vERL21P
         m8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=51FMChkJehx7pHQ73T1R4wuQ3K5opuWy1ShYWSXgcLc=;
        b=0QB10yWYTSax+YsHWUS9iND+yl4yaitQ3dmqy/w2ho0FjXROFq7LGzYK/aeIqTPOCB
         0NtT63PtMxKk8YlgspsTTrkiWbzu5Vb+p6lW5MUcj2RAxuqwiR0wIUoMdP846Y0hhq0S
         wYZ1wcnXxAr8DIqs+LFfZ5f09ki5at5qrKzaq0zlBonAYsF49T55n1n9Zo6tHsUlkwsJ
         vQAeKk+zR9S6LH1wgdYVso/N4dolds/LAuzfjjqVz5CCh95EFgikpJ35XxMgly+zaaP2
         MrRF45NNQ3XxJUDZTuA6YeF/2fe7siZ4vdLSAK9rKqcX0lM6th/Ap6C55j8WXdKYK6ih
         SExw==
X-Gm-Message-State: AJIora/6sK2QmXP0RzQOKRvsiNAtobOpx/HDgpQQFS47NFGDFJ7zbciU
        P1ZJ2PuMiEJq2ET3rnfwv46jXQ==
X-Google-Smtp-Source: AGRyM1sNF6svcWGxSuUx8Ka7ezTADczi0FQJjbOAHkM55oW99hTvyuSUoBOHMICbkM3Ftbz1hcJ25g==
X-Received: by 2002:a17:90b:3c4f:b0:1f0:b59f:8b86 with SMTP id pm15-20020a17090b3c4f00b001f0b59f8b86mr5752596pjb.225.1657816119680;
        Thu, 14 Jul 2022 09:28:39 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id mv2-20020a17090b198200b001f0ade18babsm2395855pjb.55.2022.07.14.09.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 09:28:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        jinpu.wang@ionos.com, christoph.boehmwalder@linbit.com,
        linux-raid@vger.kernel.org, song@kernel.org, mark@fasheh.com,
        tytso@mit.edu, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca, ocfs2-devel@oss.oracle.com,
        joseph.qi@linux.alibaba.com, jack@suse.com, haris.iqbal@ionos.com,
        jlbec@evilplan.org
In-Reply-To: <20220713055317.1888500-1-hch@lst.de>
References: <20220713055317.1888500-1-hch@lst.de>
Subject: Re: remove bdevname
Message-Id: <165781611803.623079.18294279066897804471.b4-ty@kernel.dk>
Date:   Thu, 14 Jul 2022 10:28:38 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 13 Jul 2022 07:53:08 +0200, Christoph Hellwig wrote:
> this series removes the final uses and the implementation of the bdevname()
> function.
> 
> Diffstat:
>  block/bdev.c                        |   10 ++---
>  block/blk-lib.c                     |    6 +--
>  block/genhd.c                       |   23 ------------
>  drivers/block/drbd/drbd_req.c       |    6 +--
>  drivers/block/pktcdvd.c             |   10 +----
>  drivers/block/rnbd/rnbd-srv-dev.c   |    1
>  drivers/block/rnbd/rnbd-srv-dev.h   |    1
>  drivers/block/rnbd/rnbd-srv-sysfs.c |    5 +-
>  drivers/block/rnbd/rnbd-srv.c       |    9 ++---
>  drivers/block/rnbd/rnbd-srv.h       |    3 -
>  drivers/md/md.c                     |    2 -
>  drivers/md/raid1.c                  |    2 -
>  drivers/md/raid10.c                 |    2 -
>  fs/ext4/mmp.c                       |    9 ++---
>  fs/jbd2/journal.c                   |    6 ++-
>  fs/ocfs2/cluster/heartbeat.c        |   64 ++++++++++++++++--------------------
>  include/linux/blkdev.h              |    1
>  kernel/trace/blktrace.c             |    4 +-
>  18 files changed, 62 insertions(+), 102 deletions(-)
> 
> [...]

Applied, thanks!

[1/9] block: stop using bdevname in bdev_write_inode
      commit: 5bf83e9a14ddae994d783dee96b91bf46f04839c
[2/9] block: stop using bdevname in __blkdev_issue_discard
      commit: 02ff3dd20f512cf811ae8028c44fdb212b5f2bf7
[3/9] drbd: stop using bdevname in drbd_report_io_error
      commit: 1b70ccecaed4c3c50239e8409156fb447f965554
[4/9] pktcdvd: stop using bdevname in pkt_seq_show
      commit: fa070a3b50a17506a230e72bd48dba89e7bb5fea
[5/9] pktcdvd: stop using bdevname in pkt_new_dev
      commit: beecf70ee84363e92f3bf783b74da5f26e765d8d
[6/9] rnbd-srv: remove the name field from struct rnbd_dev
      commit: 6e880cf59932a14bca128fc8e8faae0554932942
[7/9] ocfs2/cluster: remove the hr_dev_name field from struct o2hb_region
      commit: 4664954c9421ce326bb5c84f175902b03f17237e
[8/9] ext4: only initialize mmp_bdevname once
      commit: c5b045b9838972cc4c4985a32fa5d35ecf2ab15a
[9/9] block: remove bdevname
      commit: 900d156bac2bc474cf7c7bee4efbc6c83ec5ae58

Best regards,
-- 
Jens Axboe


