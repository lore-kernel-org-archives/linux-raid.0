Return-Path: <SRS0=c9Ba=EI=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0471C2D0A3
	for <linux-raid@archiver.kernel.org>; Mon,  2 Nov 2020 18:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 800CE22280
	for <linux-raid@archiver.kernel.org>; Mon,  2 Nov 2020 18:59:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=drivescale-com.20150623.gappssmtp.com header.i=@drivescale-com.20150623.gappssmtp.com header.b="y8K5h6gM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgKBS7x (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Nov 2020 13:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgKBS7x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Nov 2020 13:59:53 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD99C0617A6
        for <linux-raid@vger.kernel.org>; Mon,  2 Nov 2020 10:59:52 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id s21so15776008oij.0
        for <linux-raid@vger.kernel.org>; Mon, 02 Nov 2020 10:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drivescale-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wnk2CLIL87tXQgWK+SrdFKrU8Jb11+wiVutkxS8FJAk=;
        b=y8K5h6gMZ1Tpu2gKkrgqxtPSgjoXfyfnfxZ1Gi6no1fM6Ufkq2SZwgGLU9tdovF8FD
         H1T5vstQrNtQKJuCst5PHACGrAbrRpFWF4UQ2X4WOTR/wX0+FGnay+51KJKTHp2DItpL
         K36OdYDSGrFeiX14jO+skjrnVyGgEq5LWrdeYEWwCOoQ7PpcpO57ytLH5vsaU7bBqf34
         CTYNsKAOoh6Ou3CvKYPkTSccGuyKV+/Q3JJNGxVlby3c5UYNkwckVW82HdOABbSSmhoM
         RLY5KqVxx25NG6jAp1gM9G8CFTXTCXCdzie9kdZIgwj9LkzYbToK7rROvBRNBDGGy+o3
         Rb6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wnk2CLIL87tXQgWK+SrdFKrU8Jb11+wiVutkxS8FJAk=;
        b=dsGhfvgwq2uJP1x4ndN4HjOF4A6IX9S2jqH07QyImzYbP9Vkl44FGQAt3/KCakknag
         vyd6Q8NI5uq1EI9nUFYuczGfpMn+/k309/chmJft79p1EWzxNFJiRoydOB5r8u04w2LL
         ndRzWhE5Bt7JxwcCtdGCqp4IoOjaj8lIceA53Puh7prU5nmZ9KPWi7m7zxDpIk+frL7m
         3wnJmP/BSJs++B1VrDdE7d1yqZxWhDq8ZELD+yEQbLVxZwxO90NQ/+MDnIkpuHRvcXLc
         yTiwb1ZxyiNqgnzp+CaNNg0xJNdsliGLcBsomk/39sjbm2qlCznCptEatK6+VNRoS8YG
         ZQ5A==
X-Gm-Message-State: AOAM532kJ5eRtcGaiPnRZB4IHgEr4jwyrzpDcGpd29ZG1ZRFDT0sZ611
        q3e/1NPn/OlFj0eU/ssYG9MdoTf6oZASn7Lturyx4w==
X-Google-Smtp-Source: ABdhPJyv8ca+UcWsaMrEtPLvZWkJ8u+QT2pHVeI/zOlp0URmlMHhtuM0mOxrGBs5do9zPRpDC/ARcMBfnYn6s/S9Lpc=
X-Received: by 2002:aca:aa90:: with SMTP id t138mr6303107oie.171.1604343592266;
 Mon, 02 Nov 2020 10:59:52 -0800 (PST)
MIME-Version: 1.0
References: <20201023033130.11354-1-cunkel@drivescale.com> <f5ba4699-5620-d30d-2b0b-51b39b46b589@redhat.com>
In-Reply-To: <f5ba4699-5620-d30d-2b0b-51b39b46b589@redhat.com>
From:   Chris Unkel <cunkel@drivescale.com>
Date:   Mon, 2 Nov 2020 10:59:39 -0800
Message-ID: <CAHFUYDpFeK+mkRSkzAydu9emGSzpPxu3QuTN73uatADvfRqzgw@mail.gmail.com>
Subject: Re: [PATCH 0/3] mdraid sb and bitmap write alignment on 512e drives
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

That particular array is super1.2.  The block trace was captured on
the disk underlying the partition device on which the md array member
resides, not on the partition device itself.  The partition starts
2048 sectors into the disk (1MB).  So the 2048 sectors offset to the
beginning of the partition, plus the 8 sector superblock offset for
super1.2 ends up at 2056.

Sorry for the confusion there.

Regards,

 --Chris

