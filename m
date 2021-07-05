Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8831C07E99
	for <linux-raid@archiver.kernel.org>; Mon,  5 Jul 2021 12:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B1296135D
	for <linux-raid@archiver.kernel.org>; Mon,  5 Jul 2021 12:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhGEMXe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Jul 2021 08:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhGEMXe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Jul 2021 08:23:34 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2D5C061574
        for <linux-raid@vger.kernel.org>; Mon,  5 Jul 2021 05:20:56 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l1so11262472wme.4
        for <linux-raid@vger.kernel.org>; Mon, 05 Jul 2021 05:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=iBrcsOofjv/x6ea7ffcwng6pGant3YhpjSYNzr33sVE=;
        b=KEzzJ3AAlRcM+MTuPGVs49Iuz/QylCbZvGHmztbuTLVv9c4OTBoDMR4jFClladSrMf
         KbJ/r9ip3ShXVRK7FAC/rRDIx7gMNfmK6a2Ob556mi6N76rsgCy9AcdDErHCc202mbsw
         wUyX3fju75xniuCZV0S0AYuLlPBCZVlzIySGbsUSKT+5Szrkwxf6VRh0bFLtVr9GiUgD
         Rbqaz8kFPFMF9Ain7DloztqTXQL7PocBNFcMdestTYI85uvIXF/mB7THH+elvsKwNKIf
         yZrN13wDTUzRVQh/mRfQXpCgLtzkc+qtfV952NDxK+rJy6KkaDkXpDVfSwVGwcjczzx2
         DEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iBrcsOofjv/x6ea7ffcwng6pGant3YhpjSYNzr33sVE=;
        b=rPpiAk88pSEeXDkFiWb7A3GPLjrKcTM9HIdYFH98Y1CDxTv5cGzFMkEIu3iKKSvM8R
         204aPHIboK9XEWtludIQ3ffihGixCNQC1qvkke8eL+4SyGdWdgAqxoA5njyujlTmSu7G
         jFErXyMWcH0eY0CkDb0C9zS9zscTWEErIZKgpxaIqvRRwD1fYRlHzhBCncuFaj6kKeF8
         Z0RdyPFjHLnBFvpN8oVXC1UQ2M5ax65R34Y9zK0lH+5K+gMogL4ncAl+Ym8rBDap8nVz
         fRZ7GGS9zGMvW8YMuE46cM0tQwWkO9UBnA8nRkRy6qx836nf2tZ6cSI1bThYNfFDNiJI
         geXg==
X-Gm-Message-State: AOAM531tF1IzYNpHFbzD1SRK+xvD6KAsHpjDnhajSgfU3rrZznXOYTDS
        3Td5bOdRVRcwNtaqFwSI4TPK+noeHC2dIsN7U4IBFJUoL4o=
X-Google-Smtp-Source: ABdhPJz2Dky39GUd8VopRIhXvceroPxPhAPu4iz5DXshWJoYmIokOHMiO1ywOHM4p7VtP5S5gDtvl1/d7ZyjANRNKZE=
X-Received: by 2002:a1c:26c2:: with SMTP id m185mr14973490wmm.146.1625487654957;
 Mon, 05 Jul 2021 05:20:54 -0700 (PDT)
MIME-Version: 1.0
From:   BW <m40636067@gmail.com>
Date:   Mon, 5 Jul 2021 14:20:43 +0200
Message-ID: <CADcL3SDfzw+PZHWabN0mrHFuyt1gVtD6Owf_bNpFT=xV-JrVVA@mail.gmail.com>
Subject: --detail --export doesn't show all properties
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is an example of the --export output:

# mdadm --detail --export /dev/md127
MD_DEVICES=3
MD_METADATA=1.2
MD_UUID=70bc1acd:f879f9cd:dca76d79:d9ce624a
MD_DEVNAME=debian:R5
MD_NAME=debian:R5
MD_DEVICE_dev_sdc_ROLE=spare
MD_DEVICE_dev_sdc_DEV=/dev/sdc
MD_DEVICE_dev_sdd_ROLE=spare
MD_DEVICE_dev_sdd_DEV=/dev/sdd
MD_DEVICE_dev_sdb_ROLE=spare
MD_DEVICE_dev_sdb_DEV=/dev/sdb

This is the same command in "normal" format-output:

# mdadm --detail /dev/md127
/dev/md127:
           Version : 1.2
        Raid Level : raid5
     Total Devices : 3
       Persistence : Superblock is persistent
             State : inactive
   Working Devices : 3
              Name : debian:R5
              UUID : 70bc1acd:f879f9cd:dca76d79:d9ce624a
            Events : 358
    Number   Major   Minor   RaidDevice
       -       8       32        -        /dev/sdc
       -       8       48        -        /dev/sdd
       -       8       16        -        /dev/sdb


It would be nice if the --export included the properties "Raid Level",
"State", "Persistence" (the first two most important).

Another thing, is it correct that "MD_DEVNAME" and "MD_NAME" should be the same?
Or perhaps "MD_NAME" should show the kernel/Device-Mapper name e.g.
"md127", that would be helpful (by the way, what do you call this mdxx
name?)

Thanks
Brian, Denmark
