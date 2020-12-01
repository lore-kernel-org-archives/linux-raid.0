Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D82C64E7A
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 11:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 693AD20705
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 11:29:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KfdV7ZKi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730530AbgLAL3Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Dec 2020 06:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729885AbgLAL3P (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Dec 2020 06:29:15 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43C1C0613CF
        for <linux-raid@vger.kernel.org>; Tue,  1 Dec 2020 03:28:35 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id t12so1054215pjq.5
        for <linux-raid@vger.kernel.org>; Tue, 01 Dec 2020 03:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a8b20HHWpsRK7rUuQWB/4pyC37GxhvgUh8QeJraixt0=;
        b=KfdV7ZKiCuVfQiI5B2QaEQ3QZ6dCMkA3dzuCGfiafcJ7ZraIubPWL+6X0CgLVGp2Lm
         TVzVaohBiVv9vnMIml86kpAiAsJakTB36X1K6hvF/F9B4ktUjz3DUsdL2ZPw+O7S8gX2
         8cdFM3b7yVBUEOE1SEpWq2kfEfrEjneVtz+DeY6w0l1rrpgVE1ihKkr9QjVBaQz+HJAS
         twtjPttTpCq+Bxy96oz0DbHs2SLnFXBLHP78zSfJVbsqNnUrjnPLnVT0IT1H5SRqnrzG
         H0wwnPGRNN3MtYT9Ztx3HzJL8ZHNiMMqLVmyN5uHZdv4bNXnH3DMgdmQHvfrvHiMhiaX
         2diQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a8b20HHWpsRK7rUuQWB/4pyC37GxhvgUh8QeJraixt0=;
        b=a3sCO/lD0BGkeYXfxHyD+idAKZCHqrZddgvaw/R1WeOwBUmSC8mi8lEr3FUPxGojQ7
         p8KgzNTQ19pUeB/usAkxXDC4iRoyWRFXX/iTJie+gUl2MneXSQZVNhB6gU/QBbN/tMTM
         9yn8JLex3jeZ7AmCzLhXjdCTUzUEz7o1LeX/Ahg9FP3iQyLZQkGs9iqKZM3y/MF6p10d
         I/yvdHSUTFvOAtA9Qb6yG8ctjjf/j2ViV3BaGdXGQ06w6ZaCzx3Ustu8X+G7v0FmJ6eX
         FFK02Db+UmnUEYeLjvqeDX3vaLwwpMUVGnF0uBEEbRAa3sASbh1G4L5bjb+I1V+1wnno
         y7pg==
X-Gm-Message-State: AOAM533QD5lGfe1bMKhc+tQHYPxxWHcO0lrlsxLrkluxf/ULWPDBbbV+
        0RcIynufUZDLtFNVmxZ/qKDiB8BOqRGa60+VQlCA0hp7
X-Google-Smtp-Source: ABdhPJxIKgRdXEHb867e8NZI/bZ5FE3s/tyGwJ6RcjMfIahYNDEgUkmCvt1x1AN+/nKyldiG2swAx4f6aq8aKh6Nj0A=
X-Received: by 2002:a17:90a:5d93:: with SMTP id t19mr2187205pji.220.1606822115254;
 Tue, 01 Dec 2020 03:28:35 -0800 (PST)
MIME-Version: 1.0
References: <CAJH6TXjsg+OE5rUpK+RqeFJRxBiZJ94ToOdUD5ajjwXzYft9Vw@mail.gmail.com>
 <CAJH6TXgED_UGRcLNVU+-1p8BVMapJkRmvZMndLYAKjX_j6f7iw@mail.gmail.com> <CAJ1=CigDVO9-2uSBw8Fbv-86y8G6XOFM2CjRs1yURAczgB6ydA@mail.gmail.com>
In-Reply-To: <CAJ1=CigDVO9-2uSBw8Fbv-86y8G6XOFM2CjRs1yURAczgB6ydA@mail.gmail.com>
From:   Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date:   Tue, 1 Dec 2020 12:28:24 +0100
Message-ID: <CAJH6TXifYVgZh9Ej1=rRe3d5JPfatws8jP4VLPxSnWQwuqAosA@mail.gmail.com>
Subject: Re: [zfs-discuss] Fwd: [OT][X-POST] RAID-6 hw rebuild speed
To:     Discuss <zfs-discuss@list.zfsonlinux.org>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Il giorno mar 1 dic 2020 alle ore 12:18 Ivan Volosyuk
<ivan.volosyuk@gmail.com> ha scritto:
> Resilver time is proportional to the storage used. Do you store the same amount of data on the disks?

I'm talking about hardware raid, not ZFS and obviously, on an hw raid,
the amount data to transfer is always the same, it doesn't change
based on disk form factor (in fact, even with ZFS the amount of data
doesn't change based on form factor)
