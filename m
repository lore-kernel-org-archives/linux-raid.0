Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43157C678D4
	for <linux-raid@archiver.kernel.org>; Tue,  7 Mar 2023 17:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCGR5p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Mar 2023 12:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjCGR5M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Mar 2023 12:57:12 -0500
X-Greylist: delayed 10802 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Mar 2023 09:51:48 PST
Received: from outbound5g.eu.mailhop.org (outbound5g.eu.mailhop.org [18.156.67.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097F99F059
        for <linux-raid@vger.kernel.org>; Tue,  7 Mar 2023 09:51:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678186776; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=b9QCTByjkSMj3lpXOv+ybZdNUOxpmiSKYIvPFfXMBV+8PAGYGsV1pOUG+AX/7p4I88Xc+HNjFlV04
         vxAYwirsntkMo91+fI/nNSYKZMVLj0Z1/rBy5OJ7JrkuWuyAnPvGLmRBajPPwCNWQG0uPPB3c2JOHw
         wOI1jrZojsbSI2WzmKzYOMolAARUip8y9bIjeTHpxh3dY/4NILxyoFIv93Uoz2qX37IkCbz1W5Sh7Q
         gBulsebHtnQsRD2O53kQqTtgEd1hXnjFsv16CrLLFkOIC1OhIFLY/S+GCL+snVc9zP6U92/bC8meMv
         /kgtwZYStioDm8fAlI9aYi3nPvNXf6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
         subject:mime-version:date:message-id:dkim-signature:from;
        bh=TzhrO4VBFZu5U+ysgKVGMFF6W6ht/M/84NEVDGT6gLk=;
        b=uoP+tXa0dY5lDfuVlo97B9jGh6zzs5DifTNXUAW3XsjDa0SzJAAIiDUO2i5Ma0/HkzRyGPOVwRg1A
         epkHUFU7Y+lm7jt1SiiMI1s0HYnR2EWONZV26sDr2w7H+LygfkifPtjKZFR/gZRtMUWLQ4qqjncazy
         9yb9vAqhhAT3cEpFAZCj4Tn943I7j4VE04Iv8e4C+aZbOb0H4eQsVPDzb8eH53NA4AWilxQt29mt/E
         iSbMYgrpEiBrf7Xrtq4m5HjEDgmy7w1IRX/MlIJjO1JbJu+s6X8qU73H5DsmpMg51+jsTbgYlfK81W
         T4yRX0wh3x2voRIPTvJ0k4a77LNpHJg==
ARC-Authentication-Results: i=1; outbound2.eu.mailhop.org;
        spf=softfail smtp.mailfrom=demonlair.co.uk smtp.remote-ip=109.155.212.229;
        dmarc=none header.from=demonlair.co.uk;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
         subject:mime-version:date:message-id:from;
        bh=TzhrO4VBFZu5U+ysgKVGMFF6W6ht/M/84NEVDGT6gLk=;
        b=maNv9it6R+ch8/3vcLsnIzDMBccu7NffRdQ2DtQVEYxtm6xK4ZgwhJLf2CfkKnCnEu/NQFfnZ8eMZ
         VduNmtoinFiBrDKNWar8cc00+Y7qd6IOoGg5I1MPS6sTxnPOo0V/cN80nNHHdEFFzf//GHQ3ojV+Cp
         xpRRqFAkye2eCLpFXREjs+amssL8gUm+1jbfWGd9D3eYJzBauIOeGIGz51QRYRos0/M/bpsLffGylH
         zcXY1orqI7AUdBYkBi21++ozkcExqabmXonFwInROo6vgPKoXI6bFDFKK5naNvj/yg+A+0JE0V+dR2
         rix7ekoms/IK87fKN5hVjtwRueA5UtQ==
X-Originating-IP: 109.155.212.229
X-MHO-RoutePath: ZGVtb25sYWly
X-MHO-User: 2492d59e-bcd7-11ed-bc05-4b4748ac966b
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from phoenix.demonlair.co.uk (host109-155-212-229.range109-155.btcentralplus.com [109.155.212.229])
        by outbound2.eu.mailhop.org (Halon) with ESMTPA
        id 2492d59e-bcd7-11ed-bc05-4b4748ac966b;
        Tue, 07 Mar 2023 10:59:33 +0000 (UTC)
Received: from [10.57.1.71] (mercury.demonlair.co.uk [10.57.1.71])
        by phoenix.demonlair.co.uk (Postfix) with ESMTP id 766421EA10A;
        Tue,  7 Mar 2023 10:59:33 +0000 (GMT)
Message-ID: <2b52d846-054b-6265-21dc-b091b39b0ee9@demonlair.co.uk>
Date:   Tue, 7 Mar 2023 10:59:33 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: What's the usage of md-autodetect.c
Content-Language: en-GB
To:     Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>
Cc:     Nigel Croxon <ncroxon@redhat.com>
References: <CALTww2-1B08z+BgPKqoBMnGQ-PhB9Yr=bA7YR7HyzGX0K127MQ@mail.gmail.com>
From:   Geoff Back <geoff@demonlair.co.uk>
In-Reply-To: <CALTww2-1B08z+BgPKqoBMnGQ-PhB9Yr=bA7YR7HyzGX0K127MQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

MD Autodetect allows for the assembly of raid-1 mirror filesystems
in-kernel before userspace starts, without requiring the complexity and
fragility of using an initrd and switch-root.
It is still in widespread use and given that it has a wide use case in
any system that wants fully resilient boot/root devices (which can be
done even on EFI) is likely to remain essential.  While the various
high-profile general purpose Linux distributions such as Red Hat and
Ubuntu may use initrd by default, there are innumerable scenarios,
particularly in embedded space, where initrd is never used but RAID may
be and hence auto-detect is used to assemble the actual root file system.

Removing it would be a major regression in 'md' functionality.

Yes, it requires CONFIG_MD and the appropriate RAID personality
(typically CONFIG_MD_RAID1) to be set to 'y' in Kconfig.  It doesn't
(IIRC) get built if CONFIG_MD is set to M.  Changing the default for
CONFIG_MD should not have any impact on this so long as the ability to
set CONFIG_MD=y does not get disabled (which would also be a regression).

If auto-detect were to be considered for removal then IMO it needs to go
through the full kernel feature deprecation/removal life cycle - i.e.
first it gets marked as deprecated in KConfig, then after a decent time
interval (years?) the default for the option is changed, and only after
that has all happened without causing problems, the code gets considered
for removal.

Regards,

Geoff.

Geoff Back
What if we're all just characters in someone's nightmares?

On 07/03/2023 03:04, Xiao Ni wrote:
> From the code of md-autodetect.c, it looks like it's used to create
> the raid device
> during boot. Now we use udev rules to assemble the raid. Do we still need it?
> What's the usage of md-autodetect?
>
> And in Kconfig, it depends on md-raid as Y when building a kernel. If we change
> the default to M, md-autodetect will not work anymore, right?
>
> Best Regards
> Xiao
>

