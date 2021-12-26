Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03293C433F5
	for <linux-raid@archiver.kernel.org>; Sun, 26 Dec 2021 00:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhLZAHS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 25 Dec 2021 19:07:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43138 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbhLZAHS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 25 Dec 2021 19:07:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B992C60D2C
        for <linux-raid@vger.kernel.org>; Sun, 26 Dec 2021 00:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A4DC36AEA
        for <linux-raid@vger.kernel.org>; Sun, 26 Dec 2021 00:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640477237;
        bh=P7fr6fl33fOCNEKNMJppJozkqvLohfECKgXV1vNccgk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ptc1yf9fbmWrAeqDQGR/cUyAoSeR/mZ7gyTYxtHGhKm3R8EuqJsZRinZqVjbVYIAZ
         oIV2Zr5n947Iw0QkaYAxFcFPUcpIO2cxIki2XyLJbADDXCMiIEWSKucZKrm42M/oPF
         buO+W5cEOHrsbiIKOEHKxJ5sDRGj8QIIhuJNQ6f1wYte/+j4k7/I8fG8hb/7M3tU7W
         u+74WCKYds2EfLEIQ6yISKRd8RWse5BIY6cfOSc9YmbgmYH9kJaPM3g1pAKhmmJ2f6
         uAz2IZ9n0P4MKLwWyckF3LpJUeefm8DKGILGuVVSO0Xfb7O/at6BiJc6ek7ny14eXd
         Btern7twninDg==
Received: by mail-yb1-f182.google.com with SMTP id m19so15797656ybf.9
        for <linux-raid@vger.kernel.org>; Sat, 25 Dec 2021 16:07:17 -0800 (PST)
X-Gm-Message-State: AOAM533vbUsyJahQeAV4YdoPs3VlhzS8XiS8hWTTnf2CQWsGwMhozM3J
        wsK/EWswUPxpr1zbfgWuI42aAqMMTbOFDxifcko=
X-Google-Smtp-Source: ABdhPJzP/6WMjvu1fUOueIHt3bWq8z9/Y8JTY+jgRaaJxV5VpN5MFEcicLVWCoIak/EnJivTB2HSJdqI7U1wtd8OW3g=
X-Received: by 2002:a25:3242:: with SMTP id y63mr246981yby.670.1640477236161;
 Sat, 25 Dec 2021 16:07:16 -0800 (PST)
MIME-Version: 1.0
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com> <20211221200622.29795-4-vverma@digitalocean.com>
 <CAPhsuW6ugK+6fcA9d4Jkx8+i9=1cMfrfJE7ZY4WH6TKrWLxP=g@mail.gmail.com>
 <aadc6d52-bc6e-527a-3b9c-0be225f9b727@digitalocean.com> <3306ef8e-88e0-74ec-4f7f-efca2605fc24@digitalocean.com>
