Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B35CC433ED
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 18:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4732E6128A
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 18:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbhDES7O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Apr 2021 14:59:14 -0400
Received: from mail1.g17.pair.com ([216.92.2.65]:48176 "EHLO
        mail1.g17.pair.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbhDES7J (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Apr 2021 14:59:09 -0400
Received: from mail1.g17.pair.com (localhost [127.0.0.1])
        by mail1.g17.pair.com (Postfix) with ESMTP id DFB9AB1A64
        for <linux-raid@vger.kernel.org>; Mon,  5 Apr 2021 14:59:00 -0400 (EDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail1.g17.pair.com (Postfix) with ESMTPSA id DBF87D8FE5
        for <linux-raid@vger.kernel.org>; Mon,  5 Apr 2021 14:59:00 -0400 (EDT)
Received: by mail-ej1-f45.google.com with SMTP id u21so18151525ejo.13
        for <linux-raid@vger.kernel.org>; Mon, 05 Apr 2021 11:59:00 -0700 (PDT)
X-Gm-Message-State: AOAM533jW+vmoanrm+wuMLn+1xs7Op97pbsgte8PawsJhef4T3ELHNRc
        AJEU1zXQ6ejckyz/iO6aQyWjrAKErwJx2Ekc7A==
X-Google-Smtp-Source: ABdhPJyGMdtigz1lZaaPNqAEOHpPAGqvOoP/BYKKbynS+BWd4XgTD38W4W4LLm+44Kh6/W/iwxjyz0K39s1IdhAglgo=
X-Received: by 2002:a17:906:1350:: with SMTP id x16mr7200353ejb.11.1617649139770;
 Mon, 05 Apr 2021 11:58:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAOLErMXeBKoC=7Bq0XddmVShJdSNrhTms+tbBnqih8nnXCF-iA@mail.gmail.com>
In-Reply-To: <CAOLErMXeBKoC=7Bq0XddmVShJdSNrhTms+tbBnqih8nnXCF-iA@mail.gmail.com>
Reply-To: jeff@cjsa.com
From:   Jeffery Small <jeff@cjsa.com>
Date:   Mon, 5 Apr 2021 11:58:43 -0700
X-Gmail-Original-Message-ID: <CAOLErMWW4vxQgJkY_hBedmm_oTx34vNhGWZet-1bkJV8qSDH_w@mail.gmail.com>
Message-ID: <CAOLErMWW4vxQgJkY_hBedmm_oTx34vNhGWZet-1bkJV8qSDH_w@mail.gmail.com>
Subject: Re: Question about mdcheck
To:     Mailing Lists <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Following up to my own post:

Further exploration revealed a couple of things (to me!):

The mdcheck_start.timer and mdcheck_continue.timer files
under /lib/systemd/system/ contain RandomizedDelaySec
settings of 24h and 12h respectively.  This appears to be
responsible for the odd starting times for the check which is
interfering with daytime system use.  Why would these
values be included for a service intended to only run once
a month?

I do not want to edit the files under /lib/systemd/system/
which would certainly be overwritten with future updates.
Can I place copies of these files in /etc/systemd/system
and completely override the entries under /lib/systemd?

Clearly, I'm still trying to figure out just how the systemd
works and how it integrates with the old legacy init system.

On Mon, Apr 5, 2021 at 10:17 AM Jeffery Small <jeff@cjsa.com> wrote:
>
> This is on an Xubuntu 20.04 system.
>
> I was wondering why I was occasionally seeing a "check" operation
> occurring on my clean RAID1 mirrors.  Eventually I discovered the
> checkarray and mdcheck scripts in /usr/share/mdadm.  It appears
> that checkarray isn't used (is that correct?), but mdcheck is being
> launched by /lib/systemd/system/mdcheck_start.service on the first
> Sunday of each month.  I have a couple of questions?
>
> 1: Where do you look for the systemctl scheduling of services
> like this?  Is there a cron-like scheduler?  The time for this needs
> to be adjusted.
>
> 2: Why does mdcheck get a 6 hour run duration set?  Right now
> it is starting a little after 8 AM, running until 2 PM and then check-
> pointed and suspended.  On Monday at 9:10 AM it  continued due
> to /lib/systemd/system/mdcheck_continue.service. It is running on
> a 4TB raid that takes over 12 hours to complete, so why stop it
> after 6 hours?  I'm certainly not getting any advantage to running in
> off hours since it is starting at a really inappropriate time.
>
> 3: The process is really putting a load on the system and interfering
> with other work.  Can the priority for this process be lowered so that
> it doesn't consume so many resources?
>
> 4: How critical is the check operation?  Does it discover things that
> the normal RAID operation misses?
>
> Anything else I should know about all of this?
>
> Thanks.
> --
> Jeffery Small
