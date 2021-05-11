Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38490C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 06:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 073B961469
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 06:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhEKHAb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 May 2021 03:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhEKHA3 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 11 May 2021 03:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7F17616EB;
        Tue, 11 May 2021 06:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620716363;
        bh=qvWtzjChomNHA8AUpSuCqWqiEcJmyj4rWdsRJAB3zDY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MhppijMnJmZhva4VtZtaBXuGyW/SdtKZvBzJmF+TZdj0+jyh/KFIYXEnDHqDD9/mY
         FOAbx/djSej3H0O+kmUTDXQpajzbCSNQreyuxcIKRH5lsmqn0LpWmxWKIrx2ZVSJ7c
         MXbcbXvRxdgHZ9mO2k7BXEV/bnZuChI6rcrDg0emsSXYTJNaTNSr7QdB56OEaN+qIX
         /ffRRnb+96YKYndp5u52kHxj5SWyImNs8uZnJo0RtBHuC8jmA0GnJ+buzGc7iXXHop
         GQqddTTyVJ08hddAkFvPA3JRz9+mpWBBS02gmFSMvSzeKw2LtaVclGtUCSbgZ5iVeF
         sSiZ9GY3yfFug==
Received: by mail-lf1-f54.google.com with SMTP id x20so27100543lfu.6;
        Mon, 10 May 2021 23:59:23 -0700 (PDT)
X-Gm-Message-State: AOAM530bALhwrMsQhuL63YH28GiL3+UA7gFQcMANX2ndQ+kH1e60IyTM
        qQepA46QyXEXF3k4wUA3GDOmyH8Iu+V3Ps3tlHE=
X-Google-Smtp-Source: ABdhPJwTrzFWG8FAKMAn39/10BywekV/sImjmdZCT5WIGrf5NPbm7ZMkN/YSkZYnrV1Qy7Ziw9F4XzCzOWb9O1Ulj8E=
X-Received: by 2002:a19:dc4e:: with SMTP id f14mr19023627lfj.176.1620716362140;
 Mon, 10 May 2021 23:59:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210508034815.123565-1-jgq516@gmail.com> <YJjL6AQ+mMgzmIqM@infradead.org>
 <14a350ee-1ec9-6a15-dd76-fb01d8dd2235@gmail.com> <6ffb719e-bb56-8f61-9cd3-a0852c4acb7d@intel.com>
 <c1bc42ff-eae7-d0ba-505d-9c6a19d60e93@gmail.com> <YJoKOT8U7+9fyraj@infradead.org>
In-Reply-To: <YJoKOT8U7+9fyraj@infradead.org>
From:   Song Liu <song@kernel.org>
Date:   Mon, 10 May 2021 23:59:11 -0700
X-Gmail-Original-Message-ID: <CAPhsuW64tRB6i7Rr2f+G-nmbacFKapB1nztinnJ2KKWTbc9VYA@mail.gmail.com>
Message-ID: <CAPhsuW64tRB6i7Rr2f+G-nmbacFKapB1nztinnJ2KKWTbc9VYA@mail.gmail.com>
Subject: Re: [PATCH] md: don't account io stat for split bio
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Guoqing Jiang <jgq516@gmail.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org,
        =?UTF-8?Q?Pawe=C5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 10, 2021 at 9:39 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, May 11, 2021 at 10:13:41AM +0800, Guoqing Jiang wrote:
> > > > Song and Artur, what are your opinion?
> > > In the initial version of the io accounting patch the bio was cloned instead
> > > of just overriding bi_end_io and bi_private. Would this be the right approach?
> > >
> > > https://lore.kernel.org/linux-raid/20200601161256.27718-1-artur.paszkiewicz@intel.com/
> >
> > Maybe we can have different approach for different personality layers.
> >
> > 1. raid1 and raid10 can do the accounting in their own layer since they
> > already
> > ?????? clone bio here.
> > 2. make the initial version handles other personality such as raid0 and
> > raid5
> > ?????? in the md layer.
> >
> > Also a sysfs node which can enable/disable the accounting could be helpful.
>
> Yes.  Also if the original bi_end_io is restore before completing the
> bio you can still override it.

Do you mean we can somehow avoid cloning the bio?

Thanks,
Song