On Sun, Nov 1, 2020 at 11:04 PM Xiao Ni <xni@redhat.com> wrote:
>
>
>
> On 10/23/2020 11:31 AM, Christopher Unkel wrote:
> > Hello all,
> >
> > While investigating some performance issues on mdraid 10 volumes
> > formed with "512e" disks (4k native/physical sector size but with 512
> > byte sector emulation), I've found two cases where mdraid will
> > needlessly issue writes that start on 4k byte boundary, but are are
> > shorter than 4k:
> >
> > 1. writes of the raid superblock; and
> > 2. writes of the last page of the write-intent bitmap.
> >
> > The following is an excerpt of a blocktrace of one of the component
> > members of a mdraid 10 volume during a 4k write near the end of the
> > array:
> >
> >    8,32  11        2     0.000001687   711  D  WS 2064 + 8 [kworker/11:1H]
> > * 8,32  11        5     0.001454119   711  D  WS 2056 + 1 [kworker/11:1H]
> > * 8,32  11        8     0.002847204   711  D  WS 2080 + 7 [kworker/11:1H]
> >    8,32  11       11     0.003700545  3094  D  WS 11721043920 + 8 [md127_raid1]
> >    8,32  11       14     0.308785692   711  D  WS 2064 + 8 [kworker/11:1H]
> > * 8,32  11       17     0.310201697   711  D  WS 2056 + 1 [kworker/11:1H]
> >    8,32  11       20     5.500799245   711  D  WS 2064 + 8 [kworker/11:1H]
> > * 8,32  11       23    15.740923558   711  D  WS 2080 + 7 [kworker/11:1H]
> >
> > Note the starred transactions, which each start on a 4k boundary, but
> > are less than 4k in length, and so will use the 512-byte emulation.
> > Sector 2056 holds the superblock, and is written as a single 512-byte
> > write.  Sector 2086 holds the bitmap bit relevant to the written
> > sector.  When it is written the active bits of the last page of the
> > bitmap are written, starting at sector 2080, padded out to the end of
> > the 512-byte logical sector as required.  This results in a 3.5kb
> > write, again using the 512-byte emulation.
>
> Hi Christopher
>
> Which superblock version do you use? If it's super1.1, superblock starts
> at 0 sector.
> If it's super1.2, superblock starts at 8 sector. If it's super1.0,
> superblock starts at the
> end of device and bitmap is before superblock. As mentioned above,
> bitmap is behind
> the superblock, so it should not be super1.0. So I have a question why
> does 2056 hold
> the superblock?
>
> Regards
> Xiao
>
> >
> > Note that in some arrays the last page of the bitmap may be
> > sufficiently full that they are not affected by the issue with the
> > bitmap write.
> >
> > As there can be a substantial penalty to using the 512-byte sector
> > emulation (turning writes into read-modify writes if the relevant
> > sector is not in the drive's cache) I believe it makes sense to pad
> > these writes out to a 4k boundary.  The writes are already padded out
> > for "4k native" drives, where the short access is illegal.
> >
> > The following patch set changes the superblock and bitmap writes to
> > respect the physical block size (e.g. 4k for today's 512e drives) when
> > possible.  In each case there is already logic for padding out to the
> > underlying logical sector size.  I reuse or repeat the logic for
> > padding out to the physical sector size, but treat the padding out as
> > optional rather than mandatory.
> >
> > The corresponding block trace with these patches is:
> >
> >     8,32   1        2     0.000003410   694  D  WS 2064 + 8 [kworker/1:1H]
> >     8,32   1        5     0.001368788   694  D  WS 2056 + 8 [kworker/1:1H]
> >     8,32   1        8     0.002727981   694  D  WS 2080 + 8 [kworker/1:1H]
> >     8,32   1       11     0.003533831  3063  D  WS 11721043920 + 8 [md127_raid1]
> >     8,32   1       14     0.253952321   694  D  WS 2064 + 8 [kworker/1:1H]
> >     8,32   1       17     0.255354215   694  D  WS 2056 + 8 [kworker/1:1H]
> >     8,32   1       20     5.337938486   694  D  WS 2064 + 8 [kworker/1:1H]
> >     8,32   1       23    15.577963062   694  D  WS 2080 + 8 [kworker/1:1H]
> >
> > I do notice that the code for bitmap writes has a more sophisticated
> > and thorough check for overlap than the code for superblock writes.
> > (Compare write_sb_page in md-bitmap.c vs. super_1_load in md.c.) From
> > what I know since the various structures starts have always been 4k
> > aligned anyway, it is always safe to pad the superblock write out to
> > 4k (as occurs on 4k native drives) but not necessarily futher.
> >
> > Feedback appreciated.
> >
> >    --Chris
> >
> >
> > Christopher Unkel (3):
> >    md: align superblock writes to physical blocks
> >    md: factor sb write alignment check into function
> >    md: pad writes to end of bitmap to physical blocks
> >
> >   drivers/md/md-bitmap.c | 80 +++++++++++++++++++++++++-----------------
> >   drivers/md/md.c        | 15 ++++++++
> >   2 files changed, 63 insertions(+), 32 deletions(-)
> >
>
