Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E524C433DB
	for <linux-raid@archiver.kernel.org>; Sun, 21 Mar 2021 04:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BC356193B
	for <linux-raid@archiver.kernel.org>; Sun, 21 Mar 2021 04:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCUEW5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 21 Mar 2021 00:22:57 -0400
Received: from mail.snapdragon.cc ([103.26.41.109]:38474 "EHLO
        mail.snapdragon.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhCUEWR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 21 Mar 2021 00:22:17 -0400
Received: by mail.snapdragon.cc (Postfix, from userid 65534)
        id 888B819E03CD; Sun, 21 Mar 2021 04:22:09 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=snapdragon.cc;
        s=default; t=1616300528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4AEgPglP7gcgMKq2HTY+pMLQ//+eAe/CyUngUK9HH1w=;
        b=Jfcfv9dgL10rtUQKCrw4X5f8TYLpEK2/brBIs8noPx/OULmVZF0WtxVS0QvdQKcwfG2T8J
        1zpPC2C+cS5qVTQWyR+F3CBUWYHmSPfG4v5oP1LWCzsiVFCNjoVN/oh7weE6M1EyHNGSjQ
        jmugFmgFmX2ja1q1Nzu1UrPEnDTdr6k=
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] md: warn about using another MD array as write journal
From:   Manuel Riel <manu@snapdragon.cc>
In-Reply-To: <27EE5CBC-B1B8-4463-87F5-2AE73F30941B@snapdragon.cc>
Date:   Sun, 21 Mar 2021 12:22:05 +0800
Cc:     Linux-RAID <linux-raid@vger.kernel.org>,
        Vojtech Myslivec <vojtech@xmyslivec.cz>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C990C60B-FB5A-4709-949B-6D86AF9FA6B1@snapdragon.cc>
References: <DAEB6C2F-3AE0-4EBE-8775-7C6292F8749A@snapdragon.cc>
 <CAPhsuW4=XoyQV_HNVnFnMWS2PvvU1+Rtbh9SJB-FQTO3haa3ig@mail.gmail.com>
 <27EE5CBC-B1B8-4463-87F5-2AE73F30941B@snapdragon.cc>
To:     Song Liu <song@kernel.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

My impression is that the write-journal feature isn't fully stable yet, =
as was already reported in 2019[^1]. Vojtech and me are seeing the same =
errors as mentioned there.

No matter if the journal is on a block device or another RAID.

1: https://www.spinics.net/lists/raid/msg62646.html


> On Mar 20, 2021, at 9:12 AM, Manuel Riel <manu@snapdragon.cc> wrote:
>=20
> On Mar 20, 2021, at 7:16 AM, Song Liu <song@kernel.org> wrote:
>>=20
>> Sorry for being late on this issue.
>>=20
>> Manuel and Vojtech, are we confident that this issue only happens =
when we use
>> another md array as the journal device?
>>=20
>> Thanks,
>> Song
>=20
> Hi Song,
>=20
> thanks for getting back.
>=20
> Unfortunately it's still happening, even when using a NVMe partition =
directly. It just took a long 3 weeks to happen. So discard my patch. =
Here how it went down yesterday:
>=20
> - process md4_raid6 is running with 100% CPU utilization, all I/O to =
the array is blocked
> - no disk activity on the physical drives
> - soft reboot doesn't work, as md4_raid6 blocks, so hard reset is =
needed
> - when booting to rescue mode, it tries to assemble the array and =
shows the same issue of 100% CPU utilization. Also can't reboot.
> - when manually assembling it *with* the journal drive, it will read a =
few GB from the journal device and then get stuck at 100% CPU =
utilization again without any disk activity.
>=20
> Solution in the end was to avoid assembling the array on reboot, then =
assemble it *without* the existing journal and add an empty journal =
drive later. This lead to some data loss and a full resync.
>=20
> I'm currently moving all data off this machine and will repave it. =
Then see if that changes anything.
>=20
> My main OS is CentOS 8 and the rescue system was Debian. Both showed a =
similar issue. This must be connected to the journal drive somehow.
>=20
> My journal drive is a partition on an NVMe with ~180GB in size.
>=20
> Thanks for any pointers, I could try next.
>=20
> Manu

