Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BC5C433FE
	for <linux-raid@archiver.kernel.org>; Fri,  3 Sep 2021 00:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A501260FDA
	for <linux-raid@archiver.kernel.org>; Fri,  3 Sep 2021 00:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhICA7T (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Sep 2021 20:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343838AbhICA7Q (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 2 Sep 2021 20:59:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0320B60FDA
        for <linux-raid@vger.kernel.org>; Fri,  3 Sep 2021 00:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630630697;
        bh=kuVPhlxMQfuMMZBIBDZamGerFY0U71zD5XGu+m2guyM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RENjiWCuE9MWM/0ByrmDDTQIuUh9yj/duyuAOBdmJIb43mPNy11Omuu4ge3upMW/N
         jSKMwiAtuDB9FmXiIgNq7fMML760Xd753X0HHGilRV5GJOVpfOwPLLHUBTh2qXLGo+
         4zTH2wms1xG7p0atDYEcv5XykwSQH8Bwkqy/m503S14c10HWwfTtlj65gPJ6qrkCSg
         gSA66S8zAc5oMmCZvZXgI7Fy2McM2+JMU6dda3MDXA8W+XXYU3bXdgTX5cvL4TqaWD
         h6xcORn4olDUyeyg6X2bejDqrbu84X6Nz/gTr3nTEgDeOMhF2kPvo09pIjLTDstM0g
         3aPEUHF4My5QQ==
Received: by mail-lf1-f41.google.com with SMTP id k13so8276885lfv.2
        for <linux-raid@vger.kernel.org>; Thu, 02 Sep 2021 17:58:16 -0700 (PDT)
X-Gm-Message-State: AOAM5324x3uoEubFSGsa+wFCsRFxwZX5f7PEUNq2K0riLy7S9DIqATdT
        4aGD6R8B/xBv6fIBhUvOfOmUpqDCC360czmnsJM=
X-Google-Smtp-Source: ABdhPJxv59K7hzi4llhrHYfW34kMlgMWeIrpSMetEwtb6cgytG6Kcgj3xNy37wYduPXfsg1c0I5dUYJuAQnkTOGxmB0=
X-Received: by 2002:a05:6512:25d:: with SMTP id b29mr667218lfo.261.1630630695430;
 Thu, 02 Sep 2021 17:58:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAFDAVznKiKC7YrCTJ4oj6NimXrhnY-=PUnJhFopw6Ur5LvOCjg@mail.gmail.com>
 <CAFDAVzmjGYsdgx0Yyn3n8NWVpAZQqmhBSneZY9fagV5PGTrgGw@mail.gmail.com> <CAPhsuW491s_6pEYRxHphgSAPVta=qPrsKXONvq03Xxv71BVx2g@mail.gmail.com>
In-Reply-To: <CAPhsuW491s_6pEYRxHphgSAPVta=qPrsKXONvq03Xxv71BVx2g@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 2 Sep 2021 17:58:04 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7R=8XyU5wU1-NT-Eo=Hir7gV_b7+_MB+bUFx3bEecbDw@mail.gmail.com>
Message-ID: <CAPhsuW7R=8XyU5wU1-NT-Eo=Hir7gV_b7+_MB+bUFx3bEecbDw@mail.gmail.com>
Subject: Re: Slow initial resync in RAID6 with 36 SAS drives
To:     Marcin Wanat <marcin.wanat@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Aug 31, 2021 at 10:19 PM Song Liu <song@kernel.org> wrote:
>
> On Wed, Aug 25, 2021 at 3:06 AM Marcin Wanat <marcin.wanat@gmail.com> wrote:
> >
> > On Thu, Aug 19, 2021 at 11:28 AM Marcin Wanat <marcin.wanat@gmail.com> wrote:
> > >
> > > Sorry, this will be a long email with everything I find to be relevant.
> > > I have a mdraid6 array with 36 hdd SAS drives each able to do
> > > >200MB/s, but I am unable to get more than 38MB/s resync speed on a
> > > fast system (48cores/96GB ram) with no other load.
> >
> > I have done a bit more research on 24 NVMe drives server and found
> > that resync speed bottleneck affect RAID6 with >16 drives:
>
> Sorry for the late response.
>
> This is interesting behavior. I don't really know why this is the case at the
> moment. Let me try to reproduce this first.
>
> Thanks,
> Song

The issue is caused by blk_plug logic. Something like the following should
fix it.

Marcin, could you please give it a try?

Thanks,
Song

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2c4ac51e54eba..fdb945be85753 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2251,7 +2251,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
                else
                        last = list_entry_rq(plug->mq_list.prev);

-               if (request_count >= BLK_MAX_REQUEST_COUNT || (last &&
+               if (request_count >= blk_plug_max_rq_count(plug) || (last &&
                    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
                        blk_flush_plug_list(plug, false);
                        trace_block_plug(q);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b5c033cf5f26f..2e3c07e959c14 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1239,6 +1239,13 @@ extern void blk_start_plug(struct blk_plug *);
 extern void blk_finish_plug(struct blk_plug *);
 extern void blk_flush_plug_list(struct blk_plug *, bool);

+static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
+{
+       if (plug->multiple_queues)
+               return BLK_MAX_REQUEST_COUNT * 4;
+       return BLK_MAX_REQUEST_COUNT;
+}
+
 static inline void blk_flush_plug(struct task_struct *tsk)
 {
        struct blk_plug *plug = tsk->plug;
