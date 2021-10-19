Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F90C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 08:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5838D6136F
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 08:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbhJSIDg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Oct 2021 04:03:36 -0400
Received: from out2.migadu.com ([188.165.223.204]:25221 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234595AbhJSIDH (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 19 Oct 2021 04:03:07 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634630437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=awFyg9JZxht9t2aSxlkReIe8+7ivtpDjrlqVRCr5/kE=;
        b=Z+4eURsnlyKcUFsiyDVfqbXSV2/22qOxSHBGd7hWMPdtBT0OulYUxGI8xRdyReuwuKwWTQ
        wKzN2XV62wh9oFBydAvxVwFua0OhMUrfe4C0YQNnuk81hRc00wcu1+orToMcd1Q0OAPwHo
        UOQKGrIuVQYuTSA+X2XaiVoKx3GmHCo=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH 3/3] md/raid10: factor out a get_error_dev helper
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20211017135019.27346-1-guoqing.jiang@linux.dev>
 <20211017135019.27346-4-guoqing.jiang@linux.dev>
 <CAPhsuW7x19D4bFXdVQRx6nVjs-w+x34e_MzMidAsQ4T1RXdXKA@mail.gmail.com>
Message-ID: <0c31ce7f-1ce9-60aa-ad61-a5320f61d49f@linux.dev>
Date:   Tue, 19 Oct 2021 16:00:30 +0800
MIME-Version: 1.0
In-Reply-To: <CAPhsuW7x19D4bFXdVQRx6nVjs-w+x34e_MzMidAsQ4T1RXdXKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 10/19/21 2:59 PM, Song Liu wrote:
> On Sun, Oct 17, 2021 at 6:50 AM Guoqing Jiang<guoqing.jiang@linux.dev>  wrote:
>> Add a helper to find error_dev in case handle_read_err is true.
>>
>> Signed-off-by: Guoqing Jiang<guoqing.jiang@linux.dev>
> For 2/3 and 3/3, I was thinking about something like below (only
> compile tested).
> Would this work?

Thanks for clarification, I guess it works.

> Thanks,
> Song
>
> diff --git i/drivers/md/raid10.c w/drivers/md/raid10.c
> index dde98f65bd04f..c2387f55343dd 100644
> --- i/drivers/md/raid10.c
> +++ w/drivers/md/raid10.c
> @@ -1116,7 +1116,7 @@ static void regular_request_wait(struct mddev
> *mddev, struct r10conf *conf,
>   }
>
>   static void raid10_read_request(struct mddev *mddev, struct bio *bio,
> -                               struct r10bio *r10_bio)
> +                               struct r10bio *r10_bio, struct md_rdev
> *err_rdev)
>   {
>          struct r10conf *conf = mddev->private;
>          struct bio *read_bio;
> @@ -1126,36 +1126,17 @@ static void raid10_read_request(struct mddev
> *mddev, struct bio *bio,
>          struct md_rdev *rdev;
>          char b[BDEVNAME_SIZE];
>          int slot = r10_bio->read_slot;
> -       struct md_rdev *err_rdev = NULL;
>          gfp_t gfp = GFP_NOIO;
>
> -       if (slot >= 0 && r10_bio->devs[slot].rdev) {
> -               /*
> -                * This is an error retry, but we cannot
> -                * safely dereference the rdev in the r10_bio,
> -                * we must use the one in conf.
> -                * If it has already been disconnected (unlikely)
> -                * we lose the device name in error messages.
> -                */
> -               int disk;
> -               /*
> -                * As we are blocking raid10, it is a little safer to
> -                * use __GFP_HIGH.
> -                */
> +       /*
> +        * As we are blocking raid10, it is a little safer to
> +        * use __GFP_HIGH.
> +        */
> +       if (err_rdev) {
>                  gfp = GFP_NOIO | __GFP_HIGH;
> -
> -               rcu_read_lock();
> -               disk = r10_bio->devs[slot].devnum;
> -               err_rdev = rcu_dereference(conf->mirrors[disk].rdev);
> -               if (err_rdev)
> -                       bdevname(err_rdev->bdev, b);
> -               else {
> -                       strcpy(b, "???");
> -                       /* This never gets dereferenced */
> -                       err_rdev = r10_bio->devs[slot].rdev;
> -               }
> -               rcu_read_unlock();
> -       }
> +               bdevname(err_rdev->bdev, b);
> +       } else
> +               strcpy(b, "???");
>
>          regular_request_wait(mddev, conf, bio, r10_bio->sectors);
>          rdev = read_balance(conf, r10_bio, &max_sectors);
> @@ -1519,7 +1500,7 @@ static void __make_request(struct mddev *mddev,
> struct bio *bio, int sectors)
>                          conf->geo.raid_disks);
>
>          if (bio_data_dir(bio) == READ)
> -               raid10_read_request(mddev, bio, r10_bio);
> +               raid10_read_request(mddev, bio, r10_bio, NULL);
>          else
>                  raid10_write_request(mddev, bio, r10_bio);
>   }
> @@ -2887,6 +2868,31 @@ static int narrow_write_error(struct r10bio
> *r10_bio, int i)
>          return ok;
>   }
>
> +static struct md_rdev *get_error_dev(struct mddev *mddev, struct
> r10conf *conf, int slot,
> +                                    struct r10bio *r10_bio)
> +{
> +       struct md_rdev *err_rdev = NULL;
> +

We need the original check ("slot >= 0 && r10_bio->devs[slot].rdev ")
in the function I think. Will take a closer look and send a new version.

Thanks,
Guoqing
