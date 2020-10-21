Return-Path: <SRS0=jU3t=D4=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 560AAC561F8
	for <linux-raid@archiver.kernel.org>; Wed, 21 Oct 2020 05:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAA4121D7B
	for <linux-raid@archiver.kernel.org>; Wed, 21 Oct 2020 05:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603258134;
	bh=eC/8ejH9N5F4wrrvByVIBEvBYC/IQ0CVvBIej1Nl2Sg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=GetzUjGmJoAHDCzo+q9cW9SaFCRNXdQIyMyqrdmB4h15eqirDyDH9nS5oS/IWY/iU
	 OlUF0tplvv5m9IcNKfpTQRiq6bbGrX7JzlEkY8ToMF8iAUOEtAc9sL/BSval7R4ffl
	 eiHrWWbZZZX/B4gJGfn3UDlLkb1YWGaNLW0Cv/NA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407867AbgJUF2u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Oct 2020 01:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407832AbgJUF2u (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 21 Oct 2020 01:28:50 -0400
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B078921D7B;
        Wed, 21 Oct 2020 05:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603258129;
        bh=eC/8ejH9N5F4wrrvByVIBEvBYC/IQ0CVvBIej1Nl2Sg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QzAZjtGK+0+nmQ/pP8JAMiF4/LyT9YluxptTfuHzN8StCRyHXXwonMBx6KB3pBthF
         wRVLChfN7X0j7w3l2yox1niTP8eakddJr2wNfyG6p6mAL914o0cQ+3NA8MUF1LJKNY
         CeE3fgMTxcLFjPpnSaRqSa50AZ1n3IY84daY+BzI=
Received: by mail-lj1-f171.google.com with SMTP id h20so1116418lji.9;
        Tue, 20 Oct 2020 22:28:48 -0700 (PDT)
X-Gm-Message-State: AOAM531b9Sohaz0siw3kAT6f3AUeL1MXMa9gYJIWsSaHaHFWAXH4b7Bv
        tcTDpU4ytJ1fPAshuBIehkHNDs1MqBWJ9WWAgV0=
X-Google-Smtp-Source: ABdhPJyW6FP/zSxKAx7F8RAcOdBp7sUVGWXw3lamx+YyF24259+mJHFNhvQPb8tgJUChbgse2QDVDao5w++IvxD8kak=
X-Received: by 2002:a05:651c:1a5:: with SMTP id c5mr631039ljn.273.1603258126970;
 Tue, 20 Oct 2020 22:28:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201017110651.GA1602260@dragonet> <CAPhsuW583=org7AOR-W2vcQV3pTBxin2LG1tb3On=x6VtjXvxQ@mail.gmail.com>
 <20201019070319.GA1811280@dragonet>
In-Reply-To: <20201019070319.GA1811280@dragonet>
From:   Song Liu <song@kernel.org>
Date:   Tue, 20 Oct 2020 22:28:36 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4dR7_pgxg-696M34peSRTPhTmJgpokKr5qAMXd81damg@mail.gmail.com>
Message-ID: <CAPhsuW4dR7_pgxg-696M34peSRTPhTmJgpokKr5qAMXd81damg@mail.gmail.com>
Subject: Re: WARNING in md_ioctl
To:     "Dae R. Jeong" <dae.r.jeong@kaist.ac.kr>
Cc:     yjkwon@kaist.ac.kr, linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Oct 19, 2020 at 12:03 AM Dae R. Jeong <dae.r.jeong@kaist.ac.kr> wrote:
>
> > diff --git i/drivers/md/md.c w/drivers/md/md.c
> > index 6072782070230..49442a3f4605b 100644
> > --- i/drivers/md/md.c
> > +++ w/drivers/md/md.c
> > @@ -7591,8 +7591,10 @@ static int md_ioctl(struct block_device *bdev,
> > fmode_t mode,
> >                         err = -EBUSY;
> >                         goto out;
> >                 }
> > -               WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
> > -               set_bit(MD_CLOSING, &mddev->flags);
> > +               if (test_and_set_bit(MD_CLOSING, &mddev->flags)) {
> > +                       err = -EBUSY;
> > +                       goto out;
> > +               }
> >                 did_set_md_closing = true;
> >                 mutex_unlock(&mddev->open_mutex);
> >                 sync_blockdev(bdev);
> >
> > Could you please test whether this fixes the issue?
>
> Since &mddev->open_mutex is held when testing a bit of mddev->flags, I
> modified the code just a little bit by putting mutex_unlock() as
> belows.

Good catch! The fix looks good. Would you like to submit a patch for it?

Thanks,
Song
