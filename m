Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E7AC3DA78
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 10:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjAOKpy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 05:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjAOKpw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 05:45:52 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555A8CDFB
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 02:45:50 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pH0WK-0008ZA-FE;
        Sun, 15 Jan 2023 10:45:48 +0000
Message-ID: <ac233386-cd36-f251-93d8-70475f02301e@youngman.org.uk>
Date:   Sun, 15 Jan 2023 10:45:48 +0000
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
 <d9a4dea4-c15d-453d-9a60-4694e31147b1@youngman.org.uk>
 <67a93fbc-258a-4425-8fa3-6f40311bc864@thelounge.net>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <67a93fbc-258a-4425-8fa3-6f40311bc864@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/01/2023 09:39, Reindl Harald wrote:
> the point is that "you need efi to boot, but the system can't access efi 
> until it's booted" is nonsense because the whole point of the ESP is 
> that the UEFI is driectly starting UEFI-binaries at the ESP

And here the fact that English appears not to be your native language is 
biting you in the bum.

Correct - the UEFI is starting your ESP binaries, which reside in 
/boot/efi, AND IF /BOOT/EFI IS A NORMAL RAID, the UEFI can't read it.

Cue a circular dependency - the UEFI can't read /boot/efi because it's 
not a bog-standard fat.

Cheers,
Wol
