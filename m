Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABDCC433E0
	for <linux-raid@archiver.kernel.org>; Fri,  1 Jan 2021 16:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77F3E221F2
	for <linux-raid@archiver.kernel.org>; Fri,  1 Jan 2021 16:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbhAAQP5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Jan 2021 11:15:57 -0500
Received: from mail.thelounge.net ([91.118.73.15]:18487 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbhAAQP5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Jan 2021 11:15:57 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4D6qqk6yBgzXMq;
        Fri,  1 Jan 2021 17:15:14 +0100 (CET)
To:     c.buhtz@posteo.jp, linux-raid@vger.kernel.org
References: <4D6pnR0fqcz9rxN@submission02.posteo.de>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: Re: naming system of raid devices
Message-ID: <6ae91038-0f94-36b1-6da5-9235b9addb6f@thelounge.net>
Date:   Fri, 1 Jan 2021 17:15:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <4D6pnR0fqcz9rxN@submission02.posteo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 01.01.21 um 16:28 schrieb c.buhtz@posteo.jp:
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

you should do that for about 20 years anyways, no matter RAID or not

> Another often reported "solution" is to edit the mdadm.conf. But this
> is not a good solution for me. mdadm looks in the superblock and knows
> (nearly) everything. Each conf-file I need to edit keeps the
> possibility for errors/mistakes/faults (because I am not a sysop/admin
> but a simple home-server-wannabe-admin).

but how often is anything changed there?

my mdadm.conf is from 2011 and it's not even the same machine with my 
disks which are in the meantime replaced by SSD

you need to make sure that the current config is part if the initrd 
(dracut -f as example) which happens anyways when the kernel is updated 
and a new initrd is generated for the new kernel

---------------------

[root@srv-rhsoft:~]$ lsinitrd | grep mdadm
-rw-r--r--   1 root     root          315 Aug 16  2014 etc/mdadm.conf

---------------------

[root@srv-rhsoft:~]$ cat /etc/mdadm.conf
MAILADDR root
HOMEHOST localhost.localdomain
AUTO +imsm +1.x -all

ARRAY /dev/md0 level=raid1 num-devices=4 
UUID=1d691642:baed26df:1d197496:4fb00ff8
ARRAY /dev/md1 level=raid10 num-devices=4 
UUID=b7475879:c95d9a47:c5043c02:0c5ae720
ARRAY /dev/md2 level=raid10 num-devices=4 
UUID=ea253255:cb915401:f32794ad:ce0fe396
---------------------

"localhost.localdomain" is intentional, there is a second machine with 
identical UUIDs all over the place cloned by move two disks, resync on 
both and adjust runtime config like networking and so on

> My Question is how this names come up? How does mdadm, the kernel or
> what ever component is responsible here, decide about the "name" of a
> raid device?
> And which factors influence the re-nameing of such devices (e.g.
> between boot or kernel-updates)?

devices are always a problem because it's unknown when they appear, it's 
even unknown *if* they appear so nothing can wait for them

that's why you should always work with UUID



