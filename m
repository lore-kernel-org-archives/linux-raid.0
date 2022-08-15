Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B56C19F2C
	for <linux-raid@archiver.kernel.org>; Tue, 16 Aug 2022 05:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiHPFm0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Aug 2022 01:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiHPFl7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 16 Aug 2022 01:41:59 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA6A1A805
        for <linux-raid@vger.kernel.org>; Mon, 15 Aug 2022 15:28:21 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id cb12-20020a056830618c00b00616b871cef3so6349902otb.5
        for <linux-raid@vger.kernel.org>; Mon, 15 Aug 2022 15:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=A84AqG8UpNzHXB3esJR/kPGFK4W+hiHbH5gDTWf2hTg=;
        b=MIPIDf5XedMUJoOa1+ED8NdyKJ/7dD5pDyiq7OTMJ7PgEv6R34LxCuFbNoxkLSfLx4
         ton2gOcW3O2GbNy4UUH5jmtJVg7xnGVyQLeIMrz2YA4zPND0GKwC6zlgLYJyjm19encM
         wfj0ePSWxEGLdS05f1atwV2AEx5f842syQRDUWIkOatFriIgbW3fCP9g7Q7vdVVFjxzD
         azegQ5ihDH/1FhA5g5WUvKmQV8BRh1Y8gPPRdOOQQudulfc29LrMLvVEWrmabgN7FItj
         LXnXEJ2uLj409epQ2pa3cAzqeswaJ51wI9QUdV8XkLS99uJeVUvJTKqX6dhMntoKsS2X
         gkEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=A84AqG8UpNzHXB3esJR/kPGFK4W+hiHbH5gDTWf2hTg=;
        b=G9Z2GdQUcY0Q7xBaCkRBZk9j8aTaHHEEhhoL7m/RQr01iMvL/+lQ4vEptKt7DhuhNv
         GcHzD9g2OMmPbaTLsMTZlhXPsbwLIL+bvQAdlm+1xBfiTWIwGAv5OWZpVDPmN0FOyo38
         P2gaGdf42ll9dpPqSVpnM2pkE4ixOHxgU4diJYcHaTn33su3Lzfc9sbVC86VKGGrRcQU
         8s7a7Xm3ZAuqO2Ajuq/+7m/6+MaBwQ7nZ8MlEShVH2R6CQOek28xgbhHoN7LscPx0E5e
         vaJVwktqE9LRqAe8FeZCGHT99jSnlpOuzD0qrziAtbImsJdr0MD+ZAc4eq93tTcYGVcF
         7cnA==
X-Gm-Message-State: ACgBeo0vi5Fcj15HuV/f1FfIc6N4lmTcrf5eTHs+XZOl3SWGHZc9vyu9
        zSbcudxb/zSY2vMsP3ZSNc+AJceBhDX9wMkXqSMelmWYlD8=
X-Google-Smtp-Source: AA6agR50wVqcTlUseHaHKoeg0GDWxmDlOxMHtMPtyIRghjyDe9Xs5ZlbkYyhbUAodFl5p9ct1IeV+KzNOCZRVEdwZMo=
X-Received: by 2002:a9d:4a8:0:b0:60c:76b1:f1be with SMTP id
 37-20020a9d04a8000000b0060c76b1f1bemr6580194otm.347.1660602499563; Mon, 15
 Aug 2022 15:28:19 -0700 (PDT)
MIME-Version: 1.0
From:   "David F." <df7729@gmail.com>
Date:   Mon, 15 Aug 2022 15:28:08 -0700
Message-ID: <CAGRSmLvY48qanq6qdi40LE_50xT9ZzUq456KntesLSrxt8AmBw@mail.gmail.com>
Subject: Timeout waiting for /dev/md/imsm0 ?
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I'm not sure if this list is getting the messages but to summarize, if
I pass the 5.15.x kernel parameter "nomdraid" to skip udev from doing
anything with the RAID and then run:

mdadm - v4.1 - 2018-10-01

mdadm --examine --scan to create the /etc/mdadm/mdadm.conf file with:

ARRAY metadata=imsm UUID=788c3635:2e37de4b:87d08323:987f57e5
ARRAY /dev/md/TestRAID container=788c3635:2e37de4b:87d08323:987f57e5
member=0 UUID=835de710:3d35bfb1:d159af46:6570f120

Then run:

mdadm --assemble --scan --no-degraded -v

I get:

mdadm: looking for devices for further assembly
mdadm: no RAID superblock on /dev/sdc1
mdadm: /dev/sdc is not attached to Intel(R) RAID controller.
mdadm: No OROM/EFI properties for /dev/sdc
mdadm: no RAID superblock on /dev/sdc
mdadm: no RAID superblock on /dev/sda5
mdadm: no RAID superblock on /dev/sda3
mdadm: no RAID superblock on /dev/sda2
mdadm: no RAID superblock on /dev/sda1
mdadm: /dev/sdb is identified as a member of /dev/md/imsm0, slot 1.
mdadm: /dev/sda is identified as a member of /dev/md/imsm0, slot 0.
mdadm: added /dev/sdb to /dev/md/imsm0 as 1
mdadm: added /dev/sda to /dev/md/imsm0 as 0
mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
mdadm: timeout waiting for /dev/md/imsm0
mdadm: looking for devices for /dev/md/TestRAID
mdadm: cannot open device /dev/md/imsm0: No such file or directory
mdadm: Cannot assemble mbr metadata on /dev/sdc1
mdadm: Cannot assemble mbr metadata on /dev/sdc
mdadm: /dev/sdb has wrong uuid.
mdadm: Cannot assemble mbr metadata on /dev/sda5
mdadm: Cannot assemble mbr metadata on /dev/sda3
mdadm: Cannot assemble mbr metadata on /dev/sda2
mdadm: no recogniseable superblock on /dev/sda1
mdadm: /dev/sda has wrong uuid.
mdadm: looking for devices for /dev/md/TestRAID
mdadm: cannot open device /dev/md/imsm0: No such file or directory
mdadm: Cannot assemble mbr metadata on /dev/sdc1
mdadm: Cannot assemble mbr metadata on /dev/sdc
mdadm: /dev/sdb has wrong uuid.
mdadm: Cannot assemble mbr metadata on /dev/sda5
mdadm: Cannot assemble mbr metadata on /dev/sda3
mdadm: Cannot assemble mbr metadata on /dev/sda2
mdadm: no recogniseable superblock on /dev/sda1
mdadm: /dev/sda has wrong uuid.

If I let UDEV start it and then stop the RAID with:

mdadm --stop --scan

(which does stop it) then try to start again using the above command,
I still get the timeout.

This was working fine with older version 5.10.x kernel with the
following differences:

   mdadm v4.1 - 2018-10-01 (but from a different build - debian
instead of devuan)
   kmod as an older version
   udev (eudev) was built against the older kmod.
   all the various shared libraries and utilities were moved up to
versions with Devuan Chimaera
   rules updated (although I tried with the old rules too, no difference)

Any idea on what is wrong?  Any tricks to have it output more
information to diagnose what is happening?   The /dev/md127 device
gets created, the actual devices never get created, even if you wait.
