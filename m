Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BB7C2D0E4
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 03:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 862CE2075A
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 03:28:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZjjwNniu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgKYD2i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 22:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgKYD2h (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 Nov 2020 22:28:37 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B95C0613D4
        for <linux-raid@vger.kernel.org>; Tue, 24 Nov 2020 19:28:37 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 34so1095218pgp.10
        for <linux-raid@vger.kernel.org>; Tue, 24 Nov 2020 19:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GohTvHnyQ3Jo9+E0RM7RIR5AARwOAdHGrwMp2/B8BG0=;
        b=ZjjwNniu2lSMSYjFUig8Z+cnd7OQTdL5xfcJkzk9rTNpecfHAJE6pgXfF4bCG3EVh5
         yX1kXAo9JgKsbhZqsUr2Q36MiOJA2CP7DXMjDiv/3+qdRoVwWeW9yFdhwa2cahswjwHq
         J98xcnX6FLtCy5d4jd63rsdyt2pTghm0tUKSp9Axm10xQOOBzRU69GkQXnYo5Zd7tYNq
         v+lLMKfTwWKhlTR4tm3GsibICrFt9sK9EwJv3Yi8YydI3ZX9X5+0i3nbldHs1B9lf8rC
         Ngwt1y9/PL+lwy9SsUVt+98rVUsXsfxfe0LfAHGXrNXNjqeafFhcslsIHFscuyJr288j
         s3Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GohTvHnyQ3Jo9+E0RM7RIR5AARwOAdHGrwMp2/B8BG0=;
        b=GLkd/XYSDjKELNf2ugeS/MKlyBI4bJXauB68giargs6tl4MaebxMC3FFqgtYnq5AD0
         fDEVrnFIIPhCiurYnQeqzmi/24tO3IdSPLtJ0LsTKPIQhb4uLKE/dwOXqAGwJUSeB/DR
         4b8r5L3WKQ7Uzmgn8+kaCUQIUaDAHYkatSroFe7Cx215PdazS+5heNQ5uj68rwapsD4G
         3wPAXxCTzYRipkY2F7q0e8qH1DmnTrf/tT5dG5cxtylQzosIYhukBdg6i7Sv6U1cY6Jo
         Z49ZPlUP2BWTKA8qWO/8qAcjwYPMW145HN2YF5Z8mPPWYpxSgTYcFm+thLmXbzTiek/S
         9GRA==
X-Gm-Message-State: AOAM531gKjLl7UO4dPQN4isMWA/1orcZOYViQzmrB5kzFeOqwe9ygpO5
        O7nqBAK7EhoHMDnBSvgFqDunYiqKWMdzZCDUWLfjs3mZ1w==
X-Google-Smtp-Source: ABdhPJyLfkSoN40msuAk+NY6sgTj+8Zzj49fs+BO26Bwo7e0r6SR38PzkKrL3c6hKHm0rA2i4z4uUkEQbS4guKzKdzA=
X-Received: by 2002:a17:90a:c695:: with SMTP id n21mr1735751pjt.86.1606274917391;
 Tue, 24 Nov 2020 19:28:37 -0800 (PST)
MIME-Version: 1.0
References: <CAB1R3sgQm2_-Bhbzned4y056XP5hM9oz1OnTZSfHH9+L5sdpFQ@mail.gmail.com>
 <c629eb5c-ee37-a7fc-6ffb-8035945e5f16@gmail.com> <CAB1R3sgK3cmqhNM-PcMP88yhFV6mgQwdVYOkUbf4N1aM-BB9sw@mail.gmail.com>
 <25741f58-676a-c4ef-7463-31b5b3a08bc5@gmail.com>
In-Reply-To: <25741f58-676a-c4ef-7463-31b5b3a08bc5@gmail.com>
From:   Alex <mysqlstudent@gmail.com>
Date:   Tue, 24 Nov 2020 22:28:26 -0500
Message-ID: <CAB1R3siNB0u8g+JNcLf+n0BEpUt2HjXam4DmqMXNDuVTjoWaWg@mail.gmail.com>
Subject: Re: Considering new SATA PCIe card
To:     Ram Ramesh <rramesh2400@gmail.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

> >> If plan to use addon cards, please consider LSI SAS9211-8i cards. Well
> >> supported and reliable.
> > Oh yes, how quickly I forgot. I actually have one of these in another
> > server, but I think it's too long to physically fit in the case. Just
> > to be sure, this is the card you're referencing, right?
> >
> > https://www.ebay.com/itm/LSI-SAS-9211-8i-8-port-6G-IT-Raid-Card-ZFS-JBOD-HBA-SAS-SATA6-0-2008-8I/143735992677
> Yes. Any one of those that mentions this controller and preferably IT
> (just HBA) firmware instead of IR (Raid) firmware as your raid will be
> implemented as SW mdraid over JBOD.

Thanks so much for your help. Are there other similar LSI cards that
are also well supported?

This looks like a 4-port version of the same card that would certainly fit.
https://www.ebay.com/itm/IBM-H1110-81Y4494-SAS-2-6Gbps-HBA-LSI-9211-4i-P20-IT-Mode-for-ZFS-FreeNAS-unRAID/143488380023

And here's a 1GB cache version?
https://www.ebay.com/itm/LSI-MegaRaid-SAS-9270CV-8i-1G-Cache-PCI3-0-6Gb-s-Raid-Card-SAS-Controller/143780173461
