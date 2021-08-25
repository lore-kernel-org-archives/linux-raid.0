Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2AB8C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 09:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8907061153
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 09:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbhHYJsk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Aug 2021 05:48:40 -0400
Received: from UPDC19PA21.eemsg.mail.mil ([214.24.27.196]:35599 "EHLO
        UPDC19PA21.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236729AbhHYJsj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Aug 2021 05:48:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1629884874; x=1661420874;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZzGQD5YZvfGruVDlAKhlGDKKC1ojIm136xpziBwCP6U=;
  b=AOY+6JHEGq53GU+XvwrrFNx/+d1bwSeJ+MflPRmsCuf70I91v9RmFHIT
   Q8z5StFRmOQRdLfWllXGh2bfJpdVf69UO26xP40WlfJ2CDs7aBQ3ViVfk
   M+YdSLcNC62iPD/EeYrXaRBJ5dBNZE/LNEQa08agCx/gVg7oLSuDTyLEn
   1d5CQBu/XegPqr3GjZaiJdnrVV6GNm9nLN6b6cni9IYti44/DWnkZZL2h
   AtFoJy5nYRfcadFgtqomRC3I4MFyEldjmOvdc5v5EbWcUJJFjg0iX6TUZ
   CNF9DjcSVtz+ZLn+RO/uEb2xXHeHq1QV5PTIH4IbgT3hMKgx3MOJACW9k
   g==;
X-EEMSG-check-017: 259369177|UPDC19PA21_ESA_OUT03.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.84,350,1620691200"; 
   d="scan'208";a="259369177"
Received: from edge-mech02.mail.mil ([214.21.130.231])
  by UPDC19PA21.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 25 Aug 2021 09:47:51 +0000
Received: from UMECHPAOR.easf.csd.disa.mil (214.21.130.161) by
 edge-mech02.mail.mil (214.21.130.231) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Wed, 25 Aug 2021 09:47:48 +0000
Received: from UMECHPA7D.easf.csd.disa.mil ([169.254.5.225]) by
 umechpaor.easf.csd.disa.mil ([214.21.130.161]) with mapi id 14.03.0513.000;
 Wed, 25 Aug 2021 09:47:48 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     'Phillip Susi' <phill@thesusis.net>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: RE: [Non-DoD Source] Re: SSDs and mdraid
Thread-Topic: [Non-DoD Source] Re: SSDs and mdraid
Thread-Index: AdeY2FCguMmiPs6WQsubw5GWI/+SEwAR1HcAAB2gygA=
Date:   Wed, 25 Aug 2021 09:47:48 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A2385862D2F@UMECHPA7D.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A238585EA77@UMECHPA7B.easf.csd.disa.mil>
 <87y28qws0r.fsf@vps.thesusis.net>
In-Reply-To: <87y28qws0r.fsf@vps.thesusis.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [214.21.44.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

IF mdraid RESYNC ran as fast as the SSDs, but it doesn't :)

-----Original Message-----
From: Phillip Susi <phill@thesusis.net>=20
Sent: Tuesday, August 24, 2021 3:39 PM
To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
Cc: linux-raid@vger.kernel.org
Subject: [Non-DoD Source] Re: SSDs and mdraid


"Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil> writes:

> All,
> As I'm trying to achieve maximum performance on mdraid with SSDs, I've=20
> noticed a situation that I think could be corrected somewhat easily.
>
> I've been having to play the partitioning game to get enough kernel=20
> workers to achieve maximum performance on mdraid SSD stripes, but I've=20
> run into a few troubling problems.  Basically on raid creation and on=20
> raid check, many events get DELAYED because they share underlying=20
> devices with other mdraid stripes when you look at the status in=20
> /proc/mdstat.  I feel like mdraid hasn't made the leap to SSDs, in=20
> that we have a signal in /sys/block/<md_device>/queue/rotational that=20
> could enable these DELAYED activities for SSDs.  The SSDs have way=20
> more IOPS, both read and write, to handle these DELAYs and we need to=20
> start taking advantage of the abilities of the SSDs.  It is an SSD=20
> world now.

While there is little to no pentalty for running multiple concurrent IO str=
eams to the SSD, there is nothing gained by doing so either.  In other word=
s, if you are trying to resync both mirrors on different parts of two SSDs =
at the same time, each one will go half as fast, and will take the same amo=
unt of time to finish both.
