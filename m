Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3935EC433EF
	for <linux-raid@archiver.kernel.org>; Sat, 16 Jul 2022 22:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiGPWbF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 16 Jul 2022 18:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiGPWbE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 16 Jul 2022 18:31:04 -0400
Received: from sneak2.sneakemail.com (sneak2.sneakemail.com [64.46.159.148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4B21A387
        for <linux-raid@vger.kernel.org>; Sat, 16 Jul 2022 15:31:01 -0700 (PDT)
Received: (sneakemail censored 4837-1658010660-795188 #2); 16 Jul 2022
 22:31:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=liamekaens.com;
        s=mail; t=1658010661;
        bh=oXeyzWVjMKoAGXmwg9cA7vILuQyyOwGSsDWr7EdlnRM=;
        h=Date:From:To:Subject:From;
        b=Db447KjXII7nC118G1nanLiELWHC0SreOqlhShO7L35MYaq+0/B7jF6d7434LSEgK
         uGIJ5t4LYvfKVDYLNeq4ucOjtoyoUKl3CIWL8I5R3MFhk8VSbdI95oHf3b2iq2tzDK
         /UP8oj2pdikr7WQHmuskot/TzzOvlK7LwLNo4WmAmk9ET3XgmujV6zomf54GZ9XVTn
         eqhrw4n7I/cy4UMzUC323yVXsNrjNbVMUlEkr1D1Hb/khYMVbtPS5qmSt6w/a8qM3N
         G3Gkg3yOvY6zU7n6BEAPx3S71vY+GV3ovczQsueI48scVFUV+hSlQX5Ic55N/GzIjA
         koMXUrNL83Iqg==
Received: (sneakemail censored 4837-1658010660-795188 #1); 16 Jul 2022
 22:31:00 -0000
Date:   Sat, 16 Jul 2022 22:31:00 +0000
From:   esqychd2f5@liamekaens.com
To:     linux-raid@vger.kernel.org
Message-ID: <4837-1658010660-795188@sneakemail.com>
Subject: Re: Determining cause of md RAID 'recovery interrupted'
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Perl5 Mail::Internet v
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Roy,

Thanks, one of the drives does have a badblocks list (/dev/sdc).  It
is also the only one with reallocated sectors (56 of them).  No drives
have a non-zero 'Current_Pending_Sector'.

This would explain why the rebuild worked for a while, but not now.
It doesn't explain whatever was happening to make drives drop out of
the array, but I'll resolve the rebuild issue before digging into
that.  I want to understand what is failing here before I put the
drives back into use.  I may leave the drive with reallocated sectors
out when I reuse the drives.

The MD array has a ZFS volume on it (meaning it should get checksum
errors if there are problems), and doesn't have critical data, so I
followed your instructions on how to disable the BBL and restarted the
rebuild.  I'll see if it completes now.

Joe
