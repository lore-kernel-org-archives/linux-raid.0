Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E7FC04A95
	for <linux-raid@archiver.kernel.org>; Sun, 23 Oct 2022 01:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiJWBwV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 22 Oct 2022 21:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJWBwT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 22 Oct 2022 21:52:19 -0400
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437B8BF4E
        for <linux-raid@vger.kernel.org>; Sat, 22 Oct 2022 18:52:18 -0700 (PDT)
Received: from [73.207.192.158] (port=55926 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1omQA0-00022J-43
        for linux-raid@vger.kernel.org;
        Sat, 22 Oct 2022 20:52:17 -0500
Date:   Sun, 23 Oct 2022 01:52:15 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: now that i've screwed up and apparently get to start over ...
Message-ID: <20221023015215.GS20480@jpo>
References: <20221017045234.GI20480@jpo>
 <87sfjjefsn.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfjjefsn.fsf@vps.thesusis.net>
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

Phillip, et al --

...and then Phillip Susi said...
% 
% David T-G <davidtg-robot@justpickone.org> writes:
% 
% > Then GRUB puked all over itself and I can't get the stupid thing running
...
% > /dev/sda and put /dev/sde back, and I get that GRUB can't boot from a GPT
% > disk ... except that /dev/sda has always been that!
% 
% GRUB can boot from GPT just fine.  Assuming you are booting in EFI mode,
% it just has to have an EFI system partition, and be registered with the

Ah, but I'm not.  I only have four partitions

  jpo:~ # parted /dev/sda unit MiB p free
  Model: ATA SAMSUNG MZ7LN128 (scsi)
  Disk /dev/sda: 122104MiB
  Sector size (logical/physical): 512B/512B
  Partition Table: gpt
  Disk Flags: pmbr_boot
  
  Number  Start     End        Size      File system     Name      Flags
	  0.02MiB   1.00MiB    0.98MiB   Free Space
   1      1.00MiB   33793MiB   33792MiB  linux-swap(v1)  jpo-swap  swap
   2      33793MiB  66561MiB   32768MiB  xfs             jposuse
   3      66561MiB  99329MiB   32768MiB  xfs             jpoalt    legacy_boot
   4      99329MiB  122104MiB  22775MiB  xfs             jpo-ssd

(taken from an identical machine) and do not use that UEFI stuff that I
don't know.  Way simple.


% EFI firmware.  You can't just copy the partitions to a new drive and
% remove the old drive and expect it to boot.  You will need to
% grub-install on the new drive to register it with the EFI firmware.

Heck, I'd be happy to be booting from the old drive!


Thanks again & HANW

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

