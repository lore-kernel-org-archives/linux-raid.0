Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B929C433E0
	for <linux-raid@archiver.kernel.org>; Tue, 16 Feb 2021 17:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534CF64DFF
	for <linux-raid@archiver.kernel.org>; Tue, 16 Feb 2021 17:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhBPRUu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Feb 2021 12:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbhBPRUr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 16 Feb 2021 12:20:47 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706F6C061574
        for <linux-raid@vger.kernel.org>; Tue, 16 Feb 2021 09:20:06 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id do6so7366779ejc.3
        for <linux-raid@vger.kernel.org>; Tue, 16 Feb 2021 09:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P1mboOoyN118xersTcywNi+4pFOPJOc+PV6vdchV3NU=;
        b=KZrPkw0/uUwFmCr+jUqX6ilUyUCIpuRePHY4AYr6PQ/qkO8U3cAiQWTr6qy9AWDpVN
         iBpPLdvDciqakZ/59rrvp/vepzxdqscNY9AhTKoq4sFuJ1wER6gm6dHKrwYIjPP+mxZm
         jZRpCI/xl2R8Rrg5DikshK8DpQRcwzPJZ1HZ9DoncxAllDkmYXPSJDX43XwFXJOVHxMV
         NCkDm/zCh+a+SHxTYQ4ddMY5DcyNXIyjdP4sCRlw7S0PX45hwi48v5Xh+no58EKTs8Tr
         6HZdpq2BH8RSBIgDTlbi7c6X7d+PRzqsM6iAKqNZPB62k/hApytrNRfjoN1p+lpT3rh8
         TZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P1mboOoyN118xersTcywNi+4pFOPJOc+PV6vdchV3NU=;
        b=VFaMIbWSjy395saojXIiguWStLKQIKu0x6f0DnpSpoRTmyzd97AgnoVZV/e9Rys+hu
         jMVW6wM6tSURUCSP97rBhGpWaQQgBJCHkvK6oH2Fy9BlYmoxqvfEZSFm0m+HGp21fcqa
         EYKoyqND/3k7T34M/tifvAFqIxNwOViDEUfL+4r+E1UqQ1k11rUY1DxLqGCMWTsRVqzd
         lORY3VdbVB4SZwdXYPIm+VvrdWfa/49kNTnpOGUR33ejLQXIFvYKcTlirylso5anPdHB
         LgGnGf7obsF2e6rU7HmFcPj7LqT2akCkn8QF3qCMH2yWUSoYfHKGmoMj8KoY7ZleivP6
         yYGQ==
X-Gm-Message-State: AOAM531Wcy+Dwwfr1YiG5lGpfJAdoZA8JinPBWJGl37tiP6QBVaanWEK
        ik/ghqwsrtM0HuoE/V4gJjCqLSrRwLYbvp4eviN+kqKTKNY=
X-Google-Smtp-Source: ABdhPJwcSUPSFhLaW3Z+fkLfcenVUHWmjGaZtcbQp8UsTQF9CfdKs9zDzR6+6P6h5deTOaXUnWeD4Cv8lxguxCo5/dE=
X-Received: by 2002:a17:907:2622:: with SMTP id aq2mr14446574ejc.470.1613496005155;
 Tue, 16 Feb 2021 09:20:05 -0800 (PST)
MIME-Version: 1.0
References: <CACs3Z9oqWPRt4uT1pYKMHzH+7JHNtsk_stE_-OmQZSQsy4n46g@mail.gmail.com>
 <0d37d776-ef5e-8a8d-ab45-bd0addd17184@molgen.mpg.de>
In-Reply-To: <0d37d776-ef5e-8a8d-ab45-bd0addd17184@molgen.mpg.de>
From:   "Michael D. O'Brien" <obrienmd@gmail.com>
Date:   Tue, 16 Feb 2021 09:20:00 -0800
Message-ID: <CACs3Z9rtvCQuJnOeR_o8-mYL3b+k7R-1=gp8sTfG3mPg=q8yvg@mail.gmail.com>
Subject: Re: mdxxx_raid6 kernel thread frozen
To:     Thomas Kreitler <kreitler@molgen.mpg.de>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Feb 16, 2021 at 6:30 AM Thomas Kreitler <kreitler@molgen.mpg.de> wrote:
>
> This sounds pretty much the same what we have experienced whilst
> checking raid6 assemblies.
>
> The issue is actively tackled in the moment, c.f the "[PATCH V2] md:
> don't unregister sync_thread with reconfig_mutex held" thread.
>
> And more details in the link:
> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t

Thank you for the pointer Thomas - I was reading through that thread
last night (I suppose I should have realized it was similar prior to
my e-mail :)), and the progress is quite encouraging.
