Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5270C2D0E4
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 03:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7963320782
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 03:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jLrccrH7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgKYDOX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 22:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgKYDOX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 Nov 2020 22:14:23 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5074DC0613D4
        for <linux-raid@vger.kernel.org>; Tue, 24 Nov 2020 19:14:23 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id l17so1110292pgk.1
        for <linux-raid@vger.kernel.org>; Tue, 24 Nov 2020 19:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=7erBERhph6Rq9KJCqBRhs3SN2hoKC/ELoNLKwZLVThM=;
        b=jLrccrH72s8A9k5Kwn9HTw3grbOcVenwRnyMIPQW5e2L03MxFB2PT1pLfcOQCWeehF
         7TVafHMCCuMgim3Pl+erv/m/X/vsWEenJfTMQzh978rvpw8aePejEIApdAcZiSE2SO/9
         elqB9LQ+ULp46MqjC3vkKD7UnuDeuHFxLRXG4lLdrXEpReLemHtoC+bZz0tMovqhPFQR
         vHjb3GCFU4Z3Jm5tKFZpbyy6AN83m+l87pJpDnEh4eFyIQ/Y13Zd+tnkkr68z852hpGj
         gmQtlSMOREjzDVjNroeJj1UdULAP5hesesXv2NsoXPEyBSg809dNiYgihe6dhfX7NyKK
         QDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=7erBERhph6Rq9KJCqBRhs3SN2hoKC/ELoNLKwZLVThM=;
        b=kqssTOQaD5KZWaH8todnP1QnBqKwrpCtLuz96T5cUBif+gV6IOJcYAkQ34dReq9qyZ
         heF/2Z89RV4cgoSOj+ID9wWAlkY/AqwWYfgEog22FrqD9Ra6xE2es8Ude1+sIK0N//45
         qASXEO1KTIXLpbHyI3K/Sgviecbc63/qKS5rgcOSQXOpsdB3asQ0+0kg/xKOGF9D9zQc
         /mV2fIsgRiV6TbqiIWr+Yu0mYM6rTsTNmqFCImuK9tyq7KneNdMd/5hE28GGKUkdDZbg
         X6nb+lEezxmPmF3nI8QkNiwgmJjpqRFHhlFe/ZE0tE/rGVhxGp6AZ7NtCWVWGgCtjFp1
         GpBg==
X-Gm-Message-State: AOAM531ugQRpvT9TN8+GLIpSeXzt/v5JGOtX0YNZ6xxYFS095Cw8SYDI
        DyoOL/8D4aQiDSxj0ODN0HzF7VT/1FZqsJiPVA==
X-Google-Smtp-Source: ABdhPJxqZG64f8LWGbeAsKngBK8sUsi9Abo+q8XLAMxtHyFvfPttBkp1qI2/xQrI9GlNW35FObZJQDSGfOJkDaffBK4=
X-Received: by 2002:a17:90a:fd0d:: with SMTP id cv13mr1654145pjb.124.1606274062907;
 Tue, 24 Nov 2020 19:14:22 -0800 (PST)
MIME-Version: 1.0
References: <CAB1R3sgQm2_-Bhbzned4y056XP5hM9oz1OnTZSfHH9+L5sdpFQ@mail.gmail.com>
 <c629eb5c-ee37-a7fc-6ffb-8035945e5f16@gmail.com>
In-Reply-To: <c629eb5c-ee37-a7fc-6ffb-8035945e5f16@gmail.com>
From:   Alex <mysqlstudent@gmail.com>
Date:   Tue, 24 Nov 2020 22:14:11 -0500
Message-ID: <CAB1R3sgK3cmqhNM-PcMP88yhFV6mgQwdVYOkUbf4N1aM-BB9sw@mail.gmail.com>
Subject: Re: Considering new SATA PCIe card
To:     Ram Ramesh <rramesh2400@gmail.com>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On Tue, Nov 24, 2020 at 9:47 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
>
> On 11/24/20 8:20 PM, Alex wrote:
> > Hi, I have a fedora33 server with an E31240 @ 3.30GHz processor with
> > 32GB that I'm using as a backup server with 4x4TB 7200 SATA disks in
> > RAID5 and 2x480GB SSDs in RAID1 for root. The motherboard has two
> > SATA-6 ports on it and the others are SATA3.
> >
> > Would there really be any benefit to purchasing a new controller such
> > as this for it instead of the onboard for the 4x4TB disks?
> > https://www.amazon.com/gp/product/B07ST9CPND/
> >
> > The server is relatively responsive, but I was just wondering if I
> > could keep it running for a few more years with a faster SATA
> > controller.
> >
> > I'm also curious if the SATA cables have improved over time, or are
> > the same cables I purchased five years ago just as good today?
> If plan to use addon cards, please consider LSI SAS9211-8i cards. Well
> supported and reliable.

Oh yes, how quickly I forgot. I actually have one of these in another
server, but I think it's too long to physically fit in the case. Just
to be sure, this is the card you're referencing, right?

https://www.ebay.com/itm/LSI-SAS-9211-8i-8-port-6G-IT-Raid-Card-ZFS-JBOD-HBA-SAS-SATA6-0-2008-8I/143735992677
