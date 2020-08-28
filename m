Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFC2C433E6
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 21:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DDBB2080C
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 21:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598651057;
	bh=NoIuA9LSio3w+knYw6DB9mvx+B/OpDIvVjN1Hs8cJtk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=X5ZtTeAbJhntRthySZqYrwoV+l24TPUeOPcZnKsz87VeDKGjuO8gITWjE+m8liklk
	 mui3Yjsi+EJbu5iZqv0jOiidVHldw7DxG9nq/lyEdVts+BoNJbFELR50q5wx7tucZ4
	 cTyOm3/W3RUQ2Gt8wv6kisRaqJJRFVoGjIpHH3oo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgH1VoQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 17:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgH1VoP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 28 Aug 2020 17:44:15 -0400
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 870FE2086A
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 21:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598651054;
        bh=NoIuA9LSio3w+knYw6DB9mvx+B/OpDIvVjN1Hs8cJtk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=yPMrPGH6y3nTNgV7ACq1C3VIR71wf6ZgqeMsRlIzlZdX+brlrux0QIljQFscdFFHf
         Cg2sBXZabzpAsjWQUX2sFe0swRhDnQ8pmbDv/gP6UDSPRKaXFCH7YDcU+T3tZYCdJ1
         UNwTdqykYAQoexQEX2BAwd4yJ4PTxD9TAD2ZSZE0=
Received: by mail-lf1-f51.google.com with SMTP id z17so397299lfi.12
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 14:44:14 -0700 (PDT)
X-Gm-Message-State: AOAM530iz0w4hopU4gos3QNp+Q68CsT7MX7E59bqAsooVLpe36dmxBCt
        3CITok1lngQ06X2qCxcDPzQKNLh1wimSTsHhpmk=
X-Google-Smtp-Source: ABdhPJy/EIdHlfBc6t9ULPpaBAYwVPkjwNagzAiv8lrvHIidEBpYm5CodQoRPxSwcbTG1+uEGHMI6x57WDcnvdPcTLw=
X-Received: by 2002:a19:6b1a:: with SMTP id d26mr249666lfa.138.1598651052853;
 Fri, 28 Aug 2020 14:44:12 -0700 (PDT)
MIME-Version: 1.0
References: <1598334183-25301-1-git-send-email-xni@redhat.com>
 <1598334183-25301-6-git-send-email-xni@redhat.com> <CAPhsuW5X7XnNX9UHiEv5wUzCNUtXG36gWz+pgZ2HPNf7NFN5Sg@mail.gmail.com>
 <37a21aa1-c23d-754f-e786-72d979bd54bd@redhat.com>
In-Reply-To: <37a21aa1-c23d-754f-e786-72d979bd54bd@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 28 Aug 2020 14:44:01 -0700
X-Gmail-Original-Message-ID: <CAPhsuW49dOUDBhKdnWkwG0RsKxw5WQp-gq1ei8TWzmiY5Qs63A@mail.gmail.com>
Message-ID: <CAPhsuW49dOUDBhKdnWkwG0RsKxw5WQp-gq1ei8TWzmiY5Qs63A@mail.gmail.com>
Subject: Re: [PATCH V5 5/5] md/raid10: improve discard request for far layout
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Coly Li <colyli@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Aug 28, 2020 at 2:50 AM Xiao Ni <xni@redhat.com> wrote:
>
>
>
> On 08/28/2020 03:03 PM, Song Liu wrote:
> > On Mon, Aug 24, 2020 at 10:43 PM Xiao Ni <xni@redhat.com> wrote:
> >> For far layout, the discard region is not continuous on disks. So it needs
> >> far copies r10bio to cover all regions. It needs a way to know all r10bios
> >> have finish or not. Similar with raid10_sync_request, only the first r10bio
> >> master_bio records the discard bio. Other r10bios master_bio record the
> >> first r10bio. The first r10bio can finish after other r10bios finish and
> >> then return the discard bio.
> >>
> >> Signed-off-by: Xiao Ni <xni@redhat.com>
> >> ---
> >>   drivers/md/raid10.c | 87 +++++++++++++++++++++++++++++++++++++++--------------
> >>   drivers/md/raid10.h |  1 +
> >>   2 files changed, 65 insertions(+), 23 deletions(-)
> >>
> >> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> >> index 257791e..f6518ea 100644
> >> --- a/drivers/md/raid10.c
> >> +++ b/drivers/md/raid10.c
> >> @@ -1534,6 +1534,29 @@ static struct bio *raid10_split_bio(struct r10conf *conf,
> >>          return bio;
> >>   }
> >>
> >> +static void raid_end_discard_bio(struct r10bio *r10bio)
> > Let's name this raid10_*
> Ok
> >
> >> +{
> >> +       struct r10conf *conf = r10bio->mddev->private;
> >> +       struct r10bio *first_r10bio;
> >> +
> >> +       while (atomic_dec_and_test(&r10bio->remaining)) {
> > Should this be "if (atomic_*"?
> >
> The usage of while is right here. For far layout, it needs far copies
> r10bio. It needs to find a method
> to know all r10bios finish. The first r10bio->remaining is used to
> achieve the target. It adds the first
> r10bio->remaining when preparing other r10bios. I was inspired by
> end_sync_request. So it should
> use while here. It needs to decrease the first r10bio remaining for
> other r10bios in the second loop.

Thanks for the explanation.

>
> Are there more things you want me to modify or add? If not, I'll send
> the v6 to rename the function
> name.  Thanks for reviewing these patches :)

1/5 to 3/5 look good so far. I applied them to md-next. I have some
comments on 4/5.

Thanks,
Song
