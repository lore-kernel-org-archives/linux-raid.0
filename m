Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB01C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 14 Dec 2021 00:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242463AbhLNAgd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Dec 2021 19:36:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43086 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbhLNAgc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Dec 2021 19:36:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC963B81749
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 00:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89588C34605
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 00:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639442190;
        bh=fCRDfV2bQ/rWlJ8HAURfhz2cDep6RNh5PLvfaNX+uIg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=H0ppD52u3q7xHrPHf2ORvjDfbBa8EdJs152Ke95AF6yDNN2AGNpvsyPKhKEi56n3x
         nx+St6ZAc6LMKfRAtkQivkvcJW2T3Yv75IJeT90uejNuTSnI6CII7SzTRqLluOfhpk
         d+9LoOJeOCFQPO2T8yQhc5epPJRu0GolBlZr2oFZc8zTNgiJgsXDB4zpSb5pyPXEQg
         JMumbWfTXC/iUFJt7pw/5GiIRnG5S4xeTxODiyhlgP9TWUcPLILEpsIbnJiD/05Zyd
         lxtTpTTFviGDjtW1M32oH/73uAJJDKfFe1sofrer/tPBMd72bR7C3jufCDQUz/0zUo
         wNUhhFifet1Lg==
Received: by mail-yb1-f177.google.com with SMTP id v203so42465462ybe.6
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 16:36:30 -0800 (PST)
X-Gm-Message-State: AOAM532XptWF5jgZXodZs5ODHdR/IJpmbG+Ypmtp73ft0/xobFcMQYl0
        N3swf2s4cMl4IyAuhzHPy+JE9r2iMzDT+WHw8wE=
X-Google-Smtp-Source: ABdhPJyxLE9RUXsCLrViOZuqsnpeup8NZrPgo19VsdSMmHHxp1XkKriNeVspfZdb1G9OLOpz/hlx2eINsG5eb9aYD/Q=
X-Received: by 2002:a25:850b:: with SMTP id w11mr2239622ybk.208.1639442189610;
 Mon, 13 Dec 2021 16:36:29 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com> <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com>
 <2354ab61-0d13-aec5-a45f-23c5cd3db319@digitalocean.com> <CAPhsuW7r-JX+zOadzbzLDa0WxZdLws9=mTbPc0ci6qNfRBxgjA@mail.gmail.com>
 <998a933f-e3af-2f2c-79c6-ae5a75f286de@digitalocean.com>
