Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3967C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 19 Mar 2022 04:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241900AbiCSELr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 19 Mar 2022 00:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiCSELo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 19 Mar 2022 00:11:44 -0400
Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248651BE4D0
        for <linux-raid@vger.kernel.org>; Fri, 18 Mar 2022 21:10:22 -0700 (PDT)
Received: from c-24-5-124-255.hsd1.ca.comcast.net ([24.5.124.255]:48552 helo=sauron.svh.merlins.org)
        by mail1.merlins.org with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim 4.94.2 #2)
        id 1nVQQ0-0007e7-PE by authid <merlins.org> with srv_auth_plain; Fri, 18 Mar 2022 21:10:20 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.92)
        (envelope-from <marc@merlins.org>)
        id 1nVQQ0-00BM1c-KJ; Fri, 18 Mar 2022 21:10:20 -0700
Date:   Fri, 18 Mar 2022 21:10:20 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     Roman Mamedov <rm@romanrm.net>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5 array?
Message-ID: <20220319041020.GW3131742@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAMCDedQxBNc6JduBEp6NQ=5Ke9hrDQwvWkOT624LmXZtpv=PQ@mail.gmail.com>
 <20220318173007.3ad9348c@nvm>
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.5.124.255
X-SA-Exim-Mail-From: marc@merlins.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Mar 18, 2022 at 05:30:07PM +0500, Roman Mamedov wrote:
> Check "Used Dev Size" in "mdadm --detail" of your array. I suppose that is how
> much (at least) it actually needs from any new member to be suitable for the
> array.
 
Thank you, it indeed uses a bit less than what was available on the
first drives, so it looks like I'm set
     Used Dev Size : 5860390400 (5588.90 GiB 6001.04 GB)
5860521536-5860390400
131136

> If you find it needs more than the size of sdk1, as an emergency measure you
> could wipe off the partition table and add the entire sdk as the array member.

Yeah, I thought of that, just don't really like it, and not sure if
mdadm -can looks for raw drives in addition to partitions

> However there should not be such size difference in the first place, check
> your dmesg if drive detection messages report "HPA", and/or check with "hdparm
> -N" if there's this HPA enabled, cutting off a portion of the drive at the end.
 

[622993.224113] scsi 11:0:0:0: Direct-Access     Seagate  FA GoFlex Desk   0307 PQ: 0 ANSI: 6
[622993.255658] sd 11:0:0:0: Attached scsi generic sg14 type 0
[622993.273983] sd 11:0:0:0: [sdk] 1465130645 4096-byte logical blocks: (6.00 TB/5.46 TiB)
[622993.300108] sd 11:0:0:0: [sdk] Write Protect is off
[622993.315060] sd 11:0:0:0: [sdk] Mode Sense: 43 00 00 00
[622993.316103] sd 11:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[622993.392979] sd 11:0:0:0: [sdk] Attached SCSI disk
gargamel:/dev# hdparm -N /dev/sdk
/dev/sdk:
 max sectors   = 11721045168/11721045168, HPA is disabled

On Fri, Mar 18, 2022 at 01:07:49PM -0500, Roger Heflin wrote:
> From the above your partition table seems to be starting at 1044.  There
> are reasons to attempt to start on a boundary, but using a value like 1024
> instead of 1044 should also work just fine and that will give you 20 more
> sectors.

normal fdisk won't allow that, but I forgot that I can go in expert mode
and force the first sector to a value the regular tool won't allow by
default.

Thanks all for the answers and suggestions.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
