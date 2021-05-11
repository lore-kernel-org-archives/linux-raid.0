Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 567B4C433B4
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 06:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BF326187E
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 06:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhEKG7v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 May 2021 02:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhEKG7u (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 11 May 2021 02:59:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECB28616EC;
        Tue, 11 May 2021 06:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620716325;
        bh=bLUSCgt/HdnpGWVV72XPemeUH2yyy53ftmSRh+aARK8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KH4uUIQGWkeTI17GwvnS8mK/MGZKKu5Y52QcYmVPCoTLxmukWMjT6YoI8f/vZxex+
         Dfnfo9YkMDpbEvUkMGkwtG2VnOmhU/K1D5csHnh1TWhi3HjetmPdnOM543ycgwZ+Wb
         aDxjso2vrNHzmUMPij0XarHk3vk9s/Tag6YVP6tihMoG7UmtxtybBHeykwoOKl+QbZ
         O73uozKC5hCQoTlm/UPpMpE4CPba7g3qxykw2z9TwvdxBGxsA9AI4TpkSPx+0YA67R
         AOouCtyeS8wZzng7oQBik8/Yw2XiW3fv7ugbGnKeKD1i9WHTPVcfNOeloFBgOHy3LB
         xhJyYf7nzT5MA==
Received: by mail-lj1-f182.google.com with SMTP id v6so23811591ljj.5;
        Mon, 10 May 2021 23:58:44 -0700 (PDT)
X-Gm-Message-State: AOAM531+DuRtAzwWPWZuUytOMIBc6sF6ZOSfWUfWH906+D2Ql/zIBY5Z
        pQom/kJH5XbM3Ph7Ho/3dbLiRHD7fmcyHw0AmpM=
X-Google-Smtp-Source: ABdhPJxCQLKjnhNQGBJEo/AiGfvSPEhNxTSBFxzLm/h7c77evsRqJ6XDNgaEf8+vis3+G9u862IsTDl54eMi8XXUwVI=
X-Received: by 2002:a2e:1608:: with SMTP id w8mr23286761ljd.506.1620716323309;
 Mon, 10 May 2021 23:58:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210508034815.123565-1-jgq516@gmail.com> <YJjL6AQ+mMgzmIqM@infradead.org>
 <14a350ee-1ec9-6a15-dd76-fb01d8dd2235@gmail.com> <6ffb719e-bb56-8f61-9cd3-a0852c4acb7d@intel.com>
 <c1bc42ff-eae7-d0ba-505d-9c6a19d60e93@gmail.com>
In-Reply-To: <c1bc42ff-eae7-d0ba-505d-9c6a19d60e93@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 10 May 2021 23:58:32 -0700
X-Gmail-Original-Message-ID: <CAPhsuW44cc2p+29_rLqrq7i3R0d03sjtwRQtbLRkta+jzsdYsw@mail.gmail.com>
Message-ID: <CAPhsuW44cc2p+29_rLqrq7i3R0d03sjtwRQtbLRkta+jzsdYsw@mail.gmail.com>
Subject: Re: [PATCH] md: don't account io stat for split bio
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org,
        =?UTF-8?Q?Pawe=C5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 10, 2021 at 7:13 PM Guoqing Jiang <jgq516@gmail.com> wrote:
>
>
>
> On 5/11/21 3:49 AM, Artur Paszkiewicz wrote:
> > On 5/10/21 9:46 AM, Guoqing Jiang wrote:
> >> On 5/10/21 2:00 PM, Christoph Hellwig wrote:
> >>> On Sat, May 08, 2021 at 11:48:15AM +0800, Guoqing Jiang wrote:
> >>>> It looks like stack overflow happened for split bio, to fix this,
> >>>> let's keep split bio untouched in md_submit_bio.
> >>>>
> >>>> As a side effect, we need to export bio_chain_endio.
> >>> Err, no.  The right answer is to not change ->bi_end_io of bios that
> >>> you do not own instead of using a horrible hack to skip accounting for
> >>> bios that have no more or less reason to be accounted than others bios.
> >> Thanks for the reply. I suppose that md needs to revert current
> >> implementation of accounting io stats, then re-implement it.
> >>
> >> Song and Artur, what are your opinion?
> > In the initial version of the io accounting patch the bio was cloned instead
> > of just overriding bi_end_io and bi_private. Would this be the right approach?
> >
> > https://lore.kernel.org/linux-raid/20200601161256.27718-1-artur.paszkiewicz@intel.com/
>
> Maybe we can have different approach for different personality layers.
>
> 1. raid1 and raid10 can do the accounting in their own layer since they
> already
>      clone bio here.
> 2. make the initial version handles other personality such as raid0 and
> raid5
>      in the md layer.
>
> Also a sysfs node which can enable/disable the accounting could be helpful.

IIUC, the sysfs node is needed to get better performance (by disabling
accounting)?
And splitting 1 and 2 above is also for better performance? If we add
the sysfs node,
I would prefer we use the same approach for all personalities (clone
in md.c). This
should simplify the code. If the user do not need extreme performance, we should
keep the stats on (default). If the user do need extreme performance, s/he could
disable stats via sysfs.

Thoughts?

Thanks,
Song
