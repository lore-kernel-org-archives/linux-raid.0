Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E57BC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 31 Jan 2022 18:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357719AbiAaS76 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Jan 2022 13:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244293AbiAaS75 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 31 Jan 2022 13:59:57 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6C8C061714
        for <linux-raid@vger.kernel.org>; Mon, 31 Jan 2022 10:59:57 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id m25so12025319qka.9
        for <linux-raid@vger.kernel.org>; Mon, 31 Jan 2022 10:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pFmDVUN8uF4nlXzB6LKQI7s0EthcJs4K55g431Pg16c=;
        b=j1KMH1IL0Ozy4Lcz3ZR49EOwjYnQb5CN1/5GUUDXHAUeGf12kyOTd3Bg5SLh4z4ToK
         C4RgxsY/sqfXECM9QK3UDPSMCQEnHR7TnHxND8gjjatsFe0zaoL9XDTA9j6pXn0XwZlM
         KLKmOwxLQAqNrBpZbnIjlIhGDVMhwcCyzR3faIZhb6n40G6NUU8fzgbrcwUMybaUW9o4
         v9SEp+7WUANHTxLSJntJmvpcAvjNAS0UwM+A+pwBuVOULEdYv44+KEVFwyfgKj+ipYgt
         DPF6rwmOnxOJwidS4xHc1pam6D8CelrE179IVjDqNzw+CQ/cXjU+TN/iyAU52QiszG35
         WkKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pFmDVUN8uF4nlXzB6LKQI7s0EthcJs4K55g431Pg16c=;
        b=sfFfVsKKfty0c41UGYh34SHeUFZY5yt2TG1x/onu++T8u5VIXbRVX3Ffd4MC6GyMzX
         e3WX7V2COA1wwfD0ss0/rRDeVjmstkgSp4sQR/Hx7e4CQy2YBww7S2+y6+146aKFOxIO
         ukbnvr0o5mkXCm9Lk2ov5r2wk1WFR9NkuScGN0MiG77v4NdRJlwyEj3Hk9RpZBXCrbhb
         wTlhMSykyBmvt3qNTKqOQXAaeJa5v1d/8KiFtSzJFFaQdLsNGwhh8bkJ2CTwfVKmGsY3
         RaPSZqvU7FqIziknGS1jo2MSVUFibPKd5hNjxy2q08imfugRhEXI41Fce2XsMwf3ST+N
         lOGg==
X-Gm-Message-State: AOAM532ajneFaE4zIrgt6KqeowBIp+JX7lRwWYGbtVDnbAiIY1CcktmR
        B2GdIeQ4bZvSUnn1xzUWkCfrRo+RcFElP3nznGROYmQS
X-Google-Smtp-Source: ABdhPJzk/ktl0jPD5+CeO2M7a/3dx/FuSTZfvUcY9rcrbZdqK61bI6NendhMGz34bJDVQeiN/uZfUDF/KF5xqe9VQxg=
X-Received: by 2002:a05:620a:4623:: with SMTP id br35mr8373062qkb.586.1643655596397;
 Mon, 31 Jan 2022 10:59:56 -0800 (PST)
MIME-Version: 1.0
References: <20220121164804.GE14596@justpickone.org> <6cfb92e5-5845-37ff-d237-4c3d663446e3@youngman.org.uk>
 <33fb3dfd-e234-14d9-7643-3449c700a241@youngman.org.uk> <b052c0be-a57b-7e2f-c2ca-44a58e971e39@youngman.org.uk>
 <CAAMCDeeXT2Sy5Tczou7X6uO1yJx9TigEmJz9guwPUjT5SiEzQQ@mail.gmail.com>
 <7571b432-4b19-3de4-b04d-3a46b09b0629@turmel.org> <c3b7a580-952f-7c7a-fddc-88ca0b5fde84@youngman.org.uk>
 <87leyvvrqp.fsf@esperi.org.uk>
In-Reply-To: <87leyvvrqp.fsf@esperi.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Mon, 31 Jan 2022 12:59:33 -0600
Message-ID: <CAAMCDee0zoWB9ud6wxvfSj0rpswFde9dd2T3chur4R9YFnRPwQ@mail.gmail.com>
Subject: Re: hardware recovery and RAID5 services
To:     Nix <nix@esperi.org.uk>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Phil Turmel <philip@turmel.org>,
        David T-G <davidtg+robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

And do not do write-sector on a disk that is in use in RAID, otherwise
that sectors data is gone.

I will completely remove a disk/partition and do --write-sectors
against it and then do a --add (don't do a re-add).    In general
though I have not had a lot of luck with the write-sector fixing
and/or forcing a reallocate even when the sector is clearly bad.  I
have to conclude (based on both WD and seagate not reallocating
sectors that reliably fail rereads in <30-seconds after just being
re-written) that pretty much everyone's disk firmware must suck.

Would --make-bad-sector work to force a reallocate?

On Mon, Jan 31, 2022 at 9:40 AM Nix <nix@esperi.org.uk> wrote:
>
> On 29 Jan 2022, Wols Lists told this:
>
> > I believe there is also a way of injecting a hardware error onto a
> > drive. Unless you can take a backup of the backup :-) I wouldn't
> > recommend it at the moment, but there's some ATA command or whatever
> > that tells the drive to flag a sector as bad, and return a read error
> > until it's over-written.
>
> See hdparm --make-bad-sector. The manpage says "EXCEPTIONALLY DANGEROUS.
> DO NOT USE THIS OPTION!!". It is not lying. :)
>
> (This is also --write-sector, which is merely VERY DANGEROUS, but can be
> used to force rewrites of bad sectors. Make sure you get the sector
> number right! Needless to say, if you don't, it's too late, and there's
> no real way to test in advance...)
