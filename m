Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7764C64E8A
	for <linux-raid@archiver.kernel.org>; Wed,  2 Dec 2020 01:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 669B92158C
	for <linux-raid@archiver.kernel.org>; Wed,  2 Dec 2020 01:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgLBBWf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Dec 2020 20:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgLBBWe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Dec 2020 20:22:34 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCEDC0613CF
        for <linux-raid@vger.kernel.org>; Tue,  1 Dec 2020 17:21:54 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id q13so170515lfr.10
        for <linux-raid@vger.kernel.org>; Tue, 01 Dec 2020 17:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3mVTg09lbk0wjPFUJXmxCZ5EZg61GjLp5n6o5phJfKU=;
        b=m0lW0mrFCD4CcxVExw5aZtwvtSz4QsjqGHyI+eP43ItiogkgUnZAj5e5REeNCSTuex
         Z++6hY/9XrrNx7vNunzhm4WPe21srVNrjhyiho4PlcwjDIeh0oSSHQeJdkie10WJImlZ
         c5YYREjqmIPv3pywXhFtHmu74+BnHMVBdYUYd+RDlyupPCEB7YQ9waLtjHTJwmd17Nbp
         /uPvpAtNFZzGdTGhsRadHtC6FsGfGziHbGo7c0Lf55PuYGxlx8pOAhRPljQv7Kbyqg5L
         Cflpt3JObKD0yFSxx6j3PADo4F7TSeTOubrXMNwo2A5FuyC7batJdz+OfRMW3NK5DGU8
         7zaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3mVTg09lbk0wjPFUJXmxCZ5EZg61GjLp5n6o5phJfKU=;
        b=eRp+fTMQIkxwnUwDdtjsO4rEwoKZGdtycnqeK1/yKxB8ho40NF2KhewfRYYQFpjxc6
         kXFHHUoSKc7p5jorL2y7ef9UgVwcH3trQZeF2iTqjzy/DQOQkhK+/+spumsA+l0v5Wwd
         flfVnPpCO0AcKRgrwR0ajxv8yoz1ApLJMNcKs1JfitJvCw0r0X+25jrnhd7iEC9XEAAL
         RywM2dY9/TwKwdpni7oqwSfcOhJMb/1aqcIz9NEfrbiUtwUcdbDQlcVhCqpXrgp0qLFO
         PWVWhPR5lGcFEVS2072V3Wm3hpJeAoN2ajlkld0quIAWf4ic24DVKqJ2AxTyPdIusizc
         1v5A==
X-Gm-Message-State: AOAM533j5tQEcxi2Bn4eVsRiMPE6mEd3j5UyNkjtnQ8xTNlpMgcOuXev
        Mi6+gk8z+O0G4gFB13o3vOSuN+05BvOCvu1y57k=
X-Google-Smtp-Source: ABdhPJw+fJLbVtgG8efbG2SX3UuXiczeD5QV/p+jRRCNgbpfBJHpliL/eiBOFnWfBN2ixuWe4FY5yNRyY1VeMW3LJ9M=
X-Received: by 2002:a19:8353:: with SMTP id f80mr153016lfd.348.1606872112415;
 Tue, 01 Dec 2020 17:21:52 -0800 (PST)
MIME-Version: 1.0
References: <CAJH6TXjsg+OE5rUpK+RqeFJRxBiZJ94ToOdUD5ajjwXzYft9Vw@mail.gmail.com>
 <CAJH6TXgED_UGRcLNVU+-1p8BVMapJkRmvZMndLYAKjX_j6f7iw@mail.gmail.com>
 <5FC62A4F.9000100@youngman.org.uk> <CAAMCDefErBEP22cVqLNO3P1fGpXkih=9nFW1OMVQZEAorgB88Q@mail.gmail.com>
 <CAJH6TXjLCuG41-YSkibAMHumoEOXApEQbxFqc47YicTyp3uzTQ@mail.gmail.com>
In-Reply-To: <CAJH6TXjLCuG41-YSkibAMHumoEOXApEQbxFqc47YicTyp3uzTQ@mail.gmail.com>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Tue, 1 Dec 2020 19:21:41 -0600
Message-ID: <CAAMCDefZDakjB4JTF4twzXssBKz3tm29jJJao9zS1+nQOYAnPg@mail.gmail.com>
Subject: Re: Fwd: [OT][X-POST] RAID-6 hw rebuild speed
To:     Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        "General discussion - ask questions, receive answers and advice from
        other ZFS users" <zfs-discuss@list.zfsonlinux.org>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

122 to 204 MB/sec old    if efficient writing all would take about an hour.
200 to 300 MB/sec new.  if efficient writing all 600gb woudl take 2400sec.

so it should be maybe 2x faster.

So to get 20 hours, I am going to guess the old disk had the write
cache turned off and the disk working badly, that would explain it
being that much slower.

It may mean all of the old disk has the write cache on the disk
disabled and the new one does not have it disabled, or the hardware
raid is more efficiently working with the write cache off with the new
disk vs the old disk.  Or it could be the write cache is the same and
the new disk with new firmware works better with command queuing so
wastes less time seeking back and forth.

On Tue, Dec 1, 2020 at 11:15 AM Gandalf Corvotempesta
<gandalf.corvotempesta@gmail.com> wrote:
>
> Il giorno mar 1 dic 2020 alle ore 14:01 Roger Heflin
> <rogerheflin@gmail.com> ha scritto:
> > So what is the model of each disk and how big is the partition used
> > for the array on each of the 8 disks?
>
> Old disk: Seagate ST3600057SS 3.5''
> New disk: Seagate ST600MP0006 2.5''
>
> One huge virtual disk, 3271G
