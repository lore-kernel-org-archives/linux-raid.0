Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53174C46467
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 09:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjAOJU1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 04:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjAOJUZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 04:20:25 -0500
X-Greylist: delayed 1068 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 15 Jan 2023 01:20:19 PST
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B282BC146
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 01:20:19 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Nvq1147FyzXKm;
        Sun, 15 Jan 2023 10:02:29 +0100 (CET)
Message-ID: <9aab4088-3ba3-3c7c-4254-a0d829b06066@thelounge.net>
Date:   Sun, 15 Jan 2023 10:02:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>, H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <37a150cb-286b-4137-bb72-08e2de21c851@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <37a150cb-286b-4137-bb72-08e2de21c851@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 15.01.23 um 09:41 schrieb Wols Lists:
> Are your /boot and /boot/efi using superblock 1.0? My system is 
> bios/grub, so not the same, but I use plain partitions here because 
> otherwise you're likely to get in a circular dependency - you need efi 
> to boot, but the system can't access efi until it's booted ... oops!
the UEFI don't care where the ESP is mounted later
from the viewpoint of the UEFI all paths are /-prefixed

that's only relevant for the OS at the time of kernel-install / updates 
and the ESP is vfat and don't support RAID anyways
