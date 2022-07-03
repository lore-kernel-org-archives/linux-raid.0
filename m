Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBC2C433EF
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jul 2022 20:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbiGCUHr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jul 2022 16:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGCUHq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Jul 2022 16:07:46 -0400
Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407342BFC
        for <linux-raid@vger.kernel.org>; Sun,  3 Jul 2022 13:07:44 -0700 (PDT)
Received: from lfbn-idf3-1-1056-96.w90-46.abo.wanadoo.fr ([90.46.126.96]:56466 helo=sauron.svh.merlins.org)
        by mail1.merlins.org with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim 4.94.2 #2)
        id 1o85AF-00085Z-2a by authid <merlins.org> with srv_auth_plain; Sun, 03 Jul 2022 13:07:42 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.92)
        (envelope-from <marc@merlins.org>)
        id 1o85sb-00DAka-2q; Sun, 03 Jul 2022 13:07:41 -0700
Date:   Sun, 3 Jul 2022 13:07:41 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     linux-raid@vger.kernel.org
Subject: Is it correct that raid5 cannot be converted from Consistency
 Policy: bitmap to ppl?
Message-ID: <20220703200741.GA3138296@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
X-SA-Exim-Connect-IP: 90.46.126.96
X-SA-Exim-Mail-From: marc@merlins.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Is there any way around this, or not without a full reformat/rebuild?

gargamel:~# mdadm --query --detail /dev/md5
/dev/md5:
           Version : 1.2
     Creation Time : Tue Jan 21 10:35:52 2014
        Raid Level : raid5
        Array Size : 15627542528 (14903.59 GiB 16002.60 GB)
     Used Dev Size : 3906885632 (3725.90 GiB 4000.65 GB)
      Raid Devices : 5
     Total Devices : 5
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Sun Jul  3 03:02:01 2022
             State : active, checking 
    Active Devices : 5
   Working Devices : 5
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : bitmap

      Check Status : 99% complete

              Name : gargamel.svh.merlins.org:5  (local to host gargamel.svh.merlins.org)
              UUID : ec672af7:a66d9557:2f00d76c:38c9f705
            Events : 642977

    Number   Major   Minor   RaidDevice State
       0       8      193        0      active sync   /dev/sdm1
       6       8      177        1      active sync   /dev/sdl1
       2       8      209        2      active sync   /dev/sdn1
       3       8        1        3      active sync   /dev/sda1
       5       8       17        4      active sync   /dev/sdb1
gargamel:~# mdadm --grow --consistency-policy=ppl /dev/md5
mdadm: Current consistency policy is bitmap, cannot change to ppl

Kernel 5.16.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
