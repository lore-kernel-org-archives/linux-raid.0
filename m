Return-Path: <SRS0=HOAI=D5=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40781C4363A
	for <linux-raid@archiver.kernel.org>; Thu, 22 Oct 2020 00:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E96BC2417D
	for <linux-raid@archiver.kernel.org>; Thu, 22 Oct 2020 00:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507458AbgJVAY4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:24:56 -0400
Received: from smtp2.kaist.ac.kr ([143.248.5.229]:42338 "EHLO
        smtp2.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507464AbgJVAY4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Oct 2020 20:24:56 -0400
Received: from unknown (HELO mail1.kaist.ac.kr) (143.248.5.247)
        by 143.248.5.229 with ESMTP; 22 Oct 2020 09:24:47 +0900
X-Original-SENDERIP: 143.248.5.247
X-Original-MAILFROM: dae.r.jeong@kaist.ac.kr
X-Original-RCPTTO: linux-raid@vger.kernel.org
Received: from kaist.ac.kr (143.248.133.220)
        by kaist.ac.kr with ESMTP imoxion SensMail SmtpServer 7.0
        id <c11218c1806a4492b2d5232b18478074> from <dae.r.jeong@kaist.ac.kr>;
        Thu, 22 Oct 2020 09:24:46 +0900
Date:   Thu, 22 Oct 2020 09:24:46 +0900
From:   "Dae R. Jeong" <dae.r.jeong@kaist.ac.kr>
To:     Song Liu <song@kernel.org>
Cc:     yjkwon@kaist.ac.kr, linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: WARNING in md_ioctl
Message-ID: <20201022002446.GB1811280@dragonet>
References: <20201017110651.GA1602260@dragonet>
 <CAPhsuW583=org7AOR-W2vcQV3pTBxin2LG1tb3On=x6VtjXvxQ@mail.gmail.com>
 <20201019070319.GA1811280@dragonet>
 <CAPhsuW4dR7_pgxg-696M34peSRTPhTmJgpokKr5qAMXd81damg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW4dR7_pgxg-696M34peSRTPhTmJgpokKr5qAMXd81damg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> > > diff --git i/drivers/md/md.c w/drivers/md/md.c
> > > index 6072782070230..49442a3f4605b 100644
> > > --- i/drivers/md/md.c
> > > +++ w/drivers/md/md.c
> > > @@ -7591,8 +7591,10 @@ static int md_ioctl(struct block_device *bdev,
> > > fmode_t mode,
> > >                         err = -EBUSY;
> > >                         goto out;
> > >                 }
> > > -               WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
> > > -               set_bit(MD_CLOSING, &mddev->flags);
> > > +               if (test_and_set_bit(MD_CLOSING, &mddev->flags)) {
> > > +                       err = -EBUSY;
> > > +                       goto out;
> > > +               }
> > >                 did_set_md_closing = true;
> > >                 mutex_unlock(&mddev->open_mutex);
> > >                 sync_blockdev(bdev);
> > >
> 
> Good catch! The fix looks good. Would you like to submit a patch for it?

Sure. I will send a patch soon.

Best regards,
Dae R. Jeong.


