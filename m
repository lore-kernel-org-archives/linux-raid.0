Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83351C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 17 Oct 2022 05:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJQFPy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 Oct 2022 01:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJQFPx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 Oct 2022 01:15:53 -0400
X-Greylist: delayed 1393 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 16 Oct 2022 22:15:51 PDT
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2143852E43
        for <linux-raid@vger.kernel.org>; Sun, 16 Oct 2022 22:15:50 -0700 (PDT)
Received: from [73.207.192.158] (port=48490 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1okI7A-0000uS-5M
        for linux-raid@vger.kernel.org;
        Sun, 16 Oct 2022 23:52:36 -0500
Date:   Mon, 17 Oct 2022 04:52:34 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: now that i've screwed up and apparently get to start over ...
Message-ID: <20221017045234.GI20480@jpo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
fccCC:  =F.sent
User-Agent: Mutt/1.10.1 (2018-07-13)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - www18.qth.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - justpickone.org
X-Get-Message-Sender-Via: www18.qth.com: authenticated_id: dmail@justpickone.org
X-Authenticated-Sender: www18.qth.com: dmail@justpickone.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, all --

I have an existing system with a raw-partitioned /dev/sda (128G SSD)
that I plan to convert to a mirrored boot drive.  I installed /dev/sde
(256G SSD) and sliced it the same way (well, with a bigger 4th slice)
and set up half mirrors in each partition.  I've been waiting for the
opportunity to copy the sda partitions over to the new sde mirrors and
then swap sda for a new 256G SSD and add the other half of each mirror.

So now I have just bought another 10T drive to add into the RAID-5 array
(that's a whole separate project, of course), so I shut it all down and
not only plugged in the big drive (but did nothing else with it) but also
copied over each slice and figured hey, yippee, I'll reboot from the mirror
and be another step forward.

Then GRUB puked all over itself and I can't get the stupid thing running
at all now.  I've disconnected /dev/sde, I've disconnected all USB
external drives, I've disconnected all internal drives, I've swapped out
/dev/sda and put /dev/sde back, and I get that GRUB can't boot from a GPT
disk ... except that /dev/sda has always been that!

So now I might as well go ahead and install a fresh version into the
alt-root slice in order to get GRUB working again and then figure out
how to get back to the real-root original.  But ... do I slice the
disk and create four mirrors or do I mirror the disk and create four
partitions therein?  I was happy with four mirrors, but then there's
the question of whether or not GRUB will work, and I don't really want
to have to create another I've-lost-count partitions for /boot and /efi
and whatever.  I've seen so much advice both ways, much of it from 2011
and 2012, that I don't know which way to go!

My goal is to mirror two SSDs and have four

  swap
  real-root
  alt-root
  data

partitions; however I get there so that I can boot from either root works
for me.  Anyone have the "Simple Setup for Dummy David" instruction set?


Thanks in advance!

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

