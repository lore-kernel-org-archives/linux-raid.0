Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C82ADC77B73
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 13:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjDXNce (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 09:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbjDXNcT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 09:32:19 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0417DB9
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 06:31:57 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-94f109b1808so809458266b.1
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 06:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682343105; x=1684935105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J87qHIx77TLbe3aqPxqmJmQdnv6HEaNsFndEw1Bs7A0=;
        b=L8G3phQMP1IsOLX2qND6qNP4bO989xmvqfwps7wVmdnCcd0Ne1csniBenmsporQdlB
         vEuNP+sQK0cmpoBuYETgGQ7sfDUOB6qcGGt5AqaP4QQIaMEMUYOvbgkbGQt/R2p/mQ2F
         Tl51RJDuHrSn6gmGYE0H4+a/vHoH2x7bGPMx9avjMOHrXimGtE+aRYG2ArI86pk4MuQq
         IbfE5n/1KisjKBEuhx999tzmHswkdYXz4buk7/YeWeptgq4mSv4H/JxpQKh7dN/FkTL9
         kqqh3O1DSAAmqCEgfpm3ILFruJ3dMO1FeQ8xjluKVHcRTjKJPFGIoWttAT2Nr4tlwx7v
         ZFnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682343105; x=1684935105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J87qHIx77TLbe3aqPxqmJmQdnv6HEaNsFndEw1Bs7A0=;
        b=K4bYooIh0BhuLKIjD+xOsp82AwTD1DUKNoSRRqRqcb2Of3/408U7eg3/TVuVtqESow
         nrO6ipjYQQI5XJLJYj/KKowBpZL5L5xnmEMdWppZz6Wke16KObUnd8paKYT283yR30DS
         XquzBd52egZI0yqJG9NploZlrD0u6VbDwAArDnVVLJT/rGzl4npFPJVvdM5bpAWLlKNU
         wwx7O2FBE8YfnqKmlMLfEkiGzFwp4E6RejOA+QXQy6UhGLFzdwFrW+PipR8ZVN3w3v9i
         ViyDTG3jWazrQpvpCDTI2O57GvpjZxck3n4rz9GCMpS8pOKYlSTX1FupAb2TabOSbrpz
         OscQ==
X-Gm-Message-State: AAQBX9fA/jRa+GE/gck3RmNW4x9JD4Ki4HetMa2i9CCQd1NSgW2ObgaS
        ls0QiyEq0ECGDoo8Q9ZhMFY+3PpjKf3X37kZ2Zo=
X-Google-Smtp-Source: AKy350auzmNfl0tCnam9Fob/sDOp2q2G01p9WIP2Lad32DuYz0JVvErfVFc5gxbFKB9oJaWqwPh3twD6/USfkj9Y8Hk=
X-Received: by 2002:a17:907:c285:b0:955:34a5:ae46 with SMTP id
 tk5-20020a170907c28500b0095534a5ae46mr9225183ejc.77.1682343105214; Mon, 24
 Apr 2023 06:31:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <bf2f7cb0-c0ae-540d-4231-a3ec9e52da3e@youngman.org.uk>
In-Reply-To: <bf2f7cb0-c0ae-540d-4231-a3ec9e52da3e@youngman.org.uk>
From:   Jove <jovetoo@gmail.com>
Date:   Mon, 24 Apr 2023 15:31:34 +0200
Message-ID: <CAFig2ctxhgV-D8C7HJmFNssewnd_nJzdhfQhhWaRXo8rmKWhyQ@mail.gmail.com>
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Any data that can be retrieved would be a plus. There is much data on
this array that I don't mind being trashed.

The older drives are WD Red, they are pre-SHMR. I have made sure after
that to use WD Red Plus and WD Red Pro drives. From what I found
online, they should be CMR too. Unless they quietly changed those too.

No, the conversion definitely did not stop at 0%. It ran for several
hours. It stopped during the night, so I can't tell you more.

I am worried that the processes are hung, though. Is that normal?

Thank you for your time!

On Mon, Apr 24, 2023 at 9:41=E2=80=AFAM Wols Lists <antlists@youngman.org.u=
k> wrote:
>
> On 23/04/2023 20:09, Jove wrote:
> > # mdadm --version
> > mdadm - v4.2 - 2021-12-30 - 8
> >
> > # mdadm -D /dev/md0
> > /dev/md0:
> >             Version : 1.2
> >       Creation Time : Sat Oct 21 01:57:20 2017
> >          Raid Level : raid6
> >          Array Size : 7813771264 (7.28 TiB 8.00 TB)
> >       Used Dev Size : 3906885632 (3.64 TiB 4.00 TB)
> >        Raid Devices : 4
> >       Total Devices : 5
> >         Persistence : Superblock is persistent
> >
> >       Intent Bitmap : Internal
> >
> >         Update Time : Sun Apr 23 10:32:01 2023
> >               State : clean, degraded
> >      Active Devices : 3
> >     Working Devices : 5
> >      Failed Devices : 0
> >       Spare Devices : 2
> >
> >              Layout : left-symmetric-6
> >          Chunk Size : 512K
> >
> > Consistency Policy : bitmap
> >
> >          New Layout : left-symmetric
> >
> >                Name : atom:0  (local to host atom)
> >                UUID : 8c56384e:ba1a3cec:aaf34c17:d0cd9318
> >              Events : 669453
> >
> >      Number   Major   Minor   RaidDevice State
> >         0       8       33        0      active sync   /dev/sdc1
> >         1       8       97        1      active sync   /dev/sdg1
> >         3       8       49        2      active sync   /dev/sdd1
> >         5       8       80        3      spare rebuilding   /dev/sdf
> >
> >         4       8       64        -      spare   /dev/sde
>
> This bit looks good. You have three active drives, so I'm HOPEFUL your
> data hasn't actually been damaged.
>
> I've cc'd two people more experienced than me who I hope can help.
>
> Cheers,
> Wol
