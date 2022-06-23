Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4053CC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 04:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiFWEok (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 00:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239662AbiFWDcm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 23:32:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561093584F;
        Wed, 22 Jun 2022 20:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F12BAB821B9;
        Thu, 23 Jun 2022 03:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FC5C341C8;
        Thu, 23 Jun 2022 03:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655955157;
        bh=QBkwADLVGu+MdkPj5mj1txUxyEsUrhEY+FUMqq1CJ4o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Af4sJ7r4/QFHgXquMCaInvBQreCPF6qIidpOH4SeSUGMVU9NSwcjb6m7hgNCy6BKc
         MrxCNQhGci0G9z45OcE4C72E/s1uJSzhhyBWzwVO3oCehSYwqIluj8KIodyUDk3qwd
         dZUcEwx50f3wjr+vEs7a6vZ/L1Tf8fPN//EUcnt8r/0g8jB4O1GpaxkY+rHSpSPWZe
         IigybdyciorEeqN9f4kyYiaIwDRE0Vl9hhPqsiAWgHuhZCbm+P3V0T927p+nPL122b
         6rN5kxQ7VwTNNPuy/zSAWDejCZnjEFKrx263RkWNsJY/96KQRqA830wKYfPEqxAWkh
         0ObRJG1A7/VvA==
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-2ef5380669cso181718777b3.9;
        Wed, 22 Jun 2022 20:32:37 -0700 (PDT)
X-Gm-Message-State: AJIora/n8MGXZr01IS9HN1ky56nhizWSjEC37VLwff78FLiw4nGCg3PJ
        oCIoORf5XnrTgUYD1tcO547RfOu9ejtV5nLoZTs=
X-Google-Smtp-Source: AGRyM1sz6LhnkuQXB++A1xxRhmxJRakOPv6yRCgJ85hWtvc01Kc40Ek0z60uOMhr5owHMe3F37Yuzc/4tXSQdAJYh/8=
X-Received: by 2002:a81:6187:0:b0:317:e37f:ae9e with SMTP id
 v129-20020a816187000000b00317e37fae9emr8275688ywb.130.1655955156649; Wed, 22
 Jun 2022 20:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <d4163d9f-8900-1ec1-ffb8-c3834c512279@gmx.com> <63a9cfb7-4999-d902-a7df-278e2ec37593@youngman.org.uk>
 <1704788b-fb7d-b532-4911-238e4f7fd448@gmx.com> <06365833-bd91-7dcf-4541-f8e15ed3bef2@youngman.org.uk>
 <87cb53c4f08cc7b18010e62b9b3178ed70e06e8d.camel@redhat.com>
 <d15f352d-41b8-8ade-4724-8370ef17db8d@gmx.com> <165593717589.4786.11549155199368866575@noble.neil.brown.name>
 <a09d6a24-6e1a-0243-ea4c-ac6d6127b69d@gmx.com>
In-Reply-To: <a09d6a24-6e1a-0243-ea4c-ac6d6127b69d@gmx.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 22 Jun 2022 20:32:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5iYWPkSyjqU0VUM-y+aQyFW6SkQXdjinu9ayz3DigcxA@mail.gmail.com>
Message-ID: <CAPhsuW5iYWPkSyjqU0VUM-y+aQyFW6SkQXdjinu9ayz3DigcxA@mail.gmail.com>
Subject: Re: About the md-bitmap behavior
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     NeilBrown <neilb@suse.de>, Doug Ledford <dledford@redhat.com>,
        Wols Lists <antlists@youngman.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jun 22, 2022 at 5:39 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
[...]
> E.g.
> btrfs uses 64KiB as stripe size.
> O = Old data
> N = New writes
>
>         0       32K     64K
> D1      |OOOOOOO|NNNNNNN|
> D2      |NNNNNNN|OOOOOOO|
> P       |NNNNNNN|NNNNNNN|
>
> In above case, no matter if the new write reaches disks, as long as the
> crash happens before we update all the metadata and superblock (which
> implies a flush for all involved devices), the fs will only try to read
> the old data.

I guess we are using "write hole" for different scenarios. I use "write hole"
for the case that we corrupt data that is not being written to. This happens
with the combination of failed drive and power loss. For example, we have
raid5 with 3 drives. Each stripe has two data and one parity. When D1
failed, read to D1 is calculated based on D2 and P; and write to D1
requires updating D2 and P at the same time. Now imagine we lost
power (or crash) while writing to D2 (and P). When the system comes back
after reboot, D2 and P are out of sync. Now we lost both D2 and D1. Note
that D1 is not being written to before the power loss.

For btrfs, maybe we can avoid write hole by NOT writing to D2 when D1
contains valid data (and the drive is failed). Instead, we can write a new
version of D1 and D2 to a different stripe. If we loss power during the write,
the old data is not corrupted. Does this make sense? I am not sure
whether it is practical in btrfs though.

>
> So at this point, our data read on old data is still correct.
> But the parity no longer matches, thus degrading our ability to tolerate
> device lost.
>
> With write-intent bitmap, we know this full stripe has something out of
> sync, so we can re-calculate the parity.
>
> Although, all above condition needs two things:
>
> - The new write is CoWed.
>    It's mandatory for btrfs metadata, so no problem. But for btrfs data,
>    we can have NODATACOW (also implies NDOATASUM), and in that case,
>    corruption will be unavoidable.
>
> - The old data should never be changed
>    This means, the device can not disappear during the recovery.
>    If powerloss + device missing happens, this will not work at all.
>
> >
> > You must either:
> >   1/ have a safe duplicate of the blocks being written, so they can be
> >     recovered and re-written after a crash.  This is what journalling
> >     does.  Or
>
> Yes, journal would be the next step to handle NODATACOW case and device
> missing case.
>
> >   2/ Only write to location which don't contain valid data.  i.e.  always
> >     write full stripes to locations which are unused on each device.
> >     This way you cannot lose existing data.  Worst case: that whole
> >     stripe is ignored.  This is how I would handle RAID5 in a
> >     copy-on-write filesystem.
>
> That is something we considered in the past, but considering even now we
> still have space reservation problems sometimes, I doubt such change
> would cause even more problems than it can solve.
>
> >
> > However, I see you wrote:
> >> Thus as long as no device is missing, a write-intent-bitmap is enough to
> >> address the write hole in btrfs (at least for COW protected data and all
> >> metadata).
> >
> > That doesn't make sense.  If no device is missing, then there is no
> > write hole.
> > If no device is missing, all you need to do is recalculate the parity
> > blocks on any stripe that was recently written.
>
> That's exactly what we need and want to do.

I guess the goal is to find some files after crash/power loss. Can we
achieve this with file mtime? (Sorry if this is a stupid question...)

Thanks,
Song
