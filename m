Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DCEC7618E
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 21:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbjDXVaF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 17:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjDXVaD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 17:30:03 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2046198
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 14:30:01 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-504fce3d7fbso7605652a12.2
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 14:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682371800; x=1684963800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QpZx22h8N9YC3esXwj+cmZI4LQ1BE1WfvWTsezU+Q1U=;
        b=VWSyuO3DBKgKnZEq+SN9glvBrk86CwwZgWOz6rke8/AzZHsxBvd2KM5dF2L4Smyz85
         B166K27LzgKWCzkqpAyVtilwye4eBk0HAk4gxTVFr+7NeIZ/AUnYxmlpebN5BulT+294
         niZWhyKTc++NecUldMPyLxeJwUqTiQLhHtna03GnLeLPuQnkDULUNymf9JBvBej5QeRn
         vG1VWzPc1KsxoenSO4f0ogv4TQSVf+OL4gwjzZzawdT8197fnI7S0zkupm8lgs+mJQJG
         QLfCMdGoAqxRhZAR99Svf6aQav7KFvENs+VAqJcmUpAUZ0lj2RPzD1zeM9jAFPtei+ax
         IoIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682371800; x=1684963800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QpZx22h8N9YC3esXwj+cmZI4LQ1BE1WfvWTsezU+Q1U=;
        b=Id7DQYK0QCGxAc4MJgVx90YtsVgG7RJCLqiDWa2+eOjILUz5FBa+tTPRL+V+KULNgj
         4RsDBxGPlynnzARPnObpTnfJn5JW3NitXaCqu7iGu+pUheIm9OJFJoANJkBxkDBtZrvi
         R0CI/NTmTMnsCTdmDtLVsBRVlBv8AcEIa1GtZgg7BDYVe6Oz/DcYWlX18EoPcQZTEifm
         ccIX67HgGJ8pyfuDmODVm2fOFx1hBJRazqISPK88rowqPlTxKMZ4n5ZxqqDm+uvxgqW4
         MYWIdm4G1i6s17h6rJBf0mWqvi3M4GixKv+r/U3uOK7lYNdNoVKWpH8FaTMq7UqD6zHh
         tKUw==
X-Gm-Message-State: AAQBX9cn83AZIBcjaMGCYjhPtVVjwiZKIGWVB7+Vcfm9lpzEzycU3YPV
        PGc9UuJXkNx2jebM4/JDEFzPPyVSF1cxCXeQW94=
X-Google-Smtp-Source: AKy350Zv2IqwSuG+HKRzCu/KWlzA0R+iAoEkmZIsGuACJPMAM+hPPB5vcse+kZC9j7PND36kKtPegJGtpnR7ERw8l74=
X-Received: by 2002:a17:906:170e:b0:947:c221:eb38 with SMTP id
 c14-20020a170906170e00b00947c221eb38mr10888659eje.13.1682371800035; Mon, 24
 Apr 2023 14:30:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <bf2f7cb0-c0ae-540d-4231-a3ec9e52da3e@youngman.org.uk> <CAFig2ctxhgV-D8C7HJmFNssewnd_nJzdhfQhhWaRXo8rmKWhyQ@mail.gmail.com>
In-Reply-To: <CAFig2ctxhgV-D8C7HJmFNssewnd_nJzdhfQhhWaRXo8rmKWhyQ@mail.gmail.com>
From:   Jove <jovetoo@gmail.com>
Date:   Mon, 24 Apr 2023 23:29:49 +0200
Message-ID: <CAFig2cvu+yCNDLfxAYfgS8_mi9Yw3Q0CEMj1Fmoh-gKBXBODcg@mail.gmail.com>
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> There is much data on this array that I don't mind being trashed.

There is about 200GB I would very much like to have back. Email archive,
travel pictures, openhab configuration, ... It is all in a huge LVM
with different
logical volumes.

On Mon, Apr 24, 2023 at 3:31=E2=80=AFPM Jove <jovetoo@gmail.com> wrote:
>
> Any data that can be retrieved would be a plus. There is much data on
> this array that I don't mind being trashed.
>
> The older drives are WD Red, they are pre-SHMR. I have made sure after
> that to use WD Red Plus and WD Red Pro drives. From what I found
> online, they should be CMR too. Unless they quietly changed those too.
>
> No, the conversion definitely did not stop at 0%. It ran for several
> hours. It stopped during the night, so I can't tell you more.
>
> I am worried that the processes are hung, though. Is that normal?
>
> Thank you for your time!
>
> On Mon, Apr 24, 2023 at 9:41=E2=80=AFAM Wols Lists <antlists@youngman.org=
.uk> wrote:
> >
> > On 23/04/2023 20:09, Jove wrote:
> > > # mdadm --version
> > > mdadm - v4.2 - 2021-12-30 - 8
> > >
> > > # mdadm -D /dev/md0
> > > /dev/md0:
> > >             Version : 1.2
> > >       Creation Time : Sat Oct 21 01:57:20 2017
> > >          Raid Level : raid6
> > >          Array Size : 7813771264 (7.28 TiB 8.00 TB)
> > >       Used Dev Size : 3906885632 (3.64 TiB 4.00 TB)
> > >        Raid Devices : 4
> > >       Total Devices : 5
> > >         Persistence : Superblock is persistent
> > >
> > >       Intent Bitmap : Internal
> > >
> > >         Update Time : Sun Apr 23 10:32:01 2023
> > >               State : clean, degraded
> > >      Active Devices : 3
> > >     Working Devices : 5
> > >      Failed Devices : 0
> > >       Spare Devices : 2
> > >
> > >              Layout : left-symmetric-6
> > >          Chunk Size : 512K
> > >
> > > Consistency Policy : bitmap
> > >
> > >          New Layout : left-symmetric
> > >
> > >                Name : atom:0  (local to host atom)
> > >                UUID : 8c56384e:ba1a3cec:aaf34c17:d0cd9318
> > >              Events : 669453
> > >
> > >      Number   Major   Minor   RaidDevice State
> > >         0       8       33        0      active sync   /dev/sdc1
> > >         1       8       97        1      active sync   /dev/sdg1
> > >         3       8       49        2      active sync   /dev/sdd1
> > >         5       8       80        3      spare rebuilding   /dev/sdf
> > >
> > >         4       8       64        -      spare   /dev/sde
> >
> > This bit looks good. You have three active drives, so I'm HOPEFUL your
> > data hasn't actually been damaged.
> >
> > I've cc'd two people more experienced than me who I hope can help.
> >
> > Cheers,
> > Wol
