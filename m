Return-Path: <SRS0=YfF9=D6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD997C5517A
	for <linux-raid@archiver.kernel.org>; Fri, 23 Oct 2020 05:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 907D920BED
	for <linux-raid@archiver.kernel.org>; Fri, 23 Oct 2020 05:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603431729;
	bh=YMvvRcZYimxB0yoov1roU28wevk7Men9gENsSxF7cvM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=icu7p2mBhvEoDJIELupPPVC9e5EvT9gPWIV6IguNevdOEV9TpQnv8xmChOHKIJIy1
	 9h/iQTki4cjqqSOl0o7uJXZCxT8Y5H9r9E/iP4Abvi8+b5aSviCsx+JWHSoU3pboM+
	 3AOPn/7RX9NIJJiMtotmXAXWVKlRxjEvPU7R+f5A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371628AbgJWFmF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Oct 2020 01:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S371624AbgJWFmF (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 23 Oct 2020 01:42:05 -0400
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DFD020BED;
        Fri, 23 Oct 2020 05:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603431724;
        bh=YMvvRcZYimxB0yoov1roU28wevk7Men9gENsSxF7cvM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Mqh+sCvPQC67UG5bWtV3Eh+J6Oih83DZhxYLFMLw7x9+m7mjooq4w3UF9xWhlBvMi
         nBpU1mK1Mh9mWCN3pk3kquDYvePW9KAAxYngKYRpAx77pcQJQ3Mvyb8q6fmPvkzJ/I
         M3HRoj4Qmwdg/s8TgrxMdjmg0o5wAlY0wcl2MR8k=
Received: by mail-lf1-f49.google.com with SMTP id v6so569010lfa.13;
        Thu, 22 Oct 2020 22:42:04 -0700 (PDT)
X-Gm-Message-State: AOAM533Do49Cnjuz4iXar/LNsW5M/dFYtyn2LVwaTtMD6pRi/EeNGG7j
        5FkBsXIDxh93GfLXxMwWAHljJniyCs+npDqPFEo=
X-Google-Smtp-Source: ABdhPJyncsib2GwIWRRiR8SwItNwZY/PJ+Ldnl3AS3u/s1TC4WTbs3uVuMJzrKw0S1q+unNfwRdPNRGwofjYQC1ByEA=
X-Received: by 2002:a05:6512:3710:: with SMTP id z16mr194904lfr.504.1603431722387;
 Thu, 22 Oct 2020 22:42:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201023033130.11354-1-cunkel@drivescale.com>
In-Reply-To: <20201023033130.11354-1-cunkel@drivescale.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 22 Oct 2020 22:41:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7vn9trTBy0vxd7D=x3Jj=Wo2cTbQNZa6dw2BS5dnfLLg@mail.gmail.com>
Message-ID: <CAPhsuW7vn9trTBy0vxd7D=x3Jj=Wo2cTbQNZa6dw2BS5dnfLLg@mail.gmail.com>
Subject: Re: [PATCH 0/3] mdraid sb and bitmap write alignment on 512e drives
To:     Christopher Unkel <cunkel@drivescale.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Oct 22, 2020 at 8:31 PM Christopher Unkel <cunkel@drivescale.com> wrote:
>
> Hello all,
>
> While investigating some performance issues on mdraid 10 volumes
> formed with "512e" disks (4k native/physical sector size but with 512
> byte sector emulation), I've found two cases where mdraid will
> needlessly issue writes that start on 4k byte boundary, but are are
> shorter than 4k:
>
> 1. writes of the raid superblock; and
> 2. writes of the last page of the write-intent bitmap.
>
> The following is an excerpt of a blocktrace of one of the component
> members of a mdraid 10 volume during a 4k write near the end of the
> array:
>
>   8,32  11        2     0.000001687   711  D  WS 2064 + 8 [kworker/11:1H]
> * 8,32  11        5     0.001454119   711  D  WS 2056 + 1 [kworker/11:1H]
> * 8,32  11        8     0.002847204   711  D  WS 2080 + 7 [kworker/11:1H]
>   8,32  11       11     0.003700545  3094  D  WS 11721043920 + 8 [md127_raid1]
>   8,32  11       14     0.308785692   711  D  WS 2064 + 8 [kworker/11:1H]
> * 8,32  11       17     0.310201697   711  D  WS 2056 + 1 [kworker/11:1H]
>   8,32  11       20     5.500799245   711  D  WS 2064 + 8 [kworker/11:1H]
> * 8,32  11       23    15.740923558   711  D  WS 2080 + 7 [kworker/11:1H]
>
> Note the starred transactions, which each start on a 4k boundary, but
> are less than 4k in length, and so will use the 512-byte emulation.
> Sector 2056 holds the superblock, and is written as a single 512-byte
> write.  Sector 2086 holds the bitmap bit relevant to the written
> sector.  When it is written the active bits of the last page of the
> bitmap are written, starting at sector 2080, padded out to the end of
> the 512-byte logical sector as required.  This results in a 3.5kb
> write, again using the 512-byte emulation.
>
> Note that in some arrays the last page of the bitmap may be
> sufficiently full that they are not affected by the issue with the
> bitmap write.
>
> As there can be a substantial penalty to using the 512-byte sector
> emulation (turning writes into read-modify writes if the relevant
> sector is not in the drive's cache) I believe it makes sense to pad
> these writes out to a 4k boundary.  The writes are already padded out
> for "4k native" drives, where the short access is illegal.
>
> The following patch set changes the superblock and bitmap writes to
> respect the physical block size (e.g. 4k for today's 512e drives) when
> possible.  In each case there is already logic for padding out to the
> underlying logical sector size.  I reuse or repeat the logic for
> padding out to the physical sector size, but treat the padding out as
> optional rather than mandatory.
>
> The corresponding block trace with these patches is:
>
>    8,32   1        2     0.000003410   694  D  WS 2064 + 8 [kworker/1:1H]
>    8,32   1        5     0.001368788   694  D  WS 2056 + 8 [kworker/1:1H]
>    8,32   1        8     0.002727981   694  D  WS 2080 + 8 [kworker/1:1H]
>    8,32   1       11     0.003533831  3063  D  WS 11721043920 + 8 [md127_raid1]
>    8,32   1       14     0.253952321   694  D  WS 2064 + 8 [kworker/1:1H]
>    8,32   1       17     0.255354215   694  D  WS 2056 + 8 [kworker/1:1H]
>    8,32   1       20     5.337938486   694  D  WS 2064 + 8 [kworker/1:1H]
>    8,32   1       23    15.577963062   694  D  WS 2080 + 8 [kworker/1:1H]
>
> I do notice that the code for bitmap writes has a more sophisticated
> and thorough check for overlap than the code for superblock writes.
> (Compare write_sb_page in md-bitmap.c vs. super_1_load in md.c.) From
> what I know since the various structures starts have always been 4k
> aligned anyway, it is always safe to pad the superblock write out to
> 4k (as occurs on 4k native drives) but not necessarily futher.
>
> Feedback appreciated.
>
>   --Chris

Thanks for the patches. Do you have performance numbers before/after these
changes? Some micro benchmarks results would be great motivation.

Thanks,
Song


>
>
> Christopher Unkel (3):
>   md: align superblock writes to physical blocks
>   md: factor sb write alignment check into function
>   md: pad writes to end of bitmap to physical blocks
>
>  drivers/md/md-bitmap.c | 80 +++++++++++++++++++++++++-----------------
>  drivers/md/md.c        | 15 ++++++++
>  2 files changed, 63 insertions(+), 32 deletions(-)
>
> --
> 2.17.1
>
