Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EA8C64E8A
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 10:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C77420708
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 10:30:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.jp header.i=@posteo.jp header.b="b8mHVeVt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgK3Kaa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 05:30:30 -0500
Received: from mout01.posteo.de ([185.67.36.65]:38461 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727288AbgK3Kaa (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 05:30:30 -0500
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 092D8160064
        for <linux-raid@vger.kernel.org>; Mon, 30 Nov 2020 11:29:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.jp; s=2017;
        t=1606732173; bh=c6OVI5Zku0zWQq7z4X9jUSV7CjdDFZVg2IrIyiQ4AHY=;
        h=Date:From:To:Subject:From;
        b=b8mHVeVtwKSeA+hAA13kNzxKEobQu0Flskq6Jur3wZBfEgz4XAJ3e7rVRsBXET9kt
         6SM8gGBOiVDVmO3WOu1GnKPAsNsupRamuPXdZOKOXhXGBIiAD8fQE32KIEOXjbDhSF
         w78IuCpe5ZISzU6BHeksB/vLrVkF3HjadJ7ReaNGV4yzyzwGD2/yq2IRhrJ5Wg9S8R
         xvUd06cI/vYDU8gHhB9BrYUH9NJkx+RxYiJFcqnfh5PtuFa1FohkQUcODBREvXUnz1
         1e0EfzCCcNHdRkBQTPJvjcqEXuW7YwdGFkzLa77ahxfASAX4hm+yNczLa5B3XeDp1K
         kfGxH7+AziXKQ==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4Cl1gc1tcbz9rxG
        for <linux-raid@vger.kernel.org>; Mon, 30 Nov 2020 11:29:31 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 30 Nov 2020 11:29:31 +0100
From:   c.buhtz@posteo.jp
To:     linux-raid@vger.kernel.org
Subject: Re: =?UTF-8?Q?=E2=80=9Croot=20account=20locked=E2=80=9D=20after?=
 =?UTF-8?Q?=20removing=20one=20RAID=31=20hard=20disc?=
In-Reply-To: <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
Message-ID: <4fde482053771294fc5369beaccea03a@posteo.de>
X-Sender: c.buhtz@posteo.jp
User-Agent: Posteo Webmail
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks for your answer. It tells me that the observed behaviour is usual 
- no matter that I think it should not be usual. ;)

Am 30.11.2020 10:27 schrieb antlists:
>> Why is the system so sensible about one RAID device that does not 
>> contain essential data for the boot process. I would I understand if 
>> there is a error messages somewhere. But blocking the whole boot 
>> process is to much in my understanding.
> 
> It's not. It's sensitive to the fact that ANY disk is missing.

But the system does not need this disc to boot or to run. This IMO 
should not happen.

> When a component of a raid disappears without warning, the raid will
> refuse to assemble properly on next boot. You need to get at a command
> line and force-assemble it.

This is logical to me.

>>> sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
>>> /dev/sda1 on / type ext4 (rw,relatime,errors=remount-ro)
>>> /dev/md127 on /Daten type ext4 (rw,relatime)
> 
> And here is at least part of your problem. If the mount fails, systemd
> will halt and chuck you into a recovery console.

btw: I am not able to open the recovery console. I am not able to enter 
the shell.
In the Unix/Linux world all things have reasons - no matter that I do 
not know or understand all of them.
But this is systemd. ;)

I see no no reason to stop the boot process just because a unneeded 
data-only partition/drive is not available.

> Is root's home on /Daten? It shouldn't be.

No it is not. As you can see in the second line of the fstab / (and all 
its sub-content like home-dirs, boot, etc) is on /dev/sda1. The RAID is 
build of sdb and sdc.
