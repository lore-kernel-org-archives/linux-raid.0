Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1256C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 20 Dec 2021 03:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbhLTDF7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Dec 2021 22:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbhLTDF6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Dec 2021 22:05:58 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E412C061574
        for <linux-raid@vger.kernel.org>; Sun, 19 Dec 2021 19:05:58 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 8so7495781pfo.4
        for <linux-raid@vger.kernel.org>; Sun, 19 Dec 2021 19:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9lOVWuxXOu0TuKF8h8Z+/23yHAwq3C+kQ9bxyyjy7hQ=;
        b=bsH/ohfU59SonZifdyZSCopabnEmAXEapidtg+d3pfWX4pPshGJXBpb2a3+kRdmPPt
         onAzE7DQUfbvVcvzV1tLURhwMCQhisoUkVadxq+OdqJsQfPose7NqHMOXYxzCXxt2T2t
         xLNJ3AV7zbwWEw9WUv0jEeN3sVdNmL9I7yZOkCnQCSVXqW+MdQaeTOqUawd2K/qHDIR3
         TnSkb5h7UBIDPm+00ZxMQ5gnQCIQ0lSOy2ZROS38ffLsmfOHbdcAQxQw64OzW5L4xcA+
         v3UGXW9Dcz4rWdTkx6WhsWL76EKHPNIAZMfsIcKqJxXom5kD4yphWYQxo/TamtwB2hvE
         Fe3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9lOVWuxXOu0TuKF8h8Z+/23yHAwq3C+kQ9bxyyjy7hQ=;
        b=ZKovjWMEMU9/RDI8nU1oKaVUnEPKR3rLNR/JGXCWyZ5tvtkZflAEa/Fakv2Bj5t+RD
         jUQ5It208KURLHcBbqo3YgK6M+fmuCuOD7qpUn3Q+qFJTpJXCmgnWHh9awiWqjq5g9kH
         4e6a5wv8PRdS9bhkzx/z4+ajVmNhZBmL0wacJdo5f7o+9Lwkn5bH/yfJb/RU9tT+GCpW
         oKnkTUfQjpqM8WWWzmanmrn6G1tVYnpwN6T/Ht2GD/joeoOFSbg8qI96IsdeYXqscHhI
         2FzN4ilymJkZsymiYH/r7GNBlY2W0g8q3Fz+UW/sCjoIZz+iioTDfDvHAiszeOfZt47h
         i0Tw==
X-Gm-Message-State: AOAM533Tu2goZx1si5htnDLWG3qzCcAtg1v0UerZgrsI3O++emEY9mms
        coZuxrnZgxI6zx+OkFStYILgsjaYta5miAWLmns=
X-Google-Smtp-Source: ABdhPJwL8B2vM7ialk/JFfElHmdlCObIq6DfFMvyilg0josCW7QapSjDhD/bqmTPwHGoeZLsuzNqCeuJC60hb3gsRXE=
X-Received: by 2002:a05:6a00:1789:b0:4ba:ca5d:35e2 with SMTP id
 s9-20020a056a00178900b004baca5d35e2mr4416273pfg.21.1639969556957; Sun, 19 Dec
 2021 19:05:56 -0800 (PST)
MIME-Version: 1.0
References: <CAGRSmLugFZo95qAOrGoKcfWN2wxe_h3Nyw8EVa+8sRVvPyu3_g@mail.gmail.com>
 <CAJj0OuvmhKP7TsamiA8X+qf38n=_94c8yR42NpUVoNp1jYqgUg@mail.gmail.com>
 <CAGRSmLvPWsYnCwkg61QJB4zjge4mu_-LOthicVzSFJo8+nj5sg@mail.gmail.com>
 <2726e0eb-90c1-b771-25c4-072caf5105be@youngman.org.uk> <02affda1-1f10-997a-616b-f9963a2ec995@grumpydevil.homelinux.org>
In-Reply-To: <02affda1-1f10-997a-616b-f9963a2ec995@grumpydevil.homelinux.org>
From:   "David F." <df7729@gmail.com>
Date:   Sun, 19 Dec 2021 19:05:45 -0800
Message-ID: <CAGRSmLvv-bipFyWCbnnU0t2=AK1PG-n7XP9H61eOWe2y+XYsjA@mail.gmail.com>
Subject: Re: Latest HP ProLiant DL380 G10 RAID1 support?
To:     Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc:     Wol <antlists@youngman.org.uk>,
        "C.J. Collier" <cjac@colliertech.org>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The report shows:

RAID bus controller [0104]: Intel Corporation C620 Series
Chipset Family SSATA Controller [RAID mode] [8086:a1d6] (rev 09)
    Subsystem: Hewlett Packard Enterprise Device [1590:00e6]
    Kernel driver in use: ahci

It's a new server, I know the older servers in the same line worked
okay (but maybe different configuration).    So there is no update to
mdadm to handle these systems (whatever the new RAID configuration
data is) and the customer will have to use Windows boot disk instead?
 I mean, why would a company create a new RAID metadata layout and
break all existing support for standards when it's still just RAID1,
5, etc.. ?

On Sun, Dec 19, 2021 at 2:26 PM Rudy Zijlstra
<rudy@grumpydevil.homelinux.org> wrote:
>
>
>
> On 19-12-2021 23:07, Wol wrote:
> > On 19/12/2021 21:11, David F. wrote:
> >> Thanks, the strange thing is it's seeing the physical drives (I
> >> understand when the drives don't show up but once the drives show up
> >> mdadm was agnostic), it's not not seeing the RAID configuration, the
> >> customer says "First two are raid one and second set of 3 drives are
> >> raid 5"?
> >
> > Could it be the customer configured (or thought he did) the drives as
> > hardware raid in the BIOS, and then it's fallen into JBOD mode? Or is
> > linux bypassing the raid hardware somehow?
> >
> > It's probable (in fact, very liklely) that linux doesn't recognise the
> > HP raid format, unless it's IMSM.
> >
> > Cheers,
> > Wol
> I suspect this is the S100i Smart Array controller. This is a SW raid
> controller which only has a windows driver.
> When you enable the raid in the BIOS the embedded raid manager lets you
> configure a raid config that windows will recognize (with the driver
> installed). Linux will only see the component disks and probably
> actually get into trouble with the S100i enabled in RAID. That at least
> is my experience with the comparable software raid on a gen8.
>
> If no data / OS on the system, better to disable the SW raid and use
> mdadm on the base disks
>
> Cheers
>
> Rudy
