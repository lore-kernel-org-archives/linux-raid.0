Return-Path: <SRS0=RAIN=C2=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FFBC433E2
	for <linux-raid@archiver.kernel.org>; Thu, 17 Sep 2020 07:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4982F21974
	for <linux-raid@archiver.kernel.org>; Thu, 17 Sep 2020 07:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600326270;
	bh=0+hT+GYcvJSeqK98OPsXXzedHRgK8e06mreG6di3eT4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=NF7lwoVbtNOOE8dujUWZY3MISpkQJcBX1VRX0lDIKnpIqDGeuxa0x61bk5P91E+rO
	 S96dWXGSt+6+MiBuqKXKPpfrA1vaO0K988vjhkUnaygD0PoSsSaUcirCu1uYJkJLtZ
	 YYGHUYaxTLCrFOsPc62f4xcJIWDVncAKw9QR1NDQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgIQHEI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgIQHDl (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 17 Sep 2020 03:03:41 -0400
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7F5C21D43
        for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2020 07:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600326216;
        bh=0+hT+GYcvJSeqK98OPsXXzedHRgK8e06mreG6di3eT4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Sbe/8QIPrR57cyqQOeSjZeMk5oFHWArb+osMh2JRiqxHbWA7XTe0UQ3cXqfuzeh5Q
         gv0yurt4BXy/fz5HxX+vAUOV2uBcULX/uwKbn02FTMZd4+GRChpBq978G46BDRP/1Z
         9fsqlEzaBEEXjlJeHf2w3nubpNfGpgqyQc9VnZLI=
Received: by mail-lj1-f180.google.com with SMTP id v23so1089102ljd.1
        for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2020 00:03:35 -0700 (PDT)
X-Gm-Message-State: AOAM530Ua+aOEjVi9CHh9INK96kDuFekovDKJb6tuoFbhykhGxLgpG9Y
        QiA3YWsH2O1nBMveTWHptiMIUynn/0cSk9Ll+FA=
X-Google-Smtp-Source: ABdhPJxyZ0cEyWIU4Sf+VFDSQnXN92gtRxQ6S20DiUznhvR57MgwTy6GSdtp3N3z9t3LYGvvBsD30PnlNc66/VeLJII=
X-Received: by 2002:a2e:7602:: with SMTP id r2mr9888799ljc.10.1600326213891;
 Thu, 17 Sep 2020 00:03:33 -0700 (PDT)
MIME-Version: 1.0
References: <6F1A48DB-CA95-433B-91F3-D0051453A8E1@amazon.com>
In-Reply-To: <6F1A48DB-CA95-433B-91F3-D0051453A8E1@amazon.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 17 Sep 2020 00:03:22 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6q5bLgOUyuTH8MFTo6GSnGqRxne6sV+dsFHRy_qHtxRA@mail.gmail.com>
Message-ID: <CAPhsuW6q5bLgOUyuTH8MFTo6GSnGqRxne6sV+dsFHRy_qHtxRA@mail.gmail.com>
Subject: Re: RAID5 issue with UBUNTU 20.04.1 on my desktop
To:     "Sung, KoWei" <winders@amazon.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Duan, HanShen" <hansduan@amazon.com>,
        "Tokoyo, Hiroshi" <htokoyo@amazon.co.jp>,
        "Fortin, Mike" <mfortin@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Winder,

On Wed, Sep 16, 2020 at 2:53 AM Sung, KoWei <winders@amazon.com> wrote:
>
> Hi,
>
> I found RAID5 stability issue while doing disk expansion.
> I attached 4 disks (/dev/sda, /dev/sdb, /dev/sdc and /dev/sdd) and create=
 partition by =E2=80=9Ccreate_partition.sh=E2=80=9D scripts on my PC and ru=
n my test scripts =E2=80=9Craid_reshape_12.sh=E2=80=9D (as attached).
> Basically, the test will add partitions to RAID5 (/dev/md3) and write fil=
es to /dev/md3 (ext4) at the same time.
> Within 1 or 2 hours, kernel will get crashed (Oops) and reshape/resync ca=
nnot be finished forever (log as attached).
>
> The issue happens randomly, but it most likely happens at beginning of re=
shape process. When kernel crash happens, the reshape stops at about 3-10% =
complete only.
> Moreover, it is not related to any partition size, because I=E2=80=99ve t=
ried different size, but issue still exists.
> I've also tried different kernel (4.1/4.2/4.9/4.19/5.4/5.8), and all kern=
el version can see this issue.

Thanks for the report. I just started some tests with the script. I
will update whether it repros the issue.

Song
