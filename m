Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778C6C433ED
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 17:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A77C6108F
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 17:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhDERSH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Apr 2021 13:18:07 -0400
Received: from mail1.g17.pair.com ([216.92.2.65]:38510 "EHLO
        mail1.g17.pair.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhDERSH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Apr 2021 13:18:07 -0400
Received: from mail1.g17.pair.com (localhost [127.0.0.1])
        by mail1.g17.pair.com (Postfix) with ESMTP id B6D92B1A6A
        for <linux-raid@vger.kernel.org>; Mon,  5 Apr 2021 13:18:00 -0400 (EDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail1.g17.pair.com (Postfix) with ESMTPSA id B56E4D92AD
        for <linux-raid@vger.kernel.org>; Mon,  5 Apr 2021 13:18:00 -0400 (EDT)
Received: by mail-ej1-f49.google.com with SMTP id mh7so7808786ejb.12
        for <linux-raid@vger.kernel.org>; Mon, 05 Apr 2021 10:18:00 -0700 (PDT)
X-Gm-Message-State: AOAM531GvgXgXrOPXLSuV1Ou557+adUpUFJTLKChDrPIkhBjg7KQbblH
        2WPRjQcRNNDD15OgD1sEDxlDU7t5AKDIYdD5wA==
X-Google-Smtp-Source: ABdhPJxq0/3ovvIiVsQhFoMI3gxIcJs5IK2mc1TkBfhTTbjLT/B2+8n5kHwHK5YGgDS6WrxOXtfzZI1YHkVXxBmsLBI=
X-Received: by 2002:a17:906:1350:: with SMTP id x16mr6778566ejb.11.1617643079712;
 Mon, 05 Apr 2021 10:17:59 -0700 (PDT)
MIME-Version: 1.0
Reply-To: jeff@cjsa.com
From:   Jeffery Small <jeff@cjsa.com>
Date:   Mon, 5 Apr 2021 10:17:43 -0700
X-Gmail-Original-Message-ID: <CAOLErMXeBKoC=7Bq0XddmVShJdSNrhTms+tbBnqih8nnXCF-iA@mail.gmail.com>
Message-ID: <CAOLErMXeBKoC=7Bq0XddmVShJdSNrhTms+tbBnqih8nnXCF-iA@mail.gmail.com>
Subject: Question about mdcheck
To:     Mailing Lists <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is on an Xubuntu 20.04 system.

I was wondering why I was occasionally seeing a "check" operation
occurring on my clean RAID1 mirrors.  Eventually I discovered the
checkarray and mdcheck scripts in /usr/share/mdadm.  It appears
that checkarray isn't used (is that correct?), but mdcheck is being
launched by /lib/systemd/system/mdcheck_start.service on the first
Sunday of each month.  I have a couple of questions?

1: Where do you look for the systemctl scheduling of services
like this?  Is there a cron-like scheduler?  The time for this needs
to be adjusted.

2: Why does mdcheck get a 6 hour run duration set?  Right now
it is starting a little after 8 AM, running until 2 PM and then check-
pointed and suspended.  On Monday at 9:10 AM it  continued due
to /lib/systemd/system/mdcheck_continue.service. It is running on
a 4TB raid that takes over 12 hours to complete, so why stop it
after 6 hours?  I'm certainly not getting any advantage to running in
off hours since it is starting at a really inappropriate time.

3: The process is really putting a load on the system and interfering
with other work.  Can the priority for this process be lowered so that
it doesn't consume so many resources?

4: How critical is the check operation?  Does it discover things that
the normal RAID operation misses?

Anything else I should know about all of this?

Thanks.
--
Jeffery Small
