Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44176C5AC75
	for <linux-raid@archiver.kernel.org>; Wed, 26 Jan 2022 01:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbiAZBNr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Jan 2022 20:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiAZBNp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 Jan 2022 20:13:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A4FC06161C
        for <linux-raid@vger.kernel.org>; Tue, 25 Jan 2022 17:13:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26BDFB819BE
        for <linux-raid@vger.kernel.org>; Wed, 26 Jan 2022 01:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A11C340E5
        for <linux-raid@vger.kernel.org>; Wed, 26 Jan 2022 01:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643159622;
        bh=GMT28Kz8yIfP0mgP8R/CzC0RAr1PzRvflmzPVTUGjUk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VR13SgIzpyhdn20AGMQx1mYsPuQHhp/u8qP1Ff9tJA3KfDor35tNWXIXFaxhrHWTj
         vSHx1H1aK84fxqCCgpsyP4/1Nf76tHaYy36xFlpyb7lzIpYpPtQB13RUsS9n9XC69R
         FOSlDHfhSNud/CSA482mYfA8xDg7NWAcyyr9Yr817UO/d08Tc4j5zPseg9TUVUbNWw
         usl6dUkEOMHjjExP1BM18XHp+6ykAweFzR89yUmQHwdvdSo/+WGvRivHHnA58mLxY2
         LfdZapWy7MaFkHGIQbJqkjprXeBZukVRGU+Ku00K0am9QS/trdY1g7FP9IkaJ0vjqu
         01AHT/hDAWuMg==
Received: by mail-yb1-f179.google.com with SMTP id k17so11631866ybk.6
        for <linux-raid@vger.kernel.org>; Tue, 25 Jan 2022 17:13:42 -0800 (PST)
X-Gm-Message-State: AOAM533duy1trmo3uHbIO8uPUHQt1y0S7iNErb50f27FRUmjaXXoAUug
        uXiPTcJxDHvDvD/pWoNdNC4jQtUwgqhYsrrLTSs=
X-Google-Smtp-Source: ABdhPJzarp6HgX/jGxCGKiphPyPOC2UQDl09b9OjmqyJQqjqtAA/37OHH9PzcuGz7P/fhfLarnAR1TZJDX1iWFsBDVs=
X-Received: by 2002:a25:8d0d:: with SMTP id n13mr34244445ybl.208.1643159622001;
 Tue, 25 Jan 2022 17:13:42 -0800 (PST)
MIME-Version: 1.0
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
 <CAPhsuW4zmx+mU6vxiTARPme3P0ANMNbC537SDKj2dEDKc_30kg@mail.gmail.com>
 <20211217090238.00000166@linux.intel.com> <20220125165225.00000407@linux.intel.com>
In-Reply-To: <20220125165225.00000407@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 25 Jan 2022 17:13:31 -0800
X-Gmail-Original-Message-ID: <CAPhsuW43QfDNGEu72o2_eqDZ5vGq3tbFvdZ-W+dxVqcEhHmJ5w@mail.gmail.com>
Message-ID: <CAPhsuW43QfDNGEu72o2_eqDZ5vGq3tbFvdZ-W+dxVqcEhHmJ5w@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Use MD_BROKEN for redundant arrays
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jan 25, 2022 at 7:52 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Fri, 17 Dec 2021 09:02:38 +0100
> Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:
>
> > Hi Song,
> >
> > On Thu, 16 Dec 2021 16:52:23 -0800
> > Song Liu <song@kernel.org> wrote:
> > > > Mariusz Tkaczyk (3):
> > > >   raid0, linear, md: add error_handlers for raid0 and linear
> > > >   md: Set MD_BROKEN for RAID1 and RAID10
> > > >   raid5: introduce MD_BROKEN
> > >
> > > The set looks good to me. The only concern is that we changed some
> > > messages. While dmesg is not a stable API, I believe there are
> > > people grep on it to detect errors.
> > > Therefore, please try to keep these messages same as before (as much
> > > as possible).
> >
> > Will do.
> > After sending it, I realized that my approach is not correct when
> > mddev->fail_last_dev is on. MD_BRKOEN should be set even if we agree
> > to remove the "last" drive. I will fix it too.
> >
>
> Hi Song,
> For raid0 and linear i added new messages so it shouldn't be a problem.
> I added one message in raid5 for failed state:
> +               pr_crit("md/raid:%s: Cannot continue on %d devices.\n",
>
> Do you want to remove it?
> Other errors are same. Order is also preserved.

I think we should print in this case. How about we change it to something
similar to the one in raid5_run():

                pr_crit("md/raid:%s: Cannot continue operation (%d/%d
failed)\n",
                        mdname(mddev), mddev->degraded, conf->raid_disks);

Thanks,
Song
