Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC00AC64E90
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 12:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80BFE206D8
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 12:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgK3Ma7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 07:30:59 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:33271 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbgK3Ma7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 07:30:59 -0500
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kjhXd-0004YR-4N; Mon, 30 Nov 2020 11:40:25 +0000
Subject: =?UTF-8?Q?Re:_=e2=80=9croot_account_locked=e2=80=9d_after_removing_?=
 =?UTF-8?Q?one_RAID1_hard_disc?=
To:     c.buhtz@posteo.jp, linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
 <4fde482053771294fc5369beaccea03a@posteo.de>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <5FC4DA28.2050408@youngman.org.uk>
Date:   Mon, 30 Nov 2020 11:40:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <4fde482053771294fc5369beaccea03a@posteo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/11/20 10:29, c.buhtz@posteo.jp wrote:
>> And here is at least part of your problem. If the mount fails, systemd
>> will halt and chuck you into a recovery console.
> 
> btw: I am not able to open the recovery console. I am not able to enter
> the shell.
> In the Unix/Linux world all things have reasons - no matter that I do
> not know or understand all of them.
> But this is systemd. ;)
> 
> I see no no reason to stop the boot process just because a unneeded
> data-only partition/drive is not available.

You haven't told systemd it's not needed. How else is it supposed to know?

There's some option you put in fstab which says "don't worry if you
can't mount this disk". My NTFS drive wasn't needed, but it still caused
the boot to crash ...

Cheers,
Wol
