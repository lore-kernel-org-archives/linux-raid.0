Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426E3C25B4E
	for <linux-raid@archiver.kernel.org>; Sun, 22 Jan 2023 17:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjAVRTj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 Jan 2023 12:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjAVRTj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 22 Jan 2023 12:19:39 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5C51CF5A
        for <linux-raid@vger.kernel.org>; Sun, 22 Jan 2023 09:19:37 -0800 (PST)
Received: from host81-147-105-30.range81-147.btcentralplus.com ([81.147.105.30] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pJe0F-000BmK-5k;
        Sun, 22 Jan 2023 17:19:36 +0000
Message-ID: <4cb62cde-a8c3-1d02-207f-efb903301255@youngman.org.uk>
Date:   Sun, 22 Jan 2023 17:19:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-GB
To:     H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <deafcb4a-ed1c-d0b3-c9f9-c0a99867bb7a@meddatainc.com>
 <3CEAC9AB-02FC-43BE-94CF-ED3ECFF6F4F7@meddatainc.com>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <3CEAC9AB-02FC-43BE-94CF-ED3ECFF6F4F7@meddatainc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 22/01/2023 05:05, H wrote:
> However, going back to the issue of /boot/efi possibly not being duplicated by CentOS, would not mdadm take care of that automatically? How can I check?

mdadm/raid will take care of /boot/efi provided both (a) it's set up 
correctly, and (b) nothing outside of linux modifies it.

You can always run a raid integrity check (can't remember what it's 
called / the syntax) which will confirm they are identical.

But if something *has* messed with the mirror outside of linux, the only 
way you can find out what happened is to mount the underlying partitions 
(for heavens sake do that read only !!!) and compare them.

A bit of suggested ?light reading for you - get your head round the 
difference between superblocks 1.0 and 1.2, understand how raid can 
mirror a fat partition and why that only works with 1.0, and then 
understand how you can mount the underlying efi fat partitions 
separately from the raided partition.

Read the raid wiki https://raid.wiki.kernel.org/index.php/Linux_Raid and 
try to get to grips with what is actually going on ...

Cheers,
Wol