In-Reply-To: <998a933f-e3af-2f2c-79c6-ae5a75f286de@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 13 Dec 2021 16:36:18 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7PcjJoN=uEv2G8wvCJmJJBdCW7o_V7e+aJrmkmwzTajA@mail.gmail.com>
Message-ID: <CAPhsuW7PcjJoN=uEv2G8wvCJmJJBdCW7o_V7e+aJrmkmwzTajA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Dec 13, 2021 at 2:43 PM Vishal Verma <vverma@digitalocean.com> wrote:
>
>
> On 12/12/21 10:56 PM, Song Liu wrote:
> > On Fri, Dec 10, 2021 at 10:26 AM Vishal Verma <vverma@digitalocean.com> wrote:
> >>
> >> On 12/9/21 7:16 PM, Song Liu wrote:
> >>> On Wed, Nov 10, 2021 at 10:15 AM Vishal Verma <vverma@digitalocean.com> wrote:
> >>>> Returns EAGAIN in case the raid456 driver would block
> >>>> waiting for situations like:
> >>>>
> >>>>     - Reshape operation,
> >>>>     - Discard operation.
> >>>>
> >>>> Signed-off-by: Vishal Verma <vverma@digitalocean.com>
> >>>> ---
> >>>>    drivers/md/raid5.c | 14 ++++++++++++++
> >>>>    1 file changed, 14 insertions(+)
> >>>>
> >>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >>>> index 9c1a5877cf9f..fa64ee315241 100644
> >>>> --- a/drivers/md/raid5.c
> >>>> +++ b/drivers/md/raid5.c
> >>>> @@ -5710,6 +5710,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
> >>>>                   int d;
> >>>>           again:
> >>>>                   sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
> >>>> +               /* Bail out if REQ_NOWAIT is set */
> >>>> +               if (bi->bi_opf & REQ_NOWAIT) {
> >>>> +                       bio_wouldblock_error(bi);
> >>>> +                       return;
> >>>> +               }
> >>> This is not right. raid5_get_active_stripe() gets refcount on the sh,
> >>> we cannot simply
> >>> return here. I think we need the logic after raid5_release_stripe()
> >>> and before schedule().
> >>>
> >>>>                   prepare_to_wait(&conf->wait_for_overlap, &w,
> >>>>                                   TASK_UNINTERRUPTIBLE);
> >>>>                   set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
> >>>> @@ -5820,6 +5825,15 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
> >>>>           bi->bi_next = NULL;
> >>>>
> >>>>           md_account_bio(mddev, &bi);
> >>>> +       /* Bail out if REQ_NOWAIT is set */
> >>>> +       if (bi->bi_opf & REQ_NOWAIT &&
> >>>> +           conf->reshape_progress != MaxSector &&
> >>>> +           mddev->reshape_backwards
> >>>> +           ? logical_sector < conf->reshape_safe
> >>>> +           : logical_sector >= conf->reshape_safe) {
> >>>> +               bio_wouldblock_error(bi);
> >>>> +               return true;
> >>>> +       }
> >>> This is also problematic, and is the trigger of those error messages.
> >>> We only want to trigger -EAGAIN when logical_sector is between
> >>> reshape_progress and reshape_safe.
> >>>
> >>> Just to clarify, did you mean doing something like:
> >>> if (bi->bi_opf & REQ_NOWAIT &&
> >>> +           conf->reshape_progress != MaxSector &&
> >>> +           (mddev->reshape_backwards
> >>> +           ? (logical_sector > conf->reshape_progress && logical_sector < conf->reshape_safe)
> >>> +           : logical_sector >= conf->reshape_safe)) {
> > I think this should be
> >    :   (logical_sector >= conf->reshape_safe && logical_sector <
> > conf->reshape_progress)
>
>
> if (bi->bi_opf & REQ_NOWAIT &&
>                  conf->reshape_progress != MaxSector &&
>                  (mddev->reshape_backwards
>                  ? (logical_sector > conf->reshape_progress &&
> logical_sector <= conf->reshape_safe)
>                  : (logical_sector >= conf->reshape_safe &&
> logical_sector < conf->reshape_progress))) {
>                          bio_wouldblock_error(bi);
>                          return true;
>          }
>
> After making this change along with other changes, I ran some tests with
> 100% reads, 70%read30%writes and 100% writes on a clean raid5 array.
>
> Unfortunately, I ran into this following task hung with 100% writes
> (with both libaio and io_uring):
>
> [21876.856692] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [21876.864518] task:md5_raid5       state:D stack:    0 pid:11675
> ppid:     2 flags:0x00004000
> [21876.864522] Call Trace:
> [21876.864526]  __schedule+0x2d4/0x970
> [21876.864532]  ? wbt_cleanup_cb+0x20/0x20
> [21876.864535]  schedule+0x4e/0xb0
> [21876.864537]  io_schedule+0x3f/0x70
> [21876.864539]  rq_qos_wait+0xb9/0x130
> [21876.864542]  ? sysv68_partition+0x280/0x280
> [21876.864543]  ? wbt_cleanup_cb+0x20/0x20
> [21876.864545]  wbt_wait+0x92/0xc0
> [21876.864546]  __rq_qos_throttle+0x25/0x40
> [21876.864548]  blk_mq_submit_bio+0xc6/0x5d0
> [21876.864551]  ? submit_bio_checks+0x39e/0x5f0
> [21876.864554]  __submit_bio+0x1bc/0x1d0
> [21876.864555]  ? kmem_cache_free+0x378/0x3c0
> [21876.864558]  ? mempool_free_slab+0x17/0x20
> [21876.864562]  submit_bio_noacct+0x256/0x2a0
> [21876.864565]  0xffffffffc01fa6d9
> [21876.864568]  ? 0xffffffffc01f5d01
> [21876.864569]  raid5_get_active_stripe+0x16c0/0x3e00 [raid456]
> [21876.864571]  ? __wake_up_common_lock+0x8a/0xc0
> [21876.864575]  raid5_get_active_stripe+0x2839/0x3e00 [raid456]
> [21876.864577]  raid5_get_active_stripe+0x2d6e/0x3e00 [raid456]
> [21876.864579]  md_thread+0xae/0x170
> [21876.864581]  ? wait_woken+0x60/0x60
> [21876.864582]  ? md_start_sync+0x60/0x60
> [21876.864584]  kthread+0x127/0x150
> [21876.864586]  ? set_kthread_struct+0x40/0x40
> [21876.864588]  ret_from_fork+0x1f/0x30

While there is something suspicious with raid10_handle_discard(), I don't
think it is related to this error. I couldn't reproduce this in my tests.

Thanks,
Song
