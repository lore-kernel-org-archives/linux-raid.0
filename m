Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA48EC43334
	for <linux-raid@archiver.kernel.org>; Fri, 22 Jul 2022 14:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiGVO73 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 22 Jul 2022 10:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiGVO72 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 22 Jul 2022 10:59:28 -0400
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735DC57E0D
        for <linux-raid@vger.kernel.org>; Fri, 22 Jul 2022 07:59:27 -0700 (PDT)
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 26MExNee015090
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 22 Jul 2022 15:59:24 +0100
From:   Nix <nix@esperi.org.uk>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Roger Heflin <rogerheflin@gmail.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
References: <87o7xmsjcv.fsf@esperi.org.uk>
        <fed30ed9-68e3-ce8b-ec27-45c48cf6a7a1@linux.dev>
        <8735evpwrf.fsf@esperi.org.uk>
        <CAAMCDeenbs5R6e_kuQR_zsv50eh49O2w4h-+BAg1xU9y0_BZ1Q@mail.gmail.com>
        <871qudo4g0.fsf@esperi.org.uk>
        <ed27e3f8-0d54-3e1e-bae8-d90c259e430a@youngman.org.uk>
Emacs:  if SIGINT doesn't work, try a tranquilizer.
Date:   Fri, 22 Jul 2022 15:59:24 +0100
In-Reply-To: <ed27e3f8-0d54-3e1e-bae8-d90c259e430a@youngman.org.uk> (Wols
        Lists's message of "Fri, 22 Jul 2022 12:30:19 +0100")
Message-ID: <87h739mbw3.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1102; Body=4 Fuz1=4 Fuz2=4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 22 Jul 2022, Wols Lists spake thusly:

> On 22/07/2022 10:57, Nix wrote:
>> I thought all the work done to assemble raid arrays was done by mdadm?
>> Because that didn't change. Does the kernel md layer also get to say
>> "type wrong, go away"? EW. I'd hope nothing is looking at partition
>> types these days...
>
> As far as I know (which is probably the same as you :-) the kernel knows nothing about the v1 superblock format, so raid assembly
> *must* be done by mdadm.
>
> That's why, despite it being obsolete, people get upset when there's any mention of 0.9 going away, because the kernel DOES
> recognise it and can assemble those arrays.

Right. These are all v1.2, e.g. for one of them:

/dev/md125:
        Version : 1.2
  Creation Time : Mon Apr 10 10:42:31 2017
     Raid Level : raid6
     Array Size : 15391689216 (14678.66 GiB 15761.09 GB)
  Used Dev Size : 5130563072 (4892.89 GiB 5253.70 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Fri Jul 22 15:58:45 2022
          State : active 
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : loom:fast  (local to host loom)
           UUID : 4eb6bf4e:7458f1f1:d05bdfe4:6d38ca23
         Events : 51202

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       2       8       35        2      active sync   /dev/sdc3
       4       8       51        3      active sync   /dev/sdd3
       5       8       83        4      active sync   /dev/sdf3
