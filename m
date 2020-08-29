Return-Path: <SRS0=8aTj=CH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B723C433E2
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 16:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 552F820757
	for <linux-raid@archiver.kernel.org>; Sat, 29 Aug 2020 16:27:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2gixNCW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgH2Q1K (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Aug 2020 12:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728310AbgH2Q1H (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Aug 2020 12:27:07 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D91C061236
        for <linux-raid@vger.kernel.org>; Sat, 29 Aug 2020 09:27:06 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id t23so2201124ljc.3
        for <linux-raid@vger.kernel.org>; Sat, 29 Aug 2020 09:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ruh2MH8h6UUJhZFjOqy00EGz/Sry01WbHgtph8EV2w8=;
        b=H2gixNCWL1+UZC06JAxuYeVnT/GSat5wG+iPtAMvdwO6hRdFe6Om8MTriqummmsT0w
         JlCjWYwVE6nZGiB3iyJPv3wx49cLM4fViig4FeSf8bUHmUAtoCVmasui5vXyHS2dpAyO
         rf4Gzy7zpBir4It0CjbCQxCFHVVT5cCMeehXlbG9PiCuniy/pYBvYoa6yyFQuTRiF8ym
         RcrrFEDBKcqx+TRx1OHtfewfwDDp1Yb1colDtheEamgQaD1xheHN/omwLGuWNc0Puf0H
         7/ky7nLhVRbfQTpUfu6EPFxVhQ65AoBbjFqvYxzjGQudzMCnhGcBXro9Y63XGsiCe/V7
         ipQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ruh2MH8h6UUJhZFjOqy00EGz/Sry01WbHgtph8EV2w8=;
        b=X709X+r3jmXj+U1KjRqFS+Ay4FXNMtoOuXIcMP6hzw/w7DUWsjhfzwQCAUKDQJLPmC
         nzABv4DC5+4aI5r5DLcklRo5WNg/UrOClh4/HXzc5Jsg4Tqi5S3zEck4KDeto1dox3xR
         +b4MGDJb0ZgfEqRdnXmIwZ8zT02M5tVHb9hoq0wluBOG/P7Dq2NXWutpzydPFECeWRQC
         lwVUuJ2eJkWl0UysURwtKleuC8PgmskDnh7DBdilZWJgMIkrpnszdW5JAp1A1WPE04U9
         XxA/63zvSW67NGMQ4hxbH2fcTZoIpIwP2ai4FSskNwJmfLFoL6vgKro7rAcZZydsOrgW
         rXyg==
X-Gm-Message-State: AOAM533dgjVLAVO3Ch18dfEoEqEbDb7TunUxvjNaGInHsVt3OVd7D1B2
        hYvvr6wXzgpVBgUrBx7yy+O8XDMMg6rOshUxfCY=
X-Google-Smtp-Source: ABdhPJz94xwrdNmTHv6s7pB4WaajG+0wV34UhLMErPlYorudtaNZxpB6A37aH3V+cv9Jr6FvtdidIWQqAr2mZPsVozk=
X-Received: by 2002:a2e:5316:: with SMTP id h22mr1336741ljb.167.1598718424617;
 Sat, 29 Aug 2020 09:27:04 -0700 (PDT)
MIME-Version: 1.0
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net> <20200828224616.58a1ad6c@natsu>
 <448afb39-d277-445f-cc42-2dfc5210da7b@gmail.com> <6a9fc5ae-1cae-a3d6-6dc3-d1a93dc1e38e@youngman.org.uk>
 <20200829205735.58dfcda1@natsu>
In-Reply-To: <20200829205735.58dfcda1@natsu>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Sat, 29 Aug 2020 11:26:53 -0500
Message-ID: <CAAMCDedK0WFpA9-p9tBMk7vzymUJMMm9nekJTPK9N0hLDUc=ng@mail.gmail.com>
Subject: Re: Best way to add caching to a new raid setup.
To:     Roman Mamedov <rm@romanrm.net>
Cc:     antlists <antlists@youngman.org.uk>,
        Ram Ramesh <rramesh2400@gmail.com>,
        "R. Ramesh" <rramesh@verizon.net>,
        Linux Raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I use mdadm raid.  From what I can tell mdadm has been around a lot
longer and is better understood by a larger group of users.   Hence if
something does go wrong there are a significant number of people that
can help.

I have been running mythtv on mdadm since early-2006, using LVM over
top of it.  I have migrated from 4x500 to 4x1.5tb and am currently on
7x3tb.

One trick I did do on the 3tb's is I did partition the disk into 4
750gb partitions and then each set of 7 makes up a PV.  Often if a
disk gets a bad block or a random io failure it only takes a single
raid from +2 down to +1, and when rebuilding them it rebuilds faster.
I created mine like below:, making sure md13 has all sdX3 disks on it
as when you have to add devices the numbers are the same.  This also
means that when enlarging it that there are 4 separate enlarges, but
no one enlarge takes more than a day.  So there might be a good reason
to say separate a 12tb drive into 6x2 or 4x3 just so if you enlarge it
it does not take a week to finish.   Also make sure to use a bitmap,
when you re-add a previous disk to it the rebuilds are much faster
especially if the drive has only been out for a few hours.

Personalities : [raid6] [raid5] [raid4]
md13 : active raid6 sdi3[9] sdg3[6] sdf3[12] sde3[10] sdd3[1] sdc3[5] sdb3[7]
      3612623360 blocks super 1.2 level 6, 512k chunk, algorithm 2
[7/7] [UUUUUUU]
      bitmap: 0/6 pages [0KB], 65536KB chunk

md14 : active raid6 sdi4[11] sdg4[6] sdf4[9] sde4[10] sdb4[7] sdd4[1] sdc4[5]
      3612623360 blocks super 1.2 level 6, 512k chunk, algorithm 2
[7/7] [UUUUUUU]
      bitmap: 1/6 pages [4KB], 65536KB chunk

md15 : active raid6 sdi5[11] sdg5[8] sdf5[9] sde5[10] sdb5[7] sdd5[1] sdc5[5]
      3612623360 blocks super 1.2 level 6, 512k chunk, algorithm 2
[7/7] [UUUUUUU]
      bitmap: 1/6 pages [4KB], 65536KB chunk

md16 : active raid6 sdi6[9] sdg6[7] sdf6[11] sde6[10] sdb6[8] sdd6[1] sdc6[5]
      3615495680 blocks super 1.2 level 6, 512k chunk, algorithm 2
[7/7] [UUUUUUU]
      bitmap: 0/6 pages [0KB], 65536KB chunk



On Sat, Aug 29, 2020 at 11:00 AM Roman Mamedov <rm@romanrm.net> wrote:
>
> On Sat, 29 Aug 2020 16:34:56 +0100
> antlists <antlists@youngman.org.uk> wrote:
>
> > On 28/08/2020 21:39, Ram Ramesh wrote:
> > > One thing about LVM that I am not clear. Given the choice between
> > > creating /mirror LV /on a VG over simple PVs and /simple LV/ over raid1
> > > PVs, which is preferred method? Why?
> >
> > Simplicity says have ONE raid, with ONE PV on top of it.
> >
> > The other way round is you need TWO SEPARATE (at least) PV/VG/LVs, which
> > you then stick a raid on top.
>
> I believe the question was not about the order of layers, but whether to
> create a RAID with mdadm and then LVM on top, vs. abandoning mdadm and using
> LVM's built-in RAID support instead:
> https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/logical_volume_manager_administration/mirror_create
>
> Personally I hugely prefer mdadm, due to the familiar and convenient interface
> of the program itself, as well as of /proc/mdstat.
>
> --
> With respect,
> Roman