In-Reply-To: <3306ef8e-88e0-74ec-4f7f-efca2605fc24@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Sat, 25 Dec 2021 16:07:03 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5m69F19w85N67WGSZfTgPfkgQv0zhYk7uGXwzkoAJh_w@mail.gmail.com>
Message-ID: <CAPhsuW5m69F19w85N67WGSZfTgPfkgQv0zhYk7uGXwzkoAJh_w@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] md: raid456 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, rgoldwyn@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Dec 25, 2021 at 2:13 PM Vishal Verma <vverma@digitalocean.com> wrote:
>
>
> On 12/25/21 12:28 AM, Vishal Verma wrote:
> >
> >
> > On 12/24/21 7:14 PM, Song Liu wrote:
> >> On Tue, Dec 21, 2021 at 12:06 PM Vishal Verma<vverma@digitalocean.com>  wrote:
> >>> Returns EAGAIN in case the raid456 driver would block
> >>> waiting for situations like:
> >>>
> >>>    - Reshape operation,
> >>>    - Discard operation.
> >>>
> >>> Signed-off-by: Vishal Verma<vverma@digitalocean.com>
> >> I think we will need the following fix for raid456:
> > Ack
> >> ============================ 8< ============================
> >>
> >> diff --git i/drivers/md/raid5.c w/drivers/md/raid5.c
> >> index 6ab22f29dacd..55d372ce3300 100644
> >> --- i/drivers/md/raid5.c
> >> +++ w/drivers/md/raid5.c
> >> @@ -5717,6 +5717,7 @@ static void make_discard_request(struct mddev
> >> *mddev, struct bio *bi)
> >>                          raid5_release_stripe(sh);
> >>                          /* Bail out if REQ_NOWAIT is set */
> >>                          if (bi->bi_opf & REQ_NOWAIT) {
> >> +                               finish_wait(&conf->wait_for_overlap, &w);
> >>                                  bio_wouldblock_error(bi);
> >>                                  return;
> >>                          }
> >> @@ -5734,6 +5735,7 @@ static void make_discard_request(struct mddev
> >> *mddev, struct bio *bi)
> >>                                  raid5_release_stripe(sh);
> >>                                  /* Bail out if REQ_NOWAIT is set */
> >>                                  if (bi->bi_opf & REQ_NOWAIT) {
> >> +
> >> finish_wait(&conf->wait_for_overlap, &w);
> >>                                          bio_wouldblock_error(bi);
> >>                                          return;
> >>                                  }
> >> @@ -5829,7 +5831,6 @@ static bool raid5_make_request(struct mddev
> >> *mddev, struct bio * bi)
> >>          last_sector = bio_end_sector(bi);
> >>          bi->bi_next = NULL;
> >>
> >> -       md_account_bio(mddev, &bi);
> >>          /* Bail out if REQ_NOWAIT is set */
> >>          if ((bi->bi_opf & REQ_NOWAIT) &&
> >>              (conf->reshape_progress != MaxSector) &&
> >> @@ -5837,9 +5838,11 @@ static bool raid5_make_request(struct mddev
> >> *mddev, struct bio * bi)
> >>              ? (logical_sector > conf->reshape_progress &&
> >> logical_sector <= conf->reshape_safe)
> >>              : (logical_sector >= conf->reshape_safe && logical_sector
> >> < conf->reshape_progress))) {
> >>                  bio_wouldblock_error(bi);
> >> +               if (rw == WRITE)
> >> +                       md_write_end(mddev);
> >>                  return true;
> >>          }
> >> -
> >> +       md_account_bio(mddev, &bi);
> >>          prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
> >>          for (; logical_sector < last_sector; logical_sector +=
> >> RAID5_STRIPE_SECTORS(conf)) {
> >>                  int previous;
> >>
> >> ============================ 8< ============================
> >>
> >> Vishal, please try to trigger all these conditions (including raid1,
> >> raid10) and make sure
> >> they work properly.
> >>
> >> For example, I triggered raid5 reshape and used something like the
> >> following to make
> >> sure the logic is triggered:
> >>
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index 55d372ce3300..e79de48a0027 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -5840,6 +5840,11 @@ static bool raid5_make_request(struct mddev
> >> *mddev, struct bio * bi)
> >>                  bio_wouldblock_error(bi);
> >>                  if (rw == WRITE)
> >>                          md_write_end(mddev);
> >> +               {
> >> +                       static int count = 0;
> >> +                       if (count++ < 10)
> >> +                               pr_info("%s REQ_NOWAIT return\n", __func__);
> >> +               }
> >>                  return true;
> >>          }
> >>          md_account_bio(mddev, &bi);
> >>
> >> Thanks,
> >> Song
> >>
> > Sure, will try this and verify for raid1/10.

Please also try test raid5 with discard. I haven't tested those two
conditions yet.

> I am running into an issue during raid10 reshape. I can see the nowait
> code getting triggered during reshape, but it seems like the reshape
> operation was stuck as soon as I issued write IO using FIO to the array
> during reshape.
> FIO also seem stuck i.e no IO went through...

Maybe the following could fix it?

Thanks,
Song

diff --git i/drivers/md/raid10.c w/drivers/md/raid10.c
index e2c524d50ec0..291eceaeb26c 100644
--- i/drivers/md/raid10.c
+++ w/drivers/md/raid10.c
@@ -1402,14 +1402,14 @@ static void raid10_write_request(struct mddev
*mddev, struct bio *bio,
             : (bio->bi_iter.bi_sector + sectors > conf->reshape_safe &&
                bio->bi_iter.bi_sector < conf->reshape_progress))) {
                /* Need to update reshape_position in metadata */
-               mddev->reshape_position = conf->reshape_progress;
-               set_mask_bits(&mddev->sb_flags, 0,
-                             BIT(MD_SB_CHANGE_DEVS) |
BIT(MD_SB_CHANGE_PENDING));
-               md_wakeup_thread(mddev->thread);
                if (bio->bi_opf & REQ_NOWAIT) {
                        bio_wouldblock_error(bio);
                        return;
                }
+               mddev->reshape_position = conf->reshape_progress;
+               set_mask_bits(&mddev->sb_flags, 0,
+                             BIT(MD_SB_CHANGE_DEVS) |
BIT(MD_SB_CHANGE_PENDING));
+               md_wakeup_thread(mddev->thread);
                raid10_log(conf->mddev, "wait reshape metadata");
                wait_event(mddev->sb_wait,
                           !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
