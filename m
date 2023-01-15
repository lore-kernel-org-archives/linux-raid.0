Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E04BC46467
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 09:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjAOJUy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 04:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjAOJUt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 04:20:49 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D0FC141
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 01:20:47 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pGzC2-0007u0-B9;
        Sun, 15 Jan 2023 09:20:46 +0000
Message-ID: <d9a4dea4-c15d-453d-9a60-4694e31147b1@youngman.org.uk>
Date:   Sun, 15 Jan 2023 09:20:45 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-GB
To:     Reindl Harald <h.reindl@thelounge.net>, H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <37a150cb-286b-4137-bb72-08e2de21c851@youngman.org.uk>
 <9aab4088-3ba3-3c7c-4254-a0d829b06066@thelounge.net>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <9aab4088-3ba3-3c7c-4254-a0d829b06066@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/01/2023 09:02, Reindl Harald wrote:
> 
Reindl and me wind each other up, so watch out for a flame war :-)
> 
> Am 15.01.23 um 09:41 schrieb Wols Lists:
>> Are your /boot and /boot/efi using superblock 1.0? My system is 
>> bios/grub, so not the same, but I use plain partitions here because 
>> otherwise you're likely to get in a circular dependency - you need efi 
>> to boot, but the system can't access efi until it's booted ... oops!
> the UEFI don't care where the ESP is mounted later
> from the viewpoint of the UEFI all paths are /-prefixed
> 
> that's only relevant for the OS at the time of kernel-install / updates 
> and the ESP is vfat and don't support RAID anyways

But ext4 doesn't support raid either. Btrfs, ZFS and XFS don't support 
md-raid. That's the whole point of having a layered stack, rather than a 
"one size fits all" filesystem.

IF YOU CAN GUARANTEE that /boot/efi is only ever modified inside linux, 
then raid it. Why not? Personally, I'm not sure that guarantee holds.

If you do raid it, then you MUST use the 1.0 superblock, otherwise it 
will be inaccessible outside of linux. Seeing as the system needs it 
before linux boots, that's your classic catch-22.

Basically the rule is, if you want to access raid-ed linux partitions 
outside of linux, you must be able to guarantee they aren't modified 
outside of linux. And you have to use superblock 1.0. If you can't 
guarantee both of those, don't go there ...

Cheers,
Wol
