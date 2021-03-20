Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A85C433DB
	for <linux-raid@archiver.kernel.org>; Sat, 20 Mar 2021 01:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C49F76194D
	for <linux-raid@archiver.kernel.org>; Sat, 20 Mar 2021 01:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCTBMn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 19 Mar 2021 21:12:43 -0400
Received: from mail.snapdragon.cc ([103.26.41.109]:59252 "EHLO
        mail.snapdragon.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhCTBMY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 19 Mar 2021 21:12:24 -0400
Received: by mail.snapdragon.cc (Postfix, from userid 65534)
        id 343D019E0C23; Sat, 20 Mar 2021 01:12:15 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=snapdragon.cc;
        s=default; t=1616202734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MPpFJgQG7FzNf0GNVZ7vrRqgdfOHils4DlWGLj7+VL0=;
        b=lRZHApRvj04ZzzMJuOFT+OpInj97Phf6gDvnDKTErx5/kCQAUt9yL1CvSnG5KUpixsfAdW
        dttFnzYEktfHmENPKQGlEQqB513JjEF2u8ynXHcQJ44IynCQMP5QTPhEorSX5xPduAbrQt
        WqIZnjNB9Hv33KCGK536ka3QATJ1Rzg=
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] md: warn about using another MD array as write journal
From:   Manuel Riel <manu@snapdragon.cc>
In-Reply-To: <CAPhsuW4=XoyQV_HNVnFnMWS2PvvU1+Rtbh9SJB-FQTO3haa3ig@mail.gmail.com>
Date:   Sat, 20 Mar 2021 09:12:08 +0800
Cc:     Linux-RAID <linux-raid@vger.kernel.org>,
        Vojtech Myslivec <vojtech@xmyslivec.cz>
Content-Transfer-Encoding: quoted-printable
Message-Id: <27EE5CBC-B1B8-4463-87F5-2AE73F30941B@snapdragon.cc>
References: <DAEB6C2F-3AE0-4EBE-8775-7C6292F8749A@snapdragon.cc>
 <CAPhsuW4=XoyQV_HNVnFnMWS2PvvU1+Rtbh9SJB-FQTO3haa3ig@mail.gmail.com>
To:     Song Liu <song@kernel.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mar 20, 2021, at 7:16 AM, Song Liu <song@kernel.org> wrote:
>=20
> Sorry for being late on this issue.
>=20
> Manuel and Vojtech, are we confident that this issue only happens when =
we use
> another md array as the journal device?
>=20
> Thanks,
> Song

Hi Song,

thanks for getting back.

Unfortunately it's still happening, even when using a NVMe partition =
directly. It just took a long 3 weeks to happen. So discard my patch. =
Here how it went down yesterday:

- process md4_raid6 is running with 100% CPU utilization, all I/O to the =
array is blocked
- no disk activity on the physical drives
- soft reboot doesn't work, as md4_raid6 blocks, so hard reset is needed
- when booting to rescue mode, it tries to assemble the array and shows =
the same issue of 100% CPU utilization. Also can't reboot.
- when manually assembling it *with* the journal drive, it will read a =
few GB from the journal device and then get stuck at 100% CPU =
utilization again without any disk activity.

Solution in the end was to avoid assembling the array on reboot, then =
assemble it *without* the existing journal and add an empty journal =
drive later. This lead to some data loss and a full resync.

I'm currently moving all data off this machine and will repave it. Then =
see if that changes anything.

My main OS is CentOS 8 and the rescue system was Debian. Both showed a =
similar issue. This must be connected to the journal drive somehow.

My journal drive is a partition on an NVMe with ~180GB in size.

Thanks for any pointers, I could try next.

Manu=
