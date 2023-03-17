Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1916C6FD1D
	for <linux-raid@archiver.kernel.org>; Fri, 17 Mar 2023 17:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCQRiT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Mar 2023 13:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCQRiR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 17 Mar 2023 13:38:17 -0400
Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C8528E56
        for <linux-raid@vger.kernel.org>; Fri, 17 Mar 2023 10:38:13 -0700 (PDT)
Received: from [76.132.34.178] (port=60048 helo=sauron.svh.merlins.org)
        by mail1.merlins.org with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim 4.94.2 #2)
        id 1pdD7j-0001BE-9O by authid <merlins.org> with srv_auth_plain; Fri, 17 Mar 2023 10:38:10 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.92)
        (envelope-from <marc@merlins.org>)
        id 1pdE1q-008yML-7l; Fri, 17 Mar 2023 10:38:10 -0700
Date:   Fri, 17 Mar 2023 10:38:10 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     linux-raid@vger.kernel.org
Subject: mdadm --detail works, mdadm --stop says "does not appear to be an md
 device"
Message-ID: <20230317173810.GW4049235@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
X-Broken-Reverse-DNS: no host name for IP address 76.132.34.178
X-SA-Exim-Connect-IP: 76.132.34.178
X-SA-Exim-Mail-From: marc@merlins.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

gargamel:~# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath] 
md6 : active raid5 sdn1[3](F) sdt1[0](F) sds1[1](F) sdq1[2](F)
      23441547264 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/0] [_____]
gargamel:~# mdadm --stop /dev/md6
mdadm: /dev/md6 does not appear to be an md device
gargamel:~# mdadm --detail /dev/md6
/dev/md6:
           Version : 1.2
     Creation Time : Wed Jul  8 10:09:21 2020
        Raid Level : raid5
        Array Size : 23441547264 (22355.60 GiB 24004.14 GB)
     Used Dev Size : 5860386816 (5588.90 GiB 6001.04 GB)
      Raid Devices : 5
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Fri Mar 17 09:17:28 2023
             State : clean, FAILED 
    Active Devices : 0
    Failed Devices : 4
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : ppl

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       -       0        0        1      removed
       -       0        0        2      removed
       -       0        0        3      removed
       -       0        0        4      removed


How do I clear this without a reboot?

gargamel:~# uname -r
5.19.7


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
