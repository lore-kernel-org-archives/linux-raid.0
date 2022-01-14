Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2CAC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 14 Jan 2022 17:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243936AbiANRxd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 Jan 2022 12:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiANRxd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 14 Jan 2022 12:53:33 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F199DC061574
        for <linux-raid@vger.kernel.org>; Fri, 14 Jan 2022 09:53:32 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id 14so4033389qty.2
        for <linux-raid@vger.kernel.org>; Fri, 14 Jan 2022 09:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=grenf96LWEXU1js57ztZaeSaNnFPMbb+myOCtvyGDXg=;
        b=MGbgdPINeVW0ETnF2ezt/hPz003t8O9pogDzimpzpFrwlE1cJcqGjuPt+i4FLPi/vT
         lEWqjBTklDppQlH0pH6I6lZC+aoW61mXrFlzZ4Snjr9j2PZ+8LWsfHVdG5OZVkQNMLs0
         v285HCtf8W/oIeznIsUxFikZ7odQ1Q3oZDOiIJojwBBj7vudF7wNL3JQY8ulq4UbyQj4
         AhLkb0womu6xl6N1jS3pBrRQzzNOVu35LGrm/VQixuYYJ6iaafqUwyHpQkMxh4Gip+BI
         40P/9lzrroGkcgLFDOyx9MqJ0914vuMBj2TYtyK9CpHLszIBIXeP677E8Dmij3AUhnwC
         YVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=grenf96LWEXU1js57ztZaeSaNnFPMbb+myOCtvyGDXg=;
        b=m0fHsf+XULESXqeaI7RnNSa+tX17aqD8ry368RgnQ7Ns9hW2UZhMp9u0R+9tGiaAR0
         pQuaH84CmCtBwYo+e2/Hn43npZ6uwDH5VptwLXKfcx5FGNAYWfmlWHLjGt4eu5YGasGv
         dJWLa1A2rgueDjaTrWWKMoJUkNMA8Eg20VKrYUVf7lgaUdI92i7IkXv5kqBk5ZOnW5Tt
         vT3b+smcvK/8IqMWtfCogkc1j8zwqMEUNx6rOUlQB3cZG/NvwLt58Nudfs2UfCtp84uR
         /d3HFUE+3gZx7gkvX1E9ZrRnU5FDuBStR93TwZNzJmDCp3vV/sAj6oUu2SH/qp3MX2Ed
         FG1g==
X-Gm-Message-State: AOAM533FcBopUuszHWOaRL1UHII0qhKc0gNR93QDHdxavTGZJoIMdWWJ
        a2a7GmAi0qK2TauR9t1p2MDiEHP8r6EmhkvSEEGhc124
X-Google-Smtp-Source: ABdhPJzj9Jkl5ureGMQw1W1GjbgafimbcKb/eHzcsxQhXWI3OBs5qLTAOxqtwvgCdn7tdZgGPHgNORQUdkG4Lr9xTR8=
X-Received: by 2002:ac8:570b:: with SMTP id 11mr8606432qtw.128.1642182812046;
 Fri, 14 Jan 2022 09:53:32 -0800 (PST)
MIME-Version: 1.0
References: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz> <0394837e-0109-e7b7-59f9-5e90a03bc629@youngman.org.uk>
 <CAAMCDec5kcK62enZCOh=SJZu0fecSV60jW8QjMierC147HE5bA@mail.gmail.com>
 <KN4.44rdw.1WKWgyVtkH0.1XtLJu@seznam.cz> <CAAMCDef-bxeM0a_qS0FuviZ89a_Qn496KDsj1WQ3r7NT+t5+_Q@mail.gmail.com>
 <Ly2.44rd2.7sLtKmD9o5e.1Xto6p@seznam.cz> <NWX.44oOw.7USLwiS0IVD.1XuOH9@seznam.cz>
In-Reply-To: <NWX.44oOw.7USLwiS0IVD.1XuOH9@seznam.cz>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 14 Jan 2022 11:53:20 -0600
Message-ID: <CAAMCDedMLUPawEwKZWw4gRSP-04SyihqiLcHeXTN2XhfDTcsKg@mail.gmail.com>
Subject: Re: Feature request: Add flag for assuming a new clean drive
 completely dirty when adding to a degraded raid5 array in order to increase
 the speed of the array rebuild
To:     =?UTF-8?B?SmFyb23DrXIgQ8OhcMOtaw==?= <jaromir.capik@email.cz>
Cc:     Linux RAID <linux-raid@vger.kernel.org>,
        Wols Lists <antlists@youngman.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

That is typically 100MB/sec per disk as it is reported, and that is a
typical speed I have seen for a rebuild and/or grow.

There are almost certainly algorithm sync points that constrain the
speed less than full streaming speed of all disks.

The algorithm may well be, read the stripe, process the stripe and
write out the new stripe, and start over (in a linear manner)  I would
expect that to be the easiest to keep track of, and that would roughly
get your speed (costs a read to each old disk + a write to the new
disk + bookkeeping writes + parity calc).     Setting up the code such
that it overlaps the operations is going to complicate the code, and
as such was likely not done.

And regardless of the client's only being able to run raid5, there is
significant risks to running raid5.   If on the rebuild you find a bad
block on one of the other disks then you have lost data, and that is
very likely to happen--that exact failure was the first raid failure I
saw 28+ years ago).

How often are you replacing/rebuilding the disks and why?

On Fri, Jan 14, 2022 at 8:10 AM Jarom=C3=ADr C=C3=A1p=C3=ADk <jaromir.capik=
@email.cz> wrote:
>
> Hello Roger.
>
> >> Also, grow differs in the fact that blocks get moved around hence the =
writes.
> >
> > Of course, but even of that the speed was poor :]
>
> Just for info, I just tried to DD data on the second (faster) hardware
> from one RAID drive to an empty one with MD offline and the transfer
> speed is the following (sorry for the czech locale :) ...
>
> 25423+0 z=C3=A1znam=C5=AF p=C5=99e=C4=8Dteno
> 25422+0 z=C3=A1znam=C5=AF zaps=C3=A1no
> 26656899072 bajt=C5=AF (27 GB, 25 GiB) zkop=C3=ADrov=C3=A1no, 105,227 s, =
253 MB/s
> 25903+0 z=C3=A1znam=C5=AF p=C5=99e=C4=8Dteno
> 25902+0 z=C3=A1znam=C5=AF zaps=C3=A1no
> 27160215552 bajt=C5=AF (27 GB, 25 GiB) zkop=C3=ADrov=C3=A1no, 107,235 s, =
253 MB/s
> 26386+0 z=C3=A1znam=C5=AF p=C5=99e=C4=8Dteno
> 26385+0 z=C3=A1znam=C5=AF zaps=C3=A1no
> 27666677760 bajt=C5=AF (28 GB, 26 GiB) zkop=C3=ADrov=C3=A1no, 109,245 s, =
253 MB/s
>
> as you can see, the write speed really matches the speed from the drive d=
atasheet,
> so ... why the sync speed was 100MB/s only when the CPU load was low?
> Can you explain that?
>
> Thanks,
> Jaromir
