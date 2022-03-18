Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4EBC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 18 Mar 2022 03:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiCRDmT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Mar 2022 23:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiCRDmS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Mar 2022 23:42:18 -0400
X-Greylist: delayed 1923 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Mar 2022 20:41:00 PDT
Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8102706C2
        for <linux-raid@vger.kernel.org>; Thu, 17 Mar 2022 20:41:00 -0700 (PDT)
Received: from c-24-5-124-255.hsd1.ca.comcast.net ([24.5.124.255]:48548 helo=sauron.svh.merlins.org)
        by mail1.merlins.org with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim 4.94.2 #2)
        id 1nV2z1-0005Ps-T7 by authid <merlins.org> with srv_auth_plain; Thu, 17 Mar 2022 20:08:55 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.92)
        (envelope-from <marc@merlins.org>)
        id 1nV2z1-0087lO-Js; Thu, 17 Mar 2022 20:08:55 -0700
Date:   Thu, 17 Mar 2022 20:08:55 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     linux-raid@vger.kernel.org
Subject: new drive is 4 sectors shorter, can it be used for swraid5 array?
Message-ID: <20220318030855.GV3131742@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.5.124.255
X-SA-Exim-Mail-From: marc@merlins.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

old drive:
Device Model:     ST6000VN0041-2EL11C
Serial Number:    ZA18WX4T
LU WWN Device Id: 5 000c50 0a47d527a
Firmware Version: SC61
User Capacity:    6,001,175,126,016 bytes [6.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical

   8      128 5860522584 sdi
   8      129 5860521543 sdi1


new drive:
Device Model:     ST6000VN001-2BB186
Serial Number:    ZR118A1Y
LU WWN Device Id: 5 000c50 0dba1b3c0
Firmware Version: SC60
User Capacity:    6,001,175,126,016 bytes [6.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical

   8      160 5860522580 sdk
   8      161 5860521536 sdk1

New drive is 4 sectors shorter, so I assume I can't use it as a replacement in my md5
array because it's 4 sectors too short, or does swraid5 not need the last few sectors
of a drive?

Looks like formatting as MDR won't help, I'm still 4 sectors short.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
