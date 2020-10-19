Return-Path: <SRS0=oHRY=D2=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C98C433DF
	for <linux-raid@archiver.kernel.org>; Mon, 19 Oct 2020 06:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7CF022263
	for <linux-raid@archiver.kernel.org>; Mon, 19 Oct 2020 06:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603088309;
	bh=wKpuJqtLejAYL1/cOYs8uVFSeuewCEtx062tOnUPBFI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=WQznp3BfFcd/PUmM43IfuN4AC7LNCGDZgUmOVuM41lGf8A46nALQpr6ZS2d+2DD5m
	 Z/9RlyCehF9CNFM+VSq1BMOuSU1L4/AoskspQnFD1NZwacrfDNCuXscoVI3zwD6zjX
	 oEe4v35Y182RwQMCU51qTvOlneoqELOcdH5UW4Wk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgJSGSZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgJSGSZ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 19 Oct 2020 02:18:25 -0400
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A6AA2225A;
        Mon, 19 Oct 2020 06:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603088304;
        bh=wKpuJqtLejAYL1/cOYs8uVFSeuewCEtx062tOnUPBFI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=y/J6T4loLP9EdxP94W3+SK+2kJMOxEOudgoxxqQe/jI0hfeQl8uob39vMceN7aq3K
         zcxwhP57XhondUyazh/tfqAJiGMVbHMwRNZ9aBL6BLNgTCQo7tE1sjaO7OsBFcb2RY
         7ZHqsIQixvicIZ2ScU1WC9RKDnL3P/3pl4gCwun8=
Received: by mail-lf1-f48.google.com with SMTP id a7so12693884lfk.9;
        Sun, 18 Oct 2020 23:18:24 -0700 (PDT)
X-Gm-Message-State: AOAM5333/ZoQBxXxPujknsNC+lhrVKJTebTnH4Yp/5YlCM3fCEDdk8M6
        RdLWAvt0H82x/1Zah0JYyVultM678u1L5/mk3zU=
X-Google-Smtp-Source: ABdhPJwKk/IhJUSPjlmgqhubcVjpH3v5MZtvWi+xOTHvDbupcZoakPgVCU8E2uQLb1yuLQWop4xYSXLcvj4phEqjU5k=
X-Received: by 2002:a19:c703:: with SMTP id x3mr4833030lff.105.1603088302460;
 Sun, 18 Oct 2020 23:18:22 -0700 (PDT)
MIME-Version: 1.0
References: <20201017110651.GA1602260@dragonet>
In-Reply-To: <20201017110651.GA1602260@dragonet>
From:   Song Liu <song@kernel.org>
Date:   Sun, 18 Oct 2020 23:18:11 -0700
X-Gmail-Original-Message-ID: <CAPhsuW583=org7AOR-W2vcQV3pTBxin2LG1tb3On=x6VtjXvxQ@mail.gmail.com>
Message-ID: <CAPhsuW583=org7AOR-W2vcQV3pTBxin2LG1tb3On=x6VtjXvxQ@mail.gmail.com>
Subject: Re: WARNING in md_ioctl
To:     "Dae R. Jeong" <dae.r.jeong@kaist.ac.kr>
Cc:     yjkwon@kaist.ac.kr, linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Oct 17, 2020 at 4:13 AM Dae R. Jeong <dae.r.jeong@kaist.ac.kr> wrote:
>
> Hi,
>
> I looked into the warning "WARNING in md_ioctl" found by Syzkaller.
> (https://syzkaller.appspot.com/bug?id=fbf9eaea2e65bfcabb4e2750c3ab0892867edea1)
> I suspect that it is caused by a race between two concurrenct ioctl()s as belows.
>
> CPU1 (md_ioctl())                          CPU2 (md_ioctl())
> ------                                     ------
> set_bit(MD_CLOSING, &mddev->flags);
> did_set_md_closing = true;
>                                            WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
>
> if(did_set_md_closing)
>     clear_bit(MD_CLOSING, &mddev->flags);
>
> If the above is correct, this warning is introduced
> in the commit 065e519e("md: MD_CLOSING needs to be cleared after called md_set_readonly or do_md_stop").
> Could you please take a look into this?

This is an interesting case. We try to protect against concurrent
ioctl via mddev->openers:

                if (mddev->pers && atomic_read(&mddev->openers) > 1) {
                        mutex_unlock(&mddev->open_mutex);
                        err = -EBUSY;
                        goto out;
                }

But in this case, we are sending multiple ioctl from the same fd, so
openers == 1.

We can probably do something like:

diff --git i/drivers/md/md.c w/drivers/md/md.c
index 6072782070230..49442a3f4605b 100644
--- i/drivers/md/md.c
+++ w/drivers/md/md.c
@@ -7591,8 +7591,10 @@ static int md_ioctl(struct block_device *bdev,
fmode_t mode,
                        err = -EBUSY;
                        goto out;
                }
-               WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
-               set_bit(MD_CLOSING, &mddev->flags);
+               if (test_and_set_bit(MD_CLOSING, &mddev->flags)) {
+                       err = -EBUSY;
+                       goto out;
+               }
                did_set_md_closing = true;
                mutex_unlock(&mddev->open_mutex);
                sync_blockdev(bdev);

Could you please test whether this fixes the issue?

Thanks,
Song
