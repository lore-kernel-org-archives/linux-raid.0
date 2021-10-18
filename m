Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08065C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 09:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E372860F57
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 09:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhJRKBT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Oct 2021 06:01:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229668AbhJRKBR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 18 Oct 2021 06:01:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634551146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SL5ZDreEN6SY6SjsZ4JetZoJ0ARZPzkdSN3l8X6cG5w=;
        b=WEDbfMrDvT7oYizVX1jMfCbcY6GmuQzl7xYwNqdfwAltHQH6CoE8xIA5jiSv84IwEK4rSW
        OZpzOMR7brbSUdU82I3uE1t9ZRle1TArh1AVP2lsdoDqcwWgxZ8N4h8kb/0PG1miP0m1oz
        SeJUGVeKTEbA/b8W7k6wgwhlpPyiV2M=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-bavoHaaQP0G0nVoZiXef-g-1; Mon, 18 Oct 2021 05:59:05 -0400
X-MC-Unique: bavoHaaQP0G0nVoZiXef-g-1
Received: by mail-ed1-f69.google.com with SMTP id v2-20020a50f082000000b003db24e28d59so13847994edl.5
        for <linux-raid@vger.kernel.org>; Mon, 18 Oct 2021 02:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SL5ZDreEN6SY6SjsZ4JetZoJ0ARZPzkdSN3l8X6cG5w=;
        b=7UMKS7PtiRdtUGtEdSu9zPA1uw+uFA8VWL2948RDS7nNRK4vAiNxs/0LuOYj7rwYe1
         zVocrBlaNhQbAxynIzVX2cqQ6eP2qhM3NZlzTnODUFpq5a6gTzNH0vSR6eWI5krbsHfm
         +TZoYlsBZlj5YUEDxe8y0oj33ZIjoNqKbU6nPe/LktULQceQHVc34ESXj3aFPGQRwBKW
         wyO3oWUlo6XwMD/oNOGAVGn0rANSQP7vP7fSwvezSQlKD3CnQbhAuZCx6p2GT3SDXLQH
         8kBAVgAHMTJmcqmtw0XkZuDKEsMlE8XLAVyxQRWMuXlCgW59uqvKjx+Fka846xDG8dqI
         xvzQ==
X-Gm-Message-State: AOAM5327z846PXj4oP2N9WiNyvG0sfJYZ4wqoGaYnkZM4OtuQavA2WiN
        n4rMnnLzKeuwNdRyvLJf7XqAkupTWuI0ORhKIRNCz2FPjCZ2toJfLZSEQUVJ8Ewdh/q5axpycxr
        XNq2cBs+f0tHUWm+m6eR3K1j+iQeUylZmBa5kNQ==
X-Received: by 2002:a50:e1c3:: with SMTP id m3mr43429539edl.28.1634551143882;
        Mon, 18 Oct 2021 02:59:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrMxQ+CzubbVw6xG6nIfrKwSZ8rZW8g4I/H5/sGbwKfqB24ydKDyat+YIxc++D/hEKGqxyYFenMiQcNYYlSeo=
X-Received: by 2002:a50:e1c3:: with SMTP id m3mr43429509edl.28.1634551143667;
 Mon, 18 Oct 2021 02:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <1634289920-5037-1-git-send-email-xni@redhat.com> <92351bf8-b0e3-89da-48c0-993b0dc29db2@linux.intel.com>
In-Reply-To: <92351bf8-b0e3-89da-48c0-993b0dc29db2@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 18 Oct 2021 17:58:52 +0800
Message-ID: <CALTww28pOiSBMA3ozM+CpM2E4mNFf2kpfGO5o3zN1oEu21tYCw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/Detail: Can't show container name correctly
 when unpluging disks
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, Nigel Croxon <ncroxon@redhat.com>,
        Fine Fan <ffan@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Oct 18, 2021 at 2:56 PM Tkaczyk, Mariusz
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Xiao,
> Thanks for taking care of this.
>
> On 15.10.2021 11:25, Xiao Ni wrote:
> > The test case is:
> > 1. create one imsm container
> > 2. create a raid5 device from the container
> > 3. unplug two disks
> > 4. mdadm --detail /dev/md126
> > [root@rhel85 ~]# mdadm -D /dev/md126
> > /dev/md126:
> >           Container : =EF=BF=BD=EF=BF=BD, member 0
> >
> > The Detail function first gets container name by function
> > map_dev_preferred. Then it tries to find which disks are
> > available. In patch db5377883fef(It should be FAILED..)
> > uses map_dev_preferred to find which disks are under /dev.
> >
> > But now, the major/minor information comes from kernel space.
> > map_dev_preferred malloc memory and init a device list when
> > first be called by Detail. It can't find the device in the
> > list by the major/minor. It free the memory and reinit the
> > list.
> >  > The container name now points to an area tha has been freed.
> > So the containt is a mess.
> >
>
> Container name is collected with 'create' flag set, so it's
> name is additionally copied to static memory to prevent
> overwrites. Could you verify?

