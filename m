Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096F0C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 06:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF78F61260
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 06:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhJSHB3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Oct 2021 03:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhJSHB2 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 19 Oct 2021 03:01:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E8DE61212
        for <linux-raid@vger.kernel.org>; Tue, 19 Oct 2021 06:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634626756;
        bh=UdCCcgNEWik0TG3mdn8L3Ua7autexDdpM0H8sX95zPo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=johwO0h290WRC6yiCRIzYRwb7cpsjFX0GunB+RhJI/MdKF+U3MPKG0BVG33godToh
         FTzj6WMVO7fXzP7fx1HG8qt5NGG2rXNH/YK8BqDC7M89k44cAYzwBDMPRx1rfcV5oE
         NVcemlIKp12ABkHarLaBQIP20/MkxWtsRXLtGQlj3RQFjlajBQCG4dixzi0lmCy0uw
         ULqHAF73e6x52d2yogU2dh8y29rfJ29C/RC/MEbPrGFNfwxVRraUUloijP9wvteitc
         k4jhWnOK1pfQUIa86FA2RvA9Q57lkaOkMbej1JVQvhcwXp4qqpTX8c7NUE1FO1WAs9
         hQD3tKFR5IfQw==
Received: by mail-lf1-f47.google.com with SMTP id y26so5167821lfa.11
        for <linux-raid@vger.kernel.org>; Mon, 18 Oct 2021 23:59:16 -0700 (PDT)
X-Gm-Message-State: AOAM533ZQQ5swQNo8j7OwynAPdD104UX5XRgCa6jcRn4Vt/ms4VUeUpI
        HPTbQ1zPC516gm71KhXtt4/6IlXIqLJwsSr7x8o=
X-Google-Smtp-Source: ABdhPJwNriYMxejKJeiYpE8p62bkonce4y0Puk+1Rtti3fyi8Lp/vT2MtDpx6Ya3UsCznnQ+SvNVZYjap6Zt256e0WI=
X-Received: by 2002:ac2:5d4b:: with SMTP id w11mr4510048lfd.676.1634626754464;
 Mon, 18 Oct 2021 23:59:14 -0700 (PDT)
MIME-Version: 1.0
References: <20211017135019.27346-1-guoqing.jiang@linux.dev> <20211017135019.27346-4-guoqing.jiang@linux.dev>
In-Reply-To: <20211017135019.27346-4-guoqing.jiang@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Mon, 18 Oct 2021 23:59:03 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7x19D4bFXdVQRx6nVjs-w+x34e_MzMidAsQ4T1RXdXKA@mail.gmail.com>
Message-ID: <CAPhsuW7x19D4bFXdVQRx6nVjs-w+x34e_MzMidAsQ4T1RXdXKA@mail.gmail.com>
Subject: Re: [PATCH 3/3] md/raid10: factor out a get_error_dev helper
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Oct 17, 2021 at 6:50 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> Add a helper to find error_dev in case handle_read_err is true.
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>

For 2/3 and 3/3, I was thinking about something like below (only
compile tested).
Would this work?

Thanks,
Song

diff --git i/drivers/md/raid10.c w/drivers/md/raid10.c
index dde98f65bd04f..c2387f55343dd 100644
--- i/drivers/md/raid10.c
+++ w/drivers/md/raid10.c
@@ -1116,7 +1116,7 @@ static void regular_request_wait(struct mddev
*mddev, struct r10conf *conf,
 }

 static void raid10_read_request(struct mddev *mddev, struct bio *bio,
-                               struct r10bio *r10_bio)
+                               struct r10bio *r10_bio, struct md_rdev
*err_rdev)
 {
        struct r10conf *conf = mddev->private;
        struct bio *read_bio;
@@ -1126,36 +1126,17 @@ static void raid10_read_request(struct mddev
*mddev, struct bio *bio,
        struct md_rdev *rdev;
        char b[BDEVNAME_SIZE];
        int slot = r10_bio->read_slot;
-       struct md_rdev *err_rdev = NULL;
        gfp_t gfp = GFP_NOIO;

-       if (slot >= 0 && r10_bio->devs[slot].rdev) {
-               /*
-                * This is an error retry, but we cannot
-                * safely dereference the rdev in the r10_bio,
-                * we must use the one in conf.
-                * If it has already been disconnected (unlikely)
-                * we lose the device name in error messages.
-                */
-               int disk;
-               /*
-                * As we are blocking raid10, it is a little safer to
-                * use __GFP_HIGH.
-                */
+       /*
+        * As we are blocking raid10, it is a little safer to
+        * use __GFP_HIGH.
+        */
+       if (err_rdev) {
                gfp = GFP_NOIO | __GFP_HIGH;
-
-               rcu_read_lock();
-               disk = r10_bio->devs[slot].devnum;
-               err_rdev = rcu_dereference(conf->mirrors[disk].rdev);
-               if (err_rdev)
-                       bdevname(err_rdev->bdev, b);
-               else {
-                       strcpy(b, "???");
-                       /* This never gets dereferenced */
-                       err_rdev = r10_bio->devs[slot].rdev;
-               }
-               rcu_read_unlock();
-       }
+               bdevname(err_rdev->bdev, b);
+       } else
+               strcpy(b, "???");

        regular_request_wait(mddev, conf, bio, r10_bio->sectors);
        rdev = read_balance(conf, r10_bio, &max_sectors);
@@ -1519,7 +1500,7 @@ static void __make_request(struct mddev *mddev,
struct bio *bio, int sectors)
                        conf->geo.raid_disks);

        if (bio_data_dir(bio) == READ)
-               raid10_read_request(mddev, bio, r10_bio);
+               raid10_read_request(mddev, bio, r10_bio, NULL);
        else
                raid10_write_request(mddev, bio, r10_bio);
 }
@@ -2887,6 +2868,31 @@ static int narrow_write_error(struct r10bio
*r10_bio, int i)
        return ok;
 }

+static struct md_rdev *get_error_dev(struct mddev *mddev, struct
r10conf *conf, int slot,
+                                    struct r10bio *r10_bio)
+{
+       struct md_rdev *err_rdev = NULL;
+
+       /*
+        * This is an error retry, but we cannot
+        * safely dereference the rdev in the r10_bio,
+        * we must use the one in conf.
+        * If it has already been disconnected (unlikely)
+        * we lose the device name in error messages.
+        */
+       int disk;
+
+       rcu_read_lock();
+       disk = r10_bio->devs[slot].devnum;
+       err_rdev = rcu_dereference(conf->mirrors[disk].rdev);
+       if (!err_rdev) {
+               /* This never gets dereferenced */
+               err_rdev = r10_bio->devs[slot].rdev;
+       }
+       rcu_read_unlock();
+       return err_rdev;
+}
+
 static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 {
        int slot = r10_bio->read_slot;
@@ -2918,7 +2924,8 @@ static void handle_read_error(struct mddev
*mddev, struct r10bio *r10_bio)
        rdev_dec_pending(rdev, mddev);
        allow_barrier(conf);
        r10_bio->state = 0;
-       raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
+       raid10_read_request(mddev, r10_bio->master_bio, r10_bio,
+                           get_error_dev(mddev, conf, slot, r10_bio));
 }

 static void handle_write_completed(struct r10conf *conf, struct
r10bio *r10_bio)
