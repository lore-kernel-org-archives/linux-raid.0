Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7AA8C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 06:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1D7D61040
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 06:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhJLHAp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Oct 2021 03:00:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233379AbhJLHAp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 12 Oct 2021 03:00:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634021923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8RijpfQi+prw8bXnwoWv3a6J45QoIwKMNHS02qVkCw=;
        b=KgNE9GMJYRJmjekzIrzTg1CbXspW3stzRTjevR4bAQ/AA6cIYraeQAniftHpD2Q2RzenTA
        0jx57b/mlvvNxwRqDP8GtYFQQ35lc4w282J3DNHj2x3MrJXplvlxuMN39kLTbMA6oMxyHM
        ZLfkzs0EESqRJVjHSbdP/kI9uq2/1ag=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-fsKPwICsPtK_QKblnJprWw-1; Tue, 12 Oct 2021 02:58:42 -0400
X-MC-Unique: fsKPwICsPtK_QKblnJprWw-1
Received: by mail-ed1-f72.google.com with SMTP id p13-20020a056402044d00b003db3256e4f2so18120490edw.3
        for <linux-raid@vger.kernel.org>; Mon, 11 Oct 2021 23:58:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q8RijpfQi+prw8bXnwoWv3a6J45QoIwKMNHS02qVkCw=;
        b=qHDLPZxjP2xb9cVWLBQfxw8yu2jz4fe7RN3IsO1O0Hc1NeosOojAEuKhKp40KWIpsz
         mzr/1+E9VwQpAq6gX3UdEezXaIgmm7GErgtShHRK7vdWaqPH7zpkbJvS97XfZ1nCOeSR
         eErx2GoEkn1eHaHJwBImjM1KK/6WdwdPZgwuMq541dfvMG5xMk0KcI+fS4hmNQAVwNqc
         adXU1aaevRzy+5PwvfU0h5N9LFd/z+WwRzM+A0x8JNU/BtG1+CDYXOnqclvpAOF3nhAS
         qGHVyUXr+qhpZVb8gPHz2JbxTroQq0H50o6VFH1Fg+rDrkvlXmX1/Jhc1WCOI36qXugl
         V4wg==
X-Gm-Message-State: AOAM530dRY30vca+7UBm1rfHLmy6IcC47yVFmWGnB1XUbC3cT3V/o2Es
        7DLgN3qF30DfscLio/jHswE7tnv98ZthQ+qGSHNrMz7WP45vT9vUovW2M2MnBfT6+8vPrrowjbN
        ldqv+MfmBkVeBuyXxPugAWJCReN08YB3W5TVNag==
X-Received: by 2002:a17:906:6d0a:: with SMTP id m10mr29787752ejr.90.1634021921120;
        Mon, 11 Oct 2021 23:58:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRHeJ989p7dVG/ei6yafdn1mzzyjVVyI8bkiTnv+xsecY3u5UUD0ZFpoZSsrAAywRK1lgyPepPpZKinKOGrh4=
X-Received: by 2002:a17:906:6d0a:: with SMTP id m10mr29787733ejr.90.1634021920886;
 Mon, 11 Oct 2021 23:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032231.1143467-1-fengli@smartx.com> <CAPhsuW5+bdQwsyjBP=QDGRbtnF021291D_XrhNtV+v-geVouVg@mail.gmail.com>
 <CALTww28b0HGzSTTNGVzeZdRp0nGMDAyY8sQ+cBsSCuYJ4jMaqw@mail.gmail.com> <CAHckoCyuqxM8po4JA4=OacVWhYuo9SWescUVOKRFGwdc=aoN8A@mail.gmail.com>
In-Reply-To: <CAHckoCyuqxM8po4JA4=OacVWhYuo9SWescUVOKRFGwdc=aoN8A@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 12 Oct 2021 14:58:30 +0800
Message-ID: <CALTww28CsJdmVOLFeoHC8FgbHDK78h8Lncsf9fFA0RYXEj=R9A@mail.gmail.com>
Subject: Re: [PATCH RESEND] md: allow to set the fail_fast on RAID1/RAID10
To:     Li Feng <fengli@smartx.com>
Cc:     Song Liu <song@kernel.org>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Oct 11, 2021 at 5:42 PM Li Feng <fengli@smartx.com> wrote:
>
> Xiao Ni <xni@redhat.com> =E4=BA=8E2021=E5=B9=B410=E6=9C=8811=E6=97=A5=E5=
=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=883:49=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi all
> >
> > Now the per device sysfs interface file state can change failfast. Do
> > we need a new file for failfast?
> >
> > I did a test. The steps are:
> >
> > mdadm -CR /dev/md0 -l1 -n2 /dev/sdb /dev/sdc --assume-clean
> > cd /sys/block/md0/md/dev-sdb
> > echo failfast > state
> > cat state
> > in_sync,failfast
>
> This works,  will it be persisted to disk?
>

mdadm --detail /dev/md0 can show the failfast information. So it
should be written in superblock.
But I don't find how md does this. I'm looking at this.

Regards
Xiao