Hi Mariusz

The chapter above you mentioned is talking about the creation process?
The container name mentioned from the patch is a temporary variable in
Detail function.

You want to say we can use the container name from the "static memory" in
Detail function, so we don't get the container name again? And where is the
static memory?

>
> So summarizing: the previously returned value might be lost
> in next call.

If you say the value returned from map_dev_preffered, you are right,
the buffer might be free and re-alloc. So the value might be lost
in the next call.

>
> I looked into code, map_dev_preffered() mainly is used for
> determining short-life buffers, which are used only to the next
> call (next call overwrites previous result, expect case you fixed).

right

>
> IMO map_dev_preffered() cannot be trusted now. I see some options:
> 1 - allocate additional memory and save return value there (caller
> needs to free it later).
> 2 - describe limitations in description of the function to avoid
> incorrect usages in the future.

I'll add one description first.

>
> > This patch replaces map_dev_preferred with devid2kname. If
> > the name is NULL, it means the disk is unplug.
> >
> Your patch fixes only one place. Please go forward and analyze all
> map_dev_preffered() calls (which looks safe to me). Maybe this
> function can be replaced at all and we can drop this code in
> flavor of devid2kname() or other.

At first, I just wanted to fix this bug. We can check all the places which
are using map_dev_preffered. But it looks like a big project. It needs to
understand all codes related to this function. It needs more time. Do you
agree with fixing this bug first, then we can try to fix the hidden bugs.

>
> > Fixes: db5377883fef (It should be FAILED when raid has)
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > Reported-by: Fine Fan <ffan@redhat.com>
> > ---
> >   Detail.c | 12 +++++++-----
> >   1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/Detail.c b/Detail.c
> > index d3af0ab..2164de3 100644
> > --- a/Detail.c
> > +++ b/Detail.c
> > @@ -351,11 +351,13 @@ int Detail(char *dev, struct context *c)
> >       avail =3D xcalloc(array.raid_disks, 1);
> >
> >       for (d =3D 0; d < array.raid_disks; d++) {
> > -             char *dv, *dv_rep;
> > -             dv =3D map_dev_preferred(disks[d*2].major,
> > -                             disks[d*2].minor, 0, c->prefer);
> > -             dv_rep =3D map_dev_preferred(disks[d*2+1].major,
> > -                             disks[d*2+1].minor, 0, c->prefer);
> > +             char *dv, *dv_rep =3D NULL;
> > +
> > +             if (!disks[d*2].major && !disks[d*2].minor)
> > +                     continue; > +
> > +             dv =3D devid2kname(makedev(disks[d*2].major, disks[d*2].m=
inor));
> > +             dv_rep =3D devid2kname(makedev(disks[d*2+1].major, disks[=
d*2+1].minor));
> >
> >               if ((dv && (disks[d*2].state & (1<<MD_DISK_SYNC))) ||
> >                   (dv_rep && (disks[d*2+1].state & (1<<MD_DISK_SYNC))))=
 {
> >
>
> Yeah, I know that it is used in Detail this way, but please  determine
> way to replace this ugly [d*2] and [d*2+1].

Yes, it takes me much time to understand how to calculate avail[]. We
can focus on
fixing this bug first, then we prepare some patches for improving the codes=
 that
related to the function map_dev_preferred and the [d*2] format codes.
It might be
a big change.

>
> This whole block should be moved from Detail() code to separate
> function, which determines if device or replacement is in sync.

A good suggestion. Put it into the change I mentioned above, is it ok?

Regards
Xiao

