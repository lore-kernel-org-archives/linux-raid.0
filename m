Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 279AAC07E96
	for <linux-raid@archiver.kernel.org>; Sun, 11 Jul 2021 18:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA225610D0
	for <linux-raid@archiver.kernel.org>; Sun, 11 Jul 2021 18:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhGKSG0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 11 Jul 2021 14:06:26 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:17019 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhGKSG0 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 11 Jul 2021 14:06:26 -0400
Received: from host86-159-54-55.range86-159.btcentralplus.com ([86.159.54.55] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1m2cxG-000Cdm-3M; Sun, 11 Jul 2021 18:09:22 +0100
Subject: Re: What about the kernel patch "failfast" and SCTERC/kernel-driver
 timeouts
To:     BW <m40636067@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
References: <CADcL3SDHb-0U2cjoNOMXbFmbiwpVfytzczyg9VkaK=vWyKiFtA@mail.gmail.com>
 <46aa1b53-596f-a647-64ef-10e2fdb614e8@youngman.org.uk>
 <CADcL3SAoMyPwmu6FrRRryTxAA+ebj9zJ8hUZ2AebhGDgK2sO0Q@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <60EB25C0.6030208@youngman.org.uk>
Date:   Sun, 11 Jul 2021 18:09:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <CADcL3SAoMyPwmu6FrRRryTxAA+ebj9zJ8hUZ2AebhGDgK2sO0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/07/21 09:53, BW wrote:
> I do believe I understand the timeout mismatch issue, at least at a
> overall level.

The mere fact you asked "why *doesn't* mdadm kick the disk out of the
array proves you don't understand, sorry. Because mdadm *does* kick the
disk out of the array.

> But it's true I don't understand the failfast patch and its influence
> on the timeout mismatch, if any?
> 
I don't know that patch at all ...

> In regards to the timeout mismatch issue at a more detailed level (not
> covered "anywhere"):
> In case of timeout-mismatch the kernel-driver reset the disk (or whole
> controller at worse) and that alone is not the problem.

The kernel driver *doesn't* reset the disk, because it *can't*. It may
try ... (sending a reset command does absolutely nothing if the disk is
not listening!)

> The problem is
> mdadm still see the drive as healthy/an active array-member and
> perhaps starts to read/write to it again when it return after a reset.

No. The problem is that mdadm *does not know* whether the drive is
healthy or not, and tries to write to it BEFORE it returns after a
kernel reset. In the case of a shingled drive, the drive is almost
certainly healthy, just "doing it's own thing"

> And waiting up-to 180 seconds, depending on config,  is unnecessary
> and is an issue by its own (some might do a system-reboot or reset
> something, not understanding what going on). A service freezing for
> up-to 2 minutes is a looooong time.

The problem is that the DISK has frozen. That 180 seconds config is
KERNEL config, nothing whatsoever to do with mdadm. It tells the kernel
how long to wait for a disk that has apparently frozen.

> What I'm saying is, if mdadm hasn't heard from the drive within 25
> seconds is should just "pretend" it got an error-code just as it would
> if the drive supported/had SCTERC enabled an act on that (kick the
> drive out of the array/mark it failed).
> There might be a good reasons for that, actually I find it strange if
> that's not the case because the above it "too" obvious.
> 
You are describing - sort of - what REALLY DOES happen, and what you say
"should happen" is exactly what "does happen and *should not*", because
that is exactly what does the damage!

The CORRECT sequence of events when something goes wrong is

1 - raid tries to read/write to the disk.
2 - the disk times out, and the kernel recognises the failure
3 - raid recalculates the data, rewrites it to disk, and everything goes
merrily on its way.

The WRONG sequence of events (which is what you are saying *should*
happen) is

1 - raid tries to read/write to the disk.
2 - the kernel times out and returns a failure to raid
3 - raid recalculates the data, rewrites it to disk, AND THE DISK IS
STILL FROZEN AND DOES NOT RESPOND.
4 - the disk gets kicked

What you are describing as the sequence you think SHOULD happen, is
exactly the sequence that DOES happen and TRASHES THE ARRAY.

Oh - and by the way, let's take raid out of the picture here. This
problem is real and it affects ALL systems, not just ones with raid.
It's just that the consequences for raid are rather more dramatic, as
one disk having problems will bring down an array like dominoes, rather
than just bringing down the file system on that disk. It will trash
btrfs or ZFS or any other setup just as effectively as it trashes md-raid.

Cheers,
Wol
