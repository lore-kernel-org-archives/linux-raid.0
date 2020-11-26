Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4B6C56202
	for <linux-raid@archiver.kernel.org>; Thu, 26 Nov 2020 02:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9A412075A
	for <linux-raid@archiver.kernel.org>; Thu, 26 Nov 2020 02:01:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R3cBkLvy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731736AbgKZCBx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Nov 2020 21:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbgKZCBx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Nov 2020 21:01:53 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC84C0613D4
        for <linux-raid@vger.kernel.org>; Wed, 25 Nov 2020 18:01:53 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y7so193478pfq.11
        for <linux-raid@vger.kernel.org>; Wed, 25 Nov 2020 18:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nbtRVnwfljkmoUi5kmNldu0u5EL/V0dLJiFIkaU8KCE=;
        b=R3cBkLvytR8b2gta1t5G/JsHWEsb7C5p9YbBlAfDnmFNxMOOK+PJQxngQDAECotMD2
         yb0AF9u22t1YBMlXe0g8CaYu1ibzBRNoEGHUFZxkLfAzUL8UeMinTE5YE+fpTOwhzpMO
         RStCS7aD9TPe1GIIW1nxsu3g2YVqnfNPFZv7LK7CR8wMJeu1yZ90siKjicHae6IzaJzr
         G/l8bsCH6UzqDkUe+133L4CPM476rqWBWUpa30OX6glzJZ7w19JtiV1ATABWhe8L4tRL
         GcfvBe0rriUucTHS7Wc+ZLvI5qANWvJy6Aik7wKStKUdjZCoLsh/6vLe7bCLC85XL3xH
         RUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nbtRVnwfljkmoUi5kmNldu0u5EL/V0dLJiFIkaU8KCE=;
        b=pUX8eaBP+yX2UbbvW9luxHMLSLgiW8guWP41FzvNF5fjGFX3v15gYHK/Az/Q3oJ0XK
         2DR9Bu1jr3dBJykIGEZQaV+XKKxXy35ifqHiHDkOeWieEyF7LlBffJwdVCiAV9XBWYXl
         B6JbcZOzxzfCKnUmweX1ewTuQr5LZ8Lx0mZ8xM2LOmNZZ8jYKIy2MjeJKR1/B/IBArlv
         vI2rxdeY81Jz9WdVa/jbjliP9bRCf0Dzskw9LEjGI6nUd4c6Q5sYuwpkVbn/UpP4zbmb
         PdmQQWlrduLd1QB7KWd1GalXXcR0JZNvg8F6esuVys+OinQtmLa8dZQgtJZm3UYX24c2
         TiKg==
X-Gm-Message-State: AOAM531p5jHe5CHO1oRIFIB1dMi5KtIreZmyvZvacdcLbSTmf2LQPU1f
        b7l1a55B2IdZaroyNFSjrQhjEzdiuI8wEwdEUfWgI3lGQCrI
X-Google-Smtp-Source: ABdhPJxlfkq4fhFIzrv8yAB/2mZ2W1VIZuUf6qwAs/312Nl8rqjyK56QpiU1aka/uOrjxSBjMcrcofIwf3jML4cbhaw=
X-Received: by 2002:a62:2bd0:0:b029:18a:df0f:dd61 with SMTP id
 r199-20020a622bd00000b029018adf0fdd61mr679337pfr.19.1606356112712; Wed, 25
 Nov 2020 18:01:52 -0800 (PST)
MIME-Version: 1.0
References: <CAB1R3sgQm2_-Bhbzned4y056XP5hM9oz1OnTZSfHH9+L5sdpFQ@mail.gmail.com>
 <871rghmqz8.fsf@vps.thesusis.net>
In-Reply-To: <871rghmqz8.fsf@vps.thesusis.net>
From:   Alex <mysqlstudent@gmail.com>
Date:   Wed, 25 Nov 2020 21:01:41 -0500
Message-ID: <CAB1R3siJ_wAm4jpyp3BXbOrT1oGWyC0jmHiM+XwTm++nw874GQ@mail.gmail.com>
Subject: Re: Considering new SATA PCIe card
To:     Phillip Susi <phill@thesusis.net>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

> > RAID5 and 2x480GB SSDs in RAID1 for root. The motherboard has two
> > SATA-6 ports on it and the others are SATA3.
>
> There is no SATA-6.  There are 3 generations of SATA.  SATA-3 operates
> at 6 Gbps.

Thanks everyone for all of your help. Also, I did mean to say ports
and not controllers.

I always just assumed the onboard controllers were very basic.
