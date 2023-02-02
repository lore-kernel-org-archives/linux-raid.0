Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598A3C05027
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 13:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbjBBNCr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 08:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjBBNCq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 08:02:46 -0500
X-Greylist: delayed 1108 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Feb 2023 05:02:23 PST
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3EC8E696
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 05:02:23 -0800 (PST)
Received: from [73.207.192.158] (port=41032 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1pNYvk-0003rK-Cf
        for linux-raid@vger.kernel.org;
        Thu, 02 Feb 2023 06:43:08 -0600
Date:   Thu, 2 Feb 2023 12:43:06 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: how to know a hard drive will mix well
Message-ID: <20230202124306.GH25616@jpo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

I have

  diskfarm:~ # mdadm -D /dev/md51 | egrep /dev/
  /dev/md51:
	 0     259        9        0      active sync   /dev/sdb51
	 1     259        2        1      active sync   /dev/sdc51
	 3     259       16        2      active sync   /dev/sdd51
	 4     259       23        3      active sync   /dev/sdj51

Toshiba X300 10T

  diskfarm:~ # smartctl -i /dev/sdb | egrep '(Model|Number|Version):'
  Device Model:     TOSHIBA HDWR11A
  Serial Number:    61U0A0HQFBKG
  Firmware Version: 0603

drives in my disk farm, and it's about time to grow again.  As I
shopped around, I stumbled over a WD Red Plus 12T WD120EFBX drive at
just $10 more, and who wouldn't want an extra 2T for ten bucks?  So I'm
contemplating rolling in a different model.  But how do I know that it
will fit well into the mix?

The X300 is a 7200rpm 256Mcache 6G/sec CMR drive.  The Red Plus is also
listed as a 7200rpm* 256Mcache 6G/sec CMR drive.  They certainly sound
equivalent.  What else do I need to consider, and where else do I need
to look to learn?

* The spec actually says "7200 RPM Class".  Does that mean not really
7200rpm?  That wouldn't surprise me in this modern day and age, and if
the X300 also isn't really then that also wouldn't.


TIA & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

