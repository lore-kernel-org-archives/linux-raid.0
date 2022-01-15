Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D8BC433EF
	for <linux-raid@archiver.kernel.org>; Sat, 15 Jan 2022 15:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbiAOPrF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 15 Jan 2022 10:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbiAOPrE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 15 Jan 2022 10:47:04 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7831C06161C
        for <linux-raid@vger.kernel.org>; Sat, 15 Jan 2022 07:47:04 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so17133339pjp.0
        for <linux-raid@vger.kernel.org>; Sat, 15 Jan 2022 07:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=DlsP7pR1KtRraZ7uD0ETGSTmj2dlGItT6jo9tnSlcWA=;
        b=Hg4LUhVHr/AQ93nNgy/TVg94Xpwc3YI1tJo7oqjt+wFCY+N1id/MwTULa3OxoKIWIB
         au1FyN5jC8H3kuBB54b7Gh9MJxa7kq6kNTlOV6uqIhONg4PsvrzDXIgNPFOfITzgqPw4
         WsbRF18D0CffD7ld49fMxOUH+XBM1qHxJJFLY5gS97ypLdMB7n7KO7wxBFnJeX1ZDDnF
         b/zwXpEv0sydff7WfOJzpouy7t4NAU5RoGFbYDsppgUVqF70WqPQMKTxL7SF5e8boYNE
         uVvqPksh0elD/+Q7FKkNiBckxuM9JcxKHi2fyooGA5C3hG6zaOAAcx1i0H7BQYvU66Xl
         cErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=DlsP7pR1KtRraZ7uD0ETGSTmj2dlGItT6jo9tnSlcWA=;
        b=stBH+C50STuoy2Ioiu8AKm1UzAGVpk/w4cWYVA3q1lhDsPfIkSuFyBOqEQctu0OhxF
         O/VsKc6QksZcAtNN7qc6Cu7JSugH07LEsEcglIKliST82Qw51FgW3RoN0mqU9aqYSb2m
         QUtfjqmASfa9E6I/519etqVxa5wFZQb7oYWZ8n697C48BD3A1G0usOVfIB9Mzoj+2Gwj
         VyQNSb+O81WRC8pslLyznqsy7qdbkKrBqAal7ocMYPxhACu68mP2RXS55kWQFzBkTa3n
         AC3u3R0ZbuVJfZuNRX46qkmqplQlPEiF6dlNyTcGaF+qsBiePMx26VlqLDEa5WPMT04P
         RNOw==
X-Gm-Message-State: AOAM5319wfSeFEpLwZ6UAVbq/EYsz4JhsNmQK+nn7ACXkxjEVCSXwCgL
        M8r5ybG5pCNWtgtT2L7RrvkH1jqU/EjjnIkq1bBW1R70EHJ1MA==
X-Google-Smtp-Source: ABdhPJwdRnlxojsOijLfJ1VzYrkBP4sP2PtexT6U3Py+GbjUnFuX+4cm0ciblPsXWv1RNTSj1vg0eXs5vyJHgvsr8tQ=
X-Received: by 2002:a17:902:8a82:b0:149:db00:dbab with SMTP id
 p2-20020a1709028a8200b00149db00dbabmr14219130plo.140.1642261623830; Sat, 15
 Jan 2022 07:47:03 -0800 (PST)
MIME-Version: 1.0
References: <CA+Kggd7mUF9MWdJsLtAQMv=KXtwaNvj6BqfM+NMyffE86iHBoQ@mail.gmail.com>
 <20210907125201.0cc77658@natsu> <20210907141835.259010e3@natsu> <CA+Kggd6AghdZt6YpBL24xC5TtMKqUiaHyoiyRLd2+dVJhVOP7w@mail.gmail.com>
In-Reply-To: <CA+Kggd6AghdZt6YpBL24xC5TtMKqUiaHyoiyRLd2+dVJhVOP7w@mail.gmail.com>
From:   Ryan Patterson <ryan.goat@gmail.com>
Date:   Sat, 15 Jan 2022 10:46:52 -0500
Message-ID: <CA+Kggd4gPsK+vUWvb8+tcenTBKF=AU7QYwm44YvUNRgjtu9bWA@mail.gmail.com>
Subject: Re: mdadm resync causes stable system to crash every 2 or 3 hours
To:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Sep 7, 2021 at 6:55 PM Ryan Patterson <ryan.goat@gmail.com> wrote:
>
> On Tue, Sep 7, 2021 at 5:18 AM Roman Mamedov <rm@romanrm.net> wrote:
> >
> > On Tue, 7 Sep 2021 12:52:01 +0500
> > Roman Mamedov <rm@romanrm.net> wrote:
> >
> > > On Mon, 6 Sep 2021 20:44:31 -0400
> > > Ryan Patterson <ryan.goat@gmail.com> wrote:
> > >
> > > > My file server is usually very stable.  The past week I had two mdadm
> > > > arrays that required recync operations.
> > > > * newly created raid6 array (14 x 16TB seagate exos)
> > > > * existing raid 6 array, after a reboot resync on hot spare (14 x 4TB
> > > > seagate barracuda)
> > > >
> > > > During both resync operations (they ran one at a time) the system
> > > > would routinely experience a major error and require a hard reboot,
> > > > every two or three hours.  I saw several errors, such as:
> > > > * kernel watchdog soft lockups [md127_raid6:364]
> > > > * general protection faults (I have a few saved with the full exception stack)
> > > > * exceptions in iommu routines (again I have the full error with
> > > > exception stack saved)
> > > > * full system lockup
> > >
> > > So in other words the server is very stable, unless asked to do full-speed
> > > reads from all disks at the same time.
> > >
> > > I'd suggest to check or improve cooling on the HBA cards, and then try a
> > > different PSU.
> >
> > Also the motherboard chipset cooling, since that's a lot of PCI-E traffic.
> > Maybe the CPU cooling as well, or at least check the CPU temperatures during
> > this load.
> >
> > And since you have full logs and backtraces, there's no point in waiting to
> > post those, just go ahead. Maybe they will point to something other than
> > suspect hardware, or at least to which part of hardware to suspect.
> >
> > --
> > With respect,
> > Roman
>
> Thanks for the suggestions.  Hardware overheating might be my problem.
> I have several (loud) case fans blowing away.  But the HBA cards and
> mobo southbridge are only passively cooled.  Maybe I could mount fans
> on each cards' headsink.  I'll investigate.
>
> The power supply is not an off the shelf job.  So I don't convientanly
> have a replacement to try.  I might have to bite the bullet and buy a
> second.
>
> I forgot to put in my original note that I ran memtest86 on this
> machine for four full cycles with no faults found.  Also nothing is
> overclocked.
>
> Here are some of the errors I recorded.  Maybe somebody can see a
> pattern in them...
>
> [snip]

Just to provide closure to the system instability I reported four
months ago.  End of 2021 I replaced the motherboard, CPU, & RAM with
"server grade" hardware (intel xeon).  Ever since upgrading hardware,
the system has been 100% stable.  Even during sustained mdadm I/O
workloads, etc.

So it appears the consumer grade motherboard was at fault all along.
Thanks for the help troubleshooting the issue.
_____________
Ryan Patterson
May the wings of liberty never lose a feather.
