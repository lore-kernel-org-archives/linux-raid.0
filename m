Return-Path: <SRS0=RtKw=CA=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25281C433E1
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 19:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB93F2075E
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 19:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgHVTyV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 22 Aug 2020 15:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgHVTyV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 22 Aug 2020 15:54:21 -0400
Received: from smtp.domeneshop.no (smtp.domeneshop.no [IPv6:2a01:5b40:0:3005::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1D2C061573
        for <linux-raid@vger.kernel.org>; Sat, 22 Aug 2020 12:54:20 -0700 (PDT)
Received: from cm-46.212.141.180.getinternet.no ([46.212.141.180]:43102 helo=olstad.com)
        by smtp.domeneshop.no with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <raid+list@olstad.com>)
        id 1k9Zag-0000Aq-6T; Sat, 22 Aug 2020 21:54:14 +0200
Date:   Sat, 22 Aug 2020 21:54:12 +0200
From:   Kai Stian Olstad <raid+list@olstad.com>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: Recommended filesystem for RAID 6
Message-ID: <20200822195412.2rtcwh2zfsj72ja2@olstad.com>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
 <1381759926.21710099.1597158389614.JavaMail.zimbra@karlsbakk.net>
 <4a7bfca8-af6e-cbd1-0dc4-feaf1a0288be@fritscher.net>
 <5F32F56C.7040603@youngman.org.uk>
 <CAJCQCtRkLmfQ9BHy1ymYU=LC95LA2b2-Pyf_Gm8X06cza1YUjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtRkLmfQ9BHy1ymYU=LC95LA2b2-Pyf_Gm8X06cza1YUjw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Aug 22, 2020 at 12:50:50PM -0600, Chris Murphy wrote:
> On Tue, Aug 11, 2020 at 1:47 PM Wols Lists <antlists@youngman.org.uk> wrote:
> >
> > On 11/08/20 20:19, Michael Fritscher wrote:
> > > Hi,
> > >
> > > if you really want to use these tiny 2 TB HDDs - yes, RAID 6 (2x - the
> > > second for the backup system on a physically different location) is a
> > > good choice.
> > >
> > > But: If you can, buy some 8-12 TB HDDs and forget the old rusty tiny
> > > HDDs. You'll save a lot at the system - and power.
> > >
> > I'm looking at one of these ...
> > https://www.amazon.co.uk/Seagate-ST8000DM004-Barracuda-internal-Silver/dp/B075WYBQXJ/ref=pd_ybh_a_8?_encoding=UTF8&psc=1&refRID=WF1CTS2K9RWY96D1RENJ
> >
> > Note that it IS a shingled drive, so fine for backup, much less so for
> > anything else.
> 
> How can you tell? From the spec, I can't find anything that indicates
> it. Let alone which of three varieties it is.
> https://www.seagate.com/www-content/product-content/barracuda-fam/barracuda-new/en-us/docs/100805918d.pdf

You can't from the spec[1], but you have this one[2] in the wake of WD
Red started to use SMR without telling anyone.

[1] https://blocksandfiles.com/2020/04/15/seagate-2-4-and-8tb-barracuda-and-desktop-hdd-smr/
[2] https://www.seagate.com/gb/en/internal-hard-drives/cmr-smr-list/


-- 
Kai Stian Olstad
PS: Sorry Chris, you get this twice, I forgot reply-to-all.
