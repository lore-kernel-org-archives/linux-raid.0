Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDD2C25B08
	for <linux-raid@archiver.kernel.org>; Wed, 17 Aug 2022 07:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiHQHKJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Aug 2022 03:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiHQHKI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 Aug 2022 03:10:08 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6F65808B
        for <linux-raid@vger.kernel.org>; Wed, 17 Aug 2022 00:10:06 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id v12-20020a9d7d0c000000b00638e210c995so703729otn.13
        for <linux-raid@vger.kernel.org>; Wed, 17 Aug 2022 00:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=VmaUr30ESoh88sFLmzG05WK8xqopcpK7DSCGXRbWjcw=;
        b=pByAlpi3O0TlvNVD7z4fdMKKuDcM8wDGEmmE5kLSOwHLDgVTPBCOYD/D0jQMvuKstB
         iPXAtliQe2XTXFU/7JdRRoULn503M9n9gskN94/yjcOB5bEnurJ0InKA1g4tbDvt1Dcj
         RNWAloFIQGTQ4XFLo/c9rNBlrnqBChmPq96yhNE1TI22WJ7ZVOAcrbmIdhAZhUmXbXny
         OXyAcsOAlgo7N/4L+kaEuPX/7GZ2tdupzS/qIsIDKN0GhNmnX6+ksixs8Fg2PDs/5SH0
         Eh+Ylgkp9ckM2j0niSShsfuYtU7p3jVeKfdpH70gUAMUNRPgUNztZNGh53do98vtJK4o
         AvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=VmaUr30ESoh88sFLmzG05WK8xqopcpK7DSCGXRbWjcw=;
        b=Bl6tZh/otg1gcRToCqypFm/n3FvScGPrr7b3W2Wvn3fkj+XQE8lQUf1mQRL/Cg08+9
         MZ0/zKfoENvxg0d/vM4C1Kbhhf4gb3bwzUyhMLG4670PNHBeanR3JnsDBVFyVPO+rlpx
         wS+XQHwYgpz3lGB/WU+450yNxS4FLrRVai1M43CgqYLYD0SiBseaGE8xvX0Gly3YWcdY
         0JhMx5PLO0Ss2mEtjdZ0e/m+m7oFUwjFzdG5bzD4GbhA2/wjsFFd9iIG99dTOaD7Z7tf
         RUcze3W8MTNtCgAWDZLYuSORQ787BaC211A/pRLiy3QRnOyvm/NOhemA4jjBnDWUKrvc
         PeGw==
X-Gm-Message-State: ACgBeo3ueJD40x8Uk01nk1AKa7KQ1/PE0TZC4C2XCJVI6w5UdpYCAVUu
        Ueq4xDGS1g5otlQYO6F4bTv7j469wG/KsYpn7pifiEyi
X-Google-Smtp-Source: AA6agR7DY9IdtwtwYtM9f0XW6SfIl8roJhQDJzXkm4/MXslT9m/wv/WRo61IPC8qYoejn0mM3SpNZvwT7QYS9AQkTf4=
X-Received: by 2002:a05:6830:1bc4:b0:636:e925:c3b6 with SMTP id
 v4-20020a0568301bc400b00636e925c3b6mr9249749ota.86.1660720204619; Wed, 17 Aug
 2022 00:10:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAGRSmLvY48qanq6qdi40LE_50xT9ZzUq456KntesLSrxt8AmBw@mail.gmail.com>
 <20220816082344.00001dbf@linux.intel.com> <CAGRSmLvKtjtDtrmv1pp7YEdxOGRYnRXs0WaFS_y0HJxX3NYSaA@mail.gmail.com>
 <828ee094-fbb0-2e55-0728-6fad769dd7ac@suse.de>
In-Reply-To: <828ee094-fbb0-2e55-0728-6fad769dd7ac@suse.de>
From:   "David F." <df7729@gmail.com>
Date:   Wed, 17 Aug 2022 00:09:53 -0700
Message-ID: <CAGRSmLsTB8bNEWcf_V6ZTVpVbgNg66OiZS244tMdtA9c6=aeEw@mail.gmail.com>
Subject: Re: Timeout waiting for /dev/md/imsm0 ?
To:     Hannes Reinecke <hare@suse.de>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It turns out the cause was missing 63-md-raid-arrays.rules.  It
appears 64-md-raid-assembly.rules will assemble the devices on
boot/sysinit and works even without 63-md-raid-arrays.rules, but
starting using the script needs the 63-md-raid-array.rules.  Not sure
why, but that appears to be it.   If I remove 64 and leave 63, the
dmraid takes over, but I can "dmsetup remove_all" then start the md
RAID with the script and it works, I can also use nodmraid and then
run the script.

So thanks for pointing me to udev - still would be curious why 64
doesn't need 63.

On Tue, Aug 16, 2022 at 10:54 PM Hannes Reinecke <hare@suse.de> wrote:
>
> On 8/17/22 04:04, David F. wrote:
> > What rules should be used?   I don't see a /dev/md directory, I
> > created one, stopped the raid (all the /dev/md* devices went away)
> > and tried to start the raid, same thing and only /dev/md127 gets
> > created, nothing in /dev/md/ directory and none of the md126 devices ?
> >   You then get the timeout.
> >
> Please check the device-mapper status.
>
> My guess is that device-mapper gets in the way (as it probably will be
> activated from udev, too), and blocks the devices when mdadm is trying
> to access them.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andre=
w
> Myers, Andrew McDonald, Martje Boudien Moerman
