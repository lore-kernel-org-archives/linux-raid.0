Return-Path: <SRS0=oHRY=D2=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9099EC433DF
	for <linux-raid@archiver.kernel.org>; Mon, 19 Oct 2020 07:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E3D222203
	for <linux-raid@archiver.kernel.org>; Mon, 19 Oct 2020 07:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbgJSHD2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Oct 2020 03:03:28 -0400
Received: from smtp2.kaist.ac.kr ([143.248.5.229]:55709 "EHLO
        smtp2.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgJSHD1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Oct 2020 03:03:27 -0400
Received: from unknown (HELO mail1.kaist.ac.kr) (143.248.5.69)
        by 143.248.5.229 with ESMTP; 19 Oct 2020 16:03:18 +0900
X-Original-SENDERIP: 143.248.5.69
X-Original-MAILFROM: dae.r.jeong@kaist.ac.kr
X-Original-RCPTTO: linux-raid@vger.kernel.org
Received: from kaist.ac.kr (143.248.133.220)
        by kaist.ac.kr with ESMTP imoxion SensMail SmtpServer 7.0
        id <64f8815d385e48338e62a2fd4ede2b9d> from <dae.r.jeong@kaist.ac.kr>;
        Mon, 19 Oct 2020 16:03:20 +0900
Date:   Mon, 19 Oct 2020 16:03:19 +0900
From:   "Dae R. Jeong" <dae.r.jeong@kaist.ac.kr>
To:     Song Liu <song@kernel.org>
Cc:     yjkwon@kaist.ac.kr, linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: WARNING in md_ioctl
Message-ID: <20201019070319.GA1811280@dragonet>
References: <20201017110651.GA1602260@dragonet>
 <CAPhsuW583=org7AOR-W2vcQV3pTBxin2LG1tb3On=x6VtjXvxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW583=org7AOR-W2vcQV3pTBxin2LG1tb3On=x6VtjXvxQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> diff --git i/drivers/md/md.c w/drivers/md/md.c
> index 6072782070230..49442a3f4605b 100644
> --- i/drivers/md/md.c
> +++ w/drivers/md/md.c
> @@ -7591,8 +7591,10 @@ static int md_ioctl(struct block_device *bdev,
> fmode_t mode,
>                         err = -EBUSY;
>                         goto out;
>                 }
> -               WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
> -               set_bit(MD_CLOSING, &mddev->flags);
> +               if (test_and_set_bit(MD_CLOSING, &mddev->flags)) {
> +                       err = -EBUSY;
> +                       goto out;
> +               }
>                 did_set_md_closing = true;
>                 mutex_unlock(&mddev->open_mutex);
>                 sync_blockdev(bdev);
> 
> Could you please test whether this fixes the issue?

Since &mddev->open_mutex is held when testing a bit of mddev->flags, I
modified the code just a little bit by putting mutex_unlock() as
belows.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 98bac4f304ae..643f7f5be49b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7590,8 +7590,11 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 			err = -EBUSY;
 			goto out;
 		}
-		WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
-		set_bit(MD_CLOSING, &mddev->flags);
+		if (test_and_set_bit(MD_CLOSING, &mddev->flags)) {
+			mutex_unlock(&mddev->open_mutex);
+			err = -EBUSY;
+			goto out;
+		}
 		did_set_md_closing = true;
 		mutex_unlock(&mddev->open_mutex);
 		sync_blockdev(bdev);

The warning no longer recurs (of course, we removed
WARN_ON_ONCE()). As I am not familiar with this code, I do not see any
other problem.

Best regards,
Dae R. Jeong


