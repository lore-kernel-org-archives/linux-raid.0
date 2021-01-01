Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5C9C433E0
	for <linux-raid@archiver.kernel.org>; Fri,  1 Jan 2021 20:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02EF6221F2
	for <linux-raid@archiver.kernel.org>; Fri,  1 Jan 2021 20:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbhAAUB5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Jan 2021 15:01:57 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:55777 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbhAAUB5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 1 Jan 2021 15:01:57 -0500
Received: from host86-158-105-41.range86-158.btcentralplus.com ([86.158.105.41] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kvQ0R-0005fn-A4; Fri, 01 Jan 2021 19:22:35 +0000
Subject: Re: naming system of raid devices
To:     c.buhtz@posteo.jp, linux-raid@vger.kernel.org
References: <4D6pnR0fqcz9rxN@submission02.posteo.de>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <f1abeaa1-e412-99f8-3853-57f1ae6915ad@youngman.org.uk>
Date:   Fri, 1 Jan 2021 19:22:35 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <4D6pnR0fqcz9rxN@submission02.posteo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 01/01/2021 15:28, c.buhtz@posteo.jp wrote:
> In the last weeks I played around with mdadm - on VMs, Odroid-Devices,
> PCs - all with Debian 10.
> 
> I observed a (for me) curious behavior about the naming of RAID
> devices.
> 
> I did "--create /dev/md0" all the time.
> 
> But sometimes it results in /dev/md127.
> Sometimes it is /dev/md/0.
> Sometimes it switches between upgrade of the kernel image (/dev/md127
> become /dev/md0 and booting fails).
> 
> Googleing this topic brings up a lot of other users discussing about
> that problem.
> 
> My current solution is to ignore the /dev/*-name and mount the
> device/partition by its UUID.
> 
> Another often reported "solution" is to edit the mdadm.conf. But this
> is not a good solution for me. mdadm looks in the superblock and knows
> (nearly) everything. Each conf-file I need to edit keeps the
> possibility for errors/mistakes/faults (because I am not a sysop/admin
> but a simple home-server-wannabe-admin).
> 
> My Question is how this names come up? How does mdadm, the kernel or
> what ever component is responsible here, decide about the "name" of a
> raid device?
> And which factors influence the re-nameing of such devices (e.g.
> between boot or kernel-updates)?
> 
The kernel and/or mdadm decides the same way it decides what drive is 
sda, sdb, etc, in that it is COMPLETELY RANDOM. Yes, the dice normally 
fall the same way and names are consistent, but numbers now normally 
always count down from 127. (I think that's so we can count down from 
32,000 if we need to... :-) For example, because I have just two, 
mirrored, drives, it doesn't matter which one appears first the arrays 
count down consistently so eg root is always md127. But that's a quirk 
of my system.

The recommended way with mdadm is to create named arrays, eg 
/dev/md/root or /dev/md/home.

Cheers,
Wol
