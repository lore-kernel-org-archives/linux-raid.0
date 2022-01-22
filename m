Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F2EC433EF
	for <linux-raid@archiver.kernel.org>; Sat, 22 Jan 2022 14:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiAVOYC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 22 Jan 2022 09:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbiAVOYC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 22 Jan 2022 09:24:02 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22DDC06173B
        for <linux-raid@vger.kernel.org>; Sat, 22 Jan 2022 06:24:01 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id h15so13587792qtx.0
        for <linux-raid@vger.kernel.org>; Sat, 22 Jan 2022 06:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cTjUeiAJ2qqwfGHqQ8tI5cblm51fyv1PiHqug5PiMtg=;
        b=d5H8HSgGjXVvU8ednB1t0Hpb5N4Z3BJPH7P5C4VCEBVTbiLfNJKsd+vm2VSOiJqxqN
         i1/SejynSRmaGqw0DFEEeOZjQQcniQoLqDnOxKz3DBNdOed/m0yRiotkhH86DJi7GO9o
         19iwPKlDt8GNDwNPSkjptM3YDpmps8b5IMcwCUod3lQo3BrIYIB27VCVyI6KSoU8TQ9h
         6/buBGTdS8WRJ//yPIbqNpfSxJt6tfTk0kBQ8d267CRj6mcHEoMky9+uPYKXRkRw4sw0
         /qCwxnKZzLP8aGKA3/l7r+rJM/ECSivVGxacPK36m4YV9LjNUFr63mzBVmipSMuWuNsu
         4jfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cTjUeiAJ2qqwfGHqQ8tI5cblm51fyv1PiHqug5PiMtg=;
        b=qH8vRHoIPE1gC6hyfbUyehUNweWk3lscww8qA8LKuLLTyuMEOhUN4Fw1RksNqOT0HS
         oLMrORUNaX0IAkAcw3X3SC9z2mFiwS9nCl+uJuVdgjWigi6ztq8jiv9Sfk+h49g9uD+o
         qlivMb/H5slokuoqzUlyr+254AKpAOQOEORgDs6iWvh22cnisOq7jtxXiR7IpolOguAG
         u13GQscMS+giZKlrwKN8ojYlcOjpa8XVRK2FHPSpy714bWW4VFbDY+wg/wIiF3GRQy6j
         fqYBNSUOSh3ZQ43Y69HuuxCutkoNwqWDu/YSY7KwAhS3gbauqsun8BNY/XvFoGCKsCOW
         2qNA==
X-Gm-Message-State: AOAM533VBUlYrWlKT+N/wmp9yOeEK7qrh6Bkzsm3rT5OVa6BWVQYOS3x
        lGfulRsH35cyIlsIb3dsRF4AiRP0OeBvrm0QXGsWRIbeYHI=
X-Google-Smtp-Source: ABdhPJxidU8gD1k25dq3Y/mqrbV8Km0SFwP04AjSwznIvD2wu+0PRiuXMZoyCvqo35mZR1jzCosYraHfzq8TlAInTWI=
X-Received: by 2002:a05:622a:1a14:: with SMTP id f20mr6879302qtb.175.1642861440858;
 Sat, 22 Jan 2022 06:24:00 -0800 (PST)
MIME-Version: 1.0
References: <20220121164804.GE14596@justpickone.org> <6cfb92e5-5845-37ff-d237-4c3d663446e3@youngman.org.uk>
 <33fb3dfd-e234-14d9-7643-3449c700a241@youngman.org.uk> <b052c0be-a57b-7e2f-c2ca-44a58e971e39@youngman.org.uk>
In-Reply-To: <b052c0be-a57b-7e2f-c2ca-44a58e971e39@youngman.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Sat, 22 Jan 2022 08:23:49 -0600
Message-ID: <CAAMCDeeXT2Sy5Tczou7X6uO1yJx9TigEmJz9guwPUjT5SiEzQQ@mail.gmail.com>
Subject: Re: hardware recovery and RAID5 services
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     David T-G <davidtg+robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From the recovery I know about in the last 3 years, it was several
thousand US$ per TB for the recovery.

On Sat, Jan 22, 2022 at 1:33 AM Wols Lists <antlists@youngman.org.uk> wrote:
>
> On 21/01/2022 19:34, Wols Lists wrote:
> > On 21/01/2022 19:31, Wols Lists wrote:
> >> Secondly, I'm sure I've dealt with these people in the past, although
> >> I can't vouch for them ...
> >>
> >> https://www.vogon-computer-evidence.com/our-story/
> >
> > OUCH! Having found that page (which is pretty much as I remember the
> > company), the rest of the web site looks like a cobweb site. So I don;t
> > know what's happened, but it doesn't look promising ...
> >
> Following up further yes it certainly looks like a cobweb site. The
> company was taken over by Ontrack - I've seen a couple of
> recommendations for them. But I have to re-iterate I can't vouch for
> them, just they are a big professional company that does that sort of thing.
>
> Cheers,
> Wol
